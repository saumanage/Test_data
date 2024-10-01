trigger HELMSTaskTrigger on Task (after insert) {
    
      BypassAutomations__c pb = BypassAutomations__c.getInstance(UserInfo.getUserId());
    List<profile> profileList = new List<profile>();
    //System.debug('pb.BypassTrigger__c : '+pb.BypassTrigger__c);
    if(pb.BypassTrigger__c == false){
        
      		Id profileId=userinfo.getProfileId();
        
              profileList=[Select Id,Name from Profile where Id=:profileId];
                //system.debug('ProfileName'+profileName); 
        		if(profileList.size()> 0){
				 if(profileList[0].Name == 'HELMS Partner Community'){
      		 		HELMSOpptystageandstatusonTaskandEvent.updateopptyStageandStatusforTask(Trigger.new);
                   }
       	 }

    }
        
}