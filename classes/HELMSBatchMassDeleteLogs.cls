global class HELMSBatchMassDeleteLogs implements Database.batchable<sobject>, Schedulable{
    
    // string query='select Name,Error_Line_Number__c,Error_Message__c,PE_Reply_Id__c,SF_Rec_Id__c,Trigger_or_Class_Name__c from Logs__c WHERE CreatedDate = LAST_N_DAYS:30';
    global final string query;
    
    global HELMSBatchMassDeleteLogs(){
               
    }
    global HELMSBatchMassDeleteLogs(string query){
        this.query=query;
        
    }

    global Database.QueryLocator start(Database.batchableContext bc){
        return Database.getQueryLocator(query);
     
    }
    global void execute(Database.batchableContext bc,List<Logs__c> scope){

        if(!scope.isEmpty()){
            delete scope;
        }
    }
    global void finish(Database.batchableContext bc){
      
    }    
    
    global void execute (SchedulableContext sc){
        string query='select id from Logs__c WHERE CreatedDate < LAST_N_DAYS:60 order by CreatedDate desc';
    
        HELMSBatchMassDeleteLogs  deleteOldLogsjob = new HELMSBatchMassDeleteLogs(query);
        Id batchId = Database.executeBatch(deleteOldLogsjob ,1000);
    }
    
}