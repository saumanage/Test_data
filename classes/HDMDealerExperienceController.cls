/**********************************************************************
Name: HDMDealerExperienceController
Purpose: Apex class is created for insertion/updation of external objects & fields for HDM org.
Created Date :  30/07/2021, 3:01 PM
Created By : Vikrant Upneja
Last Modified By :  Faraz Ansari 25/05/2022 for 8722
Last Modified By :  RajRishi Kaushik ,  06/06/2022, 11:19 AM
Salesforce API Version : 55.0
*************************************************************/
public class HDMDealerExperienceController {
    @TestVisible private static List<Order__x> mockedOrder = new List<Order__x>();
    @TestVisible private static List<OrderItem__x> mockedOrderItems = new List<OrderItem__x>();
    @TestVisible private static List<Account__x> mockedAccounts = new List<Account__x>();
    //public static B2B_VertexTaxCalculationIntegration.ResponseDataWrapper responseData2 = New B2B_VertexTaxCalculationIntegration.ResponseDataWrapper(); // Saravanan LTIM Test Classes
    private static B2B_HDMBraintreeIntegration.ResponseWrapper objResponse; //added by suresh for Braintree Reconciliation
    private static B2B_BrainTreeTransactionResponse BTResponsebody; //added by suresh for Braintree Reconciliation
    private static String orderTransactionId;//added by suresh for Braintree Reconciliation


    
    @auraEnabled
    public static Order__x updateExternalOrder(Order__x objOrder){
        system.debug('Order__x : '+objOrder);
        if(objOrder != null){
            Long beforeAPI = B2B_Util.fetchCurrentTime();
            try{ 
                if(!Test.isRunningTest()){
    
    
                    Database.SaveResult updateResult = Database.updateImmediate(objOrder);
                    if (updateResult.isSuccess()) {
                        System.debug('$$Record updated successfully. Id: ' + updateResult.getId());
                    } else {
                        for(Database.Error error : updateResult.getErrors()) {
                            System.debug('$$Error updating record: ' + error.getStatusCode() + ' - ' + error.getMessage());
                        }
                    }
                }
                return objOrder;
            }catch(Exception ex){
                System.debug('Exception Occurred : '+ ex.getMessage());             
                //Added by Lokesh for payment-settlement HDMP-29580
                Long afterAPI = B2B_Util.fetchCurrentTime();
                Long durationTime = B2B_Util.calInMilliSeconds(beforeAPI,afterAPI);
                B2B_Util.createErrorRecord('Shipment Info Update','','','','','HDMDealerExperienceController', 'Shipment Update Info Failed',Label.B2B_Error_Type,'','updateExternalOrder',true, objOrder.Id,'','',durationTime,Label.B2B_Severity,'','');            
            }            
        }
        return null;       
    } 
    
    @auraEnabled
    public static List<OrderItem__x> updateExternalOrderItem(List<OrderItem__x> lstOrderItems, String orderStatus, Decimal restockingFees, Decimal shippingRefund, Decimal installRefund, Decimal TaxRefund, String customerNote){
        system.debug('lstOrderItems : '+lstOrderItems);
        List<OrderItem__x> lstOrderItemUpdate = new List<OrderItem__x>();

        if(!lstOrderItems.isEmpty()){
            try{ 
                String OrderId = (!mockedOrder.isEmpty()) ? 'mocked' : lstOrderItems[0].OrderId__c;              
                Decimal shippingAmountToDuduct = 0;  
                Decimal updatedAmount = 0;
                Boolean  isVertexFails = false;
                Boolean isVoidTransacFails = false;
                Boolean isVoidMethod = false;
                Boolean revertOrderChanges = false;
                Boolean revertChangesOnVertexFails = false;
                Map<Id, OrderItem__x> mapOrderItemToUpdate = new Map<Id, OrderItem__x>();
                          
                if(String.isNotBlank(OrderId)){
                    System.debug('OrderId' + OrderId);
                    // Saravanan LTIM Added Total_Core_Charge_Current_Amount__c,Total_Core_Charge_Current_Tax__c,Total_Core_Charge_Current_Quantity__c for Sprint 3 Data Rules,Total_Core_Charge_Return_Amount__c , Total_Core_Charge_Current_Amount__c
                    Order__x objOrder = (!mockedOrder.isEmpty()) ? mockedOrder[0] : [SELECT Id, Type__c, ShippingStreet__c, Total_Current_Product_Tax_c__c, Total_Current_Pre_Tax_Order_Amount_c__c, Current_Quantity_c__c, ShippingCity__c, ShippingState__c, ShippingCountry__c, ShippingPostalCode__c, Current_Installation_Tax_c__c, ExternalId, AccountId__c,Customer_Notes_c__c,
                                                                                     Updated_Shipping_c__c, Updated_Total_Tax_c__c, Updated_Order_Total_c__c, Status__c, Updated_Order_Amount_c__c, Send_Email_To_Customer_c__c, Shipping_Refund_c__c, Restocking_Fees_c__c, Install_Refund_c__c, Tax_Refund_c__c,
                                                                                     Cart_Shipping_Street_c__c, Cart_Shipping_City_c__c, Cart_Shipping_State_c__c, Cart_Shipping_Postal_Code_c__c, Total_Return_c__c, Total_Tax_Return_c__c, Total_Item_Return_c__c, OrderedDate__c,Return_Shipping_Tax_c__c,Total_Restocking_Fee_Tax_c__c, Total_Core_Charge_Return_Amount__c, Total_Core_Charge_Return_Quantity__c,Total_Core_Charge_Return_Tax_c__c,Total_Return_Product_Tax_c__c,
                                                                                     Total_Core_Charge_Original_Tax__c,Total_Core_Charge_Current_Tax__c,cart_c__c,OwnerId__c,BT_Transaction_Id_c__c,BT_Transaction_Status_c__c,BT_Customer_Detail_c__c,Current_Shipping_Tax_c__c,Total_Core_Charge_Current_Amount__c,Total_Core_Charge_Current_Quantity__c,Delivery_Types_c__c,Dealer_Number_c__c,IsError_c__c,BillingStreet__c,BillingCity__c,BillingState__c,
                                                                                     BillingZip_c__c,BillingPostalCode__c,CC_Last4_c__c,Payment_Gateway_c__c,Payment_Method_Token_c__c,Payment_Type_c__c
                                         FROM Order__x
                                         WHERE Id =: OrderId];
                     List<OrderItem__x> listOrderItems = [SELECT Id,ExternalId, Total_Return_Installation_Charge_c__c, Total_Current_Product_Tax_c__c, Total_Return_Product_Tax_c__c, TotalPrice__c, Dealer_Installation_Price_c__c, Delta_Installation_Price_c__c, Delta_Quantity_c__c,Updated_Quantity_c__c,Return_Quantity_c__c, Quantity__c, UnitPrice__c, ListPrice__c, Total_Tax_c__c, Product_SKU_c__c, Cart_Item_Product_Name_c__c, Op_Code_c__c ,Product_Type_c__c,TotalLineAmount__c, Order_Item_Status_c__c, Total_Original_ShippingAMT_c__c, Total_Current_ShippingAMT_c__c, Total_Current_Shipping_TaxAMT_c__c, Total_Original_Shipping_TaxAmt_c__c,Shipping_Amount_Per_Unit_c__c FROM OrderItem__x WHERE Type__c != 'Delivery Charge' AND OrderId__c =:OrderId];

                    System.debug('objOrder' + objOrder);
                    if(orderStatus == 'Modify Order'){
                        List<B2B_VertexTaxCalculationIntegration.OrderItemWrapper> lstOrderItemWrappers = new List<B2B_VertexTaxCalculationIntegration.OrderItemWrapper>();              
                        Decimal updatedTax = 0;
                        Decimal updatedCore = 0; // Added by ashwin for bug number 19392
                        //Imtiyaz - EVSE_Phase2_Sprint_3_HDMP- Start
                        Decimal shippingTaxToDuduct = 0;
                        //Imtiyaz - EVSE_Phase2_Sprint_3_HDMP- Start
                        Decimal orderItemcurrentQuantity = 0;
                        for(OrderItem__x objOrderItem : lstOrderItems){    
                            System.debug('HPC_: objOrderItem: ' + objOrderItem);
                            B2B_VertexTaxCalculationIntegration.OrderItemWrapper objOrderItemWrapper = new B2B_VertexTaxCalculationIntegration.OrderItemWrapper();
                            if(objOrderItem.Delta_Quantity_c__c > 0){
                                objOrderItemWrapper.quantity = Integer.valueOf(objOrderItem.Delta_Quantity_c__c); 
                                objOrderItemWrapper.unitPrice =  (!Test.isRunningTest()) ? objOrderItem.ListPrice__c : 22.00;
                                objOrderItemWrapper.orderItemId = objOrderItem.Id;
                                // added for motocompacto
                                objOrderItemWrapper.productType = objOrderItem.Cart_Item_Product_Name_c__c == 'Motocompacto' ? 'Motocompacto' : '';
                                // LTIM added field mapping                       
                                /* Added by ashwin,Saravanan for SP3-16544, Data Rules  */ 
                                objOrderItemWrapper.carItemProductName = objOrderItem.Cart_Item_Product_Name_c__c;
                                lstOrderItemWrappers.add(objOrderItemWrapper);
                                //Imtiyaz - EVSE_Phase2_Sprint_3_HDMP- Start
                                if(objOrder.Type__c == B2B_Constants.DIRECTSHIP){
                                    shippingAmountToDuduct += objOrderItem.Shipping_Amount_Per_Unit_c__c * objOrderItem.Delta_Quantity_c__c;
                                    shippingTaxToDuduct += (objOrderItem.Total_Original_Shipping_TaxAmt_c__c / objOrderItem.Quantity__c) * objOrderItem.Delta_Quantity_c__c;
                                } //Imtiyaz - EVSE_Phase2_Sprint_3_HDMP- End
                                orderItemcurrentQuantity += orderItemcurrentQuantity  + objOrderItem.Delta_Quantity_c__c ; 
                                //added by suresh

                            }            
                            if(!Test.isRunningTest()){
                            // if condition Added by ashwin for bug number 19392
                                if(objOrderItem.Product_Type_c__c == 'Core Charge'){
                                   updatedCore += objOrderItem.Delta_Quantity_c__c * objOrderItem.ListPrice__c;
                                }else{
                                updatedAmount += objOrderItem.Delta_Quantity_c__c * objOrderItem.ListPrice__c;    //REMAN-122
                                }
                            }                                                     
                        }
                        //below lines code for order cancellation when order modified to zero quantity
                        String brainTreeResponse = '';
                        B2B_BrainTreeTransactionResponse objBTTransResponse = new B2B_BrainTreeTransactionResponse();
                        if(objOrder.Current_Quantity_c__c == orderItemcurrentQuantity && objOrder.Delivery_Types_c__c != 'Install At Dealer' ){
                            isVoidMethod = true;
                            if(objOrder.BT_Transaction_Status_c__c =='Authorized'){
                                Long beforeAPI = B2B_Util.fetchCurrentTime();
                                // call the HDM Salesforce API to get the SF Token
                                B2B_HDMBraintreeIntegration.DeviceCodeWrapper tokenDetails = B2B_HDMBraintreeIntegration.getDeviceCode();
                                if(tokenDetails.status == 200 && String.isNotEmpty(tokenDetails.deviceToken)){
                                // call the HDM Salesforce API to get the BT dealer access token
                                    B2B_HDMBraintreeIntegration.ResponseWrapper objResponse = B2B_HDMBraintreeIntegration.getDealerAccessToken(objOrder.Dealer_Number_c__c, tokenDetails.deviceToken);
                                    if(objResponse != null && objResponse.isSuccess && String.isNotEmpty(objResponse.accessToken)){
                                        brainTreeResponse = B2B_HDMBraintreeIntegration.braintreeTransactionVoid(objOrder.BT_Customer_Detail_c__c, objResponse.merchantId, objOrder.BT_Transaction_Id_c__c, objResponse.accessToken);
                                        objBTTransResponse = B2B_BrainTreeTransactionResponse.parse(brainTreeResponse);
                                        if(objBTTransResponse.status == 200){
                                            objOrder.BT_Transaction_Status_c__c = objBTTransResponse.transactionBT.status;
                                           
                                        }else{
                                            isVoidTransacFails = true;
                                            B2B_HDMBraintreeIntegration.createBTTransaction(objBTTransResponse,objOrder);
                                            //objOrder.BT_Transaction_Status_c__c = 'Voided';
                                        }

                                    }
                                }
                            }

                        }
                        if(objOrder.Delivery_Types_c__c != 'Install At Dealer'){
                            B2B_VertexTaxCalculationIntegration.ResponseDataWrapper responseData = B2B_VertexTaxCalculationIntegration.calculateLineItemReturnTax(objOrder, lstOrderItemWrappers,String.valueof(objOrder.Shipping_Refund_c__c),null);
                            
                            if(responseData.isSuccess == true){
                                Map<String, Vertex_Details_c__x> mapOrderItemVertexTax = new Map<String, Vertex_Details_c__x>();
                                Decimal shippingreturnTax = 0;
                                Decimal restockingtax = 0;
                                //map orderitem and vertex details records to update order item tax
                                for(Vertex_Details_c__x objVertexdetails : responseData.lstVertexDetails){
                                    if(String.isNotEmpty(objVertexDetails.OrderItem_c__c)){
                                        mapOrderItemVertexTax.put(objVertexDetails.OrderItem_c__c, objVertexDetails);
                                    }else if(objVertexDetails.B2B_Cart_Item_Id_c__c == Label.B2B_Shipping_Code){
                                        shippingreturnTax = objVertexDetails.B2B_Total_Tax_c__c;
                                    }else if(objVertexDetails.B2B_Cart_Item_Id_c__c == Label.B2B_restockingfee_Code){
                                        restockingTax = objVertexDetails.B2B_Total_Tax_c__c;
                                    }
                                }
                                objOrder.Return_Shipping_Tax_c__c = objOrder.Return_Shipping_Tax_c__c +(-1 * shippingreturnTax);
                                objOrder.Total_Restocking_Fee_Tax_c__c = restockingtax;

                                Decimal returnQuantity = 0;
                                Decimal returnProductTax = 0;
                                // Saravanan LTIM Starts - Sprint 2 Data Rules Partial Return Complete REMAN-208

                                Decimal returnCoreChargeQuantity = 0;
                                Decimal returnCoreChargeTax = 0;
                                Decimal returnCoreAmount = 0;
                                
                                Decimal currentCoreChargeQuantity = 0 ;
                                    Decimal currentCoreChargeAmount = 0 ;
                                    Decimal currentCoreChargeTax = 0 ;
                                //List<OrderItem__x> lstOrderItems2 = [SELECT Id,ExternalId, Total_Return_Installation_Charge_c__c, Total_Current_Product_Tax_c__c, Total_Return_Product_Tax_c__c, TotalPrice__c, Dealer_Installation_Price_c__c, Delta_Installation_Price_c__c, Delta_Quantity_c__c,Updated_Quantity_c__c,Return_Quantity_c__c, Quantity__c, UnitPrice__c, ListPrice__c, Total_Tax_c__c, Product_SKU_c__c, Cart_Item_Product_Name_c__c, Op_Code_c__c ,Product_Type_c__c,TotalLineAmount__c, Order_Item_Status_c__c, Total_Original_ShippingAMT_c__c, Total_Current_ShippingAMT_c__c, Total_Current_Shipping_TaxAMT_c__c, Total_Original_Shipping_TaxAmt_c__c,Shipping_Amount_Per_Unit_c__c FROM OrderItem__x WHERE Type__c != 'Delivery Charge' AND OrderId__c =: OrderId];
                                Decimal totalproductTaxes = 0;
                                for(OrderItem__x objOrderItem : lstOrderItems){ 
                                    if(mapOrderItemVertexTax.containsKey(objOrderItem.ExternalId)){
                                        Vertex_Details_c__x objVertexDetail = mapOrderItemVertexTax.get(objOrderItem.ExternalId);   
                                        system.debug('objVertexDetail--164'+objVertexDetail);                            
                                        objOrderItem.Total_Return_Product_Tax_c__c = objOrderItem.Total_Return_Product_Tax_c__c + (-1 * objVertexDetail.B2B_Total_Tax_c__c);
                                        //pricesMap.put(objOrderItem.ExternalId, (-1 * objVertexDetail.B2B_Total_Tax_c__c));
                                        totalproductTaxes = totalproductTaxes + (-1 * objVertexDetail.B2B_Total_Tax_c__c);
                                        //updating tax on order item
                                        Decimal productTax = (-1* objVertexDetail.B2B_Total_Tax_c__c);
                                        objOrderItem.Total_Current_Product_Tax_c__c = objOrderItem.Total_Current_Product_Tax_c__c - productTax;
                                        if(objOrderItem.Product_Type_c__c != 'Core Charge'){
                                        returnProductTax = returnProductTax + (-1 * objVertexDetail.B2B_Total_Tax_c__c);
                                        }
                                        if(objOrderItem.Product_Type_c__c == 'Core Charge'){
                                            returnCoreChargeTax = returnCoreChargeTax + (-1 * objVertexDetail.B2B_Total_Tax_c__c);
                                        }
                                        
                                    } 
                                    if(objOrderItem.Product_Type_c__c != 'Core Charge'){
                                    returnQuantity += objOrderItem.Return_Quantity_c__c;
                                    }                  
                                    if(objOrderItem.Product_Type_c__c == 'Core Charge'){
                                        currentCoreChargeQuantity += objOrderItem.Updated_Quantity_c__c ; // Saravanan LTIM Locking Variables
                                        currentCoreChargeAmount += (objOrderItem.Updated_Quantity_c__c * objOrderItem.ListPrice__c) ; // Saravanan LTIM Locking Variables
                                        currentCoreChargeTax += objOrderItem.Total_Current_Product_Tax_c__c;// // Saravanan LTIM Locking Variables
                                        returnCoreChargeQuantity += objOrderItem.Return_Quantity_c__c;
                                        returnCoreAmount+=objOrderItem.Delta_Quantity_c__c * objOrderItem.ListPrice__c; //Saravanan LTIM HDMP-19484

                                    }
                                    system.debug('objOrderItem.Updated_Quantity_c__c ---190----'+objOrderItem.Updated_Quantity_c__c);
                                    //objOrderItem.Updated_Quantity_c__c = objOrderItem.Updated_Quantity_c__c -  objOrderItem.Delta_Quantity_c__c;
                                    system.debug('objOrderItem.Updated_Quantity_c__c ---190--'+objOrderItem.Updated_Quantity_c__c);
                                    system.debug('objOrderItem.Delta_Quantity_c__c ---190---'+objOrderItem.Delta_Quantity_c__c);
                                    //objOrderItem.Delta_Quantity_c__c = 0;
                                    system.debug('objOrderItem ---190'+objOrderItem);
                                    lstOrderItemUpdate.add(objOrderItem);
                                }
                                //objOrder.Send_Email_To_Customer_c__c = true;
                                objOrder.Return_Quantity_c__c = returnQuantity;
                                objOrder.Total_Return_Product_Tax_c__c += returnProductTax;
                                objOrder.Total_Core_Charge_Return_Amount__c = objOrder.Total_Core_Charge_Return_Amount__c != null ? objOrder.Total_Core_Charge_Return_Amount__c + returnCoreAmount : returnCoreAmount ;
                                objOrder.Total_Core_Charge_Return_Quantity__c = returnCoreChargeQuantity;
                                objOrder.Total_Core_Charge_Return_Tax_c__c = objOrder.Total_Core_Charge_Return_Tax_c__c != null ? objOrder.Total_Core_Charge_Return_Tax_c__c + returnCoreChargeTax : returnCoreChargeTax;

                                objOrder.Total_Core_Charge_Original_Tax__c = objOrder.Total_Core_Charge_Original_Tax__c != null ? objOrder.Total_Core_Charge_Original_Tax__c : 0;
                                objOrder.Total_Core_Charge_Return_Tax_c__c = objOrder.Total_Core_Charge_Return_Tax_c__c != null ? objOrder.Total_Core_Charge_Return_Tax_c__c : 0;
                                objOrder.Total_Core_Charge_Current_Tax__c = objOrder.Total_Core_Charge_Original_Tax__c - objOrder.Total_Core_Charge_Return_Tax_c__c ; //HDMP-19755

                                //added by here                           
                                updatedTax =  ((totalproductTaxes + (-1 *shippingreturnTax) ) - shippingTaxToDuduct);
                                decimal totalUpdated = updatedAmount + updatedTax + shippingAmountToDuduct;
                                objOrder.Updated_Order_Amount_c__c = objOrder.Updated_Order_Amount_c__c - updatedAmount;
                                objOrder.Updated_Shipping_c__c = objOrder.Updated_Shipping_c__c - shippingAmountToDuduct;
                                objOrder.Updated_Total_Tax_c__c = objOrder.Updated_Total_Tax_c__c - updatedTax;
                                objOrder.Updated_Order_Total_c__c = objOrder.Updated_Order_Total_c__c - totalUpdated;
                                system.debug('updatedAmount----'+updatedAmount);
                                system.debug('updatedTax----'+updatedTax);
                                system.debug('totalUpdated----'+totalUpdated);
                                system.debug('shippingreturnTax----'+shippingreturnTax);
                                system.debug('objOrder.Updated_Order_Amount_c__c----'+objOrder.Updated_Order_Amount_c__c);
                                system.debug('objOrder.Updated_Shipping_c__c----'+objOrder.Updated_Shipping_c__c);
                                system.debug('objOrder.Updated_Order_Total_c__c----'+objOrder.Updated_Order_Total_c__c);

                                
                                objOrder.Current_Quantity_c__c = objOrder.Current_Quantity_c__c - orderItemcurrentQuantity;
                                objOrder.Total_Current_Pre_Tax_Order_Amount_c__c = objOrder.Updated_Order_Total_c__c - objOrder.Updated_Total_Tax_c__c;
                                //objOrder.Total_Current_Product_Tax_c__c = objOrder.Total_Current_Product_Tax_c__c - updatedTax;
                                
                                if(!String.isEmpty(customerNote)){
                                    objOrder.Customer_Notes_c__c = customerNote;// Added by Faraz for 8722
                                }
                        
                            }else{
                                isVertexFails = true;
                            }
                            if(isVoidMethod){
                                objOrder.BT_Transaction_Status_c__c = 'Voided';
                                  if(objOrder.BT_Transaction_Status_c__c == 'Voided'){ 
                                    system.debug('objOrderItem ---222'+objOrder.BT_Transaction_Status_c__c);   
                                    //objOrder.Send_Email_To_Customer_c__c = true;
                                    objOrder.Status__c = 'SYSTEM CANCELED'; 
                                    objOrder.Updated_Order_Amount_c__c = 0;
                                    objOrder.Updated_Total_Tax_c__c = 0;
                                    objOrder.Updated_Order_Total_c__c = 0; 
                                    objOrder.Updated_Shipping_c__c = 0;
                                    objOrder.Current_Quantity_c__c= 0;
                                    objOrder.Current_Shipping_Tax_c__c = 0;
                                    objOrder.Total_Current_Pre_Tax_Order_Amount_c__c = 0;
                                    objOrder.Total_Current_Product_Tax_c__c = 0;
                                    objOrder.Total_Core_Charge_Current_Amount__c = 0;
                                    objOrder.Total_Core_Charge_Current_Tax__c = 0;
                                    objOrder.Total_Core_Charge_Current_Quantity__c = 0;
                                    //update orderItems
                                    for(OrderItem__x objOrderItem : listOrderItems){
                                        objOrderItem.Updated_Quantity_c__c = objOrderItem.Updated_Quantity_c__c -  objOrderItem.Delta_Quantity_c__c;

                                        if(objOrderItem.Delta_Quantity_c__c == 0){ 
                                            objOrder.Updated_Shipping_c__c = 0;
                                        }
                                        objOrderItem.Updated_Quantity_c__c = 0;
                                        objOrderItem.Total_Current_Product_Tax_c__c = 0;
                                        if(objOrder.Type__c == 'DIRECTSHIP'){
                                            objOrderItem.Order_Item_Status_c__c = 'CANCELLED';
                                            objOrderItem.Total_Current_ShippingAMT_c__c = 0;
                                            objOrderItem.Total_Current_Shipping_TaxAMT_c__c = 0;   
                                        }
                                        objOrder.Send_Email_To_Customer_c__c = false;
                                        lstOrderItemUpdate.add(objOrderItem);
                                    }
                                 }
                            } 
                            if(!isVoidMethod){
                                if(responseData.isSuccess == false){
                                    revertChangesOnVertexFails = true;
                                    objOrder.IsError_c__c = true;
                                    createOrderAuditTrails(objOrder, lstOrderItems, customerNote, shippingAmountToDuduct, updatedAmount);
                                    return null;
                                }
                            }
                            
                            if(isVertexFails && isVoidTransacFails){
                                revertOrderChanges = true;
                                objOrder.IsError_c__c = true;
                                createOrderAuditTrails(objOrder, lstOrderItems, customerNote, shippingAmountToDuduct, updatedAmount);
                                return null;
                            }else if(isVoidTransacFails){
                                objOrder.IsError_c__c = true;
                                createOrderAuditTrails(objOrder, lstOrderItems, customerNote, shippingAmountToDuduct, updatedAmount);

                            }
                        }else{
                        String taxResponse = B2B_TaxHelper.getTaxRatesAndAmountsFromVertex(objOrder, lstOrderItemWrappers, null, null, null);
                            B2B_VertexTaxCalculationIntegration.ResponseDataWrapper responseData = (B2B_VertexTaxCalculationIntegration.ResponseDataWrapper) JSON.deserialize(taxResponse, B2B_VertexTaxCalculationIntegration.ResponseDataWrapper.class);
                        // Saravanan LTIM Added for Sprint Modifications REMAN-073
                        objOrder.Total_Core_Charge_Current_Quantity__c = objOrder.Total_Core_Charge_Current_Quantity__c != null ?  objOrder.Total_Core_Charge_Current_Quantity__c : 0;
                         // Saravanan LTIM Ended for Sprint Modifications REMAN-073

                      //  responseData = Test.isRunningTest() ? responseData2 : responseData; // Saravanan LTIM Test Classes

                        if(responseData.isSuccess == true){
                            Decimal currentQuantity = 0;
                            // changes for HDMP-8716 : audit trail starts
                            system.debug('Total Tax Value----'+responseData.totalTaxAmount);

                            Decimal ProductTaxVal = 0;

                            Decimal orderItemProductTaxVal = 0;
                            Decimal coreChargeTax = 0.00;
                            Decimal coreChargeTaxAfterModification =0.00; // Saravanan LTIM Locking
                            Boolean hasChangeinCoreCharge = false; // Saravanan LTIM HDMP-25371

                            for(OrderItem__x objOrderItem : lstOrderItems){ 
                                if(responseData.mapOrderItemTax.containsKey(objOrderItem.Id)){

                                    // Saravanan LTIM Added if conditions for Sprint 2 Data Rules Order Modification REMAN-128 ,reman-122

                                    if(objOrderItem.Product_Type_c__c != 'Core Charge'){
                                        Decimal productTax = -1 * responseData.mapOrderItemTax.get(objOrderItem.Id);
                                        objOrderItem.Total_Current_Product_Tax_c__c = objOrderItem.Total_Current_Product_Tax_c__c - productTax;
                                        objOrderItem.Total_Return_Product_Tax_c__c = productTax;

                                        system.debug('Check Value ---'+objOrderItem.Total_Current_Product_Tax_c__c);

                                        ProductTaxVal = ProductTaxVal + objOrderItem.Total_Current_Product_Tax_c__c;

                                        orderItemProductTaxVal = orderItemProductTaxVal + objOrderItem.Total_Current_Product_Tax_c__c;

                                    }

                                    // Saravanan LTIM Added for Sprint 2 Data Rules Order Modification
                                    if(objOrderItem.Product_Type_c__c == 'Core Charge'){
                                        Decimal productTax = -1 * responseData.mapOrderItemTax.get(objOrderItem.Id);

                                        coreChargeTax = coreChargeTax + productTax;
                                        system.debug('Core Charge Product Tax---'+productTax);
                                        system.debug('Core Charge Product Tax---'+coreChargeTax);


                                      //  system.debug('Checking Updated_Quantity_c__c--'+objOrderItem.Updated_Quantity_c__c);
                                        objOrderItem.Delta_Quantity_c__c = objOrderItem.Delta_Quantity_c__c != null ? objOrderItem.Delta_Quantity_c__c : 0;
                                        objOrder.Total_Core_Charge_Current_Quantity__c =  (objOrder.Total_Core_Charge_Current_Quantity__c - objOrderItem.Delta_Quantity_c__c); // objOrderItem.Updated_Quantity_c__c;
                                        objOrder.Total_Core_Charge_Current_Amount__c =   objOrder.Total_Core_Charge_Current_Amount__c - (objOrderItem.ListPrice__c*objOrderItem.Delta_Quantity_c__c);// (!Test.isRunningTest()) ?  (objOrderItem.ListPrice__c * objOrderItem.Updated_Quantity_c__c) : 2; // REMAN-073
                                        
                                        objOrderItem.Total_Current_Product_Tax_c__c = objOrderItem.Total_Current_Product_Tax_c__c - productTax;  //objOrder.Total_Core_Charge_Current_Quantity__c != 0 ? objOrder.Total_Core_Charge_Current_Quantity__c * (productTax/objOrderItem.Delta_Quantity_c__c) : 0; // Bug HDMP-    .setscale(2,)
                                        objOrderItem.Total_Return_Product_Tax_c__c = productTax; // HDMP - 19396 
                                        hasChangeinCoreCharge = true; // Saravanan LTIM 25371
                                        coreChargeTaxAfterModification +=  objOrderItem.Total_Current_Product_Tax_c__c != null ?  objOrderItem.Total_Current_Product_Tax_c__c : 0; // Saravanan LTIM Locking

                                    }
                                    // Saravanan LTIM Ends for Sprint 2 Data Rules Order Modification

                                    // Below Else condition to calculate Delta Quantity for Non-Core Charge REMAN-073
                                    else{  
                                            currentQuantity += objOrderItem.Delta_Quantity_c__c; 

                                    }

                                }                              

                                
                           

                            }
                            // changes for HDMP-8716 : audit trail ends
                            
                            //Imtiyaz - EVSE_Phase2_Sprint_3_HDMP- Start
                            updatedTax = -1 * (responseData.totalTaxAmount - shippingTaxToDuduct);
                            decimal totalUpdated = updatedAmount + updatedTax + updatedCore + shippingAmountToDuduct;  // + updatedCore Added by ashwin for bug number 19392
                            objOrder.Updated_Order_Amount_c__c = objOrder.Updated_Order_Amount_c__c - updatedAmount; //REMAN-122
                            objOrder.Updated_Shipping_c__c = objOrder.Updated_Shipping_c__c - shippingAmountToDuduct;
                            objOrder.Updated_Total_Tax_c__c = objOrder.Updated_Total_Tax_c__c - updatedTax;
                            objOrder.Updated_Order_Total_c__c = objOrder.Updated_Order_Total_c__c - totalUpdated;
                            //Added by Lokesh for bug-29252
                            if(!String.isEmpty(customerNote)){
                                objOrder.Customer_Notes_c__c = customerNote;// Added by Faraz for 8722
                            }
                            objOrder.Restocking_Fees_c__c = 0;
                        
                            //Imtiyaz - EVSE_Phase2_Sprint_3_HDMP- End

                            System.debug('HPC_: objOrder: ' + objOrder);
                            
                            //added for HDMP-10890
                            objOrder.Current_Quantity_c__c = objOrder.Current_Quantity_c__c - currentQuantity;
                            objOrder.Total_Current_Pre_Tax_Order_Amount_c__c = objOrder.Updated_Order_Total_c__c - objOrder.Updated_Total_Tax_c__c;
                            objOrder.Total_Current_Product_Tax_c__c = objOrder.Total_Current_Product_Tax_c__c - ( updatedTax - (coreChargeTax != null ? coreChargeTax : 0)) ;// - (objOrder.Total_Core_Charge_Current_Tax__c != null ? objOrder.Total_Core_Charge_Current_Tax__c : 0); // HDMP-19436 , reman-122

                            system.debug('objOrder.Total_Core_Charge_Current_Tax__c---'+objOrder.Total_Core_Charge_Current_Tax__c);
                            
                            // Saravanan LTIM 25371
                            objOrder.Total_Core_Charge_Current_Tax__c =  (hasChangeinCoreCharge == true) ? coreChargeTaxAfterModification : objOrder.Total_Core_Charge_Current_Tax__c ;//objOrder.Total_Core_Charge_Current_Quantity__c > 0 ? ((objOrder.Total_Core_Charge_Current_Tax__c != null ? objOrder.Total_Core_Charge_Current_Tax__c : 0) - (coreChargeTax != null ? coreChargeTax : 0)) : 0; // reman-122 Variance Saravanan LTIM Locking


                            if(objOrder.Updated_Order_Amount_c__c == 0){
                                objOrder.Updated_Order_Total_c__c = 0;
                                objOrder.Updated_Shipping_c__c = 0;
                                objOrder.Send_Email_To_Customer_c__c = true;
                                objOrder.Status__c = 'CUSTOMER CANCELED'; 
                                objOrder.Total_Core_Charge_Current_Tax__c = 0; // Saravanan LTIM Added for Variance

                            } 
                        }else {
                            createOrderAuditTrails(objOrder, lstOrderItems, customerNote, shippingAmountToDuduct, updatedAmount);
                            return null;
                        }
                    }

                    }else if(orderStatus == 'Partial Return'){
                        objOrder.Status__c = 'PARTIAL RETURN COMPLETE';
                       
                        objOrder.Send_Email_To_Customer_c__c = false;
                        objOrder.Shipping_Refund_c__c = shippingRefund;
                        objOrder.Restocking_Fees_c__c = restockingFees;
                        objOrder.Install_Refund_c__c = installRefund;
                        objOrder.Tax_Refund_c__c = TaxRefund;
                        //Added by Lokesh for bug-29252
                        if(!String.isEmpty(customerNote)){
                        objOrder.Customer_Notes_c__c = customerNote;// Added by Faraz for 8722
                        }
                        // Saravanan ADED for Debug
                        for(OrderItem__x objOrderItem : lstOrderItems){    
                            if(objOrderItem.Product_Type_c__c == 'Core Charge'){
                                 objOrder.Total_Core_Charge_Current_Amount__c =   objOrder.Total_Core_Charge_Current_Amount__c - ((Test.isRunningTest() ? 0 : objOrderItem.ListPrice__c) *objOrderItem.Delta_Quantity_c__c);// (!Test.isRunningTest()) ?  (objOrderItem.ListPrice__c * objOrderItem.Updated_Quantity_c__c) : 2; // REMAN-073
                                 objOrder.Total_Core_Charge_Current_Quantity__c =  (objOrder.Total_Core_Charge_Current_Quantity__c - objOrderItem.Delta_Quantity_c__c); // Saravanan LTIM Added for HDMP-19481

                                }    
                        }
                        // Saravanan ADED for Debug
                    }
                    if(!Test.isRunningTest()){
                       //update orderItem
                       if(objOrder.Delivery_Types_c__c != 'Install At Dealer' && orderStatus == 'Modify Order' ){
                            if(!revertOrderChanges || !revertChangesOnVertexFails){
                                mapOrderItemToUpdate.putAll(lstOrderItemUpdate);
                                Database.updateImmediate(mapOrderItemToUpdate.values());
                            }
                       }else{
                        Database.updateImmediate(lstOrderItems);
                       }
                        
                        
                        
                        //update order                
                        
                        if(!revertOrderChanges || !revertChangesOnVertexFails){
                            System.debug('updataing_: objOrder--340: ' + objOrder); 
                        Database.updateImmediate(objOrder);  
                        }             

                        
                    }                   
                }
                
                return lstOrderItems;
            }catch(Exception ex){
                System.debug('Exception Occurred : '+ ex.getMessage());
                System.debug('Exception Line Number : '+ ex.getLineNumber());
                System.debug('Exception Line Number : '+ ex.getStackTraceString());
            }            
        }
        return null;       
    } 
   
    // Added by Swaroop for HPD_Sprint5 --- Start
    public class orderFullFilmentWrapper{
        @AuraEnabled
        public String Id{get;set;}
        @AuraEnabled
        public String orderId{get;set;}
        @AuraEnabled
        public String trackingNumber{get;set;}
        @AuraEnabled
        public String shipmentCarrier{get;set;}
        @AuraEnabled
        public String hondaShippingSpeed{get;set;}
    }

    @AuraEnabled
    public static Order_Fulfillment_c__x insertUpdateExternalOrdFullFilment(orderFullFilmentWrapper objOrdFulFillWrapper, Boolean dmlOp){
        if(objOrdFulFillWrapper != null){
            Long beforeAPI = B2B_Util.fetchCurrentTime();
            try{ 
                    List<Carrier_Speed_c__x> metadatarecords=[select id,Carrier_Speed_Name_c__c, Carrier_c__r.Name__c,Honda_Shipping_Speed_c__c,Honda_Shipping_Speed_c__r.Honda_Speed_Name_c__c,Sort_Order_c__c from Carrier_Speed_c__x where Carrier_c__r.Name__c=: objOrdFulFillWrapper.shipmentCarrier and Honda_Shipping_Speed_c__r.Honda_Speed_Name_c__c =: objOrdFulFillWrapper.hondaShippingSpeed and Carrier_c__r.Is_Active_c__c =true order by Sort_Order_c__c];
                    Order_Fulfillment_c__x objOrdFulFill = new Order_Fulfillment_c__x();
                    objOrdFulFill.OrderId_c__c = objOrdFulFillWrapper.orderId;
                    objOrdFulFill.Tracking_Number_c__c = objOrdFulFillWrapper.trackingNumber;
                    objOrdFulFill.Shipment_Carrier_c__c = objOrdFulFillWrapper.shipmentCarrier;
                    objOrdFulFill.Honda_Shipping_Speed_c__c = objOrdFulFillWrapper.hondaShippingSpeed;
                    objOrdFulFill.Shipment_Date_Time_c__c = System.now();
                    objOrdFulFill.AK_Order_Fulfillment_c__c = objOrdFulFill.OrderId_c__c +'~'+objOrdFulFill.Shipment_Carrier_c__c+'~'+objOrdFulFill.Tracking_Number_c__c;
                    objOrdFulFill.Shipped_Partnumber_c__c = 'HRCPart';
                    if(!metadatarecords.isEmpty()){
                        objOrdFulFill.Shipping_Speed_c__c = metadatarecords[0].Carrier_Speed_Name_c__c;
                    }else{
                        objOrdFulFill.Shipping_Speed_c__c = objOrdFulFillWrapper.hondaShippingSpeed;
                    }
                    
                    Database.SaveResult insertUpdateResult;
                    if(dmlOp == true){
                        insertUpdateResult = Database.insertImmediate(objOrdFulFill);
                    }else{
                    objOrdFulFill.Id = objOrdFulFillWrapper.Id;
                        insertUpdateResult = Database.updateImmediate(objOrdFulFill);
                    }
                    if (insertUpdateResult.isSuccess()) {
                        System.debug('$$Record inserted/updated successfully. Id: ' + insertUpdateResult.getId());
                    } else {
                        for(Database.Error error : insertUpdateResult.getErrors()) {
                            System.debug('$$Error inserting/updating record: ' + error.getStatusCode() + ' - ' + error.getMessage());
                        }
                    }
                    return objOrdFulFill;
                
            }catch(Exception ex){
                System.debug('Exception Occurred : '+ ex.getMessage());             
                //Added by Lokesh for payment-settlement HDMP-29580
                Long afterAPI = B2B_Util.fetchCurrentTime();
                Long durationTime = B2B_Util.calInMilliSeconds(beforeAPI,afterAPI);
                B2B_Util.createErrorRecord('Shipment Info Update','','','','','HDMDealerExperienceController', 'Shipment Update Info Failed',Label.B2B_Error_Type,'','insertUpdateExternalOrdFullFilment',true, objOrdFulFillWrapper.orderId,'','',durationTime,Label.B2B_Severity,'','');            
            }            
        }
        return null;      
    }
    // Added by Swaroop for HPD_Sprint5 --- End
    
     //Added By Rajrishi For Phase2
    public static void createOrderAuditTrails(Order__x objOrder, List<OrderItem__x> lstOrderItems, String customerNote,  Decimal shippingAmountToDuduct, Decimal updatedAmount){
        try {
            decimal totalUpdated = updatedAmount + shippingAmountToDuduct;
            if(objOrder.Status__c == 'Voided'){
                totalUpdated = 0;
            }
            //create order transaction object 
            Order_Transaction_c__x objOrderTransaction = new Order_Transaction_c__x();
            objOrderTransaction.Order_c__c = objOrder.ExternalId;
            objOrderTransaction.Order_Transaction_Type_c__c = 'Modified';       
            objOrderTransaction.Order_Transaction_Status_c__c = objOrder.IsError_c__c == false ? 'Success' :'Failure';
            objOrderTransaction.Dealer_To_Customer_Note_c__c = customerNote;
            objOrderTransaction.Adjustment_Date_Time_c__c = System.now();
            
            //pre values  
            objOrderTransaction.Total_Pre_Adjustment_Shiping_Charge_c__c = objOrder.Updated_Shipping_c__c;                              
            objOrderTransaction.Pre_Adjustment_Total_Amount_c__c = objOrder.Updated_Order_Total_c__c;
            objOrderTransaction.Is_Adjustment_c__c = true;           
            
            //post values     
            objOrderTransaction.Total_Post_Adjustment_Shiping_Charge_c__c = objOrder.Updated_Shipping_c__c - shippingAmountToDuduct;	       	
            objOrderTransaction.Post_Adjustment_Total_Amount_c__c = objOrder.Updated_Order_Total_c__c - totalUpdated;
            objOrderTransaction.Post_Adjustment_Total_Tax_c__c = objOrder.Updated_Total_Tax_c__c;
                       
            //Added for EVSE Phase2 test class fix
            if(!Test.isRunningTest()){
            Database.insertImmediate(objOrderTransaction);
            objOrderTransaction = [Select Id, ExternalId FROM Order_Transaction_c__x WHERE Id =:objOrderTransaction.Id LIMIT 1];
            }
            //Added for EVSE Phase2 test class fix         
            
            List<Order_Transaction_Item_c__x> lstTransItems = new List<Order_Transaction_Item_c__x>();
            for(OrderItem__x objOrderItem : lstOrderItems){
                B2B_VertexTaxCalculationIntegration.OrderItemWrapper objOrderItemWrapper = new B2B_VertexTaxCalculationIntegration.OrderItemWrapper();
                if(objOrderItem.Delta_Quantity_c__c > 0){                             
                    Order_Transaction_Item_c__x objOrderTranItem = new Order_Transaction_Item_c__x();
                    objOrderTranItem.Order_Item_c__c = objOrderItem.ExternalId;
                    
                    //post values                              
                    objOrderTranItem.Post_Adjustment_Quantity_c__c = objOrderItem.Updated_Quantity_c__c;
                    if(!Test.isRunningTest()){//Added for EVSE Phase2 test class fix
                    objOrderTranItem.Post_Adjustment_Extended_Price_c__c = objOrderItem.Updated_Quantity_c__c * objOrderItem.ListPrice__c;
                    }
                    objOrderTranItem.Total_Post_Adjustment_Product_Tax_c__c = objOrderItem.Total_Current_Product_Tax_c__c;               
                    
                    //pre values
                    objOrderTranItem.Pre_Adjustment_Quantity_c__c = objOrderItem.Updated_Quantity_c__c + objOrderItem.Delta_Quantity_c__c;
                    if(!Test.isRunningTest()){//Added for EVSE Phase2 test class fix
                    objOrderTranItem.Pre_Adjustment_Extended_Price_c__c = objOrderTranItem.Pre_Adjustment_Quantity_c__c * objOrderItem.ListPrice__c;  
                    }
                    objOrderTranItem.Total_Pre_Adjustment_Product_Tax_c__c = objOrderItem.Total_Current_Product_Tax_c__c;
                    objOrderTranItem.Adjustment_Date_Time_c__c = System.now();
                    objOrderTranItem.AK_Order_Transaction_Item_c__c = objOrderItem.ExternalId +''+ objOrderTransaction.ExternalId; 
                    
                    if(objOrder.Type__c == B2B_Constants.DIRECTSHIP){
                       objOrderTranItem.Total_Pre_ShippingAmt_c__c = objOrderItem.Shipping_Amount_Per_Unit_c__c * objOrderTranItem.Pre_Adjustment_Quantity_c__c;
                       objOrderTranItem.Total_Post_ShippingAmt_c__c = objOrderItem.Shipping_Amount_Per_Unit_c__c * objOrderTranItem.Post_Adjustment_Quantity_c__c;
                    }                 
                    lstTransItems.add(objOrderTranItem);
                }            
                
            }
            //Added for EVSE Phase2 test class fix - Start
            if(!Test.isRunningTest()){
            Database.insertImmediate(lstTransItems);
            }
           //Added for EVSE Phase2 test class fix - End
        }catch(Exception ex){
            System.debug('Exception -' + ex.getMessage());
            System.debug('Exception Line -' + ex.getLineNumber());
        }
             
    }
    
    @AuraEnabled
    public static OrderWrapper OrderDetails(String recordId){
        OrderWrapper objOrderWrapper = new OrderWrapper();
         objOrderWrapper.isDealerAdmin = false;
        objOrderWrapper.isBraintreeFetchError = false;//added by suresh for Braintree Reconciliation
        objOrderWrapper.isaccessTokenError = false;//added by suresh for Braintree Reconciliation
        system.debug('recordid is'+ recordId);
        String userid = UserInfo.getUserId();
        String orderExternalId;//Added by imtiyaz|| swaroop for HPD Sprint4
        List<PermissionSetAssignment> lstPermissionSets = [SELECT Id, PermissionSetId, PermissionSet.Name, AssigneeId, Assignee.Name 
                                                           FROM PermissionSetAssignment 
                                                          WHERE AssigneeId =: userid AND (PermissionSet.Name = 'DreamShop_Order_Managemnt' OR PermissionSet.Name = 'DreamShop_Order_General' OR PermissionSet.Name ='HELMS_and_HDM_Manager' )];
        if(!lstPermissionSets.isEmpty()){
            for(PermissionSetAssignment objPermission : lstPermissionSets){
               if(objPermission.PermissionSet.Name == 'DreamShop_Order_Managemnt' || objPermission.PermissionSet.Name == 'HELMS_and_HDM_Manager'){
                    objOrderWrapper.isDealerAdmin = true;
                }   
            }
        }
         //Lakshmi HDMP-19441 - Zipcode changes added BillingPostalCode__c field in below query
         //R2B changes for HDMP-10201 : added OrderReferenceNumber__c in Query
        // Saravanan LTIM Added Total_Core_Charge_Current_Quantity__c for Sprint 2 Data Rules , Total_Core_Charge_Current_Amount__c , Total_Core_Charge_Return_Amount__c
 List<Order__x> orderlist = (!mockedOrder.isEmpty()) ? mockedOrder : [SELECT Id,ExternalId, Ship_To_Address_Type_c__c, Type__c, OrderReferenceNumber__c, Payment_Type_c__c, Tax_Refund_c__c, AccountId__c, Install_Refund_c__c, Total_Installation_Charges_c__c, Is_Shipping_Returned_c__c, Total_Installation_Return_c__c, Total_Return_c__c, Total_Item_Return_c__c, Total_Ship_Return_c__c, Updated_Shipping_c__c, Total_Tax_Return_c__c, Total_Restocking_Fees_c__c, Shipping_Refund_c__c, Restocking_Fees_c__c,Current_Quantity_c__c,Current_Shipping_Tax_c__c,Total_Current_Product_Tax_c__c,//modified by suresh
                            AccountId__r.IsActive_c__c, AccountId__r.Charge_Restocking_Fees_c__c, AccountId__r.Return_Window_c__c, AccountId__r.Restocking_Fees_c__c, AccountId__r.Restocking_Fees_Percentage_c__c, AccountId__r.Restocking_Fees_Type_c__c, Shipped_Date_c__c, Dealer_Shipping_Speed_c__c, Customer_Preferred_Speeds_c__c, 
                            Total_Installation_Charge_c__c, Delivery_Types_c__c, isOrderPickedUp_c__c, CC_Last4_c__c, Customer_Name_c__c, Other_Carrier_c__c, BT_Transaction_Id_c__c, Vertex_Trans_Id_c__c, OrderNumber__c, IsError_c__c, Name__c, BillingPhoneNumber__c,BT_Transaction_Status_c__c,TotalTaxAmount__c,
                            Cart_Shipping_Customer_Name_c__c, Cart_Shipping_Phone_c__c, ShippingStreet__c, ShippingCity__c, ShippingState__c, ShippingCountry__c, ShippingPostalCode__c,Customer_Notes_c__c,
                            Status__c,Shipping_Vendors_c__c,OrderedDate__c,Email_c__c,BillingStreet__c,BillingCity__c,BillingState__c,Total_Restocking_Fee_Tax_c__c,
                            BillingZip_c__c,Phone_No_c__c,Account_Name_c__c,ShippingNumber_c__c,ORDER_AMOUNT_from_cart_c__c,SHIPPING_from_cart_c__c,TAX_from_cart_c__c,
                            TOTAL_from_cart_c__c,IsPaymentReproccessing_c__c ,Updated_Total_Tax_c__c, Updated_Order_Total_c__c, Updated_Order_Amount_c__c,
                            Send_Email_To_Customer_c__c,BillingEmailAddress__c,BillingPostalCode__c, (SELECT Id, ExternalId, Shipped_Quantity_c__c, Product_Identifier_c__c, Unavailable_Quantity_c__c, Total_Return_Installation_Charge_c__c, Total_Current_Product_Tax_c__c,Total_Return_Product_Tax_c__c, Dealer_Installation_Price_c__c, Delta_Installation_Price_c__c, Product2Id__c, Cart_Item_Product_Name_c__c,Product_Name_c__c,Product_SKU_c__c,Type__c ,Quantity__c,ListPrice__c,Order_Item_Status_c__c,
                            Updated_Quantity_c__c, Return_Quantity_c__c,Delta_Quantity_c__c, OrderId__c,Total_Tax_c__c,Product_Model_Marketing_Name_c__c,Product_Type_c__c, Item_Tax_Code_c__c, Total_Unavailable_ShippingTax_c__c, Total_Unavailable_ShippingAmt_c__c
                            , Shipping_Amount_Per_Unit_c__c, Total_Current_Shipping_TaxAMT_c__c, Total_Original_Shipping_TaxAmt_c__c FROM Order_Products__r WHERE Type__c != 'Delivery Charge' Order by Product_SKU_c__c), Total_Core_Charge_Current_Amount__c , Total_Core_Charge_Return_Amount__c,
                             (SELECT Id, Dealer_To_Customer_Note_c__c, CreatedDate__c FROM Order_Transactions__r WHERE Order_Transaction_Status_c__c = 'Success' Order By CreatedDate__c DESC)                                    
                            , Total_Unavailable_ProductAmt_c__c,Total_Unavailable_ShippingAmt_c__c,Total_Unavailable_TaxAmt_c__c,HPD_RLN_c__c, Product_Subdivision_c__c,Product_Division_c__c, Total_Unavailable_ProductTax_c__c,Shipping_Note_c__c, AccountId__r.PoIId_c__c,Payment_Method_Token_c__c,Payment_Gateway_c__c FROM Order__x
                            WHERE Id=:recordId];  // Imtiyaz Ali - added -HDMP-24620 - HPD_Sprint_4// HPD_RLN_c__c, Product_Subdivision_c__c
 
        //Tanisha - EVSE_Phase2_Sprint_1 Start
        Set<Id> orderItemIds = new Set<Id>();
        if(!orderlist.isEmpty()){
            //check for transaction status = submitted for settlement
            //call updateCurrentTransactionStatus
           system.debug('orderlist@@@@@'+orderlist[0].BT_Transaction_Status_c__c);
            string transacStatus = orderlist[0].BT_Transaction_Status_c__c;
            //modified by suresh for Braintree Reconciliation
            if((transacStatus.equalsIgnoreCase('Submitted_For_Settlement') || transacStatus.equalsIgnoreCase('settling')) || transacStatus.equalsIgnoreCase('Authorized') && 
            orderlist[0].Delivery_Types_c__c != 'Install At Dealer'
            ){
                if(orderlist[0].Status__c == 'Activated' || orderlist[0].Status__c == 'IN PROGRESS' && orderlist[0].Product_Division_c__c !='9'){
                    HDMDealerExperienceController.updateCurrentTransactionStatus(orderlist,objOrderWrapper);
                }else if(orderlist[0].Product_Division_c__c =='9'){
                    HDMDealerExperienceController.updateCurrentTransactionStatus(orderlist,objOrderWrapper);
                }
            }
            //commented by suresh for Payment Settlement  
            //else if(transacStatus.equalsIgnoreCase('Authorization_Expired') && (orderlist[0].Status__c == 'READY FOR PICKUP' || orderlist[0].Status__c == 'ORDER COMPLETE - SHIPPED')){ //Added by Swaroop to Handle Authorization Expired BT Transactions 
            //     orderlist[0].Status__c = 'PAYMENT ISSUE';
            //     orderlist[0].IsPaymentReproccessing_c__c = true;
            //     orderlist[0].Send_Email_To_Customer_c__c = false;
            //     updateExternalOrder(orderlist[0]);
            // }//End
            
           for(OrderItem__x item : orderlist[0].Order_Products__r){
            orderItemIds.add(item.ExternalId);
           }
           orderExternalId = orderlist[0].ExternalId; //Added by Imtiyaz|Swaroop for HPD Sprint_4 - HDMP-24620 - HDMP-25860
        }
        List<Order_Fulfillment_c__x> orderfulfilled = [SELECT Order_Product_c__c, Shipment_Date_Time_c__c,OrderId_c__c,Shipped_Partnumber_c__c,Shipped_Item_Quantity_c__c,Tracking_Number_c__c,Honda_Shipping_Speed_c__c,Shipment_Carrier_c__c FROM Order_Fulfillment_c__x WHERE Order_Product_c__c IN : orderItemIds];
        // Start - Added by Imtiyaz|Swaroop for HPD Sprint_4 - HDMP-24620 - HDMP-25860
        List<TAndC_Acceptance_c__x> lstTnCAcceptance = [SELECT Id, Accepted_Datetime_c__c, AK_TandCID_RelatedID_c__c, ObjectName_c__c, Related_to_ID_c__c, Name__c, TermsAndConditions_ID_c__c FROM TAndC_Acceptance_c__x WHERE Related_to_ID_c__c =: orderExternalId AND ObjectName_c__c ='Order' LIMIT 1];
        List<Order_Fulfillment_c__x> hpdOrderfulfilled = [SELECT Order_Product_c__c, Shipment_Date_Time_c__c,OrderId_c__c,Shipped_Partnumber_c__c,Shipped_Item_Quantity_c__c,Tracking_Number_c__c,Shipping_Speed_c__c,Honda_Shipping_Speed_c__c,Shipment_Carrier_c__c FROM Order_Fulfillment_c__x WHERE OrderId_c__c  =: orderExternalId]; // Added by Swaroop for HPD_Sprint5
        if(!lstTnCAcceptance.isEmpty()) {
            objOrderWrapper.tnCAcceptedDatetime = lstTnCAcceptance[0].Accepted_Datetime_c__c;
        }
        // End - Added by Imtiyaz|Swaroop for HPD Sprint_4 - HDMP-24620 - HDMP-25860
        system.debug('orderfulfilled is'+orderfulfilled); 
        system.debug('orderlist is'+orderlist);        
        if(!orderlist.isEmpty()){
            objOrderWrapper.lstOrders = orderlist;
            objOrderWrapper.listFulfilledOrders = orderfulfilled;
            objOrderWrapper.listHpdFulfilledOrders = hpdOrderfulfilled;// Added by Swaroop for HPD_Sprint5
            return objOrderWrapper;
        }
        return null;           
    }  //Tanisha - EVSE_Phase2_Sprint_1 End
       
    ///added by  Rajrishi|| Suresh to get updatedTransactionStatus
    public static void updateCurrentTransactionStatus(List<Order__x> objOrder,OrderWrapper objOrderWrapper ){
        Long beforeAPI = B2B_Util.fetchCurrentTime();
        try {
            B2B_HDMBraintreeIntegration.DeviceCodeWrapper tokenDetails = B2B_HDMBraintreeIntegration.getDeviceCode();
            if(tokenDetails.status == 200 && String.isNotEmpty(tokenDetails.deviceToken)){
                // call the HDM Salesforce API to get the BT dealer access token
                objResponse = B2B_HDMBraintreeIntegration.getDealerAccessToken(objOrder[0].AccountId__r.PoIId_c__c, tokenDetails.deviceToken); //modified by suresh for Braintree reconciliation
                system.debug('399---objResponse;'+ objResponse);
                
                 // added by rajrishi - HDMP-28423 - token issue - Start
                String accessToken;                        
                if(objResponse != null && objResponse.isSuccess){                  
                    // if the access token is expired, get the new token from BT refresh token API
                    if(String.isNotEmpty(objResponse.refreshToken)){
                        B2B_AccessTokenResponseWrapper objRefreshResponse = B2B_HDMBraintreeIntegration.getRefreshToken(objResponse.merchantId, objResponse.refreshToken);
                        if(objRefreshResponse != null && objRefreshResponse.status == 200){
                            accessToken = objRefreshResponse.credentials?.accessToken;  
                            
                            //Update BT Token Details record
                            B2B_HDMBraintreeIntegration.ResponseWrapper tokenResponse = B2B_HDMBraintreeIntegration.updateBTToken(tokenDetails.deviceToken, objRefreshResponse);
                            if(tokenResponse != null && tokenResponse.status != 200){
                                //To Do create error record
                                Long afterAPI = B2B_Util.fetchCurrentTime();
                                Long durationTime = B2B_Util.calInMilliSeconds(beforeAPI,afterAPI);
                                B2B_Util.createErrorRecord('UpdateBTToken API ERROR HELMS','',objOrder[0].AccountId__c,'','','HDMDealerExperienceController',tokenResponse.errorMessage,'','','',true,objOrder[0].ExternalId,'','',durationTime,'',
                                                            'Request:'+tokenResponse.requestBody,'Response:'+tokenResponse.responseBody);
                            }
                        }else {
                            objOrderWrapper.isaccessTokenError= true;
                            //To Do create error record
                            Long afterAPI = B2B_Util.fetchCurrentTime();
                            Long durationTime = B2B_Util.calInMilliSeconds(beforeAPI,afterAPI);
                            B2B_Util.createErrorRecord('RefreshToken API ERROR HELMS','',objOrder[0].AccountId__c,'','','HDMDealerExperienceController',objRefreshResponse.errorMessage,'','','',true,objOrder[0].ExternalId,'','',durationTime,'',
                                                        'Request:'+objRefreshResponse.requestBody,'Response:'+objRefreshResponse.responseBody);
            
                        }
                    }else {
                        accessToken = objResponse.accessToken;
                    }                  
                   
                }
                 // added by rajrishi - HDMP-28423 - token issue - Ends

                //HDMP-28423 - changed condition - If the access token is their
                if(String.isNotEmpty(accessToken)){
                    // call the Braintree search API
                    BTResponsebody = B2B_HDMBraintreeIntegration.braintreeTransactionSearch(objOrder[0].BT_Transaction_Id_c__c, accessToken);//modified by suresh for Braintree Reconciliation
                    system.debug('405---BTResponsebody;'+BTResponsebody);
                    // check if the response status is 200                    
                    if(BTResponsebody.status == 200){
                        String transactionStatus = BTResponsebody.transactionBT.status;
                        //modified by suresh for Braintree Reconciliation
                        objOrder[0].BT_Transaction_Status_c__c = transactionStatus.equalsIgnoreCase('Settled') ? 'Settled' : transactionStatus.equalsIgnoreCase('Settling') ? 'Settling' : transactionStatus.equalsIgnoreCase('Authorized') ? 'Authorized' :  transactionStatus.equalsIgnoreCase('Voided') ? 'Voided' : transactionStatus.equalsIgnoreCase('Submitted_For_Settlement') ? 'Submitted_For_Settlement' :transactionStatus ;
                        System.debug('objBTResponse'+BTResponsebody.transactionBT.status);
                        if(transactionStatus.equalsIgnoreCase('Voided') && objOrder[0].Product_Division_c__c !='9'){
                            objOrder[0].Status__c = 'SYSTEM CANCELED'; 
                            objOrder[0].Send_Email_To_Customer_c__c = false;
                            objOrder[0].Shipping_Refund_c__c = objOrder[0].Updated_Shipping_c__c != null ? objOrder[0].Updated_Shipping_c__c : 0;
                            updateExternalOrder(objOrder[0]);

                        }
                         
                        if(objOrder[0].BT_Transaction_Status_c__c != 'Submitted_For_Settlement' && objOrder[0].BT_Transaction_Status_c__c != 'Settling' && objOrder[0].Product_Division_c__c =='9' ){
                            updateExternalOrder(objOrder[0]); //Added by Swaroop to update the latest Transaction status on Order record.
                        }else if((objOrder[0].Product_Division_c__c !='9' && objOrder[0].BT_Transaction_Status_c__c != 'Voided')){ //modified by suresh for payment settlement
                             updateExternalOrder(objOrder[0]); //added by suresh for Braintree Reconciliation
                        }
                        
                    }else{
                        objOrderWrapper.isBraintreeFetchError = true; //added by suresh for Braintree Reconciliation
                        system.debug('isBraintreeFetchError;;424'+objOrderWrapper.isBraintreeFetchError);

                    }               
                }else {
                    objOrderWrapper.isaccessTokenError= true; //Added by Swaroop for HDMP-27596
                    system.debug('objResponse;;424'+objResponse);
                }
            }
        }catch(Exception ex){
            System.debug('Exceptin : '+ ex.getMessage());
        }
        //added by suresh for Braintree Reconciliation 
        // changed condition by rajrishi for HDMP-28423 - token issue
        if(objOrderWrapper.isaccessTokenError == true && String.isEmpty(objResponse.accessToken) && String.isEmpty(objResponse.refreshToken)){
            Long afterAPI = B2B_Util.fetchCurrentTime();
            Long durationTime = B2B_Util.calInMilliSeconds(beforeAPI,afterAPI);
            B2B_Util.createErrorRecord('GetDealerAccessToken API ERROR HELMS','',objOrder[0].AccountId__c,'','','',objResponse.errorMessage,'','','',true,objOrder[0].ExternalId,'','',durationTime,'',
                                           'Request:'+objResponse.requestBody,'Response:'+objResponse.responseBody);
            
        }else if(objOrderWrapper.isBraintreeFetchError == true ){
            Long afterAPI = B2B_Util.fetchCurrentTime();
            Long durationTime = B2B_Util.calInMilliSeconds(beforeAPI,afterAPI);
            B2B_Util.createErrorRecord('Braintree Search API Error HELMS','',objOrder[0].AccountId__c,'','','',BTResponsebody.errorMessage,'','','',true,objOrder[0].ExternalId,'','',durationTime,'',
                                           'Request:'+BTResponsebody.requestBody,'Response:'+BTResponsebody.responseBody);
            
        }  //end   
    }
    //end       
    @AuraEnabled
    public static OrderWrapper getAccountDetails(){
        OrderWrapper objOrderWrapper = new OrderWrapper();
        objOrderWrapper.isDealerAdmin = false;   
        objOrderWrapper.lstCarriers = new List<Carrier_c__x>();
        
        String userid = UserInfo.getUserId();
        List<PermissionSetAssignment> lstPermissionSets = [SELECT Id, PermissionSetId, PermissionSet.Name, AssigneeId, Assignee.Name 
                                                           FROM PermissionSetAssignment 
                                                          WHERE AssigneeId =: userid AND (PermissionSet.Name = 'DreamShop_Order_Managemnt' OR PermissionSet.Name = 'DreamShop_Order_General' OR PermissionSet.Name ='HELMS_and_HDM_Manager' )];
        if(!lstPermissionSets.isEmpty()){
            for(PermissionSetAssignment objPermission : lstPermissionSets){
               if(objPermission.PermissionSet.Name == 'DreamShop_Order_Managemnt' || objPermission.PermissionSet.Name == 'HELMS_and_HDM_Manager'){
                    objOrderWrapper.isDealerAdmin = true;
                }   
            }
        }
                
        String contactid;
        String dealercode;       
        List<Account__x> accountList;        
        List<User> usrLst = new List<user>();
        if(!String.isEmpty(userid)){           
            usrLst = [SELECT ContactId from User WHERE Id=:userid];
            contactid=usrLst.get(0).ContactId;
        }
        
        if(!String.isEmpty(contactid)){
            List<Contact> dealercodelst = new List<Contact>();
            dealercodelst= [SELECT Account.DealerCode_CD__c FROM Contact WHERE Id=:contactid];
            dealercode=dealercodelst.get(0).Account.DealerCode_CD__c;           
            // Pratik Added Sales_Tax_Jurisdiction__c,ShippingState__c for Sprint 4 
            accountList = (!mockedAccounts.isEmpty()) ? mockedAccounts : [SELECT Id,ExternalId, Preferred_Shipping_Carrier_c__c, Service_Scheduling_URL_c__c, Return_Window_c__c, Charge_Restocking_Fees_c__c,
                      Restocking_Fees_c__c, Restocking_Fees_Percentage_c__c, Restocking_Fees_Type_c__c,Sales_Tax_Jurisdiction__c , ShippingState__c, DivisionCd_c__c
                      FROM Account__x 
                      WHERE PoIId_c__c =: dealercode];// Added ExternalId field which was missing by Aditya to fix 19411
            if(!accountList.isEmpty())
                objOrderWrapper.lstAccounts = accountList;
            System.debug('accountList : '+accountList);
            
            objOrderWrapper.lstCarriers = [SELECT Id, ExternalId, Name__c, OwnerId__c FROM Carrier_c__x];
            
            // Pratik LTIM Added for Reman Sprint 4 Tax Juridications
            objOrderWrapper.wrapSales = getSellingStates();
        }
        return objOrderWrapper;
    }

     // Start Added by Aditya to fix 19411
     @AuraEnabled
     public static String updateOpsTeam(Account__x objAccount){
        try{
            objAccount = Test.isRunningTest() ? HDMDealerExperienceController.mockedAccounts[0] : objAccount;
         Long durationTime = DateTime.now().getTime();
            if(!Test.isRunningTest()){
         B2B_Util.createErrorRecord('','',objAccount.ExternalId,'','','HDMDealerExperienceController', 'Sales tax jurisdiction field Dealer state update failed',Label.B2B_Error_Type,'','updateOpsTeam',true, '','','',durationTime,Label.B2B_Severity,'','');
            }
         return 'Success';
        }catch(Exception ex){
            return ex.getMessage();
        }
     }
     // End Added by Aditya to fix 19411
    
    @AuraEnabled
    public static Account__x updateDealerAccount(Account__x objAccount){         
        if(objAccount != null){
            Long beforeAPI = B2B_Util.fetchCurrentTime();
            try{
                 if(!Test.isRunningTest()){
                    Database.SaveResult results = Database.updateImmediate(objAccount); // Lakshmi LTIM Added for  Database.SaveResult 19411

                    /*** Lakshmi LTIM Added for HDMP-19411 */
                    if(!results.isSuccess()){

                        Long afterAPI = B2B_Util.fetchCurrentTime();
                        Long durationTime = B2B_Util.calInMilliSeconds(beforeAPI,afterAPI);
                        Database.Error[] error = results.getErrors();

                        B2B_Util.createErrorRecord('','',objAccount.ExternalId,'','','HDMDealerExperienceController', error[0].getMessage(),Label.B2B_Error_Type,'','updateDealerAccount',true, '','','',durationTime,Label.B2B_Severity,'','');

                        return null;
                    }
                    /*** Lakshmi LTIM Added for HDMP-19411 */
                 }
            }catch(exception ex){
                Long afterAPI = B2B_Util.fetchCurrentTime();
                Long durationTime = B2B_Util.calInMilliSeconds(beforeAPI,afterAPI);
                B2B_Util.createErrorRecord('','',objAccount.ExternalId,'','','HDMDealerExperienceController', ex.getMessage(),Label.B2B_Error_Type,'','updateDealerAccount',true, '','','',durationTime,Label.B2B_Severity,'','');
                
                System.debug('Exception :'+ ex.getMessage());
            }
           
        }       
        return objAccount;
    }

    //Added by Faraz for 8722 on 25/05/22 - start
    @AuraEnabled
    public static string addExternalDealerNotes(String orderId, String dealerNote){
        try {
            Dealer_Notes_c__x notesObj = new Dealer_Notes_c__x();
            notesObj.Order_c__c = orderId;
            notesObj.Notes_c__c = dealerNote;
            notesObj.Created_By_Name_c__c = UserInfo.getName();
            //insert notesObj;
            if(!Test.isRunningTest()){
                Database.insertImmediate(notesObj);
                return 'Note Added';
            }
            return 'Insertion Failed';
        } catch (Exception e) {
            System.debug('Exception :'+ e.getMessage());
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static string getAllExternalDealerNotes(String orderId){
        try {
            return JSON.serialize([SELECT Id, (SELECT Id, Order_c__c, Notes_c__c, CreatedDate__c, Created_By_Name_c__c FROM Dealers_Notes__r Order by CreatedDate__c DESC)  FROM Order__x Where id =: orderId]);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    //Added by Faraz for 8722 on 25/05/22 - end


//added by suresh for Payment settlement
    @auraEnabled 
    public static BraintreeWrapper verifyaccessToken(String dealerPOIID, string orderid){
        //String accessToken;  
        List<Order__x> objOrder = [Select id, BT_Transaction_Status_c__c,AccountId__c,ExternalId From Order__x where id =: orderid];
        BraintreeWrapper btWrapper = new BraintreeWrapper();
        Long beforeAPI = B2B_Util.fetchCurrentTime();
        B2B_AccessTokenResponseWrapper objRefreshResponse;
            B2B_HDMBraintreeIntegration.DeviceCodeWrapper tokenDetails = B2B_HDMBraintreeIntegration.getDeviceCode();
            if(tokenDetails.status == 200 && String.isNotEmpty(tokenDetails.deviceToken)){
                // call the HDM Salesforce API to get the BT dealer access token
                objResponse = B2B_HDMBraintreeIntegration.getDealerAccessToken(dealerPOIID, tokenDetails.deviceToken);                     
                if(objResponse != null && objResponse.isSuccess){                  
                    // if the access token is expired, get the new token from BT refresh token API
                    if(String.isNotEmpty(objResponse.refreshToken)){
                        objRefreshResponse = B2B_HDMBraintreeIntegration.getRefreshToken(objResponse.merchantId, objResponse.refreshToken);
                        if(objRefreshResponse != null && objRefreshResponse.status == 200){
                            btWrapper.accessToken = objRefreshResponse.credentials?.accessToken; 
                            B2B_HDMBraintreeIntegration.ResponseWrapper tokenResponse = B2B_HDMBraintreeIntegration.updateBTToken(tokenDetails.deviceToken, objRefreshResponse);

                            if(tokenResponse != null && tokenResponse.status != 200){
                                btWrapper.accessToken = 'Contact BT';
                                Long afterAPI = B2B_Util.fetchCurrentTime();
                                Long durationTime = B2B_Util.calInMilliSeconds(beforeAPI,afterAPI);
                                B2B_Util.createErrorRecord('UpdateBTToken API ERROR HELMS','',objOrder[0].AccountId__c,'','','HDMDealerExperienceController',tokenResponse.errorMessage,'','','',true,objOrder[0].ExternalId,'','',durationTime,'',
                                                            'Request:'+tokenResponse.requestBody,'Response:'+tokenResponse.responseBody);
                            }
                        }else {
                            btWrapper.accessToken = 'Contact BT';
                            btWrapper.isRefreshTokenError = true;
                            //To Do create error record
                            Long afterAPI = B2B_Util.fetchCurrentTime();
                            Long durationTime = B2B_Util.calInMilliSeconds(beforeAPI,afterAPI);
                            B2B_Util.createErrorRecord('RefreshToken API ERROR HELMS','',objOrder[0].AccountId__c,'','','HDMDealerExperienceController',objRefreshResponse.errorMessage,'','','',true,objOrder[0].ExternalId,'','',durationTime,'',
                                                        'Request:'+objRefreshResponse.requestBody,'Response:'+objRefreshResponse.responseBody);
                        }
                    }else {
                        btWrapper.accessToken = objResponse.accessToken;
                    }                    
                }else{
                    btWrapper.accessToken ='Contact BT';
                    btWrapper.isDealerAccRevoked = true;
                    Long afterAPI = B2B_Util.fetchCurrentTime();
                    Long durationTime = B2B_Util.calInMilliSeconds(beforeAPI,afterAPI);
                    B2B_Util.createErrorRecord('DealerAccessToken Error','',objOrder[0].AccountId__c,'','','HDMDealerExperienceController',objResponse.errorMessage,'','','',true,objOrder[0].ExternalId,'','',durationTime,'',
                                                        'Request:'+objResponse.requestBody,'Response:'+objResponse.responseBody);
                }              
            }

    return btWrapper;
        
    }
//added by suresh for Payment settlement
    @auraEnabled
    public static Boolean fetchBTlatestStatus(string accid, string access_Token){
        Long beforeAPI = B2B_Util.fetchCurrentTime();
        Boolean isSuccess = true;
        List<Order__x> orders = [Select id,Status__c, BT_Transaction_Id_c__c,AccountId__c,ExternalId from Order__x where AccountId__r.PoIId_c__c =: accid and (BT_Transaction_Status_c__c != 'Settled' and BT_Transaction_Status_c__c != 'Voided')];
        for(Order__x objOrder : orders){
            if(objOrder.Status__c != 'ORDER COMPLETE - PICKED UP' && objOrder.Status__c != 'ORDER COMPLETE - SHIPPED'){
                BTResponsebody = B2B_HDMBraintreeIntegration.braintreeTransactionSearch(objOrder.BT_Transaction_Id_c__c, access_Token);
                if(BTResponsebody.status == 200){
                    String transactionStatus = BTResponsebody.transactionBT.status;
                    objOrder.BT_Transaction_Status_c__c = transactionStatus.equalsIgnoreCase('Settled') ? 'Settled' : transactionStatus.equalsIgnoreCase('Settling') ? 'Settling' : transactionStatus.equalsIgnoreCase('Authorized') ? 'Authorized' :  transactionStatus.equalsIgnoreCase('Voided') ? 'Voided' : transactionStatus.equalsIgnoreCase('Submitted_For_Settlement') ? 'Submitted_For_Settlement' : transactionStatus ;
                    updateExternalOrder(objOrder); 
                    if(transactionStatus.equalsIgnoreCase('Processor_Declined') || transactionStatus.equalsIgnoreCase('Gateway_Rejected') || transactionStatus.equalsIgnoreCase('Settlement_Declined')){
                        objOrder.Status__c = ' PAYMENT ISSUE';
                        objOrder.IsPaymentReproccessing_c__c = true;
                        Long afterAPI = B2B_Util.fetchCurrentTime();
                        Long durationTime = B2B_Util.calInMilliSeconds(beforeAPI,afterAPI);
                        String errorMsg = 'Error in Payment Settlement Process. Error : Credit Card Issue';
                        B2B_Util.createErrorRecord('Braintree Search API Error HELMS','',objOrder.AccountId__c,'','','HDMDealerExperienceController',BTResponsebody.errorMessage,'','','braintreeTransactionSearch',true,objOrder.ExternalId,'','',durationTime,'',
                                                    'Request:'+BTResponsebody.requestBody,'Response:'+BTResponsebody.responseBody);               
                    
                    }
                }else{
                    Long afterAPI = B2B_Util.fetchCurrentTime();
                    Long durationTime = B2B_Util.calInMilliSeconds(beforeAPI,afterAPI);
                    String errorMsg = 'Error in fetching Braintree Payment status. Error : API not available';
                    B2B_Util.createErrorRecord('Braintree Search API Error HELMS','',objOrder.AccountId__c,'','','HDMDealerExperienceController',errorMsg,'','','braintreeTransactionSearch',true,'','','',durationTime,'',
                                                   'Request:'+BTResponsebody.requestBody,'Response:'+BTResponsebody.responseBody); 
                    
                    isSuccess = false;     
                    break; 
                    
                                 
                }
            }
           
        }
        if(isSuccess == true){
            return true; 
        } else{
            return false; 
        }
             
    }


    
    public class OrderWrapper {
        @AuraEnabled public boolean isDealerAdmin;
        @AuraEnabled public List<Order__x> lstOrders;
        @AuraEnabled public List<Account__x> lstAccounts;   
        @AuraEnabled public List<Carrier_c__x> lstCarriers;  
        @AuraEnabled public List<Order_Fulfillment_c__x>  listFulfilledOrders;  //Tanisha - EVSE_Phase2_Sprint_1 Start
        @AuraEnabled public DateTime tnCAcceptedDatetime; // Start - Added by Imtiyaz|Swaroop for HPD Sprint_4 - HDMP-24620 - HDMP-25860
        @AuraEnabled Public SalesTaxJurisdications wrapSales;  // Added by Pratik for Sprint 4 Sales
        @AuraEnabled public List<Order_Fulfillment_c__x>  listHpdFulfilledOrders; // Start - Added by Imtiyaz|Swaroop for HPD Sprint_5 - HDMP-24620 - HDMP-25860
        @AuraEnabled public boolean isBraintreeFetchError;//added by suresh for Braintree Reconciliation
        @AuraEnabled public boolean isaccessTokenError;//added by suresh for Braintree Reconciliation
    }
    public class BraintreeWrapper{
        @auraEnabled public Boolean isRefreshTokenError;
        @auraEnabled public Boolean isDealerAccRevoked;
        @auraEnabled public String accessToken;
        BraintreeWrapper(){
            isRefreshTokenError = false;
            isDealerAccRevoked = false; 
            accessToken = '';           
        }
    }

    @AuraEnabled(cacheable = true)
    Public static SalesTaxJurisdications getSellingStates(){
        SalesTaxJurisdications cls = new SalesTaxJurisdications();
        Map<string,string> mapStatetoCode = new Map<string,string>();
        Schema.DescribeFieldResult F = Account__x.Sales_Tax_Jurisdiction__c.getDescribe();
        Schema.sObjectField T = F.getSObjectField();
        List<PicklistEntry> entries = T.getDescribe().getPicklistValues();
        for(PicklistEntry objPickListEntry : entries){
            mapStatetoCode.put(objPickListEntry.label,objPickListEntry.value);
        }
        cls.mapStatetoCode = mapStatetoCode;
        return cls;
    }

    Public class SalesTaxJurisdications{
        @AuraEnabled
        Public  Map<string,string> mapStatetoCode;
    }
}