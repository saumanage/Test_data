trigger Lead_Dealer_AcknowledgementPE on Lead_Dealer_Acknowledgement_ADF__e (after insert) {
    if(Trigger.isInsert && Trigger.isAfter){
        HELMSLeadDealerAssignmentADFHandler handlerObj = new HELMSLeadDealerAssignmentADFHandler(); 
        handlerObj.updateOpportunityOnDealerAcknowledgement(Trigger.new);
    }
    
}