global class HelmsDispFailureLogDeletionBatch implements Database.Batchable<sObject>, Schedulable
{
        global HelmsDispFailureLogDeletionBatch()
        {
            //constuctor
        }
        //Start Method
        global Database.QueryLocator start(Database.BatchableContext bc)
        {
            Date pastdate = System.today().adddays(-30);
            //query to return all expired Case Share records
            return Database.getQueryLocator([Select Id From Routing_Disposition_Failure__c where createddate<:pastdate]);
        }
		//Eecute Method
        global void execute(SchedulableContext sc)
        {
            //execute the batch
            HelmsDispFailureLogDeletionBatch deleteCS = new HelmsDispFailureLogDeletionBatch();
            ID batchprocessid = Database.executeBatch(deleteCS);
        }
		//Execute for delete
        global void execute(Database.BatchableContext bc, list<sObject> scope)
        {       
            delete scope;
            Database.emptyRecycleBin(scope);
        }

        global void finish(Database.BatchableContext bc)
        {
        
        }
}