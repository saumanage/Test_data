/*----------------------------------------------------------------------------------------------------------------------------------------------------
Class Name : StagingDeletionBatch 
Test Class Name : StagingDeletionBatchTest
Last Modified Version Owner : Saikiran Siddipeta
Comments : Code to delete the staging object records whose created date is greater than 30 days (AMSLM-684)
-------------------------------------------------------------------------------------------------------------------------------------------------------
*/
global class StagingDeletionBatch implements Schedulable,Database.Batchable<sObject>,Database.Stateful{
    

    public Database.QueryLocator start(Database.BatchableContext context)
    {
           //actualquery :
         //select Id,CreatedDate FROM Dealer_Deprovision__c  WHERE createddate  < LAST_N_DAYS:30 
        //   String query = 'select Id,CreatedDate FROM Dealer_Deprovision__c  WHERE createddate  <= LAST_N_DAYS:30 ';    
           String query = 'select Id,CreatedDate FROM Dealer_Deprovision__c  WHERE createddate  < LAST_N_DAYS:30 ';  
           //system.debug(' Inside start method $$ '+query);
                   return Database.getQueryLocator(query);
        
    }

    public void execute(Database.BatchableContext context, List<SObject> records)
    {
        delete records;
    }

        global void execute(SchedulableContext ctx) 
    {
        Database.executeBatch(new StagingDeletionBatch());
    }
     global void finish(Database.BatchableContext BC) 
    {
   
    }

}