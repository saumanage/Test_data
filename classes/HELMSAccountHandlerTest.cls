/****************************************************************************** 
File Name:      HELMSAccountHandler  
Created On:      2nd June, 2021
Created By:     Bandi Sujatha, Appirio
Test Classes:   HELMSAccountHandlerTest        
HELMS Jira Story: 
===============================================================================
Modification Log:
*******************************************************************************/
@IsTest
public class HELMSAccountHandlerTest {
    //Creating Partner User wtih Admin
   @IsTest static void testCreateAndUpdateUser() { 
       UserRole r = new UserRole(DeveloperName = 'HELMS_Standard', Name = 'HELMS_Standard');
        insert r;

        Profile partnerProfile = [SELECT Id FROM Profile WHERE Name = 'Partner Community User' LIMIT 1];
        Profile adminUser = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
            User admin = new User( 
            Email = 'Test123username@gmail.com',
            ProfileId = adminUser.Id, 
            UserRoleId = r.Id,
            UserName = 'Test31name@gmail.com', 
            Alias = 'Test',
            TimeZoneSidKey = 'America/New_York',
            EmailEncodingKey = 'ISO-8859-1',
            LocaleSidKey = 'en_US', 
            LanguageLocaleKey = 'en_US',
            PortalRole = 'Manager',
            FirstName = 'Firstname',
            LastName = 'Lastname'
        );
        insert admin;

        User partnerUser;
        System.runAs(admin) {

            List<Account> alist = new List<Account>();
            Account ac3 = new Account(name ='Grazitti', DealerCode_CD__c='30Z514', recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Dealer').getRecordTypeId()) ;
            
            insert ac3;
            ac3.name ='Grazitti';
           
            alist.add(ac3); 
            update alist;
      
            Id conRecordTypeId = Schema.SObjectType.contact.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
            Contact conTestRec = new Contact(FirstName='YashLead1234',LastName='Record1234',Email='yash1234@testing.com',Title='Mr',
                                             AccountId=alist[0].Id,RecordTypeId=conRecordTypeId,HelmsCRMEligible_FLAG__c=false);
            insert conTestRec;
            
            List<User> uList1=new List<User>();
            
            partnerUser = new User( 
                Email = 'Test1233username@gmail.com',
                ProfileId = partnerProfile.Id, 
                UserName = 'Test321name@gmail.com', 
                Alias = 'Test',
                TimeZoneSidKey = 'America/New_York',
                EmailEncodingKey = 'ISO-8859-1',
                LocaleSidKey = 'en_US', 
                LanguageLocaleKey = 'en_US',
                ContactId = conTestRec.Id,
                PortalRole = 'Manager',
                FirstName = 'Firstname',
                LastName = 'Lastname',
                IsActive=true 
            );
           insert partnerUser;
            
          uList1.add(partnerUser);   
            update uList1;
        }
        Test.startTest();
        System.runAs(partnerUser) {
            System.assertEquals(UserInfo.getUserId(), partnerUser.Id);
        }
        Test.stopTest();
    }
    @IsTest static void testCreateAndUpdateMethod1() { 
       UserRole r = new UserRole(DeveloperName = 'HELMS_Standard', Name = 'HELMS_Standard');
        insert r;
        //System.debug('r'+r);
        Profile profile_1 = [SELECT Id FROM Profile WHERE Name = 'Partner Community User' LIMIT 1];
        Profile profile_2 = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
            User admin = new User( 
            Email = 'Test123username@gmail.com',
            ProfileId = profile_2.Id, 
            UserRoleId = r.Id,
            UserName = 'Test31name@gmail.com', 
            Alias = 'Test',
            TimeZoneSidKey = 'America/New_York',
            EmailEncodingKey = 'ISO-8859-1',
            LocaleSidKey = 'en_US', 
            LanguageLocaleKey = 'en_US',
            PortalRole = 'Manager',
            FirstName = 'Firstname',
            LastName = 'Lastname'
        );
        insert admin;

        User adminUser;
        List<Account> alist = new List<Account>();
        System.runAs(admin) {  
            List<Id> accountIds4=new List<Id>();
            
            Account ac3 = new Account(name ='Grazitti', DealerCode_CD__c='30Z514', recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Dealer').getRecordTypeId()) ;
            
            insert ac3;
            
            ac3.name ='Grazitti';
            accountIds4.add(ac3.Id);
            
            alist.add(ac3); 
            update alist;
            Id conRecordTypeId = Schema.SObjectType.contact.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
            Contact conTestRec = new Contact(FirstName='YashLead1234',LastName='Record1234',Email='yash1234@testing.com',Title='Mr',
                                             AccountId=alist[0].Id,RecordTypeId=conRecordTypeId,HelmsCRMEligible_FLAG__c=false);
            insert conTestRec;
        
            adminUser = new User( 
                Email = 'Test1233username@gmail.com',
                ProfileId = profile_1.Id, 
                UserName = 'Test321name@gmail.com', 
                Alias = 'Test',
                TimeZoneSidKey = 'America/New_York',
                EmailEncodingKey = 'ISO-8859-1',
                LocaleSidKey = 'en_US', 
                LanguageLocaleKey = 'en_US',
                ContactId = conTestRec.Id,
                PortalRole = 'Manager',
                FirstName = 'Firstname',
                LastName = 'Lastname'
            );
            insert adminUser;
                Lead newLead = new Lead(lastName='Test last',Email='Testing@testing.com',Lead_Group_ID__c='12345',
                                   Model_TXT__c='abc',PreferredDealerAccount_ID__c=ac3.Id,OwnerId=adminUser.Id,ProviderDetail_TXT__c=ac3.Id,
                                    PreferredDealerNumber_NUM__c='30Z514');
            
        insert newLead;
        HELMSAccountHandler.handleAccountUpdate(accountIds4);   
        }
        Test.startTest();
        System.runAs(adminUser) {
            HELMSAccountHandler.dealerB2CMapping(alist);
            System.assertEquals(UserInfo.getUserId(), adminUser.Id);
            HELMSAccountHandler.processReportOnlyAccounts(null);
            HELMSAccountHandler.dealerB2CMapping(null);
        }
        Test.stopTest();
    }
}