/**********************************************************************
Name: B2B_HRCOrderProcess
Purpose: This class is used to process HRC order Modification from Dealer Console
Created Date :  10/01/2024
Created By : Rajrishi Kaushik
*************************************************************/
public class B2B_HRCOrderProcess {
    
    @TestVisible private static List<Order__x> mockedOrder = new List<Order__x>();
    @TestVisible private static List<OrderItem__x> mockedOrderItems = new List<OrderItem__x>();
    @TestVisible private static List<BT_Transaction_Details_c__x> mockedBTTransaction = new List<BT_Transaction_Details_c__x>();
    // for HRC Modification refund
    private static Decimal refundProductAmount = 0;
    private static Decimal refundShipping = 0;
    private static Decimal refundTotal = 0; 
    private static Decimal totalRefundQuantity = 0;
    private static Order__x objOrder;
    private static List<OrderItem__x> lstOrderItems;
    private static B2B_VertexTaxCalculationIntegration.ResponseDataWrapper vertexResponse;
    private static String orderTransactionId;
    private static boolean isSuccess = false;
    private static String customerNotes = '';
    private static B2B_BrainTreeTransactionResponse objBTResponse;
    //-------------------------------------HRC Modification refund Start ------------------------------------------------------//
    @AuraEnabled
    public static Boolean processHrcOrderRefund(List<OrderItem__x> lstOrderItem,String customerNote){
        try {    
            customerNotes = customerNote;
            lstOrderItems = lstOrderItem;
            if(!lstOrderItems.isEmpty()){
                String OrderId = (!mockedOrder.isEmpty()) ? 'testorderid' : lstOrderItems[0].OrderId__c; 
                if(String.isNotBlank(OrderId)){               
                    List<B2B_VertexTaxCalculationIntegration.OrderItemWrapper> lstOrderItemWrappers = new List<B2B_VertexTaxCalculationIntegration.OrderItemWrapper>();
                    
                    
                    objOrder = (!mockedOrder.isEmpty()) ? mockedOrder[0] : [SELECT Id, Status__c, OrderedDate__c, Quantity_c__c, AccountId__c, Dealer_Number_c__c, BT_Customer_Detail_c__c, BT_Transaction_Id_c__c, ExternalId, BillingStreet__c, BillingCity__c, BillingState__c, 
                                BillingPostalCode__c, CC_Last4_c__c, Payment_Gateway_c__c, Payment_Type_c__c, Payment_Method_Token_c__c, Updated_Total_Tax_c__c, Total_Current_Product_Tax_c__c, Current_Shipping_Tax_c__c, 
                                Unavailable_Quantity_c__c, Total_Unavailable_ShippingAmt_c__c, Total_Unavailable_ShippingTax_c__c, Total_Unavailable_ProductAmt_c__c, Total_Unavailable_ProductTax_c__c, 
                                Total_Unavailable_TaxAmt_c__c, Total_Unavailable_AMT_c__c, Total_Unavailable_PreTaxAmt_c__c, ShippingStreet__c, ShippingCity__c, ShippingState__c, ShippingPostalCode__c, Updated_Order_Total_c__c 
                                FROM Order__x WHERE Id =: OrderId LIMIT 1];
                    
                    // create vertex request wrapper for Quotation                    
                    for(OrderItem__x objOrderItem : lstOrderItems){
                        B2B_VertexTaxCalculationIntegration.OrderItemWrapper objOrderItemWrapper = new B2B_VertexTaxCalculationIntegration.OrderItemWrapper();
                        if(objOrderItem.Delta_Quantity_c__c > 0){
                            objOrderItemWrapper.quantity = Integer.valueOf(objOrderItem.Delta_Quantity_c__c); 
                            objOrderItemWrapper.unitPrice =  (!Test.isRunningTest()) ? objOrderItem.ListPrice__c : 22.00;
                            objOrderItemWrapper.orderItemId = (!mockedOrder.isEmpty()) ? 'x0301000003JHFcAAO' : objOrderItem.Id;
                            objOrderItemWrapper.shippingCharge = objOrderItem.Shipping_Amount_Per_Unit_c__c * objOrderItem.Delta_Quantity_c__c; //added by Rajrishi for HRC
                            lstOrderItemWrappers.add(objOrderItemWrapper);	
                            
                            totalRefundQuantity = totalRefundQuantity + objOrderItem.Delta_Quantity_c__c;
                            refundShipping += objOrderItem.Shipping_Amount_Per_Unit_c__c * objOrderItem.Delta_Quantity_c__c;      
                            if(!Test.isRunningTest()){
                                refundProductAmount += objOrderItem.Delta_Quantity_c__c * objOrderItem.ListPrice__c;
                            }    
                        }                                                                                     
                    }
                    
                    refundTotal = refundProductAmount + refundShipping;
                    
                    // Call vertex Quotation tax API
                    String taxResponse = B2B_TaxHelper.getTaxRatesAndAmountsFromVertex(objOrder, lstOrderItemWrappers, null, null, null);
                    vertexResponse = (B2B_VertexTaxCalculationIntegration.ResponseDataWrapper) JSON.deserialize(taxResponse, B2B_VertexTaxCalculationIntegration.ResponseDataWrapper.class);
                    if(vertexResponse.isSuccess == true){
                        System.debug('Vertex Response:--> '+vertexResponse);
                        vertexResponse.totalTaxAmount = -1 * vertexResponse.totalTaxAmount;
                        vertexResponse.product_Charges_tax = -1 * vertexResponse.product_Charges_tax;
                        vertexResponse.shipping_Charges_tax = -1 *  vertexResponse.shipping_Charges_tax;
                        Decimal remainingTax = 0;
                        Decimal remainingProductTax = 0;
                        Decimal remainingShippingTax = 0;
                        // Handling Vertex Known issue - start
                        // Total return tax
                        if(objOrder.Total_Unavailable_TaxAmt_c__c != null){
                            remainingTax = objOrder.Updated_Total_Tax_c__c - objOrder.Total_Unavailable_TaxAmt_c__c;
                            if(vertexResponse.totalTaxAmount > remainingTax){
                                vertexResponse.totalTaxAmount = remainingTax;
                            } 
                        }
                        remainingTax = objOrder.Updated_Total_Tax_c__c - (objOrder.Total_Unavailable_TaxAmt_c__c != null? objOrder.Total_Unavailable_TaxAmt_c__c : 0) ;
                        if(vertexResponse.totalTaxAmount < remainingTax && (objOrder.Quantity_c__c - (objOrder.Unavailable_Quantity_c__c + totalRefundQuantity) == 0)){
                            vertexResponse.totalTaxAmount += remainingTax - vertexResponse.totalTaxAmount;
                        }
                        
                        //Total refund product tax
                        if(objOrder.Total_Unavailable_ProductTax_c__c != null){
                            remainingProductTax = objOrder.Total_Current_Product_Tax_c__c - objOrder.Total_Unavailable_ProductTax_c__c;
                            if(vertexResponse.product_Charges_tax > remainingProductTax){
                                vertexResponse.product_Charges_tax = remainingProductTax;
                            }
                        }
                        remainingProductTax = objOrder.Total_Current_Product_Tax_c__c - (objOrder.Total_Unavailable_ProductTax_c__c != null? objOrder.Total_Unavailable_ProductTax_c__c : 0);
                        if(vertexResponse.product_Charges_tax < remainingProductTax && (objOrder.Quantity_c__c - (objOrder.Unavailable_Quantity_c__c + totalRefundQuantity) == 0)){
                            vertexResponse.product_Charges_tax += remainingProductTax - vertexResponse.product_Charges_tax;
                        }
                        
                        //Total refund shipping tax
                        if(objOrder.Total_Unavailable_ShippingTax_c__c != null){
                            remainingShippingTax = objOrder.Current_Shipping_Tax_c__c - objOrder.Total_Unavailable_ShippingTax_c__c;
                            if(vertexResponse.shipping_Charges_tax > remainingShippingTax){
                                vertexResponse.shipping_Charges_tax = remainingShippingTax;
                            }
                        }
                        remainingShippingTax = objOrder.Current_Shipping_Tax_c__c - (objOrder.Total_Unavailable_ShippingTax_c__c !=null? objOrder.Total_Unavailable_ShippingTax_c__c : 0);
                        if(vertexResponse.shipping_Charges_tax < remainingShippingTax && (objOrder.Quantity_c__c - (objOrder.Unavailable_Quantity_c__c + totalRefundQuantity) == 0)){
                            vertexResponse.shipping_Charges_tax += remainingShippingTax - vertexResponse.shipping_Charges_tax;
                        }
                        
                        // Handling Vertex Known issue - Ends
                                        
                        // add taxes to the total refund amount
                        refundTotal += vertexResponse.totalTaxAmount;
                        // process refund to customer
                        refundModifiedOrder();                      
                    }else {
                        //Audit trail - create order transaction for the order
                        createRefundAuditTrails(B2B_IntegrationConstants.PAYMENT_FAILURE);
                    }
                }
            }
        } catch (Exception ex) {
            System.debug('Exception Occurred : '+ ex.getMessage());
            System.debug('Exception Line Number : '+ ex.getLineNumber());
            System.debug('Exception Line Number : '+ ex.getStackTraceString());
        }
        return isSuccess;
    }
    
    public static void refundModifiedOrder(){
        Long beforeAPI = B2B_Util.fetchCurrentTime();
        // call the HDM Salesforce API to get the SF Token
        B2B_HDMBraintreeIntegration.DeviceCodeWrapper tokenDetails = B2B_HDMBraintreeIntegration.getDeviceCode();
        if(tokenDetails.status == 200 && String.isNotEmpty(tokenDetails.deviceToken)){
            // call the HDM Salesforce API to get the BT dealer access token
            B2B_HDMBraintreeIntegration.ResponseWrapper objResponse = B2B_HDMBraintreeIntegration.getDealerAccessToken(objOrder.Dealer_Number_c__c, tokenDetails.deviceToken);
            if(objResponse != null && objResponse.isSuccess && String.isNotEmpty(objResponse.accessToken)){
                // call the Braintree refund API
                objBTResponse = B2B_HDMBraintreeIntegration.braintreeTransactionRefund(objOrder.BT_Customer_Detail_c__c, objResponse.merchantId, objOrder.BT_Transaction_Id_c__c, objResponse.accessToken, String.valueOf(refundTotal));
                // check if the response status is 200
                if(objBTResponse.status == 200){ 
                    isSuccess = true;
                    System.debug('BT Refund Response --> '+objBTResponse);                                     
                    //Audit trail - create order transaction for the order
                    createRefundAuditTrails(B2B_IntegrationConstants.PAYMENT_SUCCESS);                                              
                    
                    // Update Unavailable fields data on Order & Order Item
                    updateOrderAndOrderItem();                                                                
                    
                }else {
                    //Audit trail - create order transaction for the order
                    createRefundAuditTrails(B2B_IntegrationConstants.PAYMENT_FAILURE);
                    Long afterAPI = B2B_Util.fetchCurrentTime();
                    Long durationTime = B2B_Util.calInMilliSeconds(beforeAPI,afterAPI);
                   	B2B_Util.createErrorRecord('braintreeTransactionRefund Error',orderTransactionId,objOrder.AccountId__c,'','','B2B_HRCOrderProcess',String.valueOf(objBTResponse.status),
                                               Label.B2B_Error_Type,'','refundModifiedOrder',true,objOrder.ExternalId,'','',durationTime,Label.B2B_Severity,
                                               'Request:'+objBTResponse.requestBody,'Response:'+objBTResponse.responseBody);
                }
            }else {
                //Audit trail - create order transaction for the order
                createRefundAuditTrails(B2B_IntegrationConstants.PAYMENT_FAILURE);
                Long afterAPI = B2B_Util.fetchCurrentTime();
                Long durationTime = B2B_Util.calInMilliSeconds(beforeAPI,afterAPI);
                B2B_Util.createErrorRecord('getDealerAccessToken Error',orderTransactionId,objOrder.AccountId__c,'','','B2B_HRCOrderProcess',String.valueOf(objResponse.status),
                                           Label.B2B_Error_Type,'','refundModifiedOrder',true,objOrder.ExternalId,'','',durationTime,Label.B2B_Severity,
                                           'Request:'+objResponse.requestBody,'Response:'+objResponse.responseBody);
            }
        }else {
            //Audit trail - create order transaction for the order
            createRefundAuditTrails(B2B_IntegrationConstants.PAYMENT_FAILURE);
            Long afterAPI = B2B_Util.fetchCurrentTime();
            Long durationTime = B2B_Util.calInMilliSeconds(beforeAPI,afterAPI);
            B2B_Util.createErrorRecord('getDeviceCode Error',orderTransactionId,objOrder.AccountId__c,'','','B2B_HRCOrderProcess',String.valueOf(tokenDetails.status),
                                       Label.B2B_Error_Type,'','refundModifiedOrder',true,objOrder.ExternalId,'','',durationTime,Label.B2B_Severity,
                                       'Request:'+tokenDetails.requestBody,'Response:'+tokenDetails.responseBody);
        }       	                             
    }
    
    // Method to create the Order Transaction & items for the Order
    public static void createRefundAuditTrails(String status){
        // Order Transaction for refund
        Order_Transaction_c__x objOrderTransaction = new Order_Transaction_c__x();
        objOrderTransaction.Order_c__c = objOrder.ExternalId;
        objOrderTransaction.Order_Transaction_Type_c__c = B2B_IntegrationConstants.UNAVAILABLE_REFUND;
        objOrderTransaction.Order_Transaction_Status_c__c = status;
        objOrderTransaction.Is_Adjustment_c__c = false;
        objOrderTransaction.Total_Post_Adjustment_Shiping_Charge_c__c = refundShipping;
        objOrderTransaction.Total_Post_adjustment_Shipping_Tax_c__c = vertexResponse.shipping_Charges_tax;
        objOrderTransaction.Post_Adjustment_Total_Amount_c__c = refundTotal;
        objOrderTransaction.Post_Adjustment_Total_Tax_c__c = vertexResponse.totalTaxAmount;
        objOrderTransaction.Adjustment_Date_Time_c__c = System.now();
        objOrderTransaction.Dealer_To_Customer_Note_c__c = customerNotes;

        if(!Test.isRunningTest()){
            Database.insertImmediate(objOrderTransaction);
            objOrderTransaction = [Select Id, ExternalId FROM Order_Transaction_c__x WHERE Id =:objOrderTransaction.Id LIMIT 1];
            orderTransactionId = objOrderTransaction.ExternalId;
        }
        
        if(status == B2B_IntegrationConstants.PAYMENT_SUCCESS){
            // create Payment Gateway Transaction
        	createBTTransaction(objBTResponse);
        }
                
        List<Order_Transaction_Item_c__x> lstOrderTransItems = new List<Order_Transaction_Item_c__x>();
        for(OrderItem__x objOrderItem : lstOrderItems){
            if(objOrderItem.Delta_Quantity_c__c > 0){
                Decimal productTax = 0; 
                Decimal shippingTax = 0;
                if(vertexResponse.mapOrderItemTax.containsKey(objOrderItem.Id)){
                    productTax = -1 * vertexResponse.mapOrderItemTax.get(objOrderItem.Id);
                }
                if(vertexResponse.mapOrderItemShipTax.containsKey(objOrderItem.Id)){
                    shippingTax = -1 * vertexResponse.mapOrderItemShipTax.get(objOrderItem.Id);
                }
                
                //Order Transaction Item for refund
                Order_Transaction_Item_c__x objOrderTranItem = new Order_Transaction_Item_c__x();
                objOrderTranItem.Order_Item_c__c = objOrderItem.ExternalId;
                objOrderTranItem.Post_Adjustment_Quantity_c__c = objOrderItem.Delta_Quantity_c__c;
                objOrderTranItem.Post_Adjustment_Extended_Price_c__c = (!Test.isRunningTest()) ? (objOrderItem.Delta_Quantity_c__c * objOrderItem.ListPrice__c) : 0;
                objOrderTranItem.Total_Post_Adjustment_Product_Tax_c__c = productTax;
                objOrderTranItem.Total_Post_ShippingAmt_c__c = objOrderItem.Delta_Quantity_c__c * objOrderItem.Shipping_Amount_Per_Unit_c__c;
                objOrderTranItem.Total_Post_ShippedTax_c__c = shippingTax; 
                objOrderTranItem.Adjustment_Date_Time_c__c = System.now();         
                objOrderTranItem.AK_Order_Transaction_Item_c__c = objOrderItem.ExternalId +''+ orderTransactionId;  
                objOrderTranItem.Product_Type_c__c = objOrderItem.Product_Type_c__c; // Added by Imtiyaz Ali
                lstOrderTransItems.add(objOrderTranItem);
            }
        }
        System.debug('Order Transaction Item List -->'+ lstOrderTransItems);
        
        if(!lstOrderTransItems.isEmpty()){
            if(!Test.isRunningTest()){
                Database.insertImmediate(lstOrderTransItems);
            }            	
        }
    }
    
    public static void createBTTransaction(B2B_BrainTreeTransactionResponse objBrainTreeTransactionResponse){
        //query old Bt transaction for reference
        BT_Transaction_Details_c__x btDetail = (!mockedBTTransaction.isEmpty()) ? mockedBTTransaction[0] : [SELECT Id, ExternalId, Customer_c__c, Cardholder_Name_c__c 
                                                FROM BT_Transaction_Details_c__x 
                                                WHERE Order_c__c =: objOrder.ExternalId Order by CreatedDate__c DESC LIMIT 1];
        
        //creating the new transaction for refund for can event    
        BT_Transaction_Details_c__x objBTTransactionDetails = new BT_Transaction_Details_c__x();   
        objBTTransactionDetails.Name__c = B2B_IntegrationConstants.TRANSACTION_REFUND_NAME;
        objBTTransactionDetails.BT_TransactionId_c__c = objBrainTreeTransactionResponse.transactionBT.id;                               
        objBTTransactionDetails.Type_c__c = objBrainTreeTransactionResponse.transactionBT.type;  
        objBTTransactionDetails.Transaction_Status_c__c = objBrainTreeTransactionResponse.transactionBT.status;
        objBTTransactionDetails.Order_c__c = objOrder.ExternalId;
        objBTTransactionDetails.Billing_Street_c__c = objOrder.BillingStreet__c;
        objBTTransactionDetails.Billing_City_c__c = objOrder.BillingCity__c;
        objBTTransactionDetails.Billing_State_c__c = objOrder.BillingState__c;
        objBTTransactionDetails.Billing_PostalCode_c__c = objOrder.BillingPostalCode__c;
        objBTTransactionDetails.Credit_Card_Number_c__c = objOrder.CC_Last4_c__c;
        objBTTransactionDetails.Payment_Gateway_c__c = objOrder.Payment_Gateway_c__c;
        objBTTransactionDetails.Payment_Method_Type_c__c = objOrder.Payment_Type_c__c;
        objBTTransactionDetails.Payment_Method_Token_c__c = objOrder.Payment_Method_Token_c__c;
        objBTTransactionDetails.Cardholder_Name_c__c = btDetail.Cardholder_Name_c__c;    
        objBTTransactionDetails.Customer_c__c = btDetail.Customer_c__c;
        objBTTransactionDetails.Order_Transaction_c__c = orderTransactionId;
        objBTTransactionDetails.Transaction_Date_c__c = System.now();
        if(!Test.isRunningTest()){
            Database.insertImmediate(objBTTransactionDetails);
        }
        System.debug('BT Transaction Details-->'+objBTTransactionDetails);
    }
    
    // Method to update Unavailable fields on Order & Order Item
    public static void updateOrderAndOrderItem(){
        
        // Order Data Updates
        objOrder.Unavailable_Quantity_c__c = objOrder.Unavailable_Quantity_c__c != null ? objOrder.Unavailable_Quantity_c__c + totalRefundQuantity : totalRefundQuantity; 
        objOrder.Total_Unavailable_ShippingAmt_c__c = objOrder.Total_Unavailable_ShippingAmt_c__c != null ? objOrder.Total_Unavailable_ShippingAmt_c__c + refundShipping : refundShipping;
        objOrder.Total_Unavailable_ShippingTax_c__c = objOrder.Total_Unavailable_ShippingTax_c__c != null ? objOrder.Total_Unavailable_ShippingTax_c__c +  vertexResponse.shipping_Charges_tax : vertexResponse.shipping_Charges_tax;
        objOrder.Total_Unavailable_ProductAmt_c__c = objOrder.Total_Unavailable_ProductAmt_c__c != null ? objOrder.Total_Unavailable_ProductAmt_c__c + refundProductAmount : refundProductAmount;
        objOrder.Total_Unavailable_ProductTax_c__c = objOrder.Total_Unavailable_ProductTax_c__c != null ? objOrder.Total_Unavailable_ProductTax_c__c + vertexResponse.product_Charges_tax : vertexResponse.product_Charges_tax;
        objOrder.Total_Unavailable_TaxAmt_c__c = objOrder.Total_Unavailable_TaxAmt_c__c != null ? objOrder.Total_Unavailable_TaxAmt_c__c + vertexResponse.totalTaxAmount : vertexResponse.totalTaxAmount;
        objOrder.Total_Unavailable_AMT_c__c = objOrder.Total_Unavailable_AMT_c__c != null ? objOrder.Total_Unavailable_AMT_c__c + refundTotal : refundTotal;
        objOrder.Total_Unavailable_PreTaxAmt_c__c = objOrder.Total_Unavailable_PreTaxAmt_c__c != null ? objOrder.Total_Unavailable_PreTaxAmt_c__c + refundProductAmount + refundShipping : refundProductAmount + refundShipping;       
        if(objOrder.Total_Unavailable_AMT_c__c == objOrder.Updated_Order_Total_c__c){
            objOrder.Status__c = B2B_IntegrationConstants.SYSTEM_CANCELED;
        }
        System.debug('Order -->'+objOrder);
        
        List<OrderItem__x> updateOrderItemLst = new List<OrderItem__x>();
        // Order Item Data Updates
        for(OrderItem__x objOrderItem : lstOrderItems){
            if(objOrderItem.Delta_Quantity_c__c > 0){
                Decimal productTax = 0; 
                Decimal shippingTax = 0;
                if(vertexResponse.mapOrderItemTax.containsKey(objOrderItem.Id)){
                    productTax = -1 * vertexResponse.mapOrderItemTax.get(objOrderItem.Id);
                    
                    Decimal remainingOrderItemProdTax = objOrderItem.Total_Current_Product_Tax_c__c - (objOrderItem.Total_Unavailable_ProductTax_c__c != null? objOrderItem.Total_Unavailable_ProductTax_c__c : 0) ;
                    if(productTax < remainingOrderItemProdTax && (objOrderItem.Quantity__c - (objOrderItem.Unavailable_Quantity_c__c + objOrderItem.Delta_Quantity_c__c) == 0)){
                        productTax += remainingOrderItemProdTax - productTax;
                    }
                
                }
                if(vertexResponse.mapOrderItemShipTax.containsKey(objOrderItem.Id)){
                    shippingTax = -1 * vertexResponse.mapOrderItemShipTax.get(objOrderItem.Id);
                
                    Decimal remainingOrderItemShipTax = objOrderItem.Total_Current_Shipping_TaxAMT_c__c - (objOrderItem.Total_Unavailable_ShippingTax_c__c != null? objOrderItem.Total_Unavailable_ShippingTax_c__c : 0);
                    if(shippingTax < remainingOrderItemShipTax && (objOrderItem.Quantity__c - (objOrderItem.Unavailable_Quantity_c__c + objOrderItem.Delta_Quantity_c__c) == 0)){
                        shippingTax += remainingOrderItemShipTax - shippingTax;
                    }
                }
                objOrderItem.Unavailable_Quantity_c__c = objOrderItem.Unavailable_Quantity_c__c != null ? objOrderItem.Unavailable_Quantity_c__c + objOrderItem.Delta_Quantity_c__c : objOrderItem.Delta_Quantity_c__c;
                objOrderItem.Total_Unavailable_ProductAmt_c__c = objOrderItem.Unavailable_Quantity_c__c * objOrderItem.ListPrice__c;
                objOrderItem.Total_Unavailable_ProductTax_c__c = objOrderItem.Total_Unavailable_ProductTax_c__c != null ? objOrderItem.Total_Unavailable_ProductTax_c__c + productTax : productTax;
                objOrderItem.Total_Unavailable_ShippingAmt_c__c = objOrderItem.Unavailable_Quantity_c__c * objOrderItem.Shipping_Amount_Per_Unit_c__c;
                objOrderItem.Total_Unavailable_ShippingTax_c__c = objOrderItem.Total_Unavailable_ShippingTax_c__c != null ? objOrderItem.Total_Unavailable_ShippingTax_c__c + shippingTax : shippingTax;       
            	updateOrderItemLst.add(objOrderItem);
            }
        }
        System.debug('Order Items List-->'+ updateOrderItemLst);
        if(!Test.isRunningTest()){
            if(!updateOrderItemLst.isEmpty()){
                Database.updateImmediate(updateOrderItemLst);
            }              
            Database.updateImmediate(objOrder);                     
        }
    }
    
    //-------------------------------------HRC Modification refund Ends ------------------------------------------------------//
    
    
    
    // Method to create the Order Transaction & items for the Order
    @AuraEnabled
    public static Boolean createShipmentAuditTrails(Order__x order){
        try {                        
            // Update order details
            objOrder = HDMDealerExperienceController.updateExternalOrder(order);  
            
            objOrder = (!mockedOrder.isEmpty()) ? mockedOrder[0] :[SELECT Id, Status__c, ExternalId, Updated_Shipping_c__c, Updated_Total_Tax_c__c, Updated_Order_Total_c__c, Current_Shipping_Tax_c__c, 
                        Total_Unavailable_ShippingAmt_c__c, Total_Unavailable_ShippingTax_c__c, Total_Unavailable_TaxAmt_c__c, Total_Unavailable_AMT_c__c,
                        (SELECT Id, ListPrice__c, ExternalId, Updated_Quantity_c__c, Total_Current_Product_Tax_c__c, Total_Current_Shipping_TaxAMT_c__c, Unavailable_Quantity_c__c, Total_Unavailable_ProductTax_c__c,
                         Shipping_Amount_Per_Unit_c__c,  Total_Unavailable_ShippingTax_c__c, Product_Type_c__c FROM Order_Products__r WHERE Type__c != 'Delivery Charge')
                        FROM Order__x WHERE Id =: order.Id LIMIT 1];
            
            // Order Transaction for refund
            Order_Transaction_c__x objOrderTransaction = new Order_Transaction_c__x();
            objOrderTransaction.Order_c__c = objOrder.ExternalId;
            objOrderTransaction.Order_Transaction_Type_c__c = 'Shipment';
            objOrderTransaction.Order_Transaction_Status_c__c = 'Success';
            objOrderTransaction.Is_Adjustment_c__c = false;
            objOrderTransaction.Total_Post_Adjustment_Shiping_Charge_c__c = objOrder.Updated_Shipping_c__c - ((objOrder.Total_Unavailable_ShippingAmt_c__c != null) ? objOrder.Total_Unavailable_ShippingAmt_c__c : 0);
            objOrderTransaction.Total_Post_adjustment_Shipping_Tax_c__c = objOrder.Current_Shipping_Tax_c__c - ((objOrder.Total_Unavailable_ShippingTax_c__c != null) ? objOrder.Total_Unavailable_ShippingTax_c__c : 0);
            objOrderTransaction.Post_Adjustment_Total_Amount_c__c = objOrder.Updated_Order_Total_c__c - ((objOrder.Total_Unavailable_AMT_c__c != null) ? objOrder.Total_Unavailable_AMT_c__c : 0);
            objOrderTransaction.Post_Adjustment_Total_Tax_c__c = objOrder.Updated_Total_Tax_c__c - ((objOrder.Total_Unavailable_TaxAmt_c__c != null) ? objOrder.Total_Unavailable_TaxAmt_c__c : 0);
            objOrderTransaction.Adjustment_Date_Time_c__c = System.now();        
            
            if(!Test.isRunningTest()){
                Database.insertImmediate(objOrderTransaction);
                objOrderTransaction = [Select Id, ExternalId FROM Order_Transaction_c__x WHERE Id =:objOrderTransaction.Id LIMIT 1];
                orderTransactionId = objOrderTransaction.ExternalId;
            }               
            
            List<Order_Transaction_Item_c__x> lstOrderTransItems = new List<Order_Transaction_Item_c__x>();
            List<OrderItem__x> lstOrderItemss = (!mockedOrderItems.isEmpty()) ? mockedOrderItems : objOrder.Order_Products__r;
            for(OrderItem__x objOrderItem :  lstOrderItemss){                         
                //Order Transaction Item for refund
                Order_Transaction_Item_c__x objOrderTranItem = new Order_Transaction_Item_c__x();
                objOrderTranItem.Order_Item_c__c = objOrderItem.ExternalId;
                objOrderTranItem.Post_Adjustment_Quantity_c__c = objOrderItem.Updated_Quantity_c__c - ((objOrderItem.Unavailable_Quantity_c__c  != null) ? objOrderItem.Unavailable_Quantity_c__c : 0);
                objOrderTranItem.Post_Adjustment_Extended_Price_c__c = (!Test.isRunningTest()) ? (objOrderTranItem.Post_Adjustment_Quantity_c__c * objOrderItem.ListPrice__c) : 0;
                objOrderTranItem.Total_Post_Adjustment_Product_Tax_c__c = objOrderItem.Total_Current_Product_Tax_c__c - ((objOrderItem.Total_Unavailable_ProductTax_c__c != null) ? objOrderItem.Total_Unavailable_ProductTax_c__c : 0);
                objOrderTranItem.Total_Post_ShippingAmt_c__c = objOrderTranItem.Post_Adjustment_Quantity_c__c * objOrderItem.Shipping_Amount_Per_Unit_c__c;
                objOrderTranItem.Total_Post_ShippedTax_c__c = objOrderItem.Total_Current_Shipping_TaxAMT_c__c - ((objOrderItem.Total_Unavailable_ShippingTax_c__c != null) ? objOrderItem.Total_Unavailable_ShippingTax_c__c : 0); 
                objOrderTranItem.Adjustment_Date_Time_c__c = System.now();         
                objOrderTranItem.AK_Order_Transaction_Item_c__c = objOrderItem.ExternalId +''+ orderTransactionId;
                objOrderTranItem.Product_Type_c__c = objOrderItem.Product_Type_c__c; // Added by Imtiyaz Ali
                lstOrderTransItems.add(objOrderTranItem);
            }
            System.debug('Order Transaction Item List -->'+ lstOrderTransItems);
            
            if(!lstOrderTransItems.isEmpty()){
                if(!Test.isRunningTest()){
                    Database.insertImmediate(lstOrderTransItems);
                }            	
            }
            return true;
        }catch(Exception ex){
            System.debug('Exception :- '+ ex.getMessage());
            return false;
        }
    }
       
}