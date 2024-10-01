@isTest
public class B2B_GetOrderExtTest {
    
    @isTest
    public static void unitTest(){
        Order__x objOrder = new Order__x();
        objOrder.Status__c = 'IN PROGRESS';
        objOrder.Updated_Order_Amount_c__c = 20.00;
        objOrder.Updated_Order_Total_c__c = 22.00;
        objOrder.Updated_Total_Tax_c__c = 2.00;
        objOrder.BT_Transaction_Status_c__c = 'Authorized';     
        B2B_GetOrderExt.mockedOrder.add(objOrder); 
        Contact objContact;//Added by Divya
        
      	Set<String> customerUserTypes = new Set<String> {'CSPLiteUser', 'PowerPartner', 'PowerCustomerSuccess',   'CustomerSuccess'};
        String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@testorg.com';
        //Added by Divya Start
        User user = new User();  
        user = [Select Id,Profile.Name from User where id=: userinfo.getUserId()];
        String userProfile = user.Profile.Name;
        User userRoleId = [Select UserRoleId from User where Profile.Name =:userProfile AND UserRoleId != null limit 1];
        UserRole userrole = [Select Id From UserRole Where Id =:userRoleId.UserRoleId  Limit 1];
        user.UserRoleId = userrole.Id;
        update user;
        System.runAs(user){//Added by Divya END
        Account objAccount = new Account();
        objAccount.Name = 'test';
        objAccount.DealerCode_CD__c = '12343';        
        insert objAccount;
        
        objContact = new Contact();//Modified by Divya
        objContact.FirstName = 'test';
        objContact.LastName = 'test';
        objContact.AccountId = objAccount.Id;
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
        
        System.runAs(u) {
            B2B_GetOrderExt.OrderInfo(true, false);
            B2B_GetOrderExt.OrderInfo(false, true);
            B2B_GetOrderExt.OrderInfo(true, true);//Added by Divya
        }
    }
    
    @isTest
    static void testShowBTTokenMsg() {
        Set<String> customerUserTypes = new Set<String> {'CSPLiteUser', 'PowerPartner', 'PowerCustomerSuccess',   'CustomerSuccess'};
        String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@testorg.com';
        
        Account objAccount = new Account();
        objAccount.Name = 'test';
        objAccount.DealerCode_CD__c = '12345';        
        insert objAccount;

        Contact objContact = new Contact();
        objContact.FirstName = 'test';
        objContact.LastName = 'test';
        objContact.AccountId = objAccount.Id;
        objContact.HelmsCRMEligible_FLAG__c = true;
        objContact.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
        insert objContact;
        
        Profile p = [select Id,name from Profile where UserType in :customerUserTypes limit 1];
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com',
                        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                        LocaleSidKey='en_US', ProfileId = p.Id,
                        TimeZoneSidKey='America/Los_Angeles',
                        contactId=objContact.Id,
                        UserName=uniqueUserName); 

       
        System.runAs(u) {
            Boolean tokenExpired = B2B_GetOrderExt.showBTTokenMsg();
        }
      
    }
}