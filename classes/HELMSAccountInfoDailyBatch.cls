/*This Class is used to update Active Division Field on Account based on Related Dealer Subdivision Record with Divison 
Field & SalesZone Field values concate and update */
public class HELMSAccountInfoDailyBatch implements Database.Batchable<sobject>,Schedulable {
	//Start Method - Query to Fetch all Dealer Account Records
    public Database.QueryLocator start(Database.BatchableContext bc){
        string query='select id,Active_Divisions__c,DealerCRMVendor_TXT__c from Account where RecordType.DeveloperName =\'Dealer\' ';
        return Database.getQueryLocator(query);  
    }
    //Execute Method - Getting Dealer Participation & Divisions Records
    public void execute(Database.BatchableContext bc,List<Account> scope){
        try{
            List<Account> updateaccountlist= new List<Account>();
            /*
            List<Dealer_Division__c> activedivisionlst = new List<Dealer_Division__c>([Select id,Division_CD__c from Dealer_Division__c where Dealer_ID__c IN:Scope and 	isActive_FLG__c=true ]);
            List<Dealer_Participation__c> activedlrparticipationlst = new List<Dealer_Participation__c>([Select id from Dealer_Participation__c where 	DealerAccount_ID__c IN:Scope and Is_Active__c=true ]);
            Map<id,List<Dealer_Division__c>> accountdivMap = new Map<id,List<Dealer_Division__c>>();
            Map<id,List<Dealer_Participation__c>> accountdlrpartMap = new Map<id,List<Dealer_Participation__c>>();
            for (Dealer_Division__c div :activedivisionlst){
                if(accountdivMap.containsKey(div.Dealer_ID__c)){
                    accountdivMap.get(div.Dealer_ID__c).add(div);
                }
                else{
                    accountdivMap.put(div.Dealer_ID__c,new List<Dealer_Division__c> {div});
                    accountdivMap.get(div.Dealer_ID__c).add(div);
                }
            }
            for (Dealer_Participation__c dpt :activedlrparticipationlst){
                if(accountdlrpartMap.containsKey(dpt.DealerAccount_ID__c)){
                    accountdlrpartMap.get(dpt.DealerAccount_ID__c).add(dpt);
                }
                else{
                    accountdlrpartMap.put(dpt.DealerAccount_ID__c,new List<Dealer_Participation__c> {dpt});
                    accountdlrpartMap.get(dpt.DealerAccount_ID__c).add(dpt);
                }
            }
            */
            List<Dealer_Division__c> activedivisionlst = new List<Dealer_Division__c>([Select id,Division_CD__c,SalesZone_CD__c,Dealer_ID__c from Dealer_Division__c where Dealer_ID__c IN:scope and isActive_FLG__c=true order by createddate]);
            List<Dealer_Participation__c> activedlrparticipationlst = new List<Dealer_Participation__c>([Select id,CRM_System__r.name,DealerAccount_ID__c from Dealer_Participation__c where 	DealerAccount_ID__c IN:scope and Is_Active__c=true order by createddate]);
            Map<id,List<string>> accountdivMap = new Map<id,List<string>>();
            Map<id,List<string>> accountdlrpartMap = new Map<id,List<string>>();
            for (Dealer_Division__c div :activedivisionlst){
                if(accountdivMap.containsKey(div.Dealer_ID__c)){
                    accountdivMap.get(div.Dealer_ID__c).add(div.Division_CD__c+div.SalesZone_CD__c);
                }
                else{
                    accountdivMap.put(div.Dealer_ID__c,new List<string> {div.Division_CD__c+div.SalesZone_CD__c});
                    //accountdivMap.get(div.Dealer_ID__c).add(div.Division_CD__c + div.SalesZone_CD__c);
                }
            }
            
            for (Dealer_Participation__c dpt :activedlrparticipationlst){
                if(accountdlrpartMap.containsKey(dpt.DealerAccount_ID__c)){
                    accountdlrpartMap.get(dpt.DealerAccount_ID__c).add(dpt.CRM_System__r.name);
                }
                else{
                    accountdlrpartMap.put(dpt.DealerAccount_ID__c,new List<string> {dpt.CRM_System__r.name});
                    //accountdlrpartMap.get(dpt.DealerAccount_ID__c).add(dpt);
                }
            }
            
            for(Account acc: Scope){
                string activedivisions='';
                string activedlrparticipations='';
                boolean changeflag=false;
                if(accountdivMap.get(acc.id)!=null){
                    activedivisions=string.join(accountdivMap.get(acc.id),',');
                }
                if(accountdlrpartMap.get(acc.id)!=null){
                    activedlrparticipations=string.join(accountdlrpartMap.get(acc.id),',');
                }
                //system.debug('Active divisions='+activedivisions);
                //system.debug('Active CRM Names='+activedlrparticipations);
                if(acc.Active_Divisions__c!=activedivisions){
                    acc.Active_Divisions__c=activedivisions;
                    changeflag=true;
                }
                if( acc.DealerCRMVendor_TXT__c!=activedlrparticipations){
                    acc.DealerCRMVendor_TXT__c=activedlrparticipations;
                    changeflag=true;
                }
                if(changeflag){
                    updateaccountlist.add(acc);    
                }
            }
            if(updateaccountlist.Size()>0){
            Database.update(updateaccountlist); 
            }
        }Catch(exception ex){
            Logs__c  l =new Logs__c (name='HELMSAccountInfoDailyBatch',Trigger_or_Class_Name__c='HELMSAccountInfoDailyBatch', Error_Message__c =ex.getMessage(), Error_Line_Number__c =Integer.valueOf(string.valueof(ex.getLineNumber() )) );
            insert l;
            
        }
        
    }
    //Finish Method
    public void finish(Database.BatchableContext bc){
        
    }
    //Executing the Batch Job
    public void execute(SchedulableContext sc){
        HELMSAccountInfoDailyBatch cs= new HELMSAccountInfoDailyBatch();
        id jobID=Database.executebatch(cs);
        
    }

}