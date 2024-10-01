trigger HELMSUserPermissionsetGroupAssignment on User (after insert,after update) {       
    Map<ID,String> mapCons = new Map<ID,String>();
    Map<String,String> custom = new Map<string,String>();
    Map<ID,String> removePermissionsetgroup = new Map<ID,String>();
    Map<ID,Boolean> tabulUserMap = new Map<ID,Boolean>();
    Map<ID,Boolean> RemovetabulUserMap = new Map<ID,Boolean>();
    //Assign permission set group for Dealer users based on Jobcode
    Map<String,SSO_Job_Code_Mapping__c> csJobcode = new Map<string,SSO_Job_Code_Mapping__c>();
    
    //Assign permission set group for Internal/corporate users based on Application role
    Map<String,String> csapplication = new Map<string,String>();
 //to by pass the trigger LMS-5009    
    if( System.isBatch() ) {
     return;
}
    List<SSO_Job_Code_Mapping__c> mcs = SSO_Job_Code_Mapping__c.getall().values();
    
    for(SSO_Job_Code_Mapping__c sc:mcs){
        if(sc.Job_Code__c!=null){
            //csJobcode.put( sc.Job_Code__c , sc.Permission_set_Group__c);
            csJobcode.put( sc.Job_Code__c.substringbefore('-').trim() , sc);
        }
        
        if(sc.ApplicationRole__c!=null){
            csapplication.put( sc.ApplicationRole__c, sc.Permission_set_Group__c);
        }
        
    }
    
    
    //ProfileID and name
    Map<String,String> profileidmap = new Map<string,String>();
    
    for(SSO_Profile_Mapping__c pm:SSO_Profile_Mapping__c.getall().values()){
        if(pm.ProfileId__c!=null){
            profileidmap.put( pm.ProfileId__c , pm.name);
        }
        
        //system.debug('profileidmap----------'+profileidmap);
    }
    
    
    set<ID> AssignOppscorePermision = new set<ID>();    
    Boolean isActive = true;
    //If(trigger.isAfter && trigger.isUpdate){
    If(trigger.isAfter){
        set<ID> dealerconIds = new set<ID>();
        Map<String,String> dealerAccessLevelMap = new Map<String,String>();
        Map<String,Boolean> dreamShop = new Map<String,Boolean>();
        set<String> dealerNumber = new set<String>();
        set<String> dealerDivision = new set<String>();
        for(User u: Trigger.new){
            if(profileidmap.get(u.profileid)=='PartnerCommunityUser'){
                if(u.IsActive){
                    dealerconIds.add(u.contactId);
                }
                dealerNumber.add(u.DealerNumber_NUM__c);
                dealerDivision.add(u.Division__c);
            }
            
        }
        
        if(dealerconIds.size()>0){
            for(Contact c:[select id,ViewOpportunityScore_FLG__c from Contact where ID IN:dealerconIds]){
                
                if(c.ViewOpportunityScore_FLG__c==true){
                    AssignOppscorePermision.add(c.id);
                }
            }           
            
        }
        //system.debug('dealerNumber---'+dealerNumber);
        //system.debug('dealerDivision---'+dealerDivision);
        
        if(dealerNumber.size()>0){
            for(Dealer_Division__c dd:[select id, Is_Dealer_DreamShop_Active__c,Dealer_ID__r.DealerCode_CD__c, Division_CD__c, Dealer_Access_Level__c,isActive_FLG__c  from Dealer_Division__c where Dealer_ID__r.DealerCode_CD__c IN:dealerNumber AND isActive_FLG__c =true AND Division_CD__c IN:dealerDivision AND (Is_Dealer_DreamShop_Active__c= true OR Dealer_Access_Level__c ='Full Access' OR Dealer_Access_Level__c='Reporting Only')]){            
                
                system.debug('dd-21341234--'+dd);
                dealerAccessLevelMap.put(dd.Dealer_ID__r.DealerCode_CD__c, dd.Dealer_Access_Level__c);
                dreamShop.put(dd.Dealer_ID__r.DealerCode_CD__c, dd.Is_Dealer_DreamShop_Active__c);
            }
        }
        
        for(User u: Trigger.new){
            isActive = u.IsActive;
            if(profileidmap.containskey(u.profileid)){ 
                String persetnames = '';
                if(profileidmap.get(u.profileid)=='PartnerCommunityUser'){
                    /*
                    if(!u.IsActive){
                        AssignOppscorePermision.remove(u.contactId);
                    }
                    */
                                    
                    
                    String s= u.JobCode_CD__c;                    
                    
                    set<String> newJobCode = new set<String>();
                    if(u.JobCode_CD__c!=null && s.contains(',') && (dealerAccessLevelMap.containskey(u.DealerNumber_NUM__c) || dreamShop.containskey(u.DealerNumber_NUM__c)) ){
                        if(dealerAccessLevelMap.get(u.DealerNumber_NUM__c)=='Full Access' || dreamShop.get(u.DealerNumber_NUM__c)){
                            String[] jcodes = s.split(',');
                            
                            for(String jc : jcodes ){
                                
                                String Jobc= jc.substringbefore('-').trim();
                                //System.debug('******'+Jobc);
                                if(csJobcode.Containskey(Jobc)){
                                    
                                    String pname= csJobcode.get(Jobc).Permission_set_Group__c;  
                                    
                                    if(persetnames == ''){
                                        persetnames = pname;
                                    }else{
                                        persetnames = persetnames + ',' +pname;
                                    }
                                    
                                    if(csJobcode.get(Jobc).Is_Required_Tableau_Permission__c){
                                        tabulUserMap.put(u.Id, true );
                                        
                                        if( AssignOppscorePermision.contains(u.contactId)){
                                            persetnames =  persetnames + ',' +label.HELMS_Opportunity_Score_Visibility;
                                            
                                        }
                                        
                                    }
                                   // system.debug ('persetnames----------'+persetnames);
                                    mapCons.put(u.Id, persetnames );
                                    
                                }
                                newJobCode.add(Jobc);
                            }
                        }else if(dealerAccessLevelMap.get(u.DealerNumber_NUM__c)=='Reporting Only' && !dreamShop.get(u.DealerNumber_NUM__c)){
                            String pname= 'HELMSReportingOnly' ;
                            if(persetnames == ''){
                                persetnames = pname;
                            }else{
                                persetnames = persetnames + ',' +pname;
                            }
                            /*if(csJobcode.get(u.JobCode_CD__c).Is_Required_Tableau_Permission__c){
                                tabulUserMap.put(u.Id, true );
                                if( AssignOppscorePermision.contains(u.contactId)){
                                    persetnames=  persetnames + ',' +label.HELMS_Opportunity_Score_Visibility;
                                }
                            }
                            
                            */
                                                    

                            String[] jcodes = s.split(',');
                            
                            for(String jc : jcodes ){
                                
                                String Jobc= jc.substringbefore('-').trim();
                                //System.debug('******'+Jobc);
                                if(csJobcode.Containskey(Jobc)){
                                                                      
                                    if(csJobcode.get(Jobc).Is_Required_Tableau_Permission__c){
                                        tabulUserMap.put(u.Id, true );
                                        
                                        if( AssignOppscorePermision.contains(u.contactId)){
                                            persetnames =  persetnames + ',' +label.HELMS_Opportunity_Score_Visibility;
                                            
                                        }
                                        
                                    }
                                   // system.debug ('persetnames----------'+persetnames);
                                    mapCons.put(u.Id, persetnames );
                                    
                                }
                                
                            }
                            
                            
                        }
                        
                    }else if(u.JobCode_CD__c!=null && csJobcode.Containskey(u.JobCode_CD__c.substringbefore('-').trim()) && (dealerAccessLevelMap.containskey(u.DealerNumber_NUM__c) || dreamShop.containskey(u.DealerNumber_NUM__c))){
                        IF(dealerAccessLevelMap.get(u.DealerNumber_NUM__c)=='Full Access' ||  dreamShop.get(u.DealerNumber_NUM__c) ){
                            
                            String pname= csJobcode.get(u.JobCode_CD__c.substringbefore('-').trim()).Permission_set_Group__c;                            
                            if(persetnames == ''){
                                persetnames = pname;
                            }else{
                                persetnames = persetnames + ',' +pname;
                            }
                            
                            //mapCons.put(u.Id, pname );
                            if(csJobcode.get(u.JobCode_CD__c.substringbefore('-').trim()).Is_Required_Tableau_Permission__c){
                                tabulUserMap.put(u.Id, true );
                                
                                if(AssignOppscorePermision.contains(u.contactId)){
                                    persetnames=  persetnames + ',' +label.HELMS_Opportunity_Score_Visibility;
                                }
                                
                            }
                           // system.debug ('persetnames----------'+persetnames);
                            mapCons.put(u.Id, persetnames );
                            newJobCode.add(u.JobCode_CD__c);
                        }else if(dealerAccessLevelMap.get(u.DealerNumber_NUM__c)=='Reporting Only' && !dreamShop.get(u.DealerNumber_NUM__c)){
                            String pname= 'HELMSReportingOnly' ;
                            if(persetnames == ''){
                                persetnames = pname;
                            }else{
                                persetnames = persetnames + ',' +pname;
                            }
                            
                            if(csJobcode.get(u.JobCode_CD__c.substringbefore('-').trim()).Is_Required_Tableau_Permission__c){
                                tabulUserMap.put(u.Id, true );
                                if( AssignOppscorePermision.contains(u.contactId)){
                                    persetnames=  persetnames + ',' +label.HELMS_Opportunity_Score_Visibility;
                                }
                            }
                            //system.debug ('persetnames----------'+persetnames);
                            mapCons.put(u.Id, persetnames );
                            //mapCons.put(u.Id, 'HELMSReportingOnly' );
                        }
                    }else{                        
                        u.addError(System.Label.Dealer_User_Error_Message);
                    }
                    
                    
                    
                    if(Trigger.isUpdate){
                        String removePGName = '';
                        Map<Id,USer> OldMap = Trigger.oldMap ;
                        if(u.JobCode_CD__c!=OldMap.get(u.id).JobCode_CD__c){
                            //String removePGName;
                            
                            String sOld= OldMap.get(u.id).JobCode_CD__c;
                            string nJob = u.JobCode_CD__c;
                            if(u.JobCode_CD__c!=null && sOld!=null && sOld.contains(',')){
                                String[] Oldjcodes = sOld.split(','); 
                                
                                for(String oldjc : Oldjcodes ){
                                    
                                    String oldJobc= oldjc.trim();
                                    
                                    if(csJobcode.Containskey(oldJobc.substringbefore('-').trim())){
                                        
                                        String pname= csJobcode.get(oldJobc.substringbefore('-').trim()).Permission_set_Group__c;  
                                        if(!newJobCode.contains(oldJobc)){
                                            if(removePGName == ''){
                                                removePGName = pname;
                                            }else{
                                                removePGName = removePGName +','+ pname;
                                            }
                                            
                                        }
                                        
                                    }
                                    
                                    if(!tabulUserMap.Containskey(u.Id)){
                                        RemovetabulUserMap.put(u.Id, false );
                                    }
                                }
                            }else if(u.JobCode_CD__c!=null && OldMap.get(u.id).JobCode_CD__c!=null){
                                
                                String pname= csJobcode.get(OldMap.get(u.id).JobCode_CD__c.substringbefore('-').trim()).Permission_set_Group__c;
                                //system.debug('pname-----'+pname);
                                if(!newJobCode.contains(OldMap.get(u.id).JobCode_CD__c)){
                                    if(removePGName == ''){
                                        removePGName = pname;
                                    }else{
                                        removePGName = removePGName +','+ pname;
                                    }
                                    
                                }
                                if(!tabulUserMap.Containskey(u.Id)){
                                    RemovetabulUserMap.put(u.Id, false );
                                }
                            }
                            //system.debug('tabulUserMap-----'+tabulUserMap);
                            //system.debug('removePGName-----'+removePGName);
                            if(removePGName!=null ){                               
                                removePermissionsetgroup.put(u.Id, removePGName);
                            }
                            
                        }
                        
                    }
                    
                }else if(profileidmap.get(u.profileid)=='InternalUser' || profileidmap.get(u.profileid)=='HELMSSupportTeam'){
                    
                    if(Trigger.isInsert){
                        String pname= csapplication.get(u.ApplicationRole_NM__c);      
                        
                        mapCons.put(u.Id, pname );
                        
                    }
                    
                    if(Trigger.isUpdate){
                        
                        Map<Id,USer> OldMap = Trigger.oldMap ;
                        
                        if(u.ApplicationRole_NM__c!=OldMap.get(u.id).ApplicationRole_NM__c){
                            
                            String pname= csapplication.get(u.ApplicationRole_NM__c);                              
                            mapCons.put(u.Id, pname );
                            
                            String OldPname= csapplication.get(OldMap.get(u.id).ApplicationRole_NM__c);  
                            
                            removePermissionsetgroup.put(u.Id, OldPname);
                        }
                        
                    }
                    
                }else if(profileidmap.get(u.profileid)=='FieldLinkUser'){
                    
                    String pname= csapplication.get('AHM_FieldLink_User');  
                    if(pname==null){
                        pname = 'AHM_FieldLink_User';
                    }
                    mapCons.put(u.Id, pname );
                    
                    
                }
                
                
            }
            
        }
        
        if(isActive){
            if(Trigger.isInsert){
                Map<Id,USer> OldMap = new Map<Id,USer>();
                Map<Id,User> NewMap = new Map<Id,USer>();
                HELMSCRMEligibleHandler.TableauCRMUserPermissions(Trigger.new , Trigger.isInsert ,Trigger.isUpdate,NewMap ,OldMap , tabulUserMap , RemovetabulUserMap);
            }
            if(Trigger.isUpdate){
                Map<Id,USer> OldMap = Trigger.oldMap ;
                Map<Id,User> NewMap = Trigger.newMap ;
                HELMSCRMEligibleHandler.TableauCRMUserPermissions(Trigger.new , Trigger.isInsert,Trigger.isUpdate ,NewMap ,OldMap , tabulUserMap , RemovetabulUserMap );
            }
        }
    }  
    //system.debug('mapCons----------'+mapCons);
    
    // if(isActive  && mapCons.size()>0 && !HELMSAccountHandler.DealerUserActivate){
    if(isActive  && mapCons.size()>0 ){
        HELMSCRMEligibleHandler.updateUserPermissions(mapCons);
    }
    
    if(removePermissionsetgroup.size()>0){  
        HELMSCRMEligibleHandler.RemovePermissionSetGroup(removePermissionsetgroup);
    }
    /*
    if(AssignOppscorePermision.size()>0){
        HELMSCRMEligibleHandler.AssignPermissionSetToUser(AssignOppscorePermision);
    }
    */
    
}