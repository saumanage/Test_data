global with sharing class HELMS_LeadConversionScheduler implements Schedulable{
    
    global void execute (SchedulableContext sc)
    {
       String batchQuery = 'Select Id,Name,LastModifiedDate,IsConverted,StatusReason_TXT__c,Status,Division_CD__c   from Lead where IsConverted=false and Status!=:ledstatus';
        LeadCloseConversionBatch leadConversionBatchInstance = new LeadCloseConversionBatch(batchQuery);
        Id batchId = Database.executeBatch(leadConversionBatchInstance);
    }

}