global class HelmsBlankRoutingStatusBatch implements Database.Batchable<sObject>,Database.Stateful,Schedulable { 
	global final string query;
    
    global HelmsBlankRoutingStatusBatch(){
               
    }
    global HelmsBlankRoutingStatusBatch(string query){
        this.query=query;
    }
    //Start Method
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(query);
    }    
    //Execute Method
    global void execute(Database.BatchableContext BC, List<Routing_Acknowledgement_No_Response__c> newOppotunityBlankResponse) {
        try{
            //System.debug('newOppotunityBlankResponse : '+newOppotunityBlankResponse);
            HELMSLeadDealerAssignmentADFHandler dealerAssignObj = new HELMSLeadDealerAssignmentADFHandler();
            dealerAssignObj.updateOpportunityBlankResponse(newOppotunityBlankResponse);
            //dealerAssignObj.updateRoutingNoAckResponse(oppSFDICSet);
            
        }Catch(Exception ex){   
            //System.debug('Inside Catch');
            Logs__c  l =new Logs__c (name='Opportunity Routable Batch',Trigger_or_Class_Name__c='HelmsBlankRoutingStatusBatch', Error_Message__c =ex.getMessage(), Error_Line_Number__c =Integer.valueOf(string.valueof(ex.getLineNumber() )) );
           insert l;
        }
    }
    //Finish Method
    global void finish(Database.BatchableContext BC) {
		// Get the ID of the AsyncApexJob representing this batch job from Database.BatchableContext.
        // Query the AsyncApexJob object to retrieve the current job's information.
        //AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email FROM AsyncApexJob WHERE Id = :BC.getJobId()];
        
        //then use the active job id and abort it
        //system.abortJob(a.id);
    }
    //Execute Method - Running the Job
    global void execute (SchedulableContext sc){
        string query= 'SELECT Id, Opportunity_SF_ID__c, IsProcessed__c, Error_Details_Urban_Science__c, Response_Urban_Science__c, Routing_Error__c, Sent_to_Urban_Science_Status__c, Status_Code__c, CRM_Payload__c, CRM_XML_Response__c, CreatedDate, CreatedDate__c,Response_DSP__c from Routing_Acknowledgement_No_Response__c where IsProcessed__c = false '; 
        HelmsBlankRoutingStatusBatch blankRoutingBatch = new HelmsBlankRoutingStatusBatch(query);
        Id batchId = Database.executeBatch(blankRoutingBatch,1);
    }
}