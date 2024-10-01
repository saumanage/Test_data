trigger HELMSUpdateRelatedOpportunity on Dealer_CRM_Disposition__e (after insert) {
    if(trigger.isAfter && trigger.isInsert){
       System.debug('Inside Trigger');
       //System.debug('HELMS_Opportunity_External_Key_TXT__c : '+trigger.new[0].HELMS_Opportunity_External_Key_TXT__c);
       HELMSOpportunityResponsePEHandler.UpdateOpportunities(Trigger.new); 
    }
}