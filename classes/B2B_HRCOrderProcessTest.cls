@isTest
public class B2B_HRCOrderProcessTest {
    
    public static Order__x createOrder(){
        Order__x objOrder = new Order__x();
        objOrder.Status__c = 'IN PROGRESS';
        objOrder.Type__c = B2B_Constants.DIRECTSHIP; // Added by Bruno - Code coverage
        objOrder.Updated_Order_Amount_c__c = 0.00;
        objOrder.Updated_Order_Total_c__c = 22.00;
        objOrder.Updated_Shipping_c__c = 1.00;
        objOrder.Updated_Total_Tax_c__c = 2.00;
        objOrder.Total_Installation_Tax_c__c = 20.00;
        objOrder.Total_Current_Product_Tax_c__c = 20;
        objOrder.BT_Transaction_Status_c__c = 'Authorized';   
        objOrder.Current_Installation_Tax_c__c = 0.00;
        objOrder.Current_Quantity_c__c = 4;
        objOrder.Current_Shipping_Tax_c__c = 2;
        objOrder.Total_Unavailable_TaxAmt_c__c = 20; //Added by HRC
        objOrder.Total_Unavailable_ProductTax_c__c = 20;
        objOrder.Total_Unavailable_ShippingTax_c__c = 8;
        objOrder.Total_Current_Product_Tax_c__c = 8;
        return objOrder;
    }
    
    public static OrderItem__x createOrderItem(){
        OrderItem__x objOrderItem1 = new OrderItem__x();
        objOrderItem1.Delta_Quantity_c__c = 2;
        objOrderItem1.Return_Quantity_c__c = 0;
        objOrderItem1.Shipping_Amount_Per_Unit_c__c = 20; 
        objOrderItem1.Total_Original_Shipping_TaxAmt_c__c = 20;
        objOrderItem1.Total_Tax_c__c = 2.00;
        objOrderItem1.UnitPrice__c = 20.00;
        objOrderItem1.Updated_Quantity_c__c = 4;     
        objOrderItem1.Quantity__c = 6;
        objOrderItem1.Total_Current_Product_Tax_c__c = 1;
        return objOrderItem1;
    }
    
    @isTest
    public static void unitTest(){
        
        Order__x objOrder = createOrder();
        B2B_HRCOrderProcess.mockedOrder.add(objOrder);
        
        OrderItem__x objOrderItem1 = createOrderItem();
        List<OrderItem__x> orderItemLst = new List<OrderItem__x>();
        orderItemLst.add(objOrderItem1);
        
        BT_Transaction_Details_c__x objBTTran = new BT_Transaction_Details_c__x();
        objBTTran.Customer_c__c = '';
        objBTTran.Cardholder_Name_c__c = '';
        B2B_HRCOrderProcess.mockedBTTransaction.add(objBTTran);
            
        Test.setMock(HttpCalloutMock.class, new B2B_BrainTreeIntegrationMock());
         
    	B2B_HRCOrderProcess.processHrcOrderRefund(orderItemLst, '');
    }
    
    @isTest
    public static void unitTest1(){
        
        Order__x objOrder = createOrder();
        B2B_HRCOrderProcess.mockedOrder.add(objOrder);
        
        OrderItem__x objOrderItem1 = createOrderItem();
        B2B_HRCOrderProcess.mockedOrderItems.add(objOrderItem1);
        
        B2B_HRCOrderProcess.createShipmentAuditTrails(objOrder);
    }
    
    @isTest
    public static void unitTestNegative1(){
        Order__x objOrder = createOrder();
        B2B_HRCOrderProcess.mockedOrder.add(objOrder);
        
        OrderItem__x objOrderItem1 = createOrderItem();
        List<OrderItem__x> orderItemLst = new List<OrderItem__x>();
        orderItemLst.add(objOrderItem1);
        
        Test.startTest();        
        Test.setMock(HttpCalloutMock.class, new deviceCodeMock());
        Test.setMock(HttpCalloutMock.class, new B2B_VertexTaxCalculationCalloutMock());
        B2B_HRCOrderProcess.processHrcOrderRefund(orderItemLst, '');
        Test.StopTest();
    }
    
    @isTest
    public static void unitTestNegative2(){
        Order__x objOrder = createOrder();
        B2B_HRCOrderProcess.mockedOrder.add(objOrder);
        
        OrderItem__x objOrderItem1 = createOrderItem();
        List<OrderItem__x> orderItemLst = new List<OrderItem__x>();
        orderItemLst.add(objOrderItem1);
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new DealerAccessTokenMock());
        B2B_HRCOrderProcess.processHrcOrderRefund(orderItemLst, '');
        Test.StopTest();
    }
    
    @isTest
    public static void unitTestNegative3(){
        Order__x objOrder = createOrder();
        B2B_HRCOrderProcess.mockedOrder.add(objOrder);
        
        OrderItem__x objOrderItem1 = createOrderItem();
        List<OrderItem__x> orderItemLst = new List<OrderItem__x>();
        orderItemLst.add(objOrderItem1);
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class,new BraintreeMock());
        B2B_HRCOrderProcess.processHrcOrderRefund(orderItemLst, '');
        Test.StopTest();
    }
    
    public class deviceCodeMock implements HTTPCalloutMock {
        public boolean isSuccess = false;
        public HTTPResponse respond(HTTPRequest request) {
            HttpResponse response = new HttpResponse();
            response.setHeader('Content-Type', 'application/json');
            String body = '{"access_token":"","instance_url":"https://americanhondamotors--pat.sandbox.my.salesforce.com","id":"https://test.salesforce.com/id/00D8C0000004eWIUAY/0058C000001D0bwQAC","token_type":"Bearer","issued_at":"1705480344089","signature":"GRE4pfgttpHzUHxqNkW2x18wTnMBiWaTLbMqMJuizeg="}';
            response.setBody(body); 
            if(isSuccess == true){
                response.setStatusCode(200);
            }else {
                response.setStatusCode(400);
            }
            return response;
        }
    }
    
    public class DealerAccessTokenMock implements HTTPCalloutMock {

        public HTTPResponse respond(HTTPRequest request) {
            String endpoint = request.getEndpoint();
            HttpResponse response = new HttpResponse();
            response.setHeader('Content-Type', 'application/json');
            String body = '';
            if(endpoint.Contains('B2B_HDM_Credential')){
                body = '{"access_token":"34546rtgrfedwsqfd","instance_url":"https://americanhondamotors--pat.sandbox.my.salesforce.com","id":"https://test.salesforce.com/id/00D8C0000004eWIUAY/0058C000001D0bwQAC","token_type":"Bearer","issued_at":"1705480344089","signature":"GRE4pfgttpHzUHxqNkW2x18wTnMBiWaTLbMqMJuizeg="}';
            	 response.setStatusCode(200);
            }else if(endpoint.Contains('B2B_HDM_Dealer_Credential')){
                body = '{"merchantId":"2ny4v6c7xpp2fkfm","isSuccess":false,"errorMessage":null,"dealerNumber":"207617","accessToken":"access_token$sandbox$2ny4v6c7xpp2fkfm$9d6d0752c3abbf34db60721ff6c032c2"}';
            	response.setStatusCode(400);
            }else {
                body = '<?xml version="1.0" encoding="UTF-8"?><soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Header/><soapenv:Body><VertexEnvelope xmlns="urn:vertexinc:o-series:tps:9:0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><Login><TrustedId>******</TrustedId></Login><QuotationResponse documentDate="2021-02-19" transactionType="SALE" postingDate="2021-02-19"><Seller><Company>AHM Group</Company><Division>206500</Division></Seller><SubTotal>100.0</SubTotal><Total>108.25</Total><TotalTax>8.25</TotalTax><LineItem lineItemNumber="1"><Seller><AdministrativeOrigin taxAreaId="443810070"><StreetAddress1>4300 S Georgia St</StreetAddress1><City>AMARILLO</City><MainDivision>TX</MainDivision><PostalCode>79110-1722</PostalCode></AdministrativeOrigin></Seller><Customer><Destination taxAreaId="441130760"><StreetAddress1>1234 Main Street</StreetAddress1><City>DALLAS</City><MainDivision>TX</MainDivision><PostalCode>75201</PostalCode></Destination></Customer>';
                body += '<Product>00004</Product><Quantity>1.0</Quantity><FairMarketValue>-100.0</FairMarketValue><ExtendedPrice>-100.0</ExtendedPrice><Taxes taxResult="TAXABLE" taxType="SELLER_USE" situs="DESTINATION" taxCollectedFromParty="BUYER" taxStructure="SINGLE_RATE"><Jurisdiction jurisdictionLevel="STATE" jurisdictionId="35763">TEXAS</Jurisdiction><CalculatedTax>-6.25</CalculatedTax><EffectiveRate>0.0625</EffectiveRate><Taxable>-100.0</Taxable><Imposition impositionId="1">Sales and Use Tax</Imposition><ImpositionType impositionTypeId="1">General Sales and Use Tax</ImpositionType><TaxRuleId>18653</TaxRuleId><NominalRate>0.0625</NominalRate></Taxes><Taxes taxResult="TAXABLE" taxType="SELLER_USE" situs="DESTINATION" taxCollectedFromParty="BUYER" taxStructure="SINGLE_RATE"><Jurisdiction jurisdictionLevel="CITY" jurisdictionId="77868">DALLAS</Jurisdiction><CalculatedTax>-1.0</CalculatedTax><EffectiveRate>0.01</EffectiveRate><Taxable>-100.0</Taxable><Imposition impositionId="1">Local Sales and Use Tax</Imposition><ImpositionType impositionTypeId="1">General Sales and Use Tax</ImpositionType><TaxRuleId>26262</TaxRuleId><NominalRate>0.01</NominalRate></Taxes><Taxes taxResult="TAXABLE" taxType="SELLER_USE" situs="DESTINATION" taxCollectedFromParty="BUYER" taxStructure="SINGLE_RATE"><Jurisdiction jurisdictionLevel="TRANSIT_DISTRICT" jurisdictionId="78120"><![CDATA[DALLAS METROPOLITAN TRANSIT AUTHORITY]]></Jurisdiction><CalculatedTax>-1.0</CalculatedTax>';
                body += '<EffectiveRate>0.01</EffectiveRate><Taxable>-100.0</Taxable><Imposition impositionId="1">Local Sales and Use Tax</Imposition><ImpositionType impositionTypeId="1">General Sales and Use Tax</ImpositionType><TaxRuleId>26649</TaxRuleId><NominalRate>0.01</NominalRate></Taxes><TotalTax>-8.25</TotalTax><FlexibleFields><FlexibleNumericField fieldId="2">3500</FlexibleNumericField></FlexibleFields><AssistedParameters><AssistedParameter paramName="FLEX.input.GVW" phase="PRE" ruleName="Set Vehicle Weight" originalValue="">3500</AssistedParameter></AssistedParameters></LineItem><LineItem lineItemNumber="2"><Seller><AdministrativeOrigin taxAreaId="443810070"><StreetAddress1>4300 S Georgia St</StreetAddress1><City>AMARILLO</City><MainDivision>TX</MainDivision><PostalCode>79110-1722</PostalCode></AdministrativeOrigin></Seller><Customer><Destination taxAreaId="441130760"><StreetAddress1>1234 Main St</StreetAddress1><City>DALLAS</City><MainDivision>TX</MainDivision><PostalCode>75201</PostalCode></Destination></Customer><Quantity>1.0</Quantity><FairMarketValue>200.0</FairMarketValue><ExtendedPrice>200.0</ExtendedPrice><Taxes taxResult="TAXABLE" taxType="SELLER_USE" situs="DESTINATION" taxCollectedFromParty="BUYER" taxStructure="SINGLE_RATE"><Jurisdiction jurisdictionLevel="STATE" jurisdictionId="35763">TEXAS</Jurisdiction>';
                body += '<CalculatedTax>12.5</CalculatedTax><EffectiveRate>0.0625</EffectiveRate><Taxable>200.0</Taxable><Imposition impositionId="1">Sales and Use Tax</Imposition><ImpositionType impositionTypeId="1">General Sales and Use Tax</ImpositionType><TaxRuleId>18653</TaxRuleId><NominalRate>0.0625</NominalRate></Taxes><Taxes taxResult="TAXABLE" taxType="SELLER_USE" situs="DESTINATION" taxCollectedFromParty="BUYER" taxStructure="SINGLE_RATE"><Jurisdiction jurisdictionLevel="CITY" jurisdictionId="77868">DALLAS</Jurisdiction><CalculatedTax>2.0</CalculatedTax><EffectiveRate>0.01</EffectiveRate><Taxable>200.0</Taxable><Imposition impositionId="1">Local Sales and Use Tax</Imposition><ImpositionType impositionTypeId="1">General Sales and Use Tax</ImpositionType><TaxRuleId>26262</TaxRuleId><NominalRate>0.01</NominalRate></Taxes><Taxes taxResult="TAXABLE" taxType="SELLER_USE" situs="DESTINATION" taxCollectedFromParty="BUYER" taxStructure="SINGLE_RATE"><Jurisdiction jurisdictionLevel="TRANSIT_DISTRICT" jurisdictionId="78120"><![CDATA[DALLAS METROPOLITAN TRANSIT AUTHORITY]]></Jurisdiction><CalculatedTax>2.0</CalculatedTax><EffectiveRate>0.01</EffectiveRate><Taxable>200.0</Taxable><Imposition impositionId="1">Local Sales and Use Tax</Imposition><ImpositionType impositionTypeId="1">General Sales and Use Tax</ImpositionType>';
                body += '<TaxRuleId>26649</TaxRuleId><NominalRate>0.01</NominalRate></Taxes><TotalTax>16.5</TotalTax><FlexibleFields><FlexibleNumericField fieldId="2">3500</FlexibleNumericField></FlexibleFields><AssistedParameters><AssistedParameter paramName="FLEX.input.GVW" phase="PRE" ruleName="Set Vehicle Weight" originalValue="">3500</AssistedParameter></AssistedParameters></LineItem></QuotationResponse><ApplicationData><ResponseTimeMS>122.9</ResponseTimeMS></ApplicationData></VertexEnvelope></soapenv:Body></soapenv:Envelope>';         
            	response.setStatusCode(200);
            }
                        
            response.setBody(body);           
            return response;
        }
    }
    
    public class BraintreeMock implements HTTPCalloutMock {

        public HTTPResponse respond(HTTPRequest request) {
            String endpoint = request.getEndpoint();
            HttpResponse response = new HttpResponse();
            response.setHeader('Content-Type', 'application/json');
            String body = '';
            if(endpoint.Contains('B2B_HDM_Credential')){
                body = '{"access_token":"34546rtgrfedwsqfd","instance_url":"https://americanhondamotors--pat.sandbox.my.salesforce.com","id":"https://test.salesforce.com/id/00D8C0000004eWIUAY/0058C000001D0bwQAC","token_type":"Bearer","issued_at":"1705480344089","signature":"GRE4pfgttpHzUHxqNkW2x18wTnMBiWaTLbMqMJuizeg="}';
            	 response.setStatusCode(200);
            }else if(endpoint.Contains('B2B_HDM_Dealer_Credential')){
                body = '{"merchantId":"2ny4v6c7xpp2fkfm","isSuccess":true,"errorMessage":null,"dealerNumber":"207617","accessToken":"access_token$sandbox$2ny4v6c7xpp2fkfm$9d6d0752c3abbf34db60721ff6c032c2"}';
            	response.setStatusCode(200);
            }else if(endpoint.Contains('Braintree_Named_Credential')){
                body ='{"status":200,"merchantId":"vvh2kqnt6m4434vr","transaction":{"id":"ky5hkfng","status":"authorized","type":"sale","amount":"20.00"},"facilitatedDetails":{"merchantId":"vvh2kqnt6m4434vr","merchantName":"Wipro pvt. lmt."},"facilitatorDetails":{"oauthApplicationClientId":"client_id$sandbox$5chrg778bfg627fg","oauthApplicationName":"Braintree Payment Service","sourcePaymentMethodToken":"009"}}';
            	response.setStatusCode(400);
            }else {
                body = '<?xml version="1.0" encoding="UTF-8"?><soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Header/><soapenv:Body><VertexEnvelope xmlns="urn:vertexinc:o-series:tps:9:0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><Login><TrustedId>******</TrustedId></Login><QuotationResponse documentDate="2021-02-19" transactionType="SALE" postingDate="2021-02-19"><Seller><Company>AHM Group</Company><Division>206500</Division></Seller><SubTotal>100.0</SubTotal><Total>108.25</Total><TotalTax>8.25</TotalTax><LineItem lineItemNumber="1"><Seller><AdministrativeOrigin taxAreaId="443810070"><StreetAddress1>4300 S Georgia St</StreetAddress1><City>AMARILLO</City><MainDivision>TX</MainDivision><PostalCode>79110-1722</PostalCode></AdministrativeOrigin></Seller><Customer><Destination taxAreaId="441130760"><StreetAddress1>1234 Main Street</StreetAddress1><City>DALLAS</City><MainDivision>TX</MainDivision><PostalCode>75201</PostalCode></Destination></Customer>';
                body += '<Product>00004</Product><Quantity>1.0</Quantity><FairMarketValue>-100.0</FairMarketValue><ExtendedPrice>-100.0</ExtendedPrice><Taxes taxResult="TAXABLE" taxType="SELLER_USE" situs="DESTINATION" taxCollectedFromParty="BUYER" taxStructure="SINGLE_RATE"><Jurisdiction jurisdictionLevel="STATE" jurisdictionId="35763">TEXAS</Jurisdiction><CalculatedTax>-6.25</CalculatedTax><EffectiveRate>0.0625</EffectiveRate><Taxable>-100.0</Taxable><Imposition impositionId="1">Sales and Use Tax</Imposition><ImpositionType impositionTypeId="1">General Sales and Use Tax</ImpositionType><TaxRuleId>18653</TaxRuleId><NominalRate>0.0625</NominalRate></Taxes><Taxes taxResult="TAXABLE" taxType="SELLER_USE" situs="DESTINATION" taxCollectedFromParty="BUYER" taxStructure="SINGLE_RATE"><Jurisdiction jurisdictionLevel="CITY" jurisdictionId="77868">DALLAS</Jurisdiction><CalculatedTax>-1.0</CalculatedTax><EffectiveRate>0.01</EffectiveRate><Taxable>-100.0</Taxable><Imposition impositionId="1">Local Sales and Use Tax</Imposition><ImpositionType impositionTypeId="1">General Sales and Use Tax</ImpositionType><TaxRuleId>26262</TaxRuleId><NominalRate>0.01</NominalRate></Taxes><Taxes taxResult="TAXABLE" taxType="SELLER_USE" situs="DESTINATION" taxCollectedFromParty="BUYER" taxStructure="SINGLE_RATE"><Jurisdiction jurisdictionLevel="TRANSIT_DISTRICT" jurisdictionId="78120"><![CDATA[DALLAS METROPOLITAN TRANSIT AUTHORITY]]></Jurisdiction><CalculatedTax>-1.0</CalculatedTax>';
                body += '<EffectiveRate>0.01</EffectiveRate><Taxable>-100.0</Taxable><Imposition impositionId="1">Local Sales and Use Tax</Imposition><ImpositionType impositionTypeId="1">General Sales and Use Tax</ImpositionType><TaxRuleId>26649</TaxRuleId><NominalRate>0.01</NominalRate></Taxes><TotalTax>-8.25</TotalTax><FlexibleFields><FlexibleNumericField fieldId="2">3500</FlexibleNumericField></FlexibleFields><AssistedParameters><AssistedParameter paramName="FLEX.input.GVW" phase="PRE" ruleName="Set Vehicle Weight" originalValue="">3500</AssistedParameter></AssistedParameters></LineItem><LineItem lineItemNumber="2"><Seller><AdministrativeOrigin taxAreaId="443810070"><StreetAddress1>4300 S Georgia St</StreetAddress1><City>AMARILLO</City><MainDivision>TX</MainDivision><PostalCode>79110-1722</PostalCode></AdministrativeOrigin></Seller><Customer><Destination taxAreaId="441130760"><StreetAddress1>1234 Main St</StreetAddress1><City>DALLAS</City><MainDivision>TX</MainDivision><PostalCode>75201</PostalCode></Destination></Customer><Quantity>1.0</Quantity><FairMarketValue>200.0</FairMarketValue><ExtendedPrice>200.0</ExtendedPrice><Taxes taxResult="TAXABLE" taxType="SELLER_USE" situs="DESTINATION" taxCollectedFromParty="BUYER" taxStructure="SINGLE_RATE"><Jurisdiction jurisdictionLevel="STATE" jurisdictionId="35763">TEXAS</Jurisdiction>';
                body += '<CalculatedTax>12.5</CalculatedTax><EffectiveRate>0.0625</EffectiveRate><Taxable>200.0</Taxable><Imposition impositionId="1">Sales and Use Tax</Imposition><ImpositionType impositionTypeId="1">General Sales and Use Tax</ImpositionType><TaxRuleId>18653</TaxRuleId><NominalRate>0.0625</NominalRate></Taxes><Taxes taxResult="TAXABLE" taxType="SELLER_USE" situs="DESTINATION" taxCollectedFromParty="BUYER" taxStructure="SINGLE_RATE"><Jurisdiction jurisdictionLevel="CITY" jurisdictionId="77868">DALLAS</Jurisdiction><CalculatedTax>2.0</CalculatedTax><EffectiveRate>0.01</EffectiveRate><Taxable>200.0</Taxable><Imposition impositionId="1">Local Sales and Use Tax</Imposition><ImpositionType impositionTypeId="1">General Sales and Use Tax</ImpositionType><TaxRuleId>26262</TaxRuleId><NominalRate>0.01</NominalRate></Taxes><Taxes taxResult="TAXABLE" taxType="SELLER_USE" situs="DESTINATION" taxCollectedFromParty="BUYER" taxStructure="SINGLE_RATE"><Jurisdiction jurisdictionLevel="TRANSIT_DISTRICT" jurisdictionId="78120"><![CDATA[DALLAS METROPOLITAN TRANSIT AUTHORITY]]></Jurisdiction><CalculatedTax>2.0</CalculatedTax><EffectiveRate>0.01</EffectiveRate><Taxable>200.0</Taxable><Imposition impositionId="1">Local Sales and Use Tax</Imposition><ImpositionType impositionTypeId="1">General Sales and Use Tax</ImpositionType>';
                body += '<TaxRuleId>26649</TaxRuleId><NominalRate>0.01</NominalRate></Taxes><TotalTax>16.5</TotalTax><FlexibleFields><FlexibleNumericField fieldId="2">3500</FlexibleNumericField></FlexibleFields><AssistedParameters><AssistedParameter paramName="FLEX.input.GVW" phase="PRE" ruleName="Set Vehicle Weight" originalValue="">3500</AssistedParameter></AssistedParameters></LineItem></QuotationResponse><ApplicationData><ResponseTimeMS>122.9</ResponseTimeMS></ApplicationData></VertexEnvelope></soapenv:Body></soapenv:Envelope>';         
            	response.setStatusCode(200);
            }
            return response;
        }
    }
    
    public class B2B_BrainTreeIntegrationMock implements HTTPCalloutMock {
        
        public HTTPResponse respond(HTTPRequest request) {
            String endpoint = request.getEndpoint();
            System.debug('endpoint => ' + endpoint);
            // Create a fake response
            HttpResponse response = new HttpResponse();
            response.setHeader('Content-Type', 'application/json');
            String body = '';
            if(endpoint.Contains('B2B_HDM_Credential')) {
                body = '{"access_token":"00D8C0000004eWI!AR8AQHUbvO_rfdvu_ROQiuk9.yjCP1vdGI.LohZ2d3GWyCYYi2Jo2.gOdDmD5ggPwOIfd3mfrJlo3290i2ZociP2MGVxxMxY","instance_url":"https://americanhondamotors--pat.sandbox.my.salesforce.com","id":"https://test.salesforce.com/id/00D8C0000004eWIUAY/0058C000001D0bwQAC","token_type":"Bearer","issued_at":"1705480344089","signature":"GRE4pfgttpHzUHxqNkW2x18wTnMBiWaTLbMqMJuizeg="}';
            }else if(endpoint.Contains('B2B_HDM_Dealer_Credential')){
                body ='{"merchantId":"2ny4v6c7xpp2fkfm","isSuccess":true,"errorMessage":null,"dealerNumber":"207617","accessToken":"access_token$sandbox$2ny4v6c7xpp2fkfm$9d6d0752c3abbf34db60721ff6c032c2"}';
            }else if(endpoint.Contains('Braintree_Named_Credential')){
                body ='{"status":200,"merchantId":"vvh2kqnt6m4434vr","transaction":{"id":"ky5hkfng","status":"authorized","type":"sale","amount":"20.00"},"facilitatedDetails":{"merchantId":"vvh2kqnt6m4434vr","merchantName":"Wipro pvt. lmt."},"facilitatorDetails":{"oauthApplicationClientId":"client_id$sandbox$5chrg778bfg627fg","oauthApplicationName":"Braintree Payment Service","sourcePaymentMethodToken":"009"}}';
            }else {                             
                body = '<?xml version="1.0" encoding="UTF-8"?><soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Header/><soapenv:Body><VertexEnvelope xmlns="urn:vertexinc:o-series:tps:9:0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><Login><TrustedId>******</TrustedId></Login><QuotationResponse documentDate="2021-02-19" transactionType="SALE" postingDate="2021-02-19"><Seller><Company>AHM Group</Company><Division>206500</Division></Seller><SubTotal>100.0</SubTotal><Total>108.25</Total><TotalTax>8.25</TotalTax><LineItem lineItemNumber="1"><Seller><AdministrativeOrigin taxAreaId="443810070"><StreetAddress1>4300 S Georgia St</StreetAddress1><City>AMARILLO</City><MainDivision>TX</MainDivision><PostalCode>79110-1722</PostalCode></AdministrativeOrigin></Seller><Customer><Destination taxAreaId="441130760"><StreetAddress1>1234 Main Street</StreetAddress1><City>DALLAS</City><MainDivision>TX</MainDivision><PostalCode>75201</PostalCode></Destination></Customer>';
                body += '<Product>00004</Product><Quantity>1.0</Quantity><FairMarketValue>-100.0</FairMarketValue><ExtendedPrice>-100.0</ExtendedPrice><Taxes taxResult="TAXABLE" taxType="SELLER_USE" situs="DESTINATION" taxCollectedFromParty="BUYER" taxStructure="SINGLE_RATE"><Jurisdiction jurisdictionLevel="STATE" jurisdictionId="35763">TEXAS</Jurisdiction><CalculatedTax>-6.25</CalculatedTax><EffectiveRate>0.0625</EffectiveRate><Taxable>-100.0</Taxable><Imposition impositionId="1">Sales and Use Tax</Imposition><ImpositionType impositionTypeId="1">General Sales and Use Tax</ImpositionType><TaxRuleId>18653</TaxRuleId><NominalRate>0.0625</NominalRate></Taxes><Taxes taxResult="TAXABLE" taxType="SELLER_USE" situs="DESTINATION" taxCollectedFromParty="BUYER" taxStructure="SINGLE_RATE"><Jurisdiction jurisdictionLevel="CITY" jurisdictionId="77868">DALLAS</Jurisdiction><CalculatedTax>-1.0</CalculatedTax><EffectiveRate>0.01</EffectiveRate><Taxable>-100.0</Taxable><Imposition impositionId="1">Local Sales and Use Tax</Imposition><ImpositionType impositionTypeId="1">General Sales and Use Tax</ImpositionType><TaxRuleId>26262</TaxRuleId><NominalRate>0.01</NominalRate></Taxes><Taxes taxResult="TAXABLE" taxType="SELLER_USE" situs="DESTINATION" taxCollectedFromParty="BUYER" taxStructure="SINGLE_RATE"><Jurisdiction jurisdictionLevel="TRANSIT_DISTRICT" jurisdictionId="78120"><![CDATA[DALLAS METROPOLITAN TRANSIT AUTHORITY]]></Jurisdiction><CalculatedTax>-1.0</CalculatedTax>';
                body += '<EffectiveRate>0.01</EffectiveRate><Taxable>-100.0</Taxable><Imposition impositionId="1">Local Sales and Use Tax</Imposition><ImpositionType impositionTypeId="1">General Sales and Use Tax</ImpositionType><TaxRuleId>26649</TaxRuleId><NominalRate>0.01</NominalRate></Taxes><TotalTax>-8.25</TotalTax><FlexibleFields><FlexibleNumericField fieldId="2">3500</FlexibleNumericField></FlexibleFields><AssistedParameters><AssistedParameter paramName="FLEX.input.GVW" phase="PRE" ruleName="Set Vehicle Weight" originalValue="">3500</AssistedParameter></AssistedParameters></LineItem><LineItem lineItemNumber="2"><Seller><AdministrativeOrigin taxAreaId="443810070"><StreetAddress1>4300 S Georgia St</StreetAddress1><City>AMARILLO</City><MainDivision>TX</MainDivision><PostalCode>79110-1722</PostalCode></AdministrativeOrigin></Seller><Customer><Destination taxAreaId="441130760"><StreetAddress1>1234 Main St</StreetAddress1><City>DALLAS</City><MainDivision>TX</MainDivision><PostalCode>75201</PostalCode></Destination></Customer><Quantity>1.0</Quantity><FairMarketValue>200.0</FairMarketValue><ExtendedPrice>200.0</ExtendedPrice><Taxes taxResult="TAXABLE" taxType="SELLER_USE" situs="DESTINATION" taxCollectedFromParty="BUYER" taxStructure="SINGLE_RATE"><Jurisdiction jurisdictionLevel="STATE" jurisdictionId="35763">TEXAS</Jurisdiction>';
                body += '<CalculatedTax>12.5</CalculatedTax><EffectiveRate>0.0625</EffectiveRate><Taxable>200.0</Taxable><Imposition impositionId="1">Sales and Use Tax</Imposition><ImpositionType impositionTypeId="1">General Sales and Use Tax</ImpositionType><TaxRuleId>18653</TaxRuleId><NominalRate>0.0625</NominalRate></Taxes><Taxes taxResult="TAXABLE" taxType="SELLER_USE" situs="DESTINATION" taxCollectedFromParty="BUYER" taxStructure="SINGLE_RATE"><Jurisdiction jurisdictionLevel="CITY" jurisdictionId="77868">DALLAS</Jurisdiction><CalculatedTax>2.0</CalculatedTax><EffectiveRate>0.01</EffectiveRate><Taxable>200.0</Taxable><Imposition impositionId="1">Local Sales and Use Tax</Imposition><ImpositionType impositionTypeId="1">General Sales and Use Tax</ImpositionType><TaxRuleId>26262</TaxRuleId><NominalRate>0.01</NominalRate></Taxes><Taxes taxResult="TAXABLE" taxType="SELLER_USE" situs="DESTINATION" taxCollectedFromParty="BUYER" taxStructure="SINGLE_RATE"><Jurisdiction jurisdictionLevel="TRANSIT_DISTRICT" jurisdictionId="78120"><![CDATA[DALLAS METROPOLITAN TRANSIT AUTHORITY]]></Jurisdiction><CalculatedTax>2.0</CalculatedTax><EffectiveRate>0.01</EffectiveRate><Taxable>200.0</Taxable><Imposition impositionId="1">Local Sales and Use Tax</Imposition><ImpositionType impositionTypeId="1">General Sales and Use Tax</ImpositionType>';
                body += '<TaxRuleId>26649</TaxRuleId><NominalRate>0.01</NominalRate></Taxes><TotalTax>16.5</TotalTax><FlexibleFields><FlexibleNumericField fieldId="2">3500</FlexibleNumericField></FlexibleFields><AssistedParameters><AssistedParameter paramName="FLEX.input.GVW" phase="PRE" ruleName="Set Vehicle Weight" originalValue="">3500</AssistedParameter></AssistedParameters></LineItem></QuotationResponse><ApplicationData><ResponseTimeMS>122.9</ResponseTimeMS></ApplicationData></VertexEnvelope></soapenv:Body></soapenv:Envelope>';         
            }
            
            response.setBody(body); 
            response.setStatusCode(200);
            return response;
        }
        
    }
}