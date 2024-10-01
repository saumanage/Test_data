trigger HELMSZipRankingDealerAccUpdateTrigger on Zip_Ranking__c (before insert,before update) {
    BypassAutomations__c pb = BypassAutomations__c.getInstance(UserInfo.getUserId());
    if(pb.BypassTrigger__c == false){
        //Get recordtype id 
        Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Dealer').getRecordTypeId();
  
        //map of dealer number vs account id
        Map<string,id>  dlrNoMap= new Map<string,id>(); 
        Set<string> dlrNoSet= new Set<string>();
        for(Zip_Ranking__c zipR: trigger.new){
            if(zipR.Dealer_Number__c!=null){
                dlrNoSet.add(zipR.Dealer_Number__c);
            }
        }
        //featch account record and put into map
        for(Account acc: [SELECT id,dealercode_cd__c from account where dealercode_cd__c in :dlrNoSet and recordtypeid=:recordTypeId]){
            dlrNoMap.put(acc.dealercode_cd__c,acc.id);
        }        
        //mapping account based on dealer number
        for(Zip_Ranking__c zipR: trigger.new){
            if(dlrNoMap.get(zipR.Dealer_Number__c)!=null){
                zipR.dealer_account__c = dlrNoMap.get(zipR.Dealer_Number__c);
                // Launchbox_ID__c field will be update by B2C load
               // if(zipR.Postal_Code__c!=null && zipR.Division__c!=null && zipR.Ranking__c!=null)
                   // zipR.Launchbox_ID__c = zipR.Postal_Code__c + zipR.Division__c + zipR.Ranking__c;
            } 
        
        }
    }     
}