/**** Trigger Name:HELMSLeadCreationPE
User story Number : LMS-1553
SFDC will subscribe to a platform event queue to get new Lead data. 
****/
trigger HELMSLeadCreationPE on Lead_Creation_ADF__e (after insert) {

//below code was updated as a part of AMSLM-832-GLavanya    
     List<Lead_Creation_ADF__e> lstldcrtionadf = new List<Lead_Creation_ADF__e>();
        for (Lead_Creation_ADF__e leadcreation: Trigger.new){
            if(leadcreation.Validateonly__c == false){
              lstldcrtionadf.add(leadcreation);
            }
        }
            if(Trigger.isInsert && Trigger.isAfter){
            HELMSLeadCreationPEHandler.createLeads(lstldcrtionadf);
              }
}


/*trigger HELMSLeadCreationPE on Lead_Creation_ADF__e (after insert) {

    if(Trigger.isInsert && Trigger.isAfter){
        HELMSLeadCreationPEHandler.createLeads(Trigger.new);
    }
}*/