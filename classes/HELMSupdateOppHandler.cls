/*******************************************************************************************
* @Name         HELMSupdateOppHandler 
//

*******************************************************************************************/
public with sharing  class HELMSupdateOppHandler {    
    public void updateOppAmount(List<Opportunity> newOpp){
        for(Opportunity lg : newOpp){
            if(lg.Total_Quote_AMT__c != NULL){
                lg.Amount = lg.Total_Quote_AMT__c;
                
            }
            else{
                if(lg.Total_MSRP_AMT__c==null){
                    lg.Total_MSRP_AMT__c= lg.MSRP_AMT__c;
                    lg.Amount = lg.Total_MSRP_AMT__c;
                }else{
                    lg.Amount = lg.Total_MSRP_AMT__c;
                }
            }
        }        
    }
    //Assigning lead provider on lead record
    public Static void assignLeadProviders(List<Opportunity> newOpps){
        try{
            List<Opportunity> newOpps2 = new List<Opportunity>();
            for(Opportunity opp : newOpps){         
                if(opp.LeadProvider_ID__c == Null || opp.LeadProvider_ID__c == ''){
                    newOpps2.add(opp);
                }
            }
            String profileId = UserInfo.getProfileId();
            Profile communityProfile = [SELECT Id, Name FROM Profile WHERE Id =:profileId and profile.Name = 'HELMS Partner Community'];
            if(communityProfile != NULL && newOpps2.size()>0){
                List<Opportunity> updateOppLst = new List<Opportunity>();
                List<Account> accountsLst = [Select Id,Name FROM Account 
                                             WHERE Name IN ('Acura Dealer Created', 'Engine Dealer Created','Honda Dealer Created','Marine Dealer Created', 'PowerEquipment Dealer Created','Motorcycle Dealer Created')
                                             AND RecordTypeId=:Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider').getRecordTypeId()
                                            ];
                
                Map<String,ID> accountNameIDMap = new Map<String,ID>();
                for(Account acc : AccountsLst){
                    accountNameIDMap.put(acc.Name,acc.Id);     
                }
                system.debug(' test class accountNameIDMap-->'+accountNameIDMap);
                for(Opportunity opp : newOpps){
                    if(opp.LeadProvider_ID__c == Null || opp.LeadProvider_ID__c == ''){
                       // system.debug('test class opp.SubDiv_TXT__c--->'+opp.SubDiv_TXT__c);
                        
                            
                        if(opp.SubDiv_TXT__c == 'Acura'){
                            if(accountNameIDMap.containsKey('Acura Dealer Created')){
                                opp.LeadProvider_ID__c =  accountNameIDMap.get('Acura Dealer Created');
                            }                                        
                        }else if(opp.SubDiv_TXT__c == 'Engine'){
                            if(accountNameIDMap.containsKey('Engine Dealer Created')){
                                opp.LeadProvider_ID__c =  accountNameIDMap.get('Engine Dealer Created');
                            }
                        }else if(opp.SubDiv_TXT__c == 'Honda'){
                            if(accountNameIDMap.containsKey('Honda Dealer Created')){
                                opp.LeadProvider_ID__c =  accountNameIDMap.get('Honda Dealer Created');
                            }
                        }else if(opp.SubDiv_TXT__c == 'Motorcycle'){
                            if(accountNameIDMap.containsKey('Motorcycle Dealer Created')){
                                opp.LeadProvider_ID__c =  accountNameIDMap.get('Motorcycle Dealer Created');
                            }
                        }else if(opp.SubDiv_TXT__c == 'PowerEquipment'){
                            if(accountNameIDMap.containsKey('PowerEquipment Dealer Created')){
                                opp.LeadProvider_ID__c =  accountNameIDMap.get('PowerEquipment Dealer Created');
                            }
                        }else if(opp.SubDiv_TXT__c == 'Marine'){
                            
                            if(accountNameIDMap.containsKey('Marine Dealer Created')){
                                opp.LeadProvider_ID__c =  accountNameIDMap.get('Marine Dealer Created');
                            }
                        }
                        
                        // updateOppLst.add(opp);
                    }
                }
                /* if(!updateOppLst.isEmpty()){
update updateOppLst;
} */
            }
        }catch(Exception e){
            
        }     
    } 

 //LMS-4878 Duplicate Opportunity(based on Opportunity RelationShip Object )
    public void findDuplicateOpportunity(List<Opportunity> newOpps){
       
        try{
            set<string> emailset= new set<string>();
            set<string> dlrNoSet= new set<string>();
            set<string> zipSet= new set<string>();
            		//system.debug('newOpps:---->'+newOpps);
            
            for(Opportunity opp: newOpps){
                if(!string.isblank(opp.Email__c)){
                   emailset.add(opp.Email__c);
                }if(!string.isblank(opp.PreferredDealerNumber_NUM__c)){
                    dlrNoSet.add(opp.PreferredDealerNumber_NUM__c);  
                }if(!string.isblank(opp.ZipCode_TXT__c)){
                    zipSet.add(opp.ZipCode_TXT__c);}  
            }
         system.debug('***emailset'+emailset);
            list<Opportunity_Relations__c> opRelationList=new list<Opportunity_Relations__c>();
            List<Opportunity> newOpporunityList=new List<Opportunity>();
            list<Opportunity_Relations__c> reltList=new list<Opportunity_Relations__c>();
            Set<id> opprelid= new Set<id>();
            
            List<Opportunity> opporunityList= [select id,First_Name_TXT__c,Last_Name_TXT__c,Email__c,Phone__c,ZipCode_TXT__c,PreferredDealerNumber_NUM__c,                                              Duplicate_Similar__c,Model_TXT__c,Division_CD__c,SubDiv_TXT__c 
                                from Opportunity where Email__c in :emailset and ZipCode_TXT__c in :zipSet and PreferredDealerNumber_NUM__c in :dlrNoSet  ORDER BY CreatedDate ASC];
            system.debug('***before opporunityList'+opporunityList);
            map<id,opportunity> maporgvsdup= new map<id,opportunity>();
            map<id,opportunity> mapdupopp= new map<id,opportunity>();
            for(Opportunity opp: newOpps){
               
                    for(Opportunity obj: opporunityList){
                        if(opp.First_Name_TXT__c == obj.First_Name_TXT__c && opp.Last_Name_TXT__c == obj.Last_Name_TXT__c && opp.Email__c==obj.Email__c
                        && opp.Phone__c==obj.Phone__c && opp.ZipCode_TXT__c==obj.ZipCode_TXT__c && opp.PreferredDealerNumber_NUM__c==obj.PreferredDealerNumber_NUM__c
                        && opp.Model_TXT__c==obj.Model_TXT__c && opp.SubDiv_TXT__c==obj.SubDiv_TXT__c ){
                            if(obj.Duplicate_Similar__c==false){
                                maporgvsdup.put(obj.id,obj);
                            }else if(opp.Duplicate_Similar__c==false){
                                 maporgvsdup.put(opp.id,opp);
                            }
                            
                            if(obj.Duplicate_Similar__c==true){
                                mapdupopp.put(obj.id,obj);
                            }
                        }
                    }
               
            }
            system.debug('***before maporgvsdup'+maporgvsdup);
            map<id,set<id>> maporgvsRel= new map<id,set<id>>();
           		// system.debug('maporgvsdup:-------->'+maporgvsdup);
           		 reltList=[Select id,New_Opportunity__c,Previous_Opportunity__c from Opportunity_Relations__c where Previous_Opportunity__c in :maporgvsdup.keyset() Limit 40000];
         
            for(Opportunity_Relations__c rel: reltList){
                if(maporgvsRel!=null){
                    if(maporgvsRel.keyset().contains(rel.Previous_Opportunity__c)){
                            maporgvsRel.get(rel.Previous_Opportunity__c).add(rel.New_Opportunity__c);
                    }else{
                        maporgvsRel.put(rel.Previous_Opportunity__c ,new set<id>{});
                        maporgvsRel.get(rel.Previous_Opportunity__c).add(rel.New_Opportunity__c);
                    }
                }else{
                    maporgvsRel.put(rel.Previous_Opportunity__c ,new set<id>{});
                    maporgvsRel.get(rel.Previous_Opportunity__c).add(rel.New_Opportunity__c);
                }
            }
             system.debug('***before maporgvsRel'+maporgvsRel);
            for(Opportunity opp: newOpps){
                if(opp.Duplicate_Similar__c==true){
                    for(opportunity orgopp: maporgvsdup.values()){
                        if(opp.First_Name_TXT__c == orgopp.First_Name_TXT__c && opp.Last_Name_TXT__c == orgopp.Last_Name_TXT__c && opp.Email__c==orgopp.Email__c
                        && opp.Phone__c==orgopp.Phone__c && opp.ZipCode_TXT__c==orgopp.ZipCode_TXT__c && opp.PreferredDealerNumber_NUM__c==orgopp.PreferredDealerNumber_NUM__c
                        && opp.Model_TXT__c==orgopp.Model_TXT__c && opp.SubDiv_TXT__c==orgopp.SubDiv_TXT__c){
                            
                            if(maporgvsRel.get(orgopp.id)!=null){ 
                                if(!maporgvsRel.get(orgopp.id).contains(opp.Id)){
                                    Opportunity_Relations__c opr=new Opportunity_Relations__c();
                                    opr.Previous_Opportunity__c= orgopp.id; 
                                    opr.New_Opportunity__c= opp.Id;
                                    opr.Reason_For_Cloning__c='Duplicate-Similar';
                                    opRelationList.add(opr);
                                }
                            }else {
                                Opportunity_Relations__c opr=new Opportunity_Relations__c();
                                opr.Previous_Opportunity__c= orgopp.id; 
                                opr.New_Opportunity__c= opp.Id;
                                opr.Reason_For_Cloning__c='Duplicate-Similar';
                                opRelationList.add(opr);
                            }
                            
                        }
                    }
                }else if(opp.Duplicate_Similar__c==false){
                    system.debug('**mapdupopp::::::::'+mapdupopp.values());
                    system.debug('**opp::::::::'+opp);
                    for(opportunity dupopp: mapdupopp.values()){
                        if(opp.First_Name_TXT__c == dupopp.First_Name_TXT__c && opp.Last_Name_TXT__c == dupopp.Last_Name_TXT__c && opp.Email__c==dupopp.Email__c
                        && opp.Phone__c==dupopp.Phone__c && opp.ZipCode_TXT__c==dupopp.ZipCode_TXT__c && opp.PreferredDealerNumber_NUM__c==dupopp.PreferredDealerNumber_NUM__c
                        && opp.Model_TXT__c==dupopp.Model_TXT__c && opp.SubDiv_TXT__c==dupopp.SubDiv_TXT__c && dupopp.Duplicate_Similar__c==true){
                            
                            system.debug('**dupopp::::::::::'+dupopp);
                                Opportunity_Relations__c opr=new Opportunity_Relations__c();
                                opr.Previous_Opportunity__c= opp.Id; 
                                opr.New_Opportunity__c= dupopp.id;
                                opr.Reason_For_Cloning__c='Duplicate-Similar';
                                opRelationList.add(opr);
                                
                                if(maporgvsRel!=null){
                                    if(maporgvsRel.keyset().contains(opr.Previous_Opportunity__c)){
                                            maporgvsRel.get(opr.Previous_Opportunity__c).add(opr.New_Opportunity__c);
                                    }else{
                                        maporgvsRel.put(opr.Previous_Opportunity__c ,new set<id>{});
                                        maporgvsRel.get(opr.Previous_Opportunity__c).add(opr.New_Opportunity__c);
                                    }
                                }else{
                                    maporgvsRel.put(opr.Previous_Opportunity__c ,new set<id>{});
                                    maporgvsRel.get(opr.Previous_Opportunity__c).add(opr.New_Opportunity__c);
                                }
                        }
                    }
                }
            }   
              
            system.debug('***before insertion opRelationList'+opRelationList.size());
            system.debug('***before insertion opRelationList'+opRelationList);
            if(!opRelationList.isempty()){ 
                insert opRelationList;
            }            
            system.debug('**** after insertion opRelationList'+opRelationList);
         
        }
        catch(Exception ex){
           Logs__c l = new Logs__c(name = 'Opportunity_FindDuplicate', Trigger_or_Class_Name__c = 'HELMSupdateOppHandler', Error_Message__c = ex.getMessage(), Error_Line_Number__c = Integer.valueOf(string.valueof(ex.getLineNumber())));
           insert l;
       }
 }
            
            

}