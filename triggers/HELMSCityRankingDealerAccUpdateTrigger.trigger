trigger HELMSCityRankingDealerAccUpdateTrigger on City_State_Ranking__c (before insert,before update) {
    BypassAutomations__c pb = BypassAutomations__c.getInstance(UserInfo.getUserId());
    if(pb.BypassTrigger__c == false){
        //Get recordtype id 
        Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Dealer').getRecordTypeId();
   
        //map of dealer number vs account id
        Map<string,id>  dlrNoMap= new Map<string,id>(); 
        Set<string> dlrNoSet= new Set<string>();
        for(City_State_Ranking__c cityR: trigger.new){
            if(cityR.Dealer_Number__c!=null){
                dlrNoSet.add(cityR.Dealer_Number__c);
            }
        }
        
        //featch account record and put into map
        for(Account acc: [SELECT id,dealercode_cd__c from account where dealercode_cd__c in :dlrNoSet and recordtypeid=:recordTypeId]){
            dlrNoMap.put(acc.dealercode_cd__c,acc.id);
        }
        
        //mapping account based on dealer number
        for(City_State_Ranking__c cityR: trigger.new){
            if(dlrNoMap.get(cityR.Dealer_Number__c)!=null){
                cityR.dealer_account__c = dlrNoMap.get(cityR.Dealer_Number__c);
                // Launchbox_ID__c field will be update by B2C load
                //if(cityR.City__c!=null && cityR.State__c!=null && cityR.Division__c!=null && cityR.Ranking__c!=null)
                   // cityR.Launchbox_ID__c = cityR.City__c + cityR.State__c + cityR.Division__c + cityR.Ranking__c;
            } 
        
        }
    }         
}