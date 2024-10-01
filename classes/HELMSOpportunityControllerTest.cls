@isTest
public class HELMSOpportunityControllerTest {
 @testSetup
     public static void testData(){
               UserRole r = new UserRole(DeveloperName = 'HELMS_Standard', Name = 'HELMS_Standard');
        insert r;
        System.debug('r'+r);
        Profile profile_1 = [SELECT Id FROM Profile WHERE Name = 'HELMS Partner Community' LIMIT 1];
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
        System.debug('admin'+admin);
        User user_1;
        System.runAs(admin) {
         //   Set<Id> accountIds4=new Set<Id>();
            List<Account> alist = new List<Account>();
            Account ac3 = new Account(name ='Grazitti', DealerCode_CD__c='30Z514', recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Dealer').getRecordTypeId()) ;
            
            insert ac3;
            ac3.name ='Grazitti';
           
            alist.add(ac3); 
          //  accountIds4.add(ac3.Id);
            update alist;
         //   update accountIds4;
            Id conRecordTypeId = Schema.SObjectType.contact.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
            Contact conTestRec = new Contact(FirstName='YashLead1234',LastName='Record1234',Email='yash1234@testing.com',Title='Mr',
                                             AccountId=alist[0].Id,RecordTypeId=conRecordTypeId,HelmsCRMEligible_FLAG__c=true);
            insert conTestRec;
            
            List<User> uList1=new List<User>();
            
            user_1 = new User( 
                Email = 'yash1234@testing.com',
                ProfileId = profile_1.Id, 
                UserName = 'Test321name@gmail.com', 
                Alias = 'Test',
                TimeZoneSidKey = 'America/New_York',
                EmailEncodingKey = 'ISO-8859-1',
                LocaleSidKey = 'en_US', 
                LanguageLocaleKey = 'en_US',
                ContactId = conTestRec.Id,
                PortalRole = 'Manager',
                FirstName = 'YashLead1234',
                LastName = 'Record1234',
                IsActive=true 
            );
           insert user_1;
          // user_1.IsActive=false;
          //  update user_1;
            
          uList1.add(user_1);   
            update uList1;
        }
        Test.startTest();
        System.runAs(user_1) {
            System.assertEquals(UserInfo.getUserId(), user_1.Id);
           // HELMSAccountHandler.handleAccountUpdate(accountIds4);
            // your test code for Salesforce Community
        }
        Test.stopTest();
    }
	@IsTest
    public static void oppcontrollerTest(){
        User admin = [SELECT id from User WHERE username = 'Test31name@gmail.com' LIMIT 1];
        User user_1 = [SELECT id from User WHERE username = 'Test321name@gmail.com' LIMIT 1];
        test.startTest();
        System.runAs(admin) {
            HELMSOpportunityController.getActions();
        }
        System.runAs(user_1){
            HELMSOpportunityController.getActionsImage();
        }
        test.stopTest();
    }
    
     }