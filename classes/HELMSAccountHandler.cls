/****User story Number : LMS-1743/1759****/
public class HELMSAccountHandler{
    Public static boolean dealerUserActivate =false;
    /****User story Number : LMS-1743/1759****/
    @future
    //Fetching Active Users
    public static void handleAccountUpdate(List<Id> accountIds){
        try{
            List<User> users = [SELECT Id, IsActive FROM User WHERE Contact.AccountId IN :accountIds];
            List<User> usersToUpdate = new List<User>();
            for(User u : users){
                if(u.IsActive){
                    u.IsActive = false;
                    usersToUpdate.add(u);
                }
            }
            if(!usersToUpdate.isEmpty() && usersToUpdate.size() > 0){
                dealerUserActivate = true;
                //System.debug('as4 ');
                update usersToUpdate;
            }
        }Catch(Exception ex){
            /*          
            Logs__c l = new Logs__c(name = 'Account- handleAccountUpdate', Trigger_or_Class_Name__c = 'HELMSAccountHandler', Error_Message__c = ex.getMessage(), Error_Line_Number__c = Integer.valueOf(string.valueof(ex.getLineNumber())));
            insert l;
            */
        }
    }

    @future
        /* User story Number : LMS-2510
If active users already exist, remove all Perm set groups, leaving profile only. Find all users where user.contact.accountid = :account and isactive = true
Remove all permission sets and permission set groups Keep Einstein PS as needed for KPI dashboard and reporting
*/
    public static void processReportOnlyAccounts(List<Id> accountIds){
        //System.debug('Account Ids : '+accountIds);
        try{
            List<PermissionSetAssignment> pSAToDelete = new List<PermissionSetAssignment>();
            
            
            
            Set<String> perGropSet = new Set<String>();
            for(Remove_Reporting_Dealer_Permission_sets__mdt perGrop: [select id,Permission_Set_Group_API_Name__c from Remove_Reporting_Dealer_Permission_sets__mdt]){
                perGropSet.add(perGrop.Permission_Set_Group_API_Name__c);
            }
            
            
            
            // Remove Dealer related permission set groups for Reporting Only dealer user
            //List<PermissionSetAssignment> PermissionSetUsers = [Select Id, PermissionSetId,PermissionSetGroupId,AssigneeId FROM PermissionSetAssignment WHERE Assignee.IsActive = True AND (Assignee.Contact.AccountId IN : accountIds) AND (PermissionSet.Name IN : perGropSet) ];
            
            List<PermissionSetAssignment> permissionSetUsers = [Select Id, PermissionSetId,PermissionSetGroupId,AssigneeId FROM PermissionSetAssignment WHERE (Assignee.Contact.AccountId IN : accountIds) AND (PermissionSet.Name IN : perGropSet) ];
            
           
            for(PermissionSetAssignment psa : permissionSetUsers){
                pSAToDelete.add(psa);               
                
            }
            if(!pSAToDelete.isEmpty() ){
                Delete pSAToDelete;
            }
        }Catch(Exception ex){
            
            Logs__c l = new Logs__c(name = 'Account- processReportOnlyAccounts', Trigger_or_Class_Name__c = 'HELMSAccountHandler', Error_Message__c = ex.getMessage(), Error_Line_Number__c = Integer.valueOf(string.valueof(ex.getLineNumber())));
            insert l;
        }
    }
    
    
    
    //match account dealer code to lead preferred dealer number and relate matched lead with the account - LMS-2837 - Hruthik
    public static void dealerB2CMapping(List<Account> newAccountList){
        try{
            //system.debug('===b2cmapping');
            Id delaerRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Dealer').getRecordTypeId();//
            Id providerRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider').getRecordTypeId();
            List<Lead> leadList = new List<Lead>();//To Update Lead Records
            Map<String, Id> accountMap = new Map<String, Id>();//To Store DealerCode_CD__c and AccountId
            //Map<String, Id> Providermap = new Map<String, Id>();
            Map<String, Id> accountProviderMap = new Map<String, Id>();
            //Map<string, List<Lead>> leadProviderMap = new Map<string, List<Lead>>();
            //List<Lead> llist = new List<Lead>();
            //List<Lead> listtemp = new List<Lead>();
            List<String>accNameList = new List<String>();
            for(Account acc : newAccountList){//Iterate through newely created Accounts
                if(acc.RecordTypeId == delaerRecordTypeId && acc.DealerCode_CD__c != null){//Condition for Dealer RecordType
                    accountMap.put(acc.DealerCode_CD__c, acc.Id);//Add DealerCode_CD__c and AccountId
                
                }                
                if(acc.RecordTypeId == providerRecordTypeId && acc.Name != null  ){//&&leadProviderMap.containsKey((acc.Name).toLowerCase())
                      accountProviderMap.put((acc.Name).toLowerCase(),acc.Id);
                   /* for(Lead ld : leadProviderMap.get((acc.Name).toLowerCase())){
                       
                         ld.LeadProvider_ID__c=acc.Id;
                        leadList.add(ld);
                    }*/
                    
                }
            }
            if(accountProviderMap.size()>0){
            List<Lead> leadListProvider =[select id,ProviderDetail_TXT__c,LeadProvider_ID__c from Lead where ProviderDetail_TXT__c != null AND LeadProvider_ID__c = null AND IsConverted=false limit 50000 ];
            //system.debug('===leadListProvider'+leadListProvider);
            for(Lead leadRec : leadListProvider ){
                if(leadRec.ProviderDetail_TXT__c!=null){
                    string providename = leadRec.ProviderDetail_TXT__c;
                    if(providename.contains(':')){
                        String[] pdn1 = providename.split(':');
                    
                        if(pdn1[0]!=null && accountProviderMap.containsKey(pdn1[0].toLowerCase())){
                                leadRec.LeadProvider_ID__c = accountProviderMap.get(pdn1[0].toLowerCase());
                            leadList.add(leadRec);
                        }
                           }
                        else if(accountProviderMap.containsKey(leadRec.ProviderDetail_TXT__c.toLowerCase())){
                            leadRec.LeadProvider_ID__c = accountProviderMap.get(leadRec.ProviderDetail_TXT__c.toLowerCase());
                       
                       leadList.add(leadRec);
                     }
                }}
            }
            if(accountMap.size()>0){
            for(Lead l : [SELECT Id, PreferredDealerAccount_ID__c,PreferredDealerNumber_NUM__c
                          FROM Lead
                          WHERE PreferredDealerNumber_NUM__c IN : accountMap.keySet()
                          AND IsConverted = false])//Get Leads where PreferredDealerNumber_NUM__c present in accountMap and IsConverted is false
            {
                if(accountMap.containsKey(l.PreferredDealerNumber_NUM__c)){//If Map contains lead.PreferredDealerNumber_NUM__c
                    l.PreferredDealerAccount_ID__c = accountMap.get(l.PreferredDealerNumber_NUM__c);//Update PreferredDealerAccount_ID__c in Lead
                    leadList.add(l);
                }
            }
            
            }
            if(!leadList.isEmpty()){
                Update leadlist;//Update Lead List
                 //system.debug('===leadlist'+leadlist);
            }
            
         }Catch(Exception ex){
            Logs__c l = new Logs__c(name = 'Account- dealerB2CMapping', Trigger_or_Class_Name__c = 'HELMSAccountHandler', Error_Message__c = ex.getMessage(), Error_Line_Number__c = Integer.valueOf(string.valueof(ex.getLineNumber())));
            insert l;
        }
    }
     /*  //5497
         public static void concierge(List<Account> newAccountList){
          set<id> accids = new set<id> ();
          List<Lead> updatedList = new List<Lead>();
            
          for(Account acc:newAccountList){
              system.debug(' inside for loop :'+acc);
              if(acc.Is_Concierge_Process_Needed__c == true){
                  
                  accids.add(acc.Id);
                }
              
            }
          
             //here we are taking the lead ids which provider account has Is_Concierge_Process_Needed__c = true and we are making the related lead status and 
             // status reason to Manual Validation and Concierge
          List<Lead> newlist = [select id,Name,LeadProvider_ID__c,Status,StatusReason_TXT__c from Lead where LeadProvider_ID__c=:accids ];
          
          
          for(Lead newLead : newlist){
              system.debug('inside lead for loop :'+newLead);
             if(newLead.Status=='Nurturing'){
                 
                 newLead.StatusReason_TXT__c='Concierge';
                 updatedList.add(newLead);
                 
                }
             
            }
            
            if(updatedList.size()>0){
                update updatedList;
                system.debug('updatedList : '+updatedList);
            }
      
        }
    
    */
    
}