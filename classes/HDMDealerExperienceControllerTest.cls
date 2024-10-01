@isTest
public class HDMDealerExperienceControllerTest {
	@isTest
    public static void unitTest(){
        String userid = UserInfo.getUserId();
        PermissionSet ps = [SELECT Id FROM PermissionSet WHERE PermissionSet.Name  = 'DreamShop_Order_Managemnt'];
        insert new PermissionSetAssignment(AssigneeId = userid, PermissionSetId = ps.Id);
        
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
        objOrder.Total_Current_Product_Tax_c__c = 10;
        objOrder.Total_Current_Pre_Tax_Order_Amount_c__c = 100;
        objOrder.Updated_Order_Total_c__c = 100;
        objOrder.Current_Quantity_c__c = 10;
        
        HDMDealerExperienceController.mockedOrder.add(objOrder);      
        HDMDealerExperienceController.OrderDetails(objOrder.Id);
        HDMDealerExperienceController.updateExternalOrder(objOrder);
        HDMDealerExperienceController.updateExternalOrder(null);
                
        OrderItem__x objOrderItem1 = new OrderItem__x();
        objOrderItem1.Delta_Quantity_c__c = 2;
        objOrderItem1.Return_Quantity_c__c = 0;
        objOrderItem1.Shipping_Amount_Per_Unit_c__c = 20; // Added by Bruno - Code coverage
        objOrderItem1.Total_Original_Shipping_TaxAmt_c__c = 20; // Added by Bruno - Code coverage
        objOrderItem1.Total_Tax_c__c = 2.00;
        objOrderItem1.UnitPrice__c = 20.00;
        objOrderItem1.Updated_Quantity_c__c = 4;     
        objOrderItem1.Quantity__c = 6;
        objOrderItem1.Total_Current_Product_Tax_c__c = 10;
        
        /** Saravanan LTIM Added for Reman Functionality ***/
        OrderItem__x objOrderItem2 = new OrderItem__x();
        objOrderItem2.Delta_Quantity_c__c = 2;
        objOrderItem2.Return_Quantity_c__c = 0;
        objOrderItem2.Total_Tax_c__c = 2.00;
        objOrderItem2.UnitPrice__c = 20.00;
        objOrderItem2.Updated_Quantity_c__c = 4;     
        objOrderItem2.Quantity__c = 6;
        objOrderItem2.Product_Type_c__c = 'Core Charge';
        objOrderItem2.Total_Current_Product_Tax_c__c = 10;
        
        objOrder.Order_Product_c__c = objOrderItem1.Id; // Added by Bruno - Code coverage
        Test.startTest();
        
         B2B_VertexTaxCalculationIntegration.ResponseDataWrapper mockTest = new B2B_VertexTaxCalculationIntegration.ResponseDataWrapper() ;
        Map<String, Decimal> mapOrderItemTax = new Map<String, Decimal>();
        
        mockTest.isSuccess = true;
        mockTest.totalTaxAmount = 500.0;
        mockTest.shipping_Charges_tax = 200;
        mockTest.installation_Charges_tax = 200;
        mapOrderItemTax.put(objOrderItem2.Id,2000);
        mockTest.mapOrderItemTax = mapOrderItemTax;
        HDMDealerExperienceController.responseData2 = mockTest;
        
        
        Test.setMock(HttpCalloutMock.class, new B2B_VertexTaxCalculationCalloutMock());
        HDMDealerExperienceController.mockedOrderItems.add(objOrderItem1);     
        HDMDealerExperienceController.updateExternalOrderItem(HDMDealerExperienceController.mockedOrderItems, 'Modify Order',2, 2,  2, 2, '');
        HDMDealerExperienceController.updateExternalOrderItem(HDMDealerExperienceController.mockedOrderItems, 'Partial Return',2, 2,  2, 2, '');
        HDMDealerExperienceController.addExternalDealerNotes(objOrder.Id, 'Addng dealer note');
        HDMDealerExperienceController.getAllExternalDealerNotes(objOrder.Id);
        HDMDealerExperienceController.mockedOrder.clear();
        Order__x objOrder1 = new Order__x();
        objOrder1.Status__c = 'IN PROGRESS';
        objOrder1.Type__c = B2B_Constants.DIRECTSHIP; // Added by Bruno - Code coverage
        objOrder1.Updated_Order_Amount_c__c = 0.00;
        objOrder1.Updated_Order_Total_c__c = 22.00;
        objOrder1.Updated_Shipping_c__c = 7.00; // Added by Bruno - Code coverage
        objOrder1.Updated_Total_Tax_c__c = 2.00;
        objOrder1.Total_Installation_Tax_c__c = 20.00;
        objOrder1.Current_Quantity_c__c = 4; // Added by Bruno - Code coverage
        objOrder1.Total_Current_Product_Tax_c__c = 20; // Added by Bruno - Code coverage
        objOrder1.BT_Transaction_Status_c__c = 'Authorized';        
		objOrder1.Order_Product_c__c = objOrderItem1.Id; // Added by Bruno - Code coverage
        HDMDealerExperienceController.mockedOrder.add(objOrder1); 
        HDMDealerExperienceController.updateExternalOrderItem(HDMDealerExperienceController.mockedOrderItems, 'Modify Order',2, 2,  2, 2, '');
    	HDMDealerExperienceController.createOrderAuditTrails(objOrder1,HDMDealerExperienceController.mockedOrderItems,'',2,2); // Added by Bruno - Code coverage
        HDMDealerExperienceController.orderFullFilmentWrapper ord = new HDMDealerExperienceController.orderFullFilmentWrapper(); // Added by Bruno - Code coverage
        
        ord.Id = 'asdjhg23232'; // Added by Bruno - Code coverage
        ord.orderId = objOrder1.Id; // Added by Bruno - Code coverage
        ord.shipmentCarrier = 'RP'; // Added by Bruno - Code coverage
        //ord.shippingSpeed = '3'; // Added by Bruno - Code coverage
        ord.trackingNumber = '891236781312'; // Added by Bruno - Code coverage
        
        HDMDealerExperienceController.insertUpdateExternalOrdFullFilment(ord, false); // Added by Bruno - Code coverage
        
        Test.stopTest();
    }
    
    // START - Added by Bruno - Code Coverage
    @isTest
    public static void unitTest2(){
        
        String userid = UserInfo.getUserId();
        PermissionSet ps = [SELECT Id FROM PermissionSet WHERE PermissionSet.Name  = 'DreamShop_Order_Managemnt'];
        insert new PermissionSetAssignment(AssigneeId = userid, PermissionSetId = ps.Id);
        
        Order__x objOrder = new Order__x();
        objOrder.Status__c = 'IN PROGRESS';
        objOrder.Type__c = B2B_Constants.DIRECTSHIP; 
        objOrder.Updated_Order_Amount_c__c = 0.00;
        objOrder.Updated_Order_Total_c__c = 22.00;
        objOrder.Updated_Shipping_c__c = 1.00;
        objOrder.Updated_Total_Tax_c__c = 2.00;
        objOrder.Total_Installation_Tax_c__c = 20.00;
        objOrder.Total_Current_Product_Tax_c__c = 20;
        objOrder.BT_Transaction_Status_c__c = 'Submitted_For_Settlement';   
        objOrder.Product_Division_c__c = '9';
        objOrder.Current_Installation_Tax_c__c = 0.00;
        objOrder.Current_Quantity_c__c = 4;
        
        OrderItem__x objOrderItem1 = new OrderItem__x();
        objOrderItem1.Delta_Quantity_c__c = 2;
        objOrderItem1.Return_Quantity_c__c = 0;
        objOrderItem1.Shipping_Amount_Per_Unit_c__c = 20; 
        objOrderItem1.Total_Original_Shipping_TaxAmt_c__c = 20; 
        objOrderItem1.Total_Tax_c__c = 2.00;
        objOrderItem1.UnitPrice__c = 20.00;
        objOrderItem1.Updated_Quantity_c__c = 4;     
        objOrderItem1.Quantity__c = 6;
        objOrderItem1.Total_Return_Product_Tax_c__c = 18;
            
        objOrder.Order_Product_c__c = objOrderItem1.Id; 
        
        HDMDealerExperienceController.mockedOrder.add(objOrder);      
        HDMDealerExperienceController.OrderDetails(objOrder.Id);
        HDMDealerExperienceController.updateExternalOrder(objOrder);
        HDMDealerExperienceController.updateExternalOrder(null);
        
        Test.startTest();
        
        Test.setMock(HttpCalloutMock.class, new B2B_VertexTaxCalculationCalloutMock());
        
        HDMDealerExperienceController.mockedOrderItems.add(objOrderItem1);     
        HDMDealerExperienceController.updateExternalOrderItem(HDMDealerExperienceController.mockedOrderItems, 'Modify Order',2, 2,  2, 2, '');
        HDMDealerExperienceController.updateExternalOrderItem(HDMDealerExperienceController.mockedOrderItems, 'Partial Return',2, 2,  2, 2, ''); 
        HDMDealerExperienceController.addExternalDealerNotes(objOrder.Id, 'Addng dealer note');
        HDMDealerExperienceController.getAllExternalDealerNotes(objOrder.Id);
        HDMDealerExperienceController.mockedOrder.clear();
        
        Order__x objOrder1 = new Order__x();
        objOrder1.Status__c = 'IN PROGRESS';
        objOrder1.Type__c = B2B_Constants.DIRECTSHIP; 
        objOrder1.Updated_Order_Amount_c__c = 0.00;
        objOrder1.Updated_Order_Total_c__c = 22.00;
        objOrder1.Updated_Shipping_c__c = 7.00; 
        objOrder1.Updated_Total_Tax_c__c = 2.00;
        objOrder1.Total_Installation_Tax_c__c = 20.00;
        objOrder1.Current_Quantity_c__c = 4; 
        objOrder1.Total_Current_Product_Tax_c__c = 20; 
        objOrder1.BT_Transaction_Status_c__c = 'Submitted_For_Settlement';   
        objOrder1.Product_Division_c__c = '9';
		objOrder1.Order_Product_c__c = objOrderItem1.Id; 
        
        HDMDealerExperienceController.mockedOrder.add(objOrder1); 
        HDMDealerExperienceController.updateExternalOrderItem(HDMDealerExperienceController.mockedOrderItems, 'Modify Order',2, 2,  2, 2, '');
    	HDMDealerExperienceController.createOrderAuditTrails(objOrder1,HDMDealerExperienceController.mockedOrderItems,'',2,2); 
		        
        Test.stopTest();
    }
    // END - Added by Bruno - Code Coverage
    
    @isTest 
    public static void testOrderDetails(){
       String userid = UserInfo.getUserId();
        List<PermissionSetAssignment>  ps = [SELECT Id,PermissionSetId,PermissionSet.Name FROM PermissionSetAssignment WHERE PermissionSet.Name  = 'DreamShop_Order_Managemnt'];
        //insert new PermissionSetAssignment(AssigneeId = userid, PermissionSetId = ps.Id);
         HDMDealerExperienceController.OrderWrapper owpr = new HDMDealerExperienceController.OrderWrapper();
        
        if(!ps.isEmpty()){
            system.debug('232');
            for(PermissionSetAssignment objPerm : ps){
               if(objPerm.PermissionSet.Name == 'DreamShop_Order_Managemnt' || objPerm.PermissionSet.Name == 'HELMS_and_HDM_Manager'){
                    owpr.isDealerAdmin = false;
                }   
            }
        }
        
        Test.startTest();
        HDMDealerExperienceController.OrderDetails('');
        
        Test.stopTest();
        
    }
    
    @isTest
    public static void getExternalAccountsTest(){
       
        Account__x objAccount = new Account__x();
        objAccount.B2B_Preferred_Carrier_c__c = 'USPS';
        objAccount.schedule_installation_c__c = '';
        objAccount.Return_Window_c__c = 14;
        objAccount.Charge_Restocking_Fees_c__c = 'Yes';
        objAccount.PoIId_c__c = '12343';
        objAccount.Restocking_Fees_c__c = 4;     
        HDMDealerExperienceController.mockedAccounts.add(objAccount);
        
        Set<String> customerUserTypes = new Set<String> {'CSPLiteUser', 'PowerPartner', 'PowerCustomerSuccess',   'CustomerSuccess'};
        String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@testorg.com';
        //Added by Divya Start
        User user = new User();
        Contact objContact;
        user = [Select Id,Profile.Name from User where id=: userinfo.getUserId()];
        String userProfile = user.Profile.Name;
        User userRoleId = [Select UserRoleId from User where Profile.Name =:userProfile AND UserRoleId != null limit 1];
        UserRole userrole = [Select Id From UserRole Where Id =:userRoleId.UserRoleId  Limit 1];
        user.UserRoleId = userrole.Id;
        update user;
        System.runAs(user){//Added by Divya END
        Account objAccount1 = new Account();
        objAccount1.Name = 'test';
        objAccount1.DealerCode_CD__c = '12343';        
        insert objAccount1;
        
        //Contact objContact = new Contact();
        objContact = new Contact();//Modified by Divya
        objContact.FirstName = 'test';
        objContact.LastName = 'test';
        objContact.AccountId = objAccount1.Id;
        objContact.HelmsCRMEligible_FLAG__c = true;
        objContact.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
        insert objContact;
        }//Added by Divya
        
       
        // This code runs as the system user
        //Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        Profile p = [select Id,name from Profile where UserType in :customerUserTypes limit 1];
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com',
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                          LocaleSidKey='en_US', ProfileId = p.Id,
                          TimeZoneSidKey='America/Los_Angeles',
                          contactId=objContact.Id,
                      
                          UserName=uniqueUserName); 
        
        PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'DreamShop_Order_Managemnt']; // Added by Bruno - Code coverage
        
        System.runAs(u) {
            insert new PermissionSetAssignment(AssigneeId = u.Id, PermissionSetId = ps.Id); // Added by Bruno - Code coverage
            HDMDealerExperienceController.getAccountDetails();
            HDMDealerExperienceController.updateDealerAccount(objAccount);
            
        }
    }
  
    
    @isTest
    public static void testgetAccountDetails(){
        Test.startTest();
        HDMDealerExperienceController.OrderWrapper odwr = new HDMDealerExperienceController.OrderWrapper();
        odwr.isDealerAdmin = false; 
        HDMDealerExperienceController.getAccountDetails();
        Test.stopTest();
    }
    
     
    @isTest
    public static void testReman(){
             String userid = UserInfo.getUserId();
        PermissionSet ps = [SELECT Id FROM PermissionSet WHERE PermissionSet.Name  = 'DreamShop_Order_Managemnt'];
        insert new PermissionSetAssignment(AssigneeId = userid, PermissionSetId = ps.Id);
       
        
         Account__x objAccount = new Account__x();
        objAccount.B2B_Preferred_Carrier_c__c = 'USPS';
        objAccount.schedule_installation_c__c = '';
        objAccount.Return_Window_c__c = 14;
        objAccount.Charge_Restocking_Fees_c__c = 'Yes';
        objAccount.PoIId_c__c = '12343';
        objAccount.Restocking_Fees_c__c = 4;     
        HDMDealerExperienceController.mockedAccounts.add(objAccount);
        
        Order__x objOrder = new Order__x();
        objOrder.Status__c = 'IN PROGRESS';
        objOrder.Updated_Order_Amount_c__c = 0.00;
        objOrder.Updated_Order_Total_c__c = 22.00;
        objOrder.Updated_Total_Tax_c__c = 2.00;
        objOrder.Total_Installation_Tax_c__c = 20.00;
        objOrder.BT_Transaction_Status_c__c = 'Authorized';   
        objOrder.Current_Installation_Tax_c__c = 0.00;
        objOrder.Total_Core_Charge_Current_Quantity__c = 10;
        objOrder.Total_Core_Charge_Current_Amount__c =100;
        objOrder.Total_Current_Product_Tax_c__c = 10;
        objOrder.Current_Quantity_c__c = 10;
        objOrder.Total_Current_Pre_Tax_Order_Amount_c__c = 100;
        objOrder.Updated_Order_Total_c__c = 100;
        
        HDMDealerExperienceController.mockedOrder.add(objOrder);      
        HDMDealerExperienceController.OrderDetails(objOrder.Id);
        HDMDealerExperienceController.updateExternalOrder(objOrder);
        HDMDealerExperienceController.updateExternalOrder(null);
        
        OrderItem__x objOrderItem1 = new OrderItem__x();
        objOrderItem1.Delta_Quantity_c__c = 2;
        objOrderItem1.Return_Quantity_c__c = 0;
        objOrderItem1.Total_Tax_c__c = 2.00;
        objOrderItem1.UnitPrice__c = 20.00;
        objOrderItem1.Updated_Quantity_c__c = 4;     
        objOrderItem1.Quantity__c = 6;     
        objOrderItem1.Product_Type_c__c = 'Part';   
             
        /** Saravanan LTIM Added for Reman Functionality ***/
        OrderItem__x objOrderItem2 = new OrderItem__x();
        objOrderItem2.Delta_Quantity_c__c = 2;
        objOrderItem2.Return_Quantity_c__c = 0;
        objOrderItem2.Total_Tax_c__c = 2.00;
        objOrderItem2.UnitPrice__c = 20.00;
        objOrderItem2.Updated_Quantity_c__c = 4;     
        objOrderItem2.Quantity__c = 6;
        objOrderItem2.Product_Type_c__c = 'Core Charge';
        
        
        List<OrderItem__x> lstOrderItem = new List<OrderItem__x>();
        lstOrderItem.add(objOrderItem1);
        lstOrderItem.add(objOrderItem2);
        
        Test.startTest();
        
        B2B_VertexTaxCalculationIntegration.ResponseDataWrapper mockTest = new B2B_VertexTaxCalculationIntegration.ResponseDataWrapper() ;
        Map<String, Decimal> mapOrderItemTax = new Map<String, Decimal>();
        
        mockTest.isSuccess = true;
        mockTest.totalTaxAmount = 500.0;
        mockTest.shipping_Charges_tax = 200;
        mockTest.installation_Charges_tax = 200;
        mapOrderItemTax.put(objOrderItem2.Id,2000);
        mockTest.mapOrderItemTax = mapOrderItemTax;
        HDMDealerExperienceController.responseData2 = mockTest;
        
        Test.setMock(HttpCalloutMock.class, new B2B_VertexTaxCalculationCalloutMock());
        HDMDealerExperienceController.mockedOrderItems.addall(lstOrderItem);
        HDMDealerExperienceController.updateExternalOrderItem(HDMDealerExperienceController.mockedOrderItems, 'Modify Order',2, 2,  2, 2, '');
        HDMDealerExperienceController.updateExternalOrderItem(HDMDealerExperienceController.mockedOrderItems, 'Partial Return',2, 2,  2, 2, '');
        HDMDealerExperienceController.addExternalDealerNotes(objOrder.Id, 'Addng dealer note');
        HDMDealerExperienceController.getAllExternalDealerNotes(objOrder.Id);
        HDMDealerExperienceController.mockedOrder.clear();
        Order__x objOrder1 = new Order__x();
        objOrder1.Status__c = 'IN PROGRESS';
        objOrder1.Updated_Order_Amount_c__c = 0.00;
        objOrder1.Updated_Order_Total_c__c = 22.00;
        objOrder1.Updated_Total_Tax_c__c = 2.00;
        objOrder1.Total_Installation_Tax_c__c = 20.00;
        objOrder1.BT_Transaction_Status_c__c = 'Authorized';        
        HDMDealerExperienceController.mockedOrder.add(objOrder1); 
        HDMDealerExperienceController.updateExternalOrderItem(HDMDealerExperienceController.mockedOrderItems, 'Modify Order',2, 2,  2, 2, '');
        HDMDealerExperienceController.updateOpsTeam(objAccount);
        HDMDealerExperienceController.updateDealerAccount(null);
        HDMDealerExperienceController.getAccountDetails();
        Test.stopTest();
       
       
    }
    
    @isTest
    public static void unittest3(){
        Order__x objOrder3 = new Order__x();
        objOrder3.Shipping_Refund_c__c = objOrder3.Updated_Shipping_c__c;
        objOrder3.Updated_Order_Amount_c__c = 1.00;
        objOrder3.Updated_Order_Total_c__c = 22.00;
        objOrder3.Updated_Shipping_c__c = 1.00;
        objOrder3.Updated_Total_Tax_c__c = -2.00;
        objOrder3.Total_Item_Return_c__c = 4.00;
        objOrder3.Total_Ship_Return_c__c = -6.0;
        objOrder3.Total_Tax_Return_c__c = 5.0;
        objOrder3.Total_Return_c__c = 4.0;
        objOrder3.Current_Shipping_Tax_c__c = 3.0;
        objOrder3.Total_Current_Product_Tax_c__c = 4.4;
        objOrder3.Current_Quantity_c__c = 3.0;
        
        
   
        HDMDealerExperienceController.mockedOrder.add(objOrder3);
         HDMDealerExperienceController.OrderWrapper owr = new HDMDealerExperienceController.OrderWrapper();
        owr.isDealerAdmin = false;
        owr.isaccessTokenError= true;
        Test.startTest();
        B2B_BrainTreeIntegrationMock objMock = new B2B_BrainTreeIntegrationMock();
        Test.setMock(HTTPCalloutMock.class, objMock); 
 
        HDMDealerExperienceController.updateCurrentTransactionStatus(HDMDealerExperienceController.mockedOrder,owr);
        Test.stopTest();
        
    }
    @isTest
    public static void unittest4(){
        Order__x objOrder4 = new Order__x();
        objOrder4.Shipping_Refund_c__c = objOrder4.Updated_Shipping_c__c;
        objOrder4.Updated_Order_Amount_c__c = 1.00;
        objOrder4.Updated_Order_Total_c__c = 22.00;
        objOrder4.Updated_Shipping_c__c = 1.00;
        objOrder4.Updated_Total_Tax_c__c = -2.00;
        objOrder4.Total_Item_Return_c__c = 4.00;
        objOrder4.Total_Ship_Return_c__c = -6.0;
        objOrder4.Total_Tax_Return_c__c = 5.0;
        objOrder4.Total_Return_c__c = 4.0;
        objOrder4.Current_Shipping_Tax_c__c = 3.0;
        objOrder4.Total_Current_Product_Tax_c__c = 4.4;
        objOrder4.Current_Quantity_c__c = 3.0;
           
        HDMDealerExperienceController.mockedOrder.add(objOrder4);
        HDMDealerExperienceController.OrderWrapper owr = new HDMDealerExperienceController.OrderWrapper();
        owr.isDealerAdmin = false;
        owr.isBraintreeFetchError= true;
        Test.startTest();
        B2B_BrainTreeIntegrationMock2 objMock = new B2B_BrainTreeIntegrationMock2();   
        Test.setMock(HTTPCalloutMock.class, objMock); 
        HDMDealerExperienceController.updateCurrentTransactionStatus(HDMDealerExperienceController.mockedOrder,owr);

        Test.stopTest();
    }
     
    public class B2B_BrainTreeIntegrationMock implements HTTPCalloutMock {
        
        public HTTPResponse respond(HTTPRequest request) {
            String requestbody = request.getBody();
            // Create a fake response
            HttpResponse response = new HttpResponse();
            response.setHeader('Content-Type', 'application/json');
            String body = '';
            if(requestbody.contains('client_id')) {
                body = '{"access_token":"asdfghjdsxcvbhtrd","instance_url":"https://americanhondamotors--qa.sandbox.my.salesforce.com","id":"https://test.salesforce.com/id/00D010000008puqEAA/00501000002yCRFAA2","token_type":"Bearer","issued_at":"1715265630437","signature":"rSCIJimBFscygfrQ6xZl0jLQq+WNpfaBPhGBNb/5eG4="}';
            } 
            else if(requestbody.contains('dealerNumber')){
                body ='{"merchantId":"2ny4v6c7xpp2fkfm","isSuccess":true,"errorMessage":null,"dealerNumber":"207617","accessToken":"access_token$sandbox$2ny4v6c7xpp2fkfm$9d6d0752c3abbf34db60721ff6c032c2","refreshToken":null}';
            }else if(requestbody.contains('transactionID')){
                body='{"status":200,"transaction":{"id":"hsz1c4pe","status":"settled","type":"sale","amount":"264.44","refundId":null},"facilitatedDetails":{"merchantId":"57grdtmzbrgbzw9b","merchantName":"Pony Powersports"},"facilitatorDetails":{"oauthApplicationClientId":"client_id$sandbox$5chrg778bfg627fg","oauthApplicationName":"Braintree Payment Service - Dev","sourcePaymentMethodToken":"7kx12m20"}}';
            }
            
            response.setBody(body); 
            response.setStatusCode(200);
            return response;
        }
    }
    
    public class B2B_BrainTreeIntegrationMock2 implements HTTPCalloutMock {
        
        public HTTPResponse respond(HTTPRequest request) {
            String requestbody = request.getBody();
            // Create a fake response
            HttpResponse response = new HttpResponse();
            response.setHeader('Content-Type', 'application/json');
            String body = '';
            if(requestbody.contains('client_id')) {
                body = '{"access_token":"asdfghjdsxcvbhtrd","instance_url":"https://americanhondamotors--qa.sandbox.my.salesforce.com","id":"https://test.salesforce.com/id/00D010000008puqEAA/00501000002yCRFAA2","token_type":"Bearer","issued_at":"1715265630437","signature":"rSCIJimBFscygfrQ6xZl0jLQq+WNpfaBPhGBNb/5eG4="}';
            } 
            else if(requestbody.contains('dealerNumber')){
                body ='{"merchantId":"2ny4v6c7xpp2fkfm","isSuccess":true,"errorMessage":null,"dealerNumber":"207617","accessToken":"access_token$sandbox$2ny4v6c7xpp2fkfm$9d6d0752c3abbf34db60721ff6c032c2","refreshToken":"ouytrszxnmkiuytredfghjkmnbvcsdrtyujnbvd"}';
            }else if(requestbody.contains('transactionID')){
                body='{"status":200,"transaction":{"id":"hsz1c4pe","status":"Voided","type":"sale","amount":"264.44","refundId":null},"facilitatedDetails":{"merchantId":"57grdtmzbrgbzw9b","merchantName":"Pony Powersports"},"facilitatorDetails":{"oauthApplicationClientId":"client_id$sandbox$5chrg778bfg627fg","oauthApplicationName":"Braintree Payment Service - Dev","sourcePaymentMethodToken":"7kx12m20"}}';
            }else if(request.getEndpoint().contains('refreshed-tokens')){
                body = '{ "status": 200, "merchantId": "73tb4bcvq9jxp9f7", "credentials": { "accessToken": "access_token$sandbox$73tb4bcvq9jxp9f7$2dcc4376084d113dfb52900dcb6bfde1", "refreshToken": "refresh_token$sandbox$73tb4bcvq9jxp9f7$f9e48476309f49065cb38b8ea3cb23cc", "tokenType": "bearer", "expiresAt": "2021-06-21T20:39:37Z", "scope": "shared_vault_transactions" }}';
            }else if(request.getEndpoint().contains('updateBTToken')){
                body ='{"merchantId":"2ny4v6c7xpp2fkfm","isSuccess":true,"errorMessage":null,"dealerNumber":"207617","accessToken":"access_token$sandbox$2ny4v6c7xpp2fkfm$9d6d0752c3abbf34db60721ff6c032c2","refreshToken":"refresh_token$sandbox$73tb4bcvq9jxp9f7$f9e48476309f49065cb38b8ea3cb23cc"}';
				response.setBody(body); 
                response.setStatusCode(400);
                return response;
            }
            
            response.setBody(body); 
            response.setStatusCode(200);
            return response;
        }
    }
 
    
}