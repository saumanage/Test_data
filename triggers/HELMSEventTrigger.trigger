trigger HELMSEventTrigger on Event (after insert) {
    
	 BypassAutomations__c pb = BypassAutomations__c.getInstance(UserInfo.getUserId());
    if(pb.BypassTrigger__c == false){
             
                Id profileId=userinfo.getProfileId();
                String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
				if(profileName == 'HELMS Partner Community'){   
   					 HELMSOpptystageandstatusonTaskandEvent.updateopptyStageandStatusforEvent(Trigger.new);
    }
    }
}