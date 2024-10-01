trigger HELMSEmailServiceTrigger on EmailMessage (after insert) {
    
     BypassAutomations__c pb = BypassAutomations__c.getInstance(UserInfo.getUserId());
    List<profile> profileList = new List<profile>();
    if(pb.BypassTrigger__c == false){
              
                Id profileId=userinfo.getProfileId();
               // String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
                 profileList=[Select Id,Name from Profile where Id=:profileId];
        	if(profileList.size()> 0){
				if(profileList[0].Name == 'HELMS Partner Community'){  
    					HELMSOpptystageandstatusonTaskandEvent.updateopptyStageandStatusforEmailMessage(Trigger.new);
                }
         }
                                           
    }

}