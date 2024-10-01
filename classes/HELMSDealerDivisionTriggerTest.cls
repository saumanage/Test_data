@isTest(SeeAllData=false)
public class HELMSDealerDivisionTriggerTest {
    
    @isTest static void divisionTestMethod1(){
       Test.startTest();
        String pid =[Select Id from Profile Where name ='HELMS Standard User'].Id ;
        UserRole r = new UserRole(DeveloperName = 'HELMS_Standard', Name = 'HELMS_Standard');
        insert r;
        User user = new User(alias = 'test123', email='Test@gmail.com',
                             emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                             localesidkey='en_US', profileid = pid, country='United States',IsActive =true,UserRoleid=r.id,
                             timezonesidkey='America/Los_Angeles', username='testuserdiv1@test.com');
        
        insert user;
        
         System.runAs(user) {
            Account_Owner_by_Division_and_Zone__c aow = new Account_Owner_by_Division_and_Zone__c();
            aow.Name = 'M01';
            aow.DivisionZone_CD__c = 'M01';
            aow.username__c = 'testuserdiv1@test.com';
            insert aow;
            
            Account acc = new Account();
            acc.Name = 'Test Kolbe Cycle Sales';
            acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId(); 
            insert acc;
            
            Dealer_Division__c dd = new Dealer_Division__c();
            dd.isActive_FLG__c = True;
            dd.Dealer_ID__c = acc.Id;
            dd.Division_CD__c = 'M';
            dd.SalesZone_CD__c = '01';
          //   dd.ownerid=user.id;
            insert dd;
            }
        system.assertEquals(user.alias, 'test123');
        Test.stopTest();
    }

}