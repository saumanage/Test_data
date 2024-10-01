@isTest 
public class HelmsDispFailureLogDeletionBatchTest 
{
    @isTest static void testMethod1() 
    {
        List<Routing_Disposition_Failure__c> lstDisp= new List<Routing_Disposition_Failure__c>();
        for(Integer i=0 ;i <200;i++)
        {
            Routing_Disposition_Failure__c dis = new Routing_Disposition_Failure__c();
            dis.Payload__c ='p'+i;
            lstDisp.add(dis);
        }
        
        insert lstDisp;
        for(Routing_Disposition_Failure__c d: lstDisp){
            date createddate=system.today().addDays(-60);
            Test.setCreatedDate(d.id, createddate);
        }
        
        Test.startTest();

            HelmsDispFailureLogDeletionBatch sh1 = new HelmsDispFailureLogDeletionBatch();
			String sch = '0 0 23 * * ?'; 
            system.schedule('Test Territory Check', sch, sh1); 
            
        Test.stopTest();
    }
}