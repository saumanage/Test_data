/**** 
Trigger Name: DSPLeadUpdate 
Handler Name:DSPLeadUpdateHandler
Test Class Name : Test_DSPLeadUpdateHandler
User story Number :DS-1185/1187
SFDC will subscribe to a platform event queue to get update Lead data. 
****/

trigger DSPLeadUpdate on DSP_Lead_Update__e (after insert) {
    
    BypassAutomations__c pb = BypassAutomations__c.getInstance(UserInfo.getUserId());
    //System.debug('pb.BypassTrigger__c : '+pb.BypassTrigger__c);
    if(pb.BypassTrigger__c == false){
        
    Set<string> sourceUniqueIds = new Set<string>();
    for(DSP_Lead_Update__e dspLead:Trigger.new){
        sourceUniqueIds.add(dspLead.Source_Unique_ID__c);
        if(dspLead.Source_Unique_ID__c == null){
        	DSPCustomException ex = new DSPCustomException('This Lead does not exist in HELMS. Please first create Lead in HELMS');
        throw ex;       
        }
    } 
    if(sourceUniqueIds.size() > 0){
        List<Lead> leads = [Select Id,Status,IsConverted,Source_Unique_ID__c,StatusReason_TXT__c,ConvertedOpportunityId From Lead Where Source_Unique_ID__c IN : sourceUniqueIds];
        if(leads.size() > 0){
            for(Lead updateLead: leads){
               if(updateLead != null && updateLead.Source_Unique_ID__c != null && updateLead.Isconverted == false && (updateLead.Status == HELMSConstants.CNC && updateLead.Status == HELMSConstants.closedcon) && (updateLead.StatusReason_TXT__c == HELMSConstants.noresponse && updateLead.StatusReason_TXT__c == HELMSConstants.windowexpired)){
                    DSPCustomException ex = new DSPCustomException('This Lead is not eligible for sending to Dealers and cannot be updated');
                    throw ex;
                } 
                else if(updateLead != null && updateLead.Source_Unique_ID__c != null && updateLead.Isconverted == false && (updateLead.Status != HELMSConstants.CNC && updateLead.Status != HELMSConstants.closedcon) && (updateLead.StatusReason_TXT__c != HELMSConstants.noresponse && updateLead.StatusReason_TXT__c != HELMSConstants.windowexpired )){
                    if(Trigger.isInsert && Trigger.isAfter){ 
                        DSPLeadUpdateHandler.updateLeads(Trigger.new); 
                    }
                }
                else if(updateLead != null && updateLead.Source_Unique_ID__c != null && updateLead.Isconverted == true && updateLead.ConvertedOpportunityId != null){
                    if(Trigger.isInsert && Trigger.isAfter){
                        DSPLeadUpdateHandler.updateOpportunity(Trigger.new);
                    }
                }
            }
        }
    }
}
}