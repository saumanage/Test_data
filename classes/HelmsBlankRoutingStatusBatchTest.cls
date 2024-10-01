@isTest
public class HelmsBlankRoutingStatusBatchTest {
	@isTest static void exc(){
     Datetime dt = System.now();
     // adding minutes in negative, effectively subtracts 30 mins
     dt = dt.addMinutes(-60);
     Id dealerAccRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
     account acc=new account();
     acc.Name = 'Syam Mohan Ac';
     acc.RecordTypeId = dealerAccRecTypeId;
     acc.DealerCode_CD__c='1234562';
     insert acc;
     
     Routing_Acknowledgement_No_Response__c r1 = new Routing_Acknowledgement_No_Response__c();
     r1.Opportunity_SF_ID__c = '123456';
     r1.CreatedDate = dt;
     insert r1;
      
     opportunity opp= new opportunity(Stagename='Assigned to Dealer',PreferredDealerAccount_TXT__c=acc.id,Name='Syam Mohan',First_Name_TXT__c='Mohan', 
     LeadProvider_ID__c=acc.id,Last_Name_TXT__c = 'Mohan',Email__c='syam.gm@gmail.com', ZipCode_TXT__c='12345',Opportunity_SF_ID__c='123456');
     opp.CloseDate= system.Today();
     opp.CreatedDate = dt;
     insert opp;
     
     Test.startTest();
     HelmsBlankRoutingStatusBatch ba= new HelmsBlankRoutingStatusBatch();
     //Id jobid= Database.executeBatch(ba,1);
	 String sch = '0 0 23 * * ?';
	 system.schedule('Testing', sch, ba );
     system.assertEquals(opp.Last_Name_TXT__c,'Mohan' );
     Test.stopTest();
    }
}