@isTest 
public class DealerDeprovisionBatchTest 
{
    public static testmethod void testMethod1() 
    {
           UserRole r = new UserRole(DeveloperName = 'HELMS_Standard', Name = 'HELMS_Standard');
        insert r;
     //   System.debug('r'+r);

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
     //   System.debug('admin'+admin);
        
        User user_1;
        
         System.runAs(admin) {  
             
        List<Account> alist = new List<Account>();
            Id dealerAccRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId(); 
            Account ac3 = new Account(Name='South West Motors',DealerCode_CD__c='30Z514', RecordTypeId=dealerAccRecTypeId,Contact_Key__c='E150363308');
            
            insert ac3;
            ac3.name ='Grazitti';
           
            alist.add(ac3); 
            update alist;
             
            Id conRecordTypeId = Schema.SObjectType.contact.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
            Contact conTestRec = new Contact(FirstName='YashLead1234',LastName='Record1234',Email='yash1234@testing.com',Title='Mr',
                                             AccountId=alist[0].Id,RecordTypeId=conRecordTypeId,HelmsCRMEligible_FLAG__c=false);
            insert conTestRec;
            
                      
        
            user_1 = new User( 
                Email = 'Test1233username@gmail.com',
              //  ProfileId = '00e7c000000I2AVAA0', 
                   ProfileId =  profile_1.Id, 
             //   UserRoleId = r.Id,
                UserName = 'Test321name@gmail.com', 
                Alias = 'Test',
                TimeZoneSidKey = 'America/New_York',
                EmailEncodingKey = 'ISO-8859-1',
                IsActive = true,
                LocaleSidKey = 'en_US', 
                LanguageLocaleKey = 'en_US',
                ContactId = conTestRec.Id,
                PortalRole = 'Manager',
                FirstName = 'Firstname',
                LastName = 'Lastname'
            );
            insert user_1;
         }
        List<Dealer_Deprovision__c> lstdep = new List<Dealer_Deprovision__c>();
        System.runAs(admin) {
        Dealer_Deprovision__c dp1=new Dealer_Deprovision__c(FirstName__c='Carl101',LastName__c='TEST101',
        								                   Dealer_Number__c='30Z514');
        dp1.CreatedDate= system.now();  
        lstdep.add(dp1);
        insert lstdep;
        }   
		Test.startTest();
		DealerDeprovisionBatch cs = new DealerDeprovisionBatch();
        DataBase.executeBatch(cs,100); 
        String schTime = '0 0 12 * * ?';
        DealerDeprovisionBatch schJob = new DealerDeprovisionBatch();
        system.schedule('TestUpdateDeprovisionJob', schTime, schJob);
        Test.stopTest();
    }   
}