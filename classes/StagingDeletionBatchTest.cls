@isTest 
public class StagingDeletionBatchTest
{
    static testMethod void testMethod1()
    {
  
        
        Dealer_Deprovision__c d1=new Dealer_Deprovision__c();
        d1.FirstName__c='kiran';
        d1.CreatedDate= System.today()-35 ;
        insert d1;
        
        Test.startTest();

        StagingDeletionBatch obj = new StagingDeletionBatch();
         obj.execute(null);
         obj.Finish(null);
            
        Test.stopTest();
    }
}