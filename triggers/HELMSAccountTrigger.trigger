trigger HELMSAccountTrigger on Account(before insert, before update,after insert,after update) {
    BypassAutomations__c pb = BypassAutomations__c.getInstance(UserInfo.getUserId());
    if(pb.BypassTrigger__c == false){
      
        if(Trigger.isInsert && Trigger.isAfter){
            HELMSAccountHandler.dealerB2CMapping(trigger.new); 
        }
           /* if(Trigger.isUpdate && Trigger.isBefore){
                system.debug('inside concierge');
            HELMSAccountHandler.concierge(trigger.new); 
        }
        */
    
    }
    
    
}