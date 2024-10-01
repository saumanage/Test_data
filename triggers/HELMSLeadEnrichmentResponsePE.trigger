/**** Trigger Name:HELMSLeadEnrichmentResponsePE 
User story Number : LMS-1733
SFDC will subscribe to a platform event queue to update Lead data. 
****/
trigger HELMSLeadEnrichmentResponsePE on Lead_Enrichment_Response__e(after insert) {
    /* Testing PE Event */
    if(Trigger.isInsert && Trigger.isAfter){
        HELMSLeadEnrichmentResponsePEHandler.UpdateLeads(Trigger.new);
    }
}