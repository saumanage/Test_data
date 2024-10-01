trigger HELMSDealerDivisionTrigger on Dealer_Division__c (before insert,before update,after insert,after update){
    // 
    BypassAutomations__c pb = BypassAutomations__c.getInstance(UserInfo.getUserId());
        
    if(pb.BypassTrigger__c == false){
        try{ 
        
            List<Id> reportingonlyAccountIds = new List<Id>();
            List<Id> noAccessAccountIds = new List<Id>();
            
            Map<String , String> dealerId = new Map<String,String>();
            //set<String> rolename = new set<String>();
            if(Trigger.isAfter){      
                for(Dealer_Division__c dd:Trigger.new){
                    if(dd.isActive_FLG__c){
                        // rolename.add('S'+dd.Division_CD__c+'Z'+dd.SalesZone_CD__c);
                        dealerId.put(dd.Dealer_ID__c, dd.Division_CD__c+''+dd.SalesZone_CD__c);
                    }
                    if(Trigger.isUpdate && Trigger.isAfter){
                        if(trigger.oldMap.get(dd.Id).Dealer_Access_Level__c != dd.Dealer_Access_Level__c && dd.Dealer_Access_Level__c == 'Reporting Only' ){
                            reportingonlyAccountIds.add(dd.Dealer_ID__c); 
                            
                            if(!dd.Is_Dealer_DreamShop_Active__c){
                                Map<ID,String> mapReportingUser = new Map<ID,String>();
                                                                
                                for(User u : [SELECT Id, IsActive FROM User WHERE Contact.AccountId IN :reportingonlyAccountIds]){
                                    
                                    mapReportingUser.put(u.Id, 'HELMSReportingOnly');
                                }
                                HELMSCRMEligibleHandler.updateUserPermissions(mapReportingUser);
                            }
                          
                        } if((trigger.oldMap.get(dd.Id).Dealer_Access_Level__c != dd.Dealer_Access_Level__c && dd.Dealer_Access_Level__c == 'No Access') || (trigger.oldMap.get(dd.Id).Is_Dealer_DreamShop_Active__c!= dd.Is_Dealer_DreamShop_Active__c&& dd.Is_Dealer_DreamShop_Active__c== False)){
                            noAccessAccountIds.add(dd.Dealer_ID__c);                          
                        }
                    }
                }

                if(!reportingonlyAccountIds.isEmpty()){
                    HELMSAccountHandler.processReportOnlyAccounts(reportingonlyAccountIds);
                                       
                }
                //System.debug('-----NoAccessAccountIds-----'+NoAccessAccountIds);
                if(!noAccessAccountIds.isEmpty()){
                    HELMSAccountHandler.handleAccountUpdate(noAccessAccountIds);
                }
               
                Map<String, String> urMap = new Map<String, String>();
                set<String> usernamelist = new set<String>();
                List<Account_Owner_by_Division_and_Zone__c> mcs = Account_Owner_by_Division_and_Zone__c.getall().values();
                for(Account_Owner_by_Division_and_Zone__c ur : mcs){
                    
                    urMap.put(ur.DivisionZone_CD__c, (ur.username__c).toLowerCase());
                    
                    usernamelist.add((ur.username__c).toLowerCase());
                }
                
                Map<String, string> usernameMap = new Map<String, String>();
                For(user u:[Select id, username from user where isactive = true and username IN : usernamelist]){
                    usernameMap.put((u.username).toLowerCase() , u.id);
                }
                Id dealerAccRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
                //System.debug('-----usernameMap-----'+usernameMap);
                List<Account> accUpdateList = new List<Account>();
                List<Account> accq =[Select id,ownerid, owner.name from Account where id IN : dealerId.Keyset() and RecordTypeId=:dealerAccRecTypeId ];
                set<id> aaccidset = new set<id>();
                for(Account acc: accq ){
                    
                    if(!aaccidset.contains(acc.id) && dealerId.ContainsKey(acc.id) && (urMap.containskey(dealerId.get(acc.id)))  && usernameMap.containskey(urMap.get(dealerId.get(acc.id)))){
                        acc.ownerid = usernameMap.get(urMap.get(dealerId.get(acc.id)));
                        
                        accUpdateList.add(acc);
                        aaccidset.add(acc.id);
                    }
                }
                //system.debug('--------'+accUpdateList);
                if(accUpdateList.size()>0){
                    database.update(accUpdateList, false);
                }
            }
            
        }Catch(Exception ex){
           
           Logs__c  l =new Logs__c (name='Dealer Division- Trigger',Trigger_or_Class_Name__c='HELMSDealerDivisionTrigger', Error_Message__c =ex.getMessage(), Error_Line_Number__c =Integer.valueOf(string.valueof(ex.getLineNumber() )) );
            insert l; 
        }
    }
}