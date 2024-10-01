//Batch Class for Lead Converstion
global class LeadCloseConversionBatch implements Database.Batchable<sObject>,Database.Stateful {
    //Query
    string query ;
    global LeadCloseConversionBatch(){
        
    }
    //Fetching Data
    global LeadCloseConversionBatch(string q){
        
        query = q;
    }
    //Start Method
    global Database.QueryLocator start(Database.BatchableContext bc)
    {   string ledstatus ='Closed - Not Converted';
        //query = 'Select Id,Name,LastModifiedDate,IsConverted,StatusReason_TXT__c,Status,Division_CD__c from Lead where IsConverted=false and Status!=:ledstatus';
        //System.debug('query-----'+query);
        return Database.getQueryLocator(query);
    }
    //Execute Method
    global void execute(Database.BatchableContext bc, List<Lead> leadListRecord)
    {
        //Lead_Expiration__c leadCustomVal = Lead_Expiration__c.getInstance();
        Lead_Expiration__c leadCustomVal = Lead_Expiration__c.getOrgDefaults();
        List<Lead> updatedLeadList = new List<Lead>();
        List<Logs__c> logRecordList = new List<Logs__c>();
        try{
             
            for(Lead ldRec : leadListRecord)
            {
               String leadDivision;
                if(ldRec.Division_CD__c!=null){
                     leadDivision = ldRec.Division_CD__c+'__C';
                  }        
                /* Lead_Expiration__c leadCustomVal = Lead_Expiration__c.getOrgDefaults();
                system.debug(leadCustomVal.A__c); */


                if(leadDivision!=null){
                    
                    //system.debug('Integer.valueOf(leadCustomVal.get(leadDivision))--------'+Integer.valueOf(leadCustomVal.get(leadDivision)));
                    Integer getCustomDivisionVal = Integer.valueOf(leadCustomVal.get(leadDivision));
                    Date lastModifiedDateVal = Date.valueOf(ldRec.LastModifiedDate);
                    Date todayDateVal = Date.valueOf(System.today());
                    Integer daysInBetween = lastModifiedDateVal.daysBetween(todayDateVal);
                    //system.debug('@@ Values of if condition : '+daysInBetween+' '+getCustomDivisionVal);
                    if(daysInBetween>=getCustomDivisionVal)
                    {
                        //System.debug('ldRec---------'+ldRec);
                        Lead ldUpdate = new Lead(Id=ldRec.Id,StatusReason_TXT__c='Inactivity',Status=System.Label.HELMS_Close_Lead_Status_Val);
                        updatedLeadList.add(ldUpdate);
                    }
                }
            }
            if(updatedLeadList.size()>0)
            {
                //System.debug('updatedLeadList---------'+updatedLeadList);
                update updatedLeadList;
            }
        }catch(Exception ex)
        {
            Logs__c logExceptionRecord = new Logs__c(Name='LeadCloseConversionBatch Batch Error',Trigger_or_Class_Name__c='LeadCloseConversionBatch',Error_Message__c = ex.getMessage(),Error_Line_Number__c = Integer.valueOf(ex.getLineNumber()));
            insert logExceptionRecord;
        }
              
        
        
    }
    //Finish Method
    global void finish(Database.BatchableContext bc)
    {
        
    }
    
    
}