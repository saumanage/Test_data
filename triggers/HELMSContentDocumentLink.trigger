trigger HELMSContentDocumentLink on ContentDocumentLink (after insert) {
     BypassAutomations__c pb = BypassAutomations__c.getInstance(UserInfo.getUserId());
  	 if(pb.BypassTrigger__c == false){
          	    Id profileId=userinfo.getProfileId();
                String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
                if(profileName == 'HELMS Partner Community')  {   
             HELMSOpptystageandstatusonTaskandEvent.updateopptyStageandStatusforNote(Trigger.new);
             }
    }
}