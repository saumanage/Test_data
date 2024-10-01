global class HELMSOppECRMDataLoaderBatch implements Database.Batchable<sObject>,Database.AllowsCallouts {
    
    global final string query;
    public HELMSOppECRMDataLoaderBatch(String query){
        this.query = query;
    }
    
    global Database.QueryLocator start(Database.BatchableContext bc){
        /*return Database.getQueryLocator([Select id, Name, Account.Contact_Key__c, StageName, OpportunityStatus_TXT__c, ContactKey_TXT__c 
                                         From Opportunity where Account.Contact_Key__c LIKE 'E%' and StageName !=
                                         'Closed Inactive' and StageName != 'Closed Lost' and StageName != 'Closed Won'
                                         ORDER BY CreatedDate desc]);*/
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext bc, List<Opportunity> opps){
        try{
            if(!opps.isEmpty()){
                Set<id> opIds = new Set<id>();
                for(Opportunity o : opps){
                   //opIds.add(o.Id);
                   //System.debug(o.id);
                }
                Map<id, Opportunity> idToOp = new Map<Id, Opportunity>();
                idToOp.putAll(opps);
                HELMSOpportunityECRMDataLoader.loadOpportunityECRMData(idToOp.keySet());
            }
            
        }catch(Exception e){
            Logs__c  l =new Logs__c (name='ECRM Opportunity Data Load',Trigger_or_Class_Name__c='HELMSOppECRMDataLoaderBatch', Error_Message__c =e.getMessage(), Error_Line_Number__c =Integer.valueOf(string.valueof(e.getLineNumber() )) );
           insert l;
        } 
    }
    
    global void finish(Database.BatchableContext bc){
        
    }    
}