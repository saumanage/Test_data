/****************************************************************************************************************
Name: 			B2B_VertexTaxCalculationIntegration
Purpose: 		This class is to provide Tax from Vertex API.
Date: 			28/01/2021
Created By: 	Soumya Sahoo
Test ClassName: B2B_TaxHelperTest, B2B_VertexTaxCalculationCalloutMock(Mock Class)
******************************************************************************************************************
MODIFICATIONS – 	Date 		|	Dev Name		|	Method		|	User Story
******************************************************************************************************************
22/05/2022	|	Soumya Sahoo	|				|	Error handling changes- JIRA- 8617
******************************************************************************************************************/
public class B2B_VertexTaxCalculationIntegration {
    public static ResponseDataWrapper calculateTaxQuotation(Map<String, String> dealerAddressMap, Map<String, String> customerAddressMap, List<OrderItemWrapper> orderItemDetails, String dealerCode, Order__x orderDetails, String shippingCharge, String installationCharges, String restockingfee,String dealerId) {
        ResponseDataWrapper responseWrapper = New ResponseDataWrapper();
        String orderId = orderDetails.ExternalId;
        try {
            if (dealerAddressMap.size() != 4 && customerAddressMap.size() != 4) {
                responseWrapper.errorMessage = B2B_IntegrationConstants.ERROR_CORRECT_ADDRESS;
                responseWrapper.isSuccess = B2B_IntegrationConstants.FALSE_VALUE;
                return responseWrapper;
            } else {
                Map<String, String> lineItemsDetails = New Map<String, String> ();
                Http http = new Http();
                HttpRequest request = new HttpRequest();
                String guId = B2B_Util.createGui();
                request.setHeader('Content-Type', 'text/xml');
                request.setMethod('POST');
                String body = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:head="http://www.honda.com/global/1.0/header/" xmlns:urn="urn:vertexinc:o-series:tps:9:0">';
                body += '<soapenv:Header>';
                body += '<head:hondaHeaderType>';
                body += '<head:messageId>' + guId + '</head:messageId>';
                body += '<head:siteId>' + Label.B2B_Tax_SiteId + '</head:siteId>';
                body += '<head:businessId>' + Label.B2B_Tax_BusinessId + '</head:businessId>';
                body += '<head:collectedTimestamp>' + datetime.now().format('yyyy-MM-dd\'T\'HH:mm:ss.SSSXXX', 'America/Los_Angeles') + '</head:collectedTimestamp>';
                body += '</head:hondaHeaderType>';
                body += '</soapenv:Header>';
                body += '<soapenv:Body><urn:VertexEnvelope>';
                body += '<urn:Login><urn:UserName>' + Label.B2B_VertexUserName + '</urn:UserName><urn:Password>' + Label.B2B_VertexPassword + '</urn:Password></urn:Login>';
                String todayDate = String.valueOf(Date.valueOf(orderDetails.OrderedDate__c));
                body += '<urn:QuotationRequest documentDate="' + todayDate + '" postingDate="' + todayDate + '" transactionType="SALE">';
                body += '<urn:Seller><urn:Company>' + 'AHM Group' + '</urn:Company>';
                body += '<urn:Division>' + dealerCode + '</urn:Division></urn:Seller>';
                Integer i = B2B_IntegrationConstants.DEFAULT_VALUE;
                String bodyRequest;
                Decimal totalamount;
                Map<Integer,OrderItemWrapper> mapLineItems = New Map<Integer,OrderItemWrapper>();
                List<B2B_VertexTaxCalculationIntegration.ShippingChargesWrapper> shippingChargesWrappers = new List<B2B_VertexTaxCalculationIntegration.ShippingChargesWrapper>();
                for(OrderItemWrapper objOrderItem: orderItemDetails){
                    // add shipping charges to wrapper - Swaroop                    
                    if(objOrderItem.shippingCharge != null){
                        B2B_VertexTaxCalculationIntegration.ShippingChargesWrapper obj = new B2B_VertexTaxCalculationIntegration.ShippingChargesWrapper();
                    	obj.itemId = objOrderItem.orderItemId;
                        obj.shippingPrice = objOrderItem.shippingCharge;
                    	shippingChargesWrappers.add(obj);  
                    }                                    
                    totalamount = -1.0;
                    system.debug('Total Price Soumya'+objOrderItem.quantity+''+objOrderItem.unitPrice);
                    totalamount = totalamount * (objOrderItem.quantity * objOrderItem.unitPrice);
                    mapLineItems.put(i, objOrderItem);
                    //Imtiyaz - EVSE_ Start
                    if(objOrderItem.itemTaxCode != null && String.isNotBlank(objOrderItem.itemTaxCode)){
                        System.debug('$$$objOrderItem.itemTaxCode:' + objOrderItem.itemTaxCode);
                        bodyRequest = getAddressDetails(i, objOrderItem.itemTaxCode, string.valueof(totalamount), dealerAddressMap, customerAddressMap,objOrderItem.quantity,objOrderItem.unitPrice,null);
                    }
                    //Imtiyaz - EVSE_ End
                    else {
                        // Ashwin LTIM for Sprint 3 - Added Parameter carItemProductName
                    bodyRequest = getAddressDetails(i, Label.B2B_Product_Code, string.valueof(totalamount), dealerAddressMap, customerAddressMap,objOrderItem.quantity,objOrderItem.unitPrice,objOrderItem.carItemProductName);
                    }
                    
                    body += bodyrequest;
                    i = i + 1;
                }
                Map<Integer,ShippingChargesWrapper> mapShippingLineItems = New Map<Integer,ShippingChargesWrapper>();
                for(ShippingChargesWrapper obj : shippingChargesWrappers){
                    mapShippingLineItems.put(i, obj);
                    totalamount = -1.0;
                    totalamount = totalamount * obj.shippingPrice;
                    bodyrequest = getAddressDetails(i, Label.B2B_Shipping_Code, string.valueof(totalamount), dealerAddressMap, customerAddressMap,null,null,'');
                    body += bodyrequest;
                    i = i + 1;
                }
                if (String.isNotBlank(shippingCharge) && shippingChargesWrappers.isEmpty()) {
                    totalamount = -1.0;
                    totalamount = totalamount * Decimal.valueof(shippingCharge);
                    // Ashwin LTIM for Sprint 3 - Added Parameter carItemProductName
                    bodyrequest = getAddressDetails(i, Label.B2B_Shipping_Code, string.valueof(totalamount), dealerAddressMap, customerAddressMap,null,null,'');
                    body += bodyrequest;
                    i = i + 1;
                }
                if (String.isNotBlank(InstallationCharges)) {
                    totalamount = -1.0;
                    totalamount = totalamount * Decimal.valueof(InstallationCharges);
                    // Ashwin LTIM for Sprint 3 - Added Parameter carItemProductName
                    bodyrequest = getAddressDetails(i, Label.B2B_Installation_Code, string.valueof(totalamount), dealerAddressMap, customerAddressMap,null,null,'');
                    body += bodyrequest;
                    i = i + 1;
                }
                if (String.isNotBlank(restockingfee)) {
                    totalamount = Decimal.valueof(restockingfee);
                    // Ashwin LTIM for Sprint 3 - Added Parameter carItemProductName
                    bodyrequest = getAddressDetails(i, Label.B2B_restockingfee_Code, string.valueof(totalamount), dealerAddressMap, dealerAddressMap,null,null,'');
                    body += bodyrequest;
                }
                body += '</urn:QuotationRequest></urn:VertexEnvelope></soapenv:Body></soapenv:Envelope>';
                request.setBody(body);
                request.setEndpoint('callout:B2B_VertexNamedCredential' + Label.B2B_Vertex_Path_URL);
                Long beforeAPI = B2B_Util.fetchCurrentTime();
                HTTPResponse response = http.send(request);
                DOM.Document doc = response.getBodyDocument();
                Dom.XMLNode rootElement = doc.getRootElement();
                String totalTaxAmount = '';
                String errorDescription = '';
                responseWrapper.responseCode = String.valueOf(response.getStatusCode());
                if (response.getStatusCode() == B2B_IntegrationConstants.STATUSCODE) {
                    for (Dom.XMLNode childElement: rootElement.getChildElements()) {
                        if (childElement.getName() == 'Body') {
                            if (childElement.getChildElement('Fault', 'http://schemas.xmlsoap.org/soap/envelope/') != null) {
                                Dom.XMLNode faultNode = childElement.getChildElement('Fault', 'http://schemas.xmlsoap.org/soap/envelope/');
                                if (faultNode.getChildElement('faultstring', null) != null) {
                                    errorDescription = faultNode.getChildElement('faultstring', null).getText();
                                    responseWrapper.isSuccess = B2B_IntegrationConstants.FALSE_VALUE;
                                    responseWrapper.errorMessage = errorDescription;
                                    responseWrapper.totalTaxAmount =  B2B_IntegrationConstants.ZERO_VALUE;
                                }
                            } else if (childElement.getChildElement('VertexEnvelope', B2B_IntegrationConstants.TAX_XML_URL) != null) {
                                Dom.XMLNode vertexEnvelopeNode = childElement.getChildElement('VertexEnvelope', B2B_IntegrationConstants.TAX_XML_URL);
                                Dom.XMLNode quotationResponse;
                                if (vertexEnvelopeNode.getChildElement('QuotationResponse', B2B_IntegrationConstants.TAX_XML_URL) != null) {
                                    quotationResponse = vertexEnvelopeNode.getChildElement('QuotationResponse', B2B_IntegrationConstants.TAX_XML_URL);
                                }
                                if (quotationResponse != null) {
                                    for (Dom.XMLNode quotationResponseChild: quotationResponse.getChildElements()) {
                                        if (quotationResponseChild.getName() == 'TotalTax') {
                                            totalTaxAmount = quotationResponseChild.getText();
                                            responseWrapper.isSuccess = true;
                                            responseWrapper.errorMessage = B2B_IntegrationConstants.BlankVariable;
                                            responseWrapper.totalTaxAmount = Decimal.valueof(totalTaxAmount);
                                        }
                                        if (quotationResponseChild.getName() == 'LineItem') {
                                            String productCode;
                                            for (Dom.XMLNode lineItemsNodes: quotationResponseChild.getChildElements()) {
                                                if (lineItemsNodes.getName() == 'Product') {
                                                    productCode = lineItemsNodes.getText();
                                                }
                                                if (lineItemsNodes.getName() == 'TotalTax' && String.isNotEmpty(productCode)) {
                                                    //changes for HDMP-8716 : Audit trail starts
                                                    Integer lineNumber = Integer.valueOf(quotationResponseChild.getAttributeValue('lineItemNumber',null));
                                                    if(mapLineItems.containsKey(lineNumber)){
                                                        OrderItemWrapper objOrderItemWrapper = mapLineItems.get(lineNumber);
                                                        responseWrapper.mapOrderItemTax.put(objOrderItemWrapper.orderItemId, Decimal.valueOf(lineItemsNodes.getText()));
                                                    }
                                                    //changes for HDMP-8716 : Audit trail ends
                                                    // added by swaroop for shipping for line item - start
                                                    else if(mapShippingLineItems.containsKey(lineNumber)){
                                                        ShippingChargesWrapper objShippingWrapper = mapShippingLineItems.get(lineNumber);
                                                        responseWrapper.mapOrderItemShipTax.put(objShippingWrapper.itemId, Decimal.valueOf(lineItemsNodes.getText()));
                                                    }
                                                    //ends
                                                    
                                                    if(lineItemsDetails.containsKey(productCode)){
                                                        Decimal productTax=Decimal.valueOf(lineItemsDetails.get(productCode)) + Decimal.valueOf(lineItemsNodes.getText());
                                                        lineItemsDetails.put(productCode, string.valueof(productTax));
                                                    } else{
                                                        lineItemsDetails.put(productCode, lineItemsNodes.getText());
                                                    }
                                                    productCode = B2B_IntegrationConstants.BlankVariable;
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                } else {
                    //HDMP-8617- Below lines of code added to handle,insert on error object and trigger email to support team
                    Long afterAPI = B2B_Util.fetchCurrentTime();
                    Long durationTime = B2B_Util.calInMilliSeconds(beforeAPI,afterAPI);
                   	B2B_Util.createErrorRecord('','',dealerId,'','','B2B_VertexTaxCalculationIntegration',String.valueOf(response.getStatusCode()),Label.B2B_Error_Type,'','calculateTaxQuotation',true,orderId,'','',durationTime,Label.B2B_Severity,'Request:'+request.getBody(),'Response:'+response.getBody());
                    //HDMP-8617- End of changes
                    responseWrapper.errorMessage=B2B_IntegrationConstants.BAD_RESPONSE_MESSAGE;
                }
                
                responseWrapper.product_Charges_tax = lineItemsDetails.containsKey(Label.B2B_Product_Code) ? Decimal.valueOf(lineItemsDetails.get(Label.B2B_Product_Code)) : 0.0;
                responseWrapper.shipping_Charges_tax = lineItemsDetails.containsKey(Label.B2B_Shipping_Code) ? Decimal.valueOf(lineItemsDetails.get(Label.B2B_Shipping_Code)) : 0.0;
                responseWrapper.installation_Charges_tax = lineItemsDetails.containsKey(Label.B2B_Installation_Code) ? Decimal.valueOf(lineItemsDetails.get(Label.B2B_Installation_Code)) : 0.0;
                responseWrapper.restocking_Charges_tax = lineItemsDetails.containsKey(Label.B2B_restockingfee_Code) ? Decimal.valueOf(lineItemsDetails.get(Label.B2B_restockingfee_Code)) : 0.0;
                
                 
            }
            
        } catch (Exception Ex) {
            responseWrapper.isSuccess = false;
            responseWrapper.errorMessage = ex.getMessage() + B2B_IntegrationConstants.LINENUMBER + ex.getLineNumber();
        }
        return responseWrapper;
    }
    // Ashwin LTIM for Sprint 3 - Added Parameter carItemProductName
    private static String getAddressDetails(Integer i, String productCode, String Charges, Map<String, String> dealerAddressMap, Map<String, String> customerAddressMap,Integer quantity,Decimal unitPrice , string carItemProductName) {
        String bodyAdd = '<urn:LineItem lineItemNumber="' + i + '">';
        bodyAdd += '<urn:Seller><urn:AdministrativeOrigin>';
        bodyAdd += '<urn:StreetAddress1>' + dealerAddressMap.get(B2B_IntegrationConstants.STREETADDRESS) + '</urn:StreetAddress1>';
        bodyAdd += '<urn:City>' + dealerAddressMap.get(B2B_IntegrationConstants.CITY) + '</urn:City>';
        bodyAdd += '<urn:MainDivision>' + dealerAddressMap.get(B2B_IntegrationConstants.STATE) + '</urn:MainDivision>';
        bodyAdd += '<urn:PostalCode>' + dealerAddressMap.get(B2B_IntegrationConstants.POSTALCODE) + '</urn:PostalCode>';
        bodyAdd += '</urn:AdministrativeOrigin></urn:Seller>';
        bodyAdd += '<urn:Customer><urn:Destination>';
        bodyAdd += '<urn:StreetAddress1>' + customerAddressMap.get(B2B_IntegrationConstants.STREETADDRESS) + '</urn:StreetAddress1>';
        bodyAdd += '<urn:City>' + customerAddressMap.get(B2B_IntegrationConstants.CITY) + '</urn:City>';
        bodyAdd += '<urn:MainDivision>' + customerAddressMap.get(B2B_IntegrationConstants.STATE) + '</urn:MainDivision>';
        bodyAdd += '<urn:PostalCode>' + customerAddressMap.get(B2B_IntegrationConstants.POSTALCODE) + '</urn:PostalCode>';
        bodyAdd += '</urn:Destination></urn:Customer>';
        
        /* begin by ashwin for SP3-16544  */ 
        if(String.isNotEmpty(carItemProductName)){
            bodyAdd += carItemProductName.contains('(CORE CHARGE)') ?'<urn:Product>' +  Label.B2B_Product_Code_Core_Charges + '</urn:Product>'
                : carItemProductName.contains('(REMANUFACTURED)') ? '<urn:Product>' + Label.B2B_Product_Code_Reman + '</urn:Product>'
                    : '<urn:Product>' + productCode + '</urn:Product>' ;
        }
        else{
             bodyAdd += '<urn:Product>' + productCode + '</urn:Product>';
        }
        /* ended by ashwin for SP3-16544 */
        if(quantity!=null && unitPrice!=null){
            bodyAdd += '<urn:Quantity unitOfMeasure="EA">' + quantity + '</urn:Quantity>';
        	bodyAdd += '<urn:UnitPrice>' + unitPrice + '</urn:UnitPrice>';
        }
        
        
        bodyAdd += '<urn:ExtendedPrice>' + Charges + '</urn:ExtendedPrice>';
        bodyAdd += '<urn:FlexibleFields><urn:FlexibleCodeField fieldId="8">HDM</urn:FlexibleCodeField></urn:FlexibleFields>' + '</urn:LineItem>';
        return bodyAdd;
    }

    public static ResponseDataWrapper calculateLineItemReturnTax(Order__x orderdetails, List<OrderItemWrapper> orderItemDetails, String shippingCharge, String restockingFees ){
        ResponseDataWrapper responseWrapper =  New ResponseDataWrapper();       
        Map<String,String> dealerAddressMap = New Map<String,String>();
        Map<String,String> customerAddressMap = New Map<String,String>();
        List<Account__x> accountDetails=new List<Account__x>();
        String dealerCode;
        String dealerId;
        String OrderId = orderDetails.ExternalId;
        String cartid = orderDetails.cart_c__c;
        //String userId = UserInfo.getUserId();

       	if(!Test.isRunningTest()){
            accountDetails=[select id,externalid,ShippingStreet__c,ShippingState__c,ShippingCity__c,ShippingPostalCode__c,PoIId_c__c from Account__x where id=:orderDetails.AccountId__c Limit 1];
        }else {
            Account__x accdetails=new Account__x();
            accdetails.ShippingStreet__c=B2B_IntegrationConstants.TESTDATA_SHIPPING_STREET;
        	accdetails.ShippingCity__c=B2B_IntegrationConstants.TESTDATA_SHIPPING_CITY;
			accdetails.ShippingState__c= B2B_IntegrationConstants.TESTDATA_SHIPPING_STATE;           
        	accdetails.ShippingPostalCode__c=B2B_IntegrationConstants.TESTDATA_SHIPPING_POSTALCODE;
            accountDetails.add(accdetails);
        }
        
        if(accountDetails.size()>0){
            dealerAddressMap.put(B2B_IntegrationConstants.STREETADDRESS,accountDetails[0].ShippingStreet__c);
        	dealerAddressMap.put(B2B_IntegrationConstants.CITY,accountDetails[0].ShippingCity__c);
        	dealerAddressMap.put(B2B_IntegrationConstants.STATE,accountDetails[0].ShippingState__c);
        	dealerAddressMap.put(B2B_IntegrationConstants.POSTALCODE,accountDetails[0].ShippingPostalCode__c);
            dealerCode= accountDetails[0].PoIId_c__c;
            dealerId=accountDetails[0].externalid;
        }
        customerAddressMap.put(B2B_IntegrationConstants.STREETADDRESS,orderDetails.ShippingStreet__c);
        customerAddressMap.put(B2B_IntegrationConstants.CITY,orderDetails.ShippingCity__c);
        customerAddressMap.put(B2B_IntegrationConstants.STATE,orderDetails.ShippingState__c);
        customerAddressMap.put(B2B_IntegrationConstants.POSTALCODE,orderDetails.ShippingPostalCode__c);

        List<CartItem__x> lstcartItems = [SELECT id, Quantity__c,CartId__c,ExternalId,UnitAdjustedPrice__c,B2B_StateTax_c__c,B2B_StateTax_Rate_c__c,B2B_CityTax_c__c,B2B_CityTax_Rate_c__c,TotalAmount__c,B2B_TransitDistrictTax_c__c,B2B_TransitDistrictTax_Rate_c__c,Product2Id__c,Product_Type_c__c FROM CartItem__x where CartId__c=:cartid];
        Map<String, CartItem__x> mapcartItems = new Map<String, CartItem__x>();
        for (CartItem__x  lstcartItem : lstcartItems){
            mapcartItems.put(lstcartItem.ExternalId, lstcartItem);
        }

        Map<String, String> mapProductIdCoreChargeCartItemIds = new Map<String, String>();
        Map<String, String> mapProductIdCartItemIds = new Map<String, String>();
        Map<String, String>  mapCartItemOrderItemIds = new Map<String, String>();
        if(!lstcartItems.isEmpty()){
                List<OrderItem__x> lstOrderItems = [SELECT Id, Product2Id__c, Dealer_Installation_Price_c__c, OrderId__c, Product_SKU_c__c, Product_Name_c__c, Quantity__c 
                , Product_Type_c__c,ExternalId  FROM OrderItem__x WHERE OrderId__c =: OrderId];
                if(lstOrderItems.isEmpty() == false){

                    for(CartItem__x objCartItem : lstcartItems){
                        if(objCartItem.Product_Type_c__c == 'Core Charge'){
                            mapProductIdCoreChargeCartItemIds.put(objCartItem.Product2Id__c, objCartItem.ExternalId);  
                        }else{
                            mapProductIdCartItemIds.put(objCartItem.Product2Id__c, objCartItem.ExternalId);   
                        }    
                    }
                    for(OrderItem__x objOrderItem : lstOrderItems){
                        if(objOrderItem.Product_Type_c__c == 'Core Charge'){ 
                            String cartItemId = mapProductIdCoreChargeCartItemIds.get(objOrderItem.Product2Id__c);
                            mapCartItemOrderItemIds.put(cartItemId, objOrderItem.ExternalId);
                        }else{
                            String cartItemId = mapProductIdCartItemIds.get(objOrderItem.Product2Id__c);
                            mapCartItemOrderItemIds.put(cartItemId, objOrderItem.ExternalId);
                        }
                    }
                }	  
            
        }




        Map<Integer, String> mapLineItem = New Map<Integer, String>();
        Map<Integer,String> mapShipLineItem = new Map<Integer, String>();

        List<B2B_VertexTaxCalculationIntegration.ShippingChargesWrapper> shippingChargesWrapper =  new List<B2B_VertexTaxCalculationIntegration.ShippingChargesWrapper>();
        if((orderdetails.Delivery_Types_c__c == 'DirectShip')){
            for(OrderItemWrapper objOrderItem : orderItemDetails){

                OrderItem__x objOrderitem2 = [SELECT id,ExternalId,Product2Id__c,Shipping_Amount_Per_Unit_c__c, Product_Type_c__c, Product_SKU_c__c,Item_Tax_Code_c__c, Product_Name_c__c,Delta_Quantity_c__c,Cart_Item_Product_Name_c__c FROM OrderItem__x where id =:objOrderItem.orderItemId ];
                
                B2B_VertexTaxCalculationIntegration.ShippingChargesWrapper obj = new B2B_VertexTaxCalculationIntegration.ShippingChargesWrapper();
                obj.itemId = objOrderitem2.ExternalId;
                obj.shippingPrice = objOrderitem2.Shipping_Amount_Per_Unit_c__c * objOrderItem.quantity;
                obj.sku = objOrderitem2.Product_SKU_c__c;
                shippingChargesWrapper.add(obj);             
            }
        }
        

        Http http = new Http();
        HttpRequest request= new HttpRequest();
        String guId = B2B_Util.createGui();
        request.setHeader('Content-Type','text/xml');
        request.setMethod('POST');

        //creating the body
        // Creating Request Body
        String body = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:head="http://www.honda.com/global/1.0/header/" xmlns:urn="urn:vertexinc:o-series:tps:9:0">';
        body += '<soapenv:Header>';
        body += '<head:hondaHeaderType>';
        body += '<head:messageId>'+guId+'</head:messageId>';
        body += '<head:siteId>'+ Label.B2B_Tax_SiteId +'</head:siteId>';
        body += '<head:businessId>'+Label.B2B_Tax_BusinessId+'</head:businessId>';
        body += '<head:collectedTimestamp>'+datetime.now().format('yyyy-MM-dd\'T\'HH:mm:ss.SSSXXX', 'America/Los_Angeles')+'</head:collectedTimestamp>';
        body += '</head:hondaHeaderType>';
        body += '</soapenv:Header>';
        body += '<soapenv:Body> <urn:VertexEnvelope>';
        body += '<urn:Login><urn:UserName>'+Label.B2B_VertexUserName + '</urn:UserName><urn:Password>'+Label.B2B_VertexPassword+'</urn:Password></urn:Login>' ;
        String todayDate = String.valueOf(Date.Today());
        body += '<urn:InvoiceRequest documentDate="'+ todayDate +'" documentNumber="'+ OrderId + '" postingDate="'+ todayDate + '" transactionType="SALE">';
        body += '<urn:Seller> <urn:Company>'+'AHM Group'+'</urn:Company>';
        body += '<urn:Division>'+dealerCode+'</urn:Division> </urn:Seller>';
        Integer i = 0;
        List<OrderItem__x> lstUpdateOrderItems = new List<OrderItem__x>();
        for(OrderItemWrapper objOrderItem : orderItemDetails){

            OrderItem__x objOrderitem2 = [SELECT id,Product2Id__c, Product_Type_c__c, Product_SKU_c__c,Item_Tax_Code_c__c, Product_Name_c__c,Delta_Quantity_c__c,Cart_Item_Product_Name_c__c FROM OrderItem__x where id =:objOrderItem.orderItemId ];
              i = i+1;
              //need to add core producs code 
            mapLineItem.put(i,objOrderitem2.Product_Type_c__c == 'Core Charge' ? mapProductIdCoreChargeCartItemIds.get(objOrderitem2.Product2Id__c) : mapProductIdCartItemIds.get(objOrderitem2.Product2Id__c) );                                              
            body += '<urn:LineItem lineItemNumber="'+i+'" vendorSKU="'+objOrderitem2.Product_SKU_c__c+'">';
            body += '<urn:Seller> <urn:AdministrativeOrigin> <urn:StreetAddress1>';
            body += dealerAddressMap.get('streetAddress') + '</urn:StreetAddress1>';
            body += '<urn:City>'+dealerAddressMap.get('city')+'</urn:City>';
            body += '<urn:MainDivision>'+dealerAddressMap.get('mainDivision')+'</urn:MainDivision>';
            body += '<urn:PostalCode>'+dealerAddressMap.get('postalCode')+'</urn:PostalCode> </urn:AdministrativeOrigin>';
            body += '</urn:Seller>';
            body += '<urn:Customer> <urn:Destination> <urn:StreetAddress1>'+customerAddressMap.get('streetAddress');
            body += '</urn:StreetAddress1><urn:City>'+customerAddressMap.get('city')+'</urn:City>';
            body += '<urn:MainDivision>'+customerAddressMap.get('mainDivision')+'</urn:MainDivision>';
            body += '<urn:PostalCode>'+customerAddressMap.get('postalCode')+'</urn:PostalCode>';
            body += '</urn:Destination></urn:Customer>';
            //Imtiyaz - EVSE_ Start
            if(objOrderitem2.Item_Tax_Code_c__c != null){
                body += '<urn:Product>'+objOrderitem2.Item_Tax_Code_c__c+'</urn:Product>';
            }
            else if (objOrderitem2.Product_Name_c__c=='Motocompacto'){
                body += '<urn:Product>'+Label.B2B_Motocompacto_Code+'</urn:Product>';
             }  else{
                //need to add core Cost unit price field on order item
            body += objOrderItem2.Product_Type_c__c == 'Core Charge' ?  '<urn:Product>'+'Core Charge'+'</urn:Product>'  :  objOrderItem2.Cart_Item_Product_Name_c__c.Contains('REMANUFACTURED')  ? '<urn:Product>'+'Remanufactured Part'+'</urn:Product>' :  '<urn:Product>'+Label.B2B_Product_Code+'</urn:Product>';
            }
            body += '<urn:Quantity unitOfMeasure="EA">'+objOrderItem.quantity+'</urn:Quantity>';
            body += '<urn:UnitPrice>'+objOrderItem.unitPrice+'</urn:UnitPrice>';                 
            body += '<urn:ExtendedPrice>'+ -objOrderItem.quantity * objOrderItem.unitPrice +'</urn:ExtendedPrice>';                    
            body += '<urn:FlexibleFields> <urn:FlexibleCodeField fieldId="8">HDM</urn:FlexibleCodeField></urn:FlexibleFields>'+'</urn:LineItem>';  
           // objOrderitem2.quantity = 0;
               lstUpdateOrderItems.add(objOrderitem2);                             
        }
        
        if(!shippingChargesWrapper.isEmpty()){
            for(B2B_VertexTaxCalculationIntegration.ShippingChargesWrapper obj : shippingChargesWrapper){
                i = i+1;
                mapShipLineItem.put(i, obj.itemId);//added by rajrishi
                mapLineItem.put(i, Label.B2B_Shipping_Code);
                body += '<urn:LineItem lineItemNumber="'+i+'" vendorSKU="'+obj.sku+'">';
                body += '<urn:Seller> <urn:AdministrativeOrigin>';                   
                body += '<urn:StreetAddress1>'+dealerAddressMap.get(B2B_IntegrationConstants.STREETADDRESS)+ '</urn:StreetAddress1>';
                body += '<urn:City>'+dealerAddressMap.get(B2B_IntegrationConstants.CITY)+'</urn:City>';
                body += '<urn:MainDivision>'+dealerAddressMap.get(B2B_IntegrationConstants.STATE)+'</urn:MainDivision>';
                body += '<urn:PostalCode>'+dealerAddressMap.get(B2B_IntegrationConstants.POSTALCODE)+'</urn:PostalCode>';
                body += ' </urn:AdministrativeOrigin></urn:Seller>';
                body += '<urn:Customer> <urn:Destination>';
                body += '<urn:StreetAddress1>'+customerAddressMap.get(B2B_IntegrationConstants.STREETADDRESS)+'</urn:StreetAddress1>';
                body += '<urn:City>'+customerAddressMap.get(B2B_IntegrationConstants.CITY)+'</urn:City>';
                body += '<urn:MainDivision>'+customerAddressMap.get(B2B_IntegrationConstants.STATE)+'</urn:MainDivision>';
                body += '<urn:PostalCode>'+customerAddressMap.get(B2B_IntegrationConstants.POSTALCODE)+'</urn:PostalCode>'; 
                body += '</urn:Destination></urn:Customer>';
                body += '<urn:Product>'+Label.B2B_Shipping_Code+'</urn:Product>';
                body += '<urn:ExtendedPrice>'+ -obj.shippingPrice +'</urn:ExtendedPrice>';
                body += '<urn:FlexibleFields> <urn:FlexibleCodeField fieldId="8">HDM</urn:FlexibleCodeField></urn:FlexibleFields>'+'</urn:LineItem>';
            }
        }
       
        
        if(shippingCharge != null  && shippingChargesWrapper.isEmpty()){
                i = i+1;
                mapLineItem.put(i,'00006');
                body += '<urn:LineItem lineItemNumber="'+i+'">';
                body += '<urn:Seller> <urn:AdministrativeOrigin> <urn:StreetAddress1>';
                body += dealerAddressMap.get('streetAddress') + '</urn:StreetAddress1>';
                body += '<urn:City>'+dealerAddressMap.get('city')+'</urn:City>';
                body += '<urn:MainDivision>'+dealerAddressMap.get('mainDivision')+'</urn:MainDivision>';
                body += '<urn:PostalCode>'+dealerAddressMap.get('postalCode')+'</urn:PostalCode> </urn:AdministrativeOrigin>';
                body += '</urn:Seller>';
                body += '<urn:Customer> <urn:Destination> <urn:StreetAddress1>'+customerAddressMap.get('streetAddress');
                body += '</urn:StreetAddress1><urn:City>'+customerAddressMap.get('city')+'</urn:City>';
                body += '<urn:MainDivision>'+customerAddressMap.get('mainDivision')+'</urn:MainDivision>';
                body += '<urn:PostalCode>'+customerAddressMap.get('postalCode')+'</urn:PostalCode>';
                body += '</urn:Destination></urn:Customer>';
                body += '<urn:Product>'+'00006'+'</urn:Product>';
                body += '<urn:ExtendedPrice>'+ -Decimal.valueOf(shippingCharge) +'</urn:ExtendedPrice>';
                body += '<urn:FlexibleFields> <urn:FlexibleCodeField fieldId="8">HDM</urn:FlexibleCodeField></urn:FlexibleFields>'+'</urn:LineItem>';
        }

        if(String.isNotBlank(restockingFees)){
            i = i+1;
            mapLineItem.put(i,Label.B2B_restockingfee_Code);
            body += '<urn:LineItem lineItemNumber="'+i+'">';
            body += '<urn:Seller> <urn:AdministrativeOrigin>';                        
            body += '<urn:StreetAddress1>'+dealerAddressMap.get(B2B_IntegrationConstants.STREETADDRESS) + '</urn:StreetAddress1>';
            body += '<urn:City>'+dealerAddressMap.get(B2B_IntegrationConstants.CITY)+'</urn:City>';
            body += '<urn:MainDivision>'+dealerAddressMap.get(B2B_IntegrationConstants.STATE)+'</urn:MainDivision>';
            body += '<urn:PostalCode>'+dealerAddressMap.get(B2B_IntegrationConstants.POSTALCODE)+'</urn:PostalCode>';
            body += ' </urn:AdministrativeOrigin></urn:Seller>';
            body += '<urn:Customer> <urn:Destination>';
            body += '<urn:StreetAddress1>'+dealerAddressMap.get(B2B_IntegrationConstants.STREETADDRESS)+'</urn:StreetAddress1>';
            body += '<urn:City>'+dealerAddressMap.get(B2B_IntegrationConstants.CITY)+'</urn:City>';
            body += '<urn:MainDivision>'+dealerAddressMap.get(B2B_IntegrationConstants.STATE)+'</urn:MainDivision>';
            body += '<urn:PostalCode>'+dealerAddressMap.get(B2B_IntegrationConstants.POSTALCODE)+'</urn:PostalCode>'; 
            body += '</urn:Destination></urn:Customer>';
            body += '<urn:Product>'+Label.B2B_restockingfee_Code+'</urn:Product>';
            body += '<urn:ExtendedPrice>'+ Decimal.valueOf(restockingFees)+'</urn:ExtendedPrice>';
            body += '<urn:FlexibleFields> <urn:FlexibleCodeField fieldId="8">HDM</urn:FlexibleCodeField></urn:FlexibleFields>'+'</urn:LineItem>';
        }
        
        body += '</urn:InvoiceRequest></urn:VertexEnvelope></soapenv:Body></soapenv:Envelope>';
        request.setBody(body);  
        request.setEndpoint('callout:B2B_VertexNamedCredential'+ Label.B2B_Vertex_Path_URL);
        responseWrapper.request = request.getbody();
        
        Long beforeAPI = B2B_Util.fetchCurrentTime();

        // Get Response
        HTTPResponse response = http.send(request);
        System.debug('response of Vertex :'+JSON.serialize(response.getBody()));
        if(response.getStatusCode() == B2B_IntegrationConstants.STATUSCODE){
            DOM.Document doc = response.getBodyDocument();
            // Get Root Element which is 'Envelope'
            Dom.XMLNode rootElement = doc.getRootElement();
            String totalTaxAmount ='';
            String errorDescription = '';
            List<CartItem__x> lstCartItem = New List<CartItem__x>();
            Vertex_Details_c__x objParentVertexDetails;
            List<Vertex_Details_c__x> lstChildVertexDetails = new  List<Vertex_Details_c__x>();
            responseWrapper.responseCode = String.valueOf(response.getStatusCode());
            for(Dom.XMLNode childElement : rootElement.getChildElements()){ 
                if(childElement.getName() == 'Body'){
                    if(childElement.getChildElement('Fault','http://schemas.xmlsoap.org/soap/envelope/') != null){
                        Dom.XMLNode faultNode =  childElement.getChildElement('Fault','http://schemas.xmlsoap.org/soap/envelope/');
                        if(faultNode.getChildElement('faultstring',null) != null){
                            errorDescription = faultNode.getChildElement('faultstring',null).getText();
                            responseWrapper.isSuccess = false;
                            responseWrapper.errorMessage = errorDescription;
                            responseWrapper.totalTaxAmount = B2B_IntegrationConstants.ZERO_VALUE;
                        }
                    }else if(childElement.getChildElement('VertexEnvelope','urn:vertexinc:o-series:tps:9:0') != null){
                        Dom.XMLNode vertexEnvelopeNode = childElement.getChildElement('VertexEnvelope','urn:vertexinc:o-series:tps:9:0');
                        Dom.XMLNode quotationResponse;                          
                        if(vertexEnvelopeNode.getChildElement('InvoiceResponse','urn:vertexinc:o-series:tps:9:0') != null){
                            quotationResponse =  vertexEnvelopeNode.getChildElement('InvoiceResponse','urn:vertexinc:o-series:tps:9:0');
                        }
                        if(quotationResponse != null){
                            for(Dom.XMLNode quotationResponseChild : quotationResponse.getChildElements()){
                                //total tax for all line items
                                if(quotationResponseChild.getName() == 'TotalTax'){
                                    totalTaxAmount = quotationResponseChild.getText();
                                    responseWrapper.isSuccess = true;
                                    responseWrapper.errorMessage = '';
                                    responseWrapper.totalTaxAmount = Decimal.valueof(totalTaxAmount);
                                    
                                    //create cartTax record for total tax of all line Items                                                                      
                                    objParentVertexDetails = new Vertex_Details_c__x();
                                    objParentVertexDetails.B2B_Total_Tax_c__c = Decimal.valueOf(totalTaxAmount);
                                    objParentVertexDetails.B2B_Cart_c__c = cartId;
                                    objParentVertexDetails.Order_c__c = OrderId;
                                    objParentVertexDetails.Customer_c__c = orderdetails.OwnerId__c;
                                    objParentVertexDetails.documentNumber_c__c = cartId;
                                    objParentVertexDetails.Tax_Transaction_Date_c__c = System.now();
                                    system.debug('objParentVertexDetails-498-'+objParentVertexDetails);

                                    
                                }
                                if(quotationResponseChild.getName() == 'LineItem'){
                                    system.debug('objChildVertexDetails--mapLineItem'+mapLineItem);

                                    B2B_VertexTaxCalculationIntegration.taxDetailForLineItem objInner = New B2B_VertexTaxCalculationIntegration.taxDetailForLineItem();
                                    String cartItemId = mapLineItem.get(Integer.valueOf(quotationResponseChild.getAttributeValue('lineItemNumber',null)));
                                    objInner.itemId = cartItemId;
                                   // CartItem__x objCartItem;
                                   
                                    Vertex_Details_c__x objChildVertexDetails;
                                    if(cartItemId != Label.B2B_Shipping_Code && cartItemId != Label.B2B_Installation_Code && cartItemId != Label.B2B_restockingfee_Code){
                                        //mapcartItems.get(cartItemId) ;
                                        //objCartItem = New CartItem__x();
                                        //objCartItem.id = objInner.itemId;
                                        //cartTax for line items
                                        objChildVertexDetails = new Vertex_Details_c__x();
                                        objChildVertexDetails.B2B_Cart_c__c = cartId;
                                        objChildVertexDetails.B2B_Cart_Item_Id_c__c = mapcartItems.get(cartItemId).ExternalId;
                                        objChildVertexDetails.Order_c__c = OrderId;
                                        objChildVertexDetails.OrderItem_c__c = mapCartItemOrderItemIds.get(mapcartItems.get(cartItemId).ExternalId);
                                        objChildVertexDetails.Customer_c__c = orderdetails.OwnerId__c;
                                        objChildVertexDetails.documentNumber_c__c = cartId;  
                                        objChildVertexDetails.Tax_Transaction_Date_c__c = System.now();
                                        system.debug('objChildVertexDetails--514'+objChildVertexDetails);
                                    }else if(cartItemId == Label.B2B_Shipping_Code || cartItemId == Label.B2B_Installation_Code || cartItemId == Label.B2B_restockingfee_Code){
                                        //added by rajrishi - HDMP-27067
                                        Integer index = Integer.valueOf(quotationResponseChild.getAttributeValue('lineItemNumber',null));                                             
                                        String orderItemShipId = mapShipLineItem.containsKey(index) ? mapShipLineItem.get(index) : '';
                                        
                                        // HDMP-27067 - ends
                                        // 
                                        //cartTax for shipping
                                        objChildVertexDetails = new Vertex_Details_c__x();
                                        objChildVertexDetails.B2B_Cart_c__c = cartId;                                          
                                        objChildVertexDetails.Order_c__c = OrderId;                   
                                        //objChildVertexDetails.Customer__c = userId;
                                        objChildVertexDetails.documentNumber_c__c = cartId;  
                                        objChildVertexDetails.B2B_Cart_Item_Id_c__c = cartItemId;
                                        objChildVertexDetails.Tax_Transaction_Date_c__c = System.now();
                                        //added by rajrishi
                                        if(String.isNotEmpty(orderItemShipId)){
                                            objChildVertexDetails.OrderItem_c__c= orderItemShipId;
                                        }
                                        system.debug('objChildVertexDetails--535'+objChildVertexDetails);

                                    }
                                    
                                    for(Dom.XMLNode lineItemsNodes : quotationResponseChild.getChildElements()){                       
                                        if(lineItemsNodes.getName() == 'TotalTax'){
                                            objInner.totalItemTax = lineItemsNodes.getText();
                                            if(cartItemId != Label.B2B_Shipping_Code && cartItemId != Label.B2B_Installation_Code && cartItemId != Label.B2B_restockingfee_Code){
                                                objChildVertexDetails.B2B_Total_Tax_c__c = Decimal.valueOf(lineItemsNodes.getText()); 
                                                system.debug('objChildVertexDetails.B2B_Total_Tax_c__c--551'+objChildVertexDetails.B2B_Total_Tax_c__c);                                        
                                            }else if(cartItemId == Label.B2B_Shipping_Code || cartItemId == Label.B2B_Installation_Code || cartItemId == Label.B2B_restockingfee_Code){
                                                objChildVertexDetails.B2B_Total_Tax_c__c = Decimal.valueOf(lineItemsNodes.getText()); 
                                                system.debug('objChildVertexDetails.B2B_Total_Tax_c__c--554'+objChildVertexDetails.B2B_Total_Tax_c__c);                                        

                                            }
                                        }
                                        if(lineItemsNodes.getName() == 'Taxes'){
                                            Dom.XMLNode JuridictionResponse =  lineItemsNodes.getChildElement('Jurisdiction','urn:vertexinc:o-series:tps:9:0');
                                            String jdLevel = JuridictionResponse.getAttributeValue('jurisdictionLevel',null);
                                            String tax =  lineItemsNodes.getChildElement('CalculatedTax','urn:vertexinc:o-series:tps:9:0').getText();
                                            String taxRate =  lineItemsNodes.getChildElement('EffectiveRate','urn:vertexinc:o-series:tps:9:0').getText();
                                            if(jdLevel == 'STATE'){
                                                objInner.stateTax = tax;
                                                objInner.stateTaxRate = taxRate; 
                                                if(cartItemId != Label.B2B_Shipping_Code && cartItemId != Label.B2B_Installation_Code && cartItemId != Label.B2B_restockingfee_Code){
                                                    mapcartItems.get(cartItemId).B2B_StateTax_c__c = Decimal.valueOf(tax);
                                                    mapcartItems.get(cartItemId).B2B_StateTax_Rate_c__c = Decimal.valueOf(taxRate);
                                                    
                                                    //for CartTax
                                                    // objChildVertexDetails.B2B_State_Tax__c = Decimal.valueOf(tax);
                                                    // objChildVertexDetails.B2B_State_Tax_Rate__c = Decimal.valueOf(taxRate);
                                                }else if(cartItemId == Label.B2B_Shipping_Code || cartItemId == Label.B2B_Installation_Code || cartItemId == Label.B2B_restockingfee_Code){
                                                    //for CartTax
                                                    // objChildVertexDetails.B2B_State_Tax__c = Decimal.valueOf(tax);
                                                    // objChildVertexDetails.B2B_State_Tax_Rate__c = Decimal.valueOf(taxRate);
                                                }
                                            }
                                            else if(jdLevel == 'CITY'){
                                                objInner.cityTax = tax;
                                                objInner.cityTaxRate = taxRate;
                                                if(cartItemId != Label.B2B_Shipping_Code && cartItemId != Label.B2B_Installation_Code && cartItemId != Label.B2B_restockingfee_Code){
                                                    mapcartItems.get(cartItemId).B2B_CityTax_c__c = Decimal.valueOf(tax);
                                                    mapcartItems.get(cartItemId).B2B_CityTax_Rate_c__c = Decimal.valueOf(taxRate);
                                                    
                                                    //for CartTax
                                                    // objChildVertexDetails.B2B_City_Tax__c = Decimal.valueOf(tax);
                                                    // objChildVertexDetails.B2B_City_Tax_Rate__c = Decimal.valueOf(taxRate);
                                                }else if(cartItemId == Label.B2B_Shipping_Code || cartItemId == Label.B2B_Installation_Code || cartItemId == Label.B2B_restockingfee_Code){
                                                    //for CartTax
                                                    // objChildVertexDetails.B2B_City_Tax__c = Decimal.valueOf(tax);
                                                    // objChildVertexDetails.B2B_City_Tax_Rate__c = Decimal.valueOf(taxRate);
                                                } 
                                            }else if(jdLevel == 'TRANSIT_DISTRICT'){
                                                objInner.transitDistrictTax = tax;
                                                objInner.transitDistrictTaxRate = taxRate; 
                                                if(cartItemId != Label.B2B_Shipping_Code && cartItemId != Label.B2B_Installation_Code && cartItemId != Label.B2B_restockingfee_Code){
                                                    mapcartItems.get(cartItemId).B2B_TransitDistrictTax_c__c = Decimal.valueOf(tax);
                                                    mapcartItems.get(cartItemId).B2B_TransitDistrictTax_Rate_c__c = Decimal.valueOf(taxRate);
                                                    
                                                    //for CartTax
                                                    // objChildVertexDetails.B2B_Transit_District_Tax__c = Decimal.valueOf(tax);
                                                    // objChildVertexDetails.B2B_Transit_District_Tax_Rate__c = Decimal.valueOf(taxRate);
                                                }else if(cartItemId == Label.B2B_Shipping_Code || cartItemId == Label.B2B_Installation_Code || cartItemId == Label.B2B_restockingfee_Code){
                                                    //for CartTax
                                                    // objChildVertexDetails.B2B_Transit_District_Tax__c = Decimal.valueOf(tax);
                                                    // objChildVertexDetails.B2B_Transit_District_Tax_Rate__c = Decimal.valueOf(taxRate);
                                                } 
                                            }                                                                                    
                                        }
                                    }
                                    if(cartItemId != Label.B2B_Shipping_Code && cartItemId != Label.B2B_Installation_Code && cartItemId != Label.B2B_restockingfee_Code){
                                        lstChildVertexDetails.add(objChildVertexDetails);
                                    }else if(cartItemId == Label.B2B_Shipping_Code || cartItemId == Label.B2B_Installation_Code || cartItemId == Label.B2B_restockingfee_Code){
                                        lstChildVertexDetails.add(objChildVertexDetails);
                                    }
                                    
                                    responseWrapper.lineItemsDetails.add(objInner);
                                    
                                }
                            }
                        }
                    }
                }
            }
            if(mapcartItems.values() != null){
                lstCartItem.addAll(mapcartItems.values());
            }
            system.debug('kstcartitems'+lstCartItem);
            if(!lstCartItem.isEmpty() && !Test.isRunningTest()){
                Database.updateImmediate(lstCartItem);
                
            } 
            if(objParentVertexDetails != null) {   
                system.debug('objParentVertexDetails-637-'+objParentVertexDetails);
                 
                Database.insertImmediate(objParentVertexDetails);

                List<Vertex_Details_c__x> lstVertaxDetails = new List<Vertex_Details_c__x>();
                Vertex_Details_c__x parentVertex = [SELECT id , ExternalId FROM Vertex_Details_c__x where id=:objParentVertexDetails.id];
                //String externalId ='';
                for(Vertex_Details_c__x objVertexDetails : lstChildVertexDetails){   
                    system.debug('objParentVertexDetails-637-'+parentVertex.ExternalId);                   
                    objVertexDetails.Parent_Vertex_Details_c__c = parentVertex.ExternalId;
                    lstVertaxDetails.add(objVertexDetails);
                }
                //insert the child cart tax records
                if(!lstVertaxDetails.isEmpty()){
                    Database.insertImmediate(lstVertaxDetails);
                    responseWrapper.lstVertexDetails = lstVertaxDetails;
                }
            }
            if(!lstUpdateOrderItems.isEmpty() && responseWrapper.isSuccess == true){
                Database.updateImmediate(lstUpdateOrderItems);

            }               	
        }else{
            Long afterAPI = B2B_Util.fetchCurrentTime();
            Long durationTime = B2B_Util.calInMilliSeconds(beforeAPI,afterAPI);
            String errorMsg = 'Order Modification Error due to Vertex API : Error : Issue With Tax posting';
             B2B_Util.createErrorRecord('Order Modification Error','',dealerId,'','','B2B_VertexTaxCalculationIntegration',errorMsg,Label.B2B_Error_Type,'','CalculateLineItemReturn Tax',true,OrderId,'','',durationTime,Label.B2B_Severity,'Request:'+request.getBody(),'Response:'+response.getBody());
             responseWrapper.isSuccess = false;
            //responseWrapper.errorMessage=B2B_IntegrationConstants.BAD_RESPONSE_MESSAGE;
        }

        return responseWrapper;
    }
     
    public class ResponseDataWrapper {
        public String responseCode;
        public String errorMessage;
        public Boolean isSuccess;
        public Decimal totalTaxAmount;
        public Decimal shipping_Charges_tax;
        public Decimal installation_Charges_tax;
        public Decimal restocking_Charges_tax;
        public Decimal product_Charges_tax;
        public Map<String, Decimal> mapOrderItemTax = new Map<String, Decimal>();
        public Map<String, Decimal> mapOrderItemShipTax = new Map<String, Decimal>();
        public List<Vertex_Details_c__x> lstVertexDetails;
        public String request;
        public List<taxDetailForLineItem> lineItemsDetails = New List<taxDetailForLineItem>();//added by suresh for payment settlement
        ResponseDataWrapper() {
            errorMessage = B2B_IntegrationConstants.BlankVariable;
            isSuccess = B2B_IntegrationConstants.FALSE_VALUE;
            responseCode = B2B_IntegrationConstants.BlankVariable;
            totalTaxAmount = B2B_IntegrationConstants.ZERO_VALUE;
            shipping_Charges_tax = B2B_IntegrationConstants.ZERO_VALUE;
            installation_Charges_tax = B2B_IntegrationConstants.ZERO_VALUE;
            restocking_Charges_tax = B2B_IntegrationConstants.ZERO_VALUE;
            product_Charges_tax = B2B_IntegrationConstants.ZERO_VALUE;
        }
    }
    public class OrderItemWrapper {
        @AuraEnabled
        public Integer quantity {get;set;}
        @AuraEnabled
        public Decimal unitPrice {get;set;}
        @AuraEnabled
        public Id orderItemId {get;set;}
        // added for motocompacto
        @AuraEnabled
        public String productType {get;set;}
        // Ashwin LTIM Added for Sp3-16544
        @AuraEnabled
        public String carItemProductName {get;set;}
        //Imtiyaz - EVSE_ Start
        @AuraEnabled
        public String itemTaxCode {get;set;}
        //Imtiyaz - EVSE_ End
        @AuraEnabled
        public Decimal shippingCharge {get;set;}
    }
    
    public class ShippingChargesWrapper{
        public String itemId;
        public Decimal shippingPrice;
        public String sku;//added by suresh for Payment settlement
    }

    //added by suresh for payment settlement
    public class taxDetailForLineItem{
        String itemId,totalItemTax,stateTax,stateTaxRate,cityTax,cityTaxRate,transitDistrictTax,transitDistrictTaxRate;
    }
}