@isTest
public class HelmsOpportunityNotificationSmsTest {
    @isTest
    static void sMSTestMethod(){
        
        Id dealerAccRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
        Account accTestRec = new Account(Name='Chapman Honda',RecordTypeId=dealerAccRecTypeId,DealerCode_CD__c='123456',Contact_Key__c='E150363308'
                                        );
        insert accTestRec;
        
        Set<id> oppList= new Set<id>();
        set<id> leadList=new set<id>();
        
         Set<id> ddIds= new Set<id>();
        
         Lead leadRec = new Lead(LastName='1 NOT GIVEN',Email='sur12@testing.com',Street= '4RUNNER', Status='Manual Validation1'); 
        Lead leadRec1 = new Lead(LastName='1 main s',Email='sur123@testing.com',Street= '4RUNNER', Status='Manual Validation');
     
                 
         insert leadRec;
        insert leadRec1;
        
        leadList.add(leadRec.id);
        leadList.add(leadRec1.id);
        
        Opportunity o = new Opportunity();
        o.name='Test';
        o.First_Name_TXT__c='OppTest';
        o.Last_Name_TXT__c='OppKiran';
        o.Email__c='kiransiddipeta1199@gmail.com';
        o.StageName='Assigned to Dealer';
        o.OpportunityStatus_TXT__c='Assigned/Routed to Dealer';
        o.CloseDate= date.parse('10/10/2021');
        o.ZipCode_TXT__c='59505';
        o.PreferredDealerAccount_TXT__c=accTestRec.id;
        // o.LeadProvider_ID__c='TestR';
        
        insert o;
        
        
        Dealer_Division__c dealerSubDivision=new Dealer_Division__c();
        dealerSubDivision.First_Name_TXT__c='testsai';
      //  dealerSubDivision.Dealer_ID__c='Chapman Honda';
         dealerSubDivision.Dealer_ID__c=accTestRec.id;
        insert dealerSubDivision;
        
        ddIds.add(dealerSubDivision.Dealer_ID__c);
            
        Dealer_Notification_Preference__c dealerPreference=new Dealer_Notification_Preference__c();
        dealerPreference.New_Lead_SMS__c=True;
        dealerPreference.Phone__c='9876543211';
        dealerPreference.Name='Test';
        dealerPreference.Email__c='kiransiddipeta1199@gmail.com';
     dealerPreference.Dealer_Subdivision__c=dealerSubDivision.id;
        insert dealerPreference;
        
        
        oppList.add(o.id);        
        
      //  HelmsOpportunityNotificationSms.OpportunityCreation(oppList);      
        if (test.isRunningTest()){
        Test.setMock(HttpCalloutMock.class, new UploadFileMock());
        }
        Test.startTest();
         System.enqueueJob(new HelmsSFMCQueueable(leadList,oppList));
        Test.stopTest();
    }
    
}