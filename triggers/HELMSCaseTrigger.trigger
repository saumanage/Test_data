trigger HELMSCaseTrigger on Case (after insert, after update) { 
    BypassAutomations__c pb = BypassAutomations__c.getInstance(UserInfo.getUserId());
    if(pb.BypassTrigger__c == false){

   HELMSCaseTriggerHandler.CaseSharing(Trigger.new);
   }
   
}