//This Class Assign the Tableau Permission Set to Partner Community Users
public class HELMSCRMEligibleHandler {
  @future
    public static void updateUser(Map<ID , Boolean> ConMap){
        try{
            List<User> lstUser = new List<User>();
            
            For(User u: [SELECT id, ContactId, IsActive  from user where ContactId IN: ConMap.Keyset()]){
                
                u.IsActive = ConMap.get(u.ContactId);
                
                lstUser.add(u);
            }
            
            if(lstUser.size()>0){
                update lstUser;
            }
        }Catch(Exception ex){
            //System.debug('Exception at line : '+ ex.getLineNumber());
            //System.debug('Exception Message : '+ ex.getMessage());
            
            //Logs__c  l =new Logs__c (name='Contact trigger',Trigger_or_Class_Name__c='HELMSCRMEligibleHandler.updateUser', Error_Message__c =ex.getMessage(), Error_Line_Number__c =Integer.valueOf(string.valueof(ex.getLineNumber() )) );    insert l;
        }
        
    }
    
    @future
    public static void updateUserPermissions(Map<ID , String> ConMap){
        try{
            List<PermissionSetAssignment> assignmentList = new List<PermissionSetAssignment>();
            Map<String , String > pmap = new Map<String , String >();
            //system.debug('keyset va----------'+ConMap.values());
            Map<ID , set<String> > Userpermap = new Map<ID , set<String> >();            
            Set<String> psnameSet = new Set<String>();
            for(ID uid : ConMap.keySet() ){
                string s = ConMap.get(uid) ;
                if( s.contains(',')){
                    String[] pnames = s.split(',');
                    for(String ps : pnames ){                       
                        psnameSet.add(ps.trim());
                    }
                    Userpermap.put(uid, psnameSet);
                }else{
                    psnameSet.add((ConMap.get(uid)).trim());
                    Userpermap.put(uid, psnameSet);
                }
            }
            
            for(PermissionSetGroup pg :[SELECT Id,DeveloperName from PermissionSetGroup where DeveloperName IN :psnameSet]){
                pmap.put(pg.DeveloperName , pg.id);
            }
            
            //system.debug('mapCons----------'+ConMap);      

            for(ID uid : Userpermap.keySet() ){
                for(String ps : Userpermap.get(uid) ){                       
                    string pname =ps.trim();
                    PermissionSetAssignment assignment = new PermissionSetAssignment(PermissionSetGroupId =pmap.get(pname) , AssigneeId =uid);
                    assignmentList.add(assignment);
                }
            }
            /*
            for(ID uid : ConMap.keySet() ){
                                
                string s = ConMap.get(uid) ;
                if( s.contains(',')){
                    String[] pnames = s.split(',');
                    for(String ps : pnames ){                       
                        string pname =ps.trim();
                        PermissionSetAssignment assignment = new PermissionSetAssignment(PermissionSetGroupId =pmap.get(pname) , AssigneeId =uid);
                        assignmentList.add(assignment);
                    }
                }else{
                    
                    PermissionSetAssignment assignment = new PermissionSetAssignment(PermissionSetGroupId =pmap.get(ConMap.get(uid)) , AssigneeId =uid);
                    assignmentList.add(assignment);
                }
                
                
            } 

            */
            if(assignmentList.size()>0){
                Database.upsert(assignmentList , false);
            }
            
        }Catch(Exception ex){
            //System.debug('Exception at line : '+ ex.getLineNumber());
            //System.debug('Exception Message : '+ ex.getMessage());
            
            // Logs__c  l =new Logs__c (name='User trigger',Trigger_or_Class_Name__c='HELMSCRMEligibleHandler.updateUserPermissions', Error_Message__c =ex.getMessage(), Error_Line_Number__c =Integer.valueOf(string.valueof(ex.getLineNumber() )) );  insert l;
        }
    }
    
    
    public static void TableauCRMUserPermissions(List<User> UserList, Boolean isinsert, Boolean isUpdate, Map<Id,USer> NewMap , Map<Id,USer> OldMap , Map<ID,Boolean> tabulUserMap , Map<ID,Boolean> RemovetabulUserMap ){
        //system.debug('tabulUserMap-----'+tabulUserMap);
        //system.debug('tabulUserMap-----'+RemovetabulUserMap);
        Tableau_CRM_Plus__c tableauCustomsetting = Tableau_CRM_Plus__c.getOrgDefaults();
        
        Map<ID,String> mapTableau_CRMUserPer = new Map<ID,String>();
        Map<ID,String> removePermissionsetgroup = new Map<ID,String>();
        //ProfileID and name
        Map<String,String> profileidmap = new Map<string,String>();
        
        for(SSO_Profile_Mapping__c pm:SSO_Profile_Mapping__c.getall().values()){
            if(pm.ProfileId__c!=null){
                profileidmap.put( pm.ProfileId__c , pm.name);
            }         
        }
               
        for(User u: UserList){
            set<String> assignPs = new set<String>();
            set<String> RemovePs = new set<String>();
            
            //String tabCRMPer = System.Label.Tableau_CRM_Plus_User;
            if(isInsert){
                
                if(tableauCustomsetting.get('Tableau_CRM_Plus_User__c')==true){
                    if(profileidmap.get(u.profileid)=='PartnerCommunityUser'  || profileidmap.get(u.profileid)=='HELMSITAdmin'){
                        if(tabulUserMap.Containskey(u.Id)){
                            
                            mapTableau_CRMUserPer.put(u.Id, 'Tableau_CRM_Plus_User_CommunityGoup' );
                        }
                        
                    }else if(profileidmap.get(u.profileid)=='InternalUser' || profileidmap.get(u.profileid)=='FieldLinkUser'){
                        
                        mapTableau_CRMUserPer.put(u.Id, 'Tableau_CRM_Plus_User');
                    }
                }
            }
            
            if(isUpdate){
                
                if(OldMap.get(u.Id).Tableau_CRM_Permission_FLG__C!= NewMap.get(u.Id).Tableau_CRM_Permission_FLG__C){ 
                    if(NewMap.get(u.Id).Tableau_CRM_Permission_FLG__C && tableauCustomsetting.get('Tableau_CRM_Plus_User__c')==true ){
                        if(profileidmap.get(u.profileid)=='PartnerCommunityUser'  || profileidmap.get(u.profileid)=='HELMSITAdmin'){
                            
                            mapTableau_CRMUserPer.put(u.Id, 'Tableau_CRM_Plus_User_CommunityGoup' );
                            
                        }else if(profileidmap.get(u.profileid)=='InternalUser' || profileidmap.get(u.profileid)=='FieldLinkUser'){
                            
                            mapTableau_CRMUserPer.put(u.Id, 'Tableau_CRM_Plus_User' );
                        }
                    }else if(!NewMap.get(u.Id).Tableau_CRM_Permission_FLG__C){
                       
                        if(profileidmap.get(u.profileid)=='PartnerCommunityUser'  || profileidmap.get(u.profileid)=='HELMSITAdmin'){
                            
                            removePermissionsetgroup.put(u.Id, 'Tableau_CRM_Plus_User_CommunityGoup , HELMSReportingOnly' );
                            removePermissionsetgroup.put(u.Id, 'HELMSReportingOnly' );
                        }else if(profileidmap.get(u.profileid)=='InternalUser' || profileidmap.get(u.profileid)=='FieldLinkUser'){
                            
                            removePermissionsetgroup.put(u.Id, 'Tableau_CRM_Plus_User');
                        }
                        
                    }
                    
                    
                }
                if(tabulUserMap.Containskey(u.Id)){
                            
                    mapTableau_CRMUserPer.put(u.Id, 'Tableau_CRM_Plus_User_CommunityGoup' );
                }
                    
                if(profileidmap.get(u.profileid)=='PartnerCommunityUser' && !tabulUserMap.Containskey(u.Id) &&  RemovetabulUserMap.Containskey(u.Id)){
                    
                    removePermissionsetgroup.put(u.Id, 'Tableau_CRM_Plus_User_CommunityGoup , HELMSReportingOnly' );
                    
                }
            }
            
        }
        
        if(mapTableau_CRMUserPer.size()>0){     
            HELMSCRMEligibleHandler.updateUserPermissions(mapTableau_CRMUserPer);
        }
        if(removePermissionsetgroup.size()>0){  
            HELMSCRMEligibleHandler.RemovePermissionSetGroup(removePermissionsetgroup);
        }
    }
    
  @future   
    public static void RemovePermissionSetGroup(Map<ID , String> ConMap){
        
        try{
            
            Set<String> psnameSet = new Set<String>();
            for(ID uid : ConMap.keySet() ){
                string s = ConMap.get(uid) ;
                if( s.contains(',')){
                    String[] pnames = s.split(',');
                    for(String ps : pnames ){                       
                        psnameSet.add(ps.trim());
                    }
                }else{
                    psnameSet.add((ConMap.get(uid)).trim());
                }
            }
            
            List<PermissionSetAssignment> assignmentList = new List<PermissionSetAssignment>();
            Map<String , String > pmap = new Map<String , String >();
            
            for(PermissionSetGroup pg :[SELECT Id,DeveloperName from PermissionSetGroup where DeveloperName IN :psnameSet]){
                pmap.put(pg.DeveloperName , pg.id);
            }
            
           
            If (pmap.size()>0){
                delete [SELECT Id from PermissionSetAssignment WHERE PermissionSetGroupId IN : pmap.values() AND AssigneeId IN :ConMap.keyset()];
                
            }
        }Catch(Exception ex){
            //System.debug('Exception at line : '+ ex.getLineNumber());
            //System.debug('Exception Message : '+ ex.getMessage());
            
        }
        
        
    }
   
    
  // logic added for Dealer visibility to Opportunity Score LMS-2839., design-3982 by Sujatha Bandi.  
  
    public static void AssignPermissionSetToUser(List<contact> conList, Map<Id,Contact> conOldmap, boolean isInsert, boolean isUpdate){
       
        set<Id> addconSet = new Set<Id>();
        set<Id> removeconSet = new Set<Id>();
        
        for (Contact con :conList) {
        
            if((isInsert && con.ViewOpportunityScore_FLG__c==false) || ( isUpdate && con.ViewOpportunityScore_FLG__c!= conOldmap.get(con.Id).ViewOpportunityScore_FLG__c&& con.ViewOpportunityScore_FLG__c==false)){
                removeconSet.add(con.Id);
            }
            
            if((isInsert && con.ViewOpportunityScore_FLG__c==true) || ( isUpdate && con.ViewOpportunityScore_FLG__c!= conOldmap.get(con.Id).ViewOpportunityScore_FLG__c&& con.ViewOpportunityScore_FLG__c==true)){
                addconSet.add(con.Id);
            }
            
            //System.debug('Inside con.ViewOpportunityScore_FLG__c-->'+con.ViewOpportunityScore_FLG__c);
            
        }
        Map<ID , String> ConOppScoreMap = new Map<ID , String>();
        if(addconSet.size()>0){
            //AssignPermissionSetToUser(addconSet); 
            for(User conDealertMap: [SELECT id,ContactId from user where ContactId IN: addconSet and IsActive=true]){
                ConOppScoreMap.put(conDealertMap.id , label.HELMS_Opportunity_Score_Visibility );
            }
            
            if(ConOppScoreMap.size()>0 ){
                HELMSCRMEligibleHandler.updateUserPermissions(ConOppScoreMap);
            }
            
        } 
        
        Map<ID , String> ConOppScoreRemoveMap = new Map<ID , String>();
        if(removeconSet.size()>0){
            //RemovePermissionSet(removeconSet); 
            for(User conDealertMapRem: [SELECT id,ContactId from user where ContactId IN: removeconSet]){
                ConOppScoreRemoveMap.put(conDealertMapRem.id , label.HELMS_Opportunity_Score_Visibility );
            }
            
             if(ConOppScoreRemoveMap.size()>0){  
                HELMSCRMEligibleHandler.RemovePermissionSetGroup(ConOppScoreRemoveMap);
            }
            
        } 
    } 

    /*
    @future
    public static void AssignPermissionSetToUser(set<Id> conList){
        try{
            string permSetId = [SELECT Id,Name FROM PermissionSet WHERE Name =:label.Opportunity_Score_Visibility_To_User LIMIT 1].Id;
                        
            List<PermissionSetAssignment> PSA = new List<PermissionSetAssignment>();
            for(User conDealertMap: [SELECT id,ContactId from user where ContactId IN: conList]){
                PermissionSetAssignment cubes = new PermissionSetAssignment();
                cubes.AssigneeId=conDealertMap.Id;
                cubes.PermissionSetId=permSetId;
                PSA.add(cubes);
            }
            
            if(PSA.size()>0){
                //upsert PSA;
                Database.upsert(PSA , false);
            }
        }catch(Exception ex){
            system.debug('Exception-->'+ex.getMessage()+'Error Line Number-->'+ex.getLineNumber());
        }
    }
    @future   
    public static void RemovePermissionSet(set<Id> conList){
        try{
           
            string permSetId = [SELECT Id,Name FROM PermissionSet WHERE Name =:label.Opportunity_Score_Visibility_To_User LIMIT 1].Id;
            set<Id> removePermUserSet = new Set<Id>();
                        
            for(User conDealertMap: [SELECT id,ContactId from user where ContactId IN: conList]){
                removePermUserSet.add(conDealertMap.Id);
            }
            
            if(removePermUserSet.size()>0){
                List<PermissionSetAssignment> PSAList= [SELECT Id from PermissionSetAssignment WHERE PermissionSetId = :permSetId AND AssigneeId IN :removePermUserSet];    
                if(PSAList.size()>0){
                    Delete PSAList;
                }
            }
        }catch(Exception ex){
            system.debug('Exception-->'+ex.getMessage()+'Error Line Number-->'+ex.getLineNumber());
        } 
    }
    */  
    
    
}