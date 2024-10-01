global class HELMS_OpportunityCreationLeadBatch implements Database.Batchable<sObject>,Database.Stateful,Schedulable{
    
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        //String statusVal = 'Ready_to_Convert';
        //String nullValue = '';
       String fieldsAPIName='';
        String triggertypecode = 'Instant';
        date d = system.today();
        //String whereConition ='isConverted=false and ValidEmail_FLG__c=true and ValidPhoneNum_FLG__c=true  and ValidName_TXT__c=null and PostalCode !=null and PreferredDealerAccount_ID__c!=null and CustomerAccount_ID__c!=null and ( (Triggertypecode__c =:Triggertypecode ) OR (LeadProvider_ID__c = null and TriggerSendbyDate_DT__c <=:d ) OR (LeadProvider_ID__c != null and LeadProvider_ID__r.RoutingDate_DT__c <=: d ))';
        String statusClosed =  'Closed - Not Converted';
        String statusVal = 'Pending';
        String statusVal2 = 'Duplicate Similar';
        String statusonhold = 'Waiting for the routing window to start';
        String journeyCompleted = 'Journey Completed';
        String tpd = 'Third Party Duplicate';
        String newOppcreated = 'New Opportunity Created';
        String conciergeCompleted = 'Concierge Completed';
        String LECE = 'Lead Enrichment call error';
        String WFDR = 'Waiting for Deal Information';
        
        
        String whereConition ='CustomerAccount_ID__c!=null and isConverted=false and LeadGrade_FLG__c=true and (StatusReason_TXT__c=null or StatusReason_TXT__c =:statusVal or StatusReason_TXT__c =:statusVal2 or StatusReason_TXT__c =: statusonhold or StatusReason_TXT__c =:JourneyCompleted or StatusReason_TXT__c =:tpd or StatusReason_TXT__c =:newOppcreated or StatusReason_TXT__c =:ConciergeCompleted or StatusReason_TXT__c =:LECE or StatusReason_TXT__c =:WFDR) and Division_CD__c!=null and Status!=:statusClosed';
        
        //system.debug('batch start');
        for(HELMS_LeadConversionFieldsToOpportunity__mdt metaDataRec : [select Label,LeadFieldAPIName__c from HELMS_LeadConversionFieldsToOpportunity__mdt])
        {
            fieldsAPIName=fieldsAPIName+metaDataRec.LeadFieldAPIName__c+',';
        }
        fieldsAPIName=fieldsAPIName.substring(0,fieldsAPIName.length()-1);
        /* String dataQuery = 'select '+fieldsAPIName+' from lead where LeadGrade_FLG__c=true and '+
            'Status=:statusVal and PreferredDealerAccount_ID__c!=:nullValue and '+
            'CustomerAccount_ID__c!=:nullValue';
        */
        String dataQuery = 'select '+fieldsAPIName+' from lead where '+whereConition;
        
        return Database.getQueryLocator(dataQuery);
    }
    
    global void execute(Database.BatchableContext bc, List<Lead> leadListRecord)
    {
        try
        {
          
           HELMSLeadConvertToOppHandler.handleLeadToOppInsert(leadListRecord);
            
        }catch(Exception ex){
            Logs__c logRecord = new Logs__c(Name='HELMS_OpportunityCreationLead Batch Error', Trigger_or_Class_Name__c='HELMS_OpportunityCreationLead', Error_Message__c = ex.getMessage(), Error_Line_Number__c = Integer.valueOf(ex.getLineNumber()));
            insert logRecord;
            
        }        
        
        
    }
    
    global void finish(Database.BatchableContext bc){
        
    }
    
    
    global void execute (SchedulableContext sc){
         HELMS_OpportunityCreationLeadBatch leadConversionBatchInstance = new HELMS_OpportunityCreationLeadBatch();
        Id batchId = Database.executeBatch(leadConversionBatchInstance,1);
    }
}