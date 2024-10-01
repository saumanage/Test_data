@isTest (isParallel=false)
public class DeactivateFieldLinkUsersBatchTest 
{ 
    static testMethod void testMethod1() 
    {
           UserRole r = new UserRole(DeveloperName = 'HELMS_Standard', Name = 'HELMS_Standard');
        insert r;
       // System.debug('r'+r);

             Profile profile_1 = [SELECT Id FROM Profile WHERE Name = 'HELMS Field User' LIMIT 1];  
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
            LastName = 'Lastname',
            IsActive = true     
        );
        insert admin;
     //   System.debug('admin'+admin);
        
        User user_1;
           User user_2;
        List<User> ddccList=new List<User>(); 
         System.runAs(admin) {  
             
        List<Account> alist = new List<Account>();
            Account ac3 = new Account(name ='Grazitti', DealerCode_CD__c='30Z514', recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Dealer').getRecordTypeId()) ;
            
            insert ac3;
            ac3.name ='Grazitti';
           
            alist.add(ac3); 
            update alist;
             
        /*    Id conRecordTypeId = Schema.SObjectType.contact.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
            Contact conTestRec = new Contact(FirstName='YashLead1234',LastName='Record1234',Email='yash1234@testing.com',Title='Mr',
                                             AccountId=alist[0].Id,RecordTypeId=conRecordTypeId,HelmsCRMEligible_FLAG__c=false);
            insert conTestRec;*/
            
                     
        
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
            //    ContactId = conTestRec.Id,
                PortalRole = 'Manager',
                FirstName = 'Firstname',
                LastName = 'Lastname'
            );
            insert user_1;
             
                    user_2 = new User( 
                Email = 'Test1233usernamee@gmail.com',
              //  ProfileId = '00e7c000000I2AVAA0', 
                   ProfileId =  profile_1.Id, 
             //   UserRoleId = r.Id,
                UserName = 'Test321namee@gmail.com', 
                Alias = 'Test',
                TimeZoneSidKey = 'America/New_York',
                EmailEncodingKey = 'ISO-8859-1',
                IsActive = true,
                LocaleSidKey = 'en_US', 
                LanguageLocaleKey = 'en_US',
            //    ContactId = conTestRec.Id,
                PortalRole = 'Manager',
                FirstName = 'Firstnamee',
                LastName = 'Lastnamee'
            );
            insert user_2;
             
              ddccList.add(user_1);
              ddccList.add(user_2);
             
                     //        system.Debug( 'newuser :: '+ddccList);  
                        	if(ddccList.size()>0){			
                             update ddccList;
            //      system.debug(' ddccList : '+ddccList);
		} 
             
         }
      
            Test.startTest();
        System.runAs(user_1) {
            System.assertEquals(UserInfo.getUserId(), user_1.Id);
            // your test code for Salesforce Community
        }
           System.runAs(user_2) {
            System.assertEquals(UserInfo.getUserId(), user_2.Id);
            // your test code for Salesforce Community
        }
      
   
        Test.stopTest(); 
        
			
          List<User> lstUsers1 = new List<User>();
     
     
            DeactivateFieldLinkUsersBatch obj = new DeactivateFieldLinkUsersBatch();
             

	}
       static testMethod void testMethod2() 
    {
           UserRole r = new UserRole(DeveloperName = 'HELMS_Standard', Name = 'HELMS_Standard');
        insert r;
        System.debug('r'+r);

             Profile profile_1 = [SELECT Id FROM Profile WHERE Name = 'HELMS Field User' LIMIT 1];  
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
            LastName = 'Lastname',
            IsActive = true     
        );
        insert admin;
        System.debug('admin'+admin);
        
        User user_1;
           User user_2;
        
         System.runAs(admin) {  
             
        List<Account> alist = new List<Account>();
            Account ac3 = new Account(name ='Grazitti', DealerCode_CD__c='30Z514', recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Dealer').getRecordTypeId()) ;
            
            insert ac3;
            ac3.name ='Grazitti';
           
            alist.add(ac3); 
            update alist;
             
        /*    Id conRecordTypeId = Schema.SObjectType.contact.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
            Contact conTestRec = new Contact(FirstName='YashLead1234',LastName='Record1234',Email='yash1234@testing.com',Title='Mr',
                                             AccountId=alist[0].Id,RecordTypeId=conRecordTypeId,HelmsCRMEligible_FLAG__c=false);
            insert conTestRec;*/
            
                List<User> ddccList=new List<User>();      
        
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
            //    ContactId = conTestRec.Id,
                PortalRole = 'Manager',
                FirstName = 'Firstname',
                LastName = 'Lastname'
            );
            insert user_1;
             
                    user_2 = new User( 
                Email = 'Test1233usernamee@gmail.com',
              //  ProfileId = '00e7c000000I2AVAA0', 
                   ProfileId =  profile_1.Id, 
             //   UserRoleId = r.Id,
                UserName = 'Test321namee@gmail.com', 
                Alias = 'Test',
                TimeZoneSidKey = 'America/New_York',
                EmailEncodingKey = 'ISO-8859-1',
                IsActive = false,
                LocaleSidKey = 'en_US', 
                LanguageLocaleKey = 'en_US',
            //    ContactId = conTestRec.Id,
                PortalRole = 'Manager',
                FirstName = 'Firstnamee',
                LastName = 'Lastnamee'
            );
            insert user_2;
             
              ddccList.add(user_1);
              ddccList.add(user_2);
             
                             system.Debug( 'newuser :: '+ddccList);  
                        	if(ddccList.size()>0){			
                             update ddccList;
                  system.debug(' ddccList : '+ddccList);
		} 
             
         }
      
 
			
          List<User> lstUsers1 = new List<User>();
      			
         Test.startTest();
            DeactivateFieldLinkUsersBatch obj = new DeactivateFieldLinkUsersBatch();
          //  DataBase.executeBatch(obj); 
        	 obj.execute(null,lstUsers1);
        	obj.execute(null);
             obj.Finish(null);
        
        Test.stopTest();
 

  
	}
 
    
    }