global class ManualRoutingBatch implements Database.Batchable<sObject>,Database.Stateful {
	global List<Opportunity> oppListToBatchProcess= new List<Opportunity>();
    
    global ManualRoutingBatch(){
        
    }
    //INside Manual Routing Batch
    global ManualRoutingBatch(List<Opportunity> oppList){
        //System.debug('INside Manual Routing Batch'+oppList);
        oppListToBatchProcess = oppList;
    }
    //Start Method
    global List<Opportunity> start(Database.BatchableContext bc){  
        return oppListToBatchProcess;
    }
    //Inside Batch Execute
    global void execute(Database.BatchableContext bc, List<Opportunity> routableOpportunity){
        try{
           // System.debug('Inside Batch Execute : '+routableOpportunity);
            if(routableOpportunity.size() > 0){
               // System.debug('Inside Execute If'+routableOpportunity);
                HELMSLeadDealerAssignmentADFHandler dealerAssignObj = new HELMSLeadDealerAssignmentADFHandler();
                HELMSLeadDealerAssignmentADFHandler.isRoutingBatchProcess = true;
                dealerAssignObj.newLeadDispositionADFs(routableOpportunity);      
            } 
        }Catch(Exception ex){                       
            Logs__c  l =new Logs__c (name='Opportunity Routable Batch',Trigger_or_Class_Name__c='OpportunityRoutableBatch', Error_Message__c =ex.getMessage(), Error_Line_Number__c =Integer.valueOf(string.valueof(ex.getLineNumber() )) );
           insert l;
        }
    }
    //Finish Method
    global void finish(Database.BatchableContext bc){
        
    } 
}