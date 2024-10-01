public with sharing class DealerSubDivisionController {
    @AuraEnabled
    	 public static map<id,string> getDealerSubDiv(){
             String combination;
             String userId = UserInfo.getUserId();
            User u = [SELECT AccountId, Profile.Name FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1 ];
			
	 map<id ,string > subDivmap= new map<id ,string > ();
      list<Dealer_Division__c> sublist=[select id,Name,Dealer_ID__c,DealerSubdivision_CD__c,Division_CD__c,SubDiv_TXT__c  from Dealer_Division__c where  Dealer_ID__c=:u.AccountId];
	 for(Dealer_Division__c sl:sublist){
        //  combination = sl.Name + '-' + sl.Division_CD__c + '-' +sl.SubDiv_TXT__c ;
        combination =   'Setup '+ sl.SubDiv_TXT__c + ' Notifications';
	   subDivmap.put(sl.id,combination);
	 
	 } 
	 return subDivmap;
	 
    }
}