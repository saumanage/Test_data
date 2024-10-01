@IsTest
public class HELMSAccountInfoDailyBatchTest {

    @isTest static void testAccountInfoDaily() { 
       
        List<Account> lstacc= new List<Account>();
        Id dealerAccRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
        Account accTestRec = new Account(Name='Test Account123',Active_Divisions__c='A06',DealerCRMVendor_TXT__c = 'Elead1',
                                         RecordTypeId=dealerAccRecTypeId, DealerCode_CD__c='728456');
        lstacc.add(accTestRec);
        insert lstacc;
        
        accTestRec.name='TestAms Helms1';
        update accTestRec;
        
         Dealer_Division__c dd = new Dealer_Division__c();
         dd.isActive_FLG__c = True;
         dd.Dealer_ID__c = accTestRec.Id;
         dd.Division_CD__c = 'M';
         dd.SalesZone_CD__c = '01';
            
         insert dd;
        
         Id vendorAccRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Vendor').getRecordTypeId();
        
       Account accVendor = new Account(Name='Hello1 vendor1', RecordTypeId=vendorAccRecTypeId,
                                  DealerCode_CD__c='1234Z',HondaDigitalSolutions_FLG__c=false,
                                 Routable_FLG__c=true);
        insert accvendor;
        
      CRM_System__c crmSystem = new CRM_System__c(Name='Test crm system1',Vendor_ID__c=accVendor.Id,ISActive_FLG__c=true,Division_CD__c ='M');
      insert crmSystem;
        
      Dealer_Participation__c dealerParticipationList = new Dealer_Participation__c(DealerAccount_ID__c =accTestRec.Id,Division__c='M',
                                                               CRM_System__c = crmSystem.Id, LeadReceivingStartDate_DT__c=System.NOW()-12,Dealer_Subdivision__c =dd.id);
       
      insert dealerParticipationList;
        
         Test.startTest();
	 	
        HELMSAccountInfoDailyBatch accInfoDailyBatch = new HELMSAccountInfoDailyBatch(); 
        Database.executeBatch(accInfoDailyBatch);
        System.assertEquals(accTestRec.name, 'TestAms Helms1');
        Test.stopTest();
        }

}