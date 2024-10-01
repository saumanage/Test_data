/**** Trigger Handler Name:HELMSOpportunityResponsePEHandler
User story Number : LMS-2002/4066
SFDC will subscribe to a platform event queue to update Opportunity data.
****/
public class HELMSOpportunityResponsePEHandler {
    public static void UpdateOpportunities(List<Dealer_CRM_Disposition__e> newOppotunityEnrichmentRes) {
       
        try{            
            //Set<String> OpptyIdsSet = new Set<String>();
            // Store The  dealer CRM Platform evenet values     
            Map<String,Dealer_CRM_Disposition__e> OppEnMap = new Map<String,Dealer_CRM_Disposition__e>();
             Map<Id, Opportunity> mapOpportunity = new Map<Id, Opportunity>();
            // Store The Disposition Code Custom Meta Data Values
            Map<String, Disposition_code__mdt> mapDispCode = new Map<String, Disposition_code__mdt>();
            List<Logs__c> insertLogs = new List<Logs__c>();
            List<Task> insertTasks = new List<Task>();
            // store the Opportunity external key and Dealer CRM Disposition Record in to map.   
            for (Dealer_CRM_Disposition__e OppEnriRes : newOppotunityEnrichmentRes){
                if(OppEnriRes.HELMS_Opportunity_External_Key_TXT__c!=null){
                //OpptyIdsSet.add(OppEnriRes.HELMS_Opportunity_External_Key_TXT__c);
                OppEnMap.put(OppEnriRes.HELMS_Opportunity_External_Key_TXT__c, OppEnriRes);
                }
            }
            //System.debug(OppEnMap.keyset());
            List<Opportunity> updateOpportunity = new List<Opportunity>();
                //   Get all Disposition Code metadata records.    
             List<Disposition_code__mdt> listDispCodes = [Select Id, MasterLabel,DeveloperName, Oppty_Stage__c, Oppty_Status__c from Disposition_code__mdt];
            //     Store the Dispostion Code masterlabel and Dispostion code record into map.
            for(Disposition_code__mdt dCode : listDispCodes){
               mapDispCode.put(dCode.MasterLabel, dCode);
            }
            
            if(OppEnMap.size()>0){
                //system.debug('OppEnMap--Query---'+[Select id,Name,StageName,OpportunityStatus_TXT__c,Opportunity_SF_ID__c from Opportunity where Opportunity_SF_ID__c IN:OppEnMap.keyset()]);
                //Get Opportunity records by using OppEnMap keyset.
                 for (Opportunity opp : [Select id,Name,StageName,OpportunityStatus_TXT__c,Opportunity_SF_ID__c from Opportunity where Opportunity_SF_ID__c IN:OppEnMap.keyset()]){
                    // Check whether the map oppEnMap contains this Opportunity SF ID.       
                    if(OppEnMap!=null && OppEnMap.containskey(opp.Opportunity_SF_ID__c)){
                    //Set Opportunity Stage name based on the LastEvent TXT.  
                        if(OppEnMap.get(opp.Opportunity_SF_ID__c).The_Last_Event_TXT__c != null && mapDispCode.containskey(OppEnMap.get(opp.Opportunity_SF_ID__c).The_Last_Event_TXT__c) ){
                            if(mapDispCode.get(OppEnMap.get(opp.Opportunity_SF_ID__c).The_Last_Event_TXT__c).Oppty_Stage__c != null){
                                opp.StageName = mapDispCode.get(OppEnMap.get(opp.Opportunity_SF_ID__c).The_Last_Event_TXT__c).Oppty_Stage__c;    
                            }
                            //Set Opportunity Staus TXT based on the LastEvent TXT.           
                            if(mapDispCode.get(OppEnMap.get(opp.Opportunity_SF_ID__c).The_Last_Event_TXT__c).Oppty_Status__c != null){
                                if(String.ValueOf(OppEnMap.get(opp.Opportunity_SF_ID__c).Auto_Response_TXT__c) == 'False' && OppEnMap.get(opp.Opportunity_SF_ID__c).The_Last_Event_TXT__c == '5' ){
                                    opp.OpportunityStatus_TXT__c = 'Lead Opened';
                                }else{
                                    opp.OpportunityStatus_TXT__c =  mapDispCode.get(OppEnMap.get(opp.Opportunity_SF_ID__c).The_Last_Event_TXT__c).Oppty_Status__c;    
                                }
                            }
                            opp.Opportunity_Received__c = false;
                            updateOpportunity.add(opp);  
                            
                            //Create new task.         
                            Task tas = new Task();
                            tas.Subject = mapDispCode.get(OppEnMap.get(opp.Opportunity_SF_ID__c).The_Last_Event_TXT__c).DeveloperName;
                            tas.Disposition_Code_CD__c = mapDispCode.get(OppEnMap.get(opp.Opportunity_SF_ID__c).The_Last_Event_TXT__c).MasterLabel;
                            tas.Opportunity_Stage_TXT__c = mapDispCode.get(OppEnMap.get(opp.Opportunity_SF_ID__c).The_Last_Event_TXT__c).Oppty_Stage__c;
                            if(String.ValueOf(OppEnMap.get(opp.Opportunity_SF_ID__c).Auto_Response_TXT__c) == 'False' && OppEnMap.get(opp.Opportunity_SF_ID__c).The_Last_Event_TXT__c == '5' ){
                                tas.Opportunity_Status_TXT__c = 'Lead Opened';
                            }else{
                                tas.Opportunity_Status_TXT__c = mapDispCode.get(OppEnMap.get(opp.Opportunity_SF_ID__c).The_Last_Event_TXT__c).Oppty_Status__c;
                            }
                            tas.Arrival_Time_DT__c = OppEnMap.get(opp.Opportunity_SF_ID__c).Arrival_Time_DT__c;
                            tas.Response_Time_TXT__c = String.ValueOf(OppEnMap.get(opp.Opportunity_SF_ID__c).Auto_Response_TXT__c);
                            tas.Status = HELMSConstants.Completed;
                            tas.Priority = HELMSConstants.Normal;
                            tas.Type = HELMSConstants.Other;
                            tas.WhatId = opp.Id;
                            insertTasks.add(tas);
                        }
                    }       
                }
            }
            if(updateOpportunity.size()>0 && insertTasks.Size()>0){
                Database.SaveResult[] results = Database.update(updateOpportunity,false);
                insert insertTasks;
                for (Integer i = 0; i < updateOpportunity.size(); i++) {
                    Database.SaveResult s = results[i];
                    Opportunity origRecord = updateOpportunity[i]; 
                    if (!s.isSuccess()) {
                        for(Database.Error error : results[i].getErrors()) {
                           Logs__c  l =new Logs__c (PE_Reply_Id__c=(OppEnMap.get(updateOpportunity[i].Opportunity_SF_ID__c)).ReplayId, SF_Rec_Id__c = updateOpportunity[i].Opportunity_SF_ID__c,name='Opportunity Enrichment Response PE- Reply Id: '+(OppEnMap.get(updateOpportunity[i].Opportunity_SF_ID__c)).ReplayId,Trigger_or_Class_Name__c='HELMSOpportunityEnrichmentResponsePEHandler', Error_Message__c =error.getMessage()
                           //, Error_Fields__c =string.valueof(error.getFields() )  
                           );
                           insertLogs.add(l); 
                        } 
                    }
                }
            }
            if(insertLogs.size() > 0){
                insert insertLogs;
            }
              
         }Catch(Exception ex){
                       
            Logs__c  l =new Logs__c (name='Opportunity Enrichment Response PE- Trigger Handler',Trigger_or_Class_Name__c='HELMSOpportunityEnrichmentResponsePEHandler', Error_Message__c =ex.getMessage(), Error_Line_Number__c =Integer.valueOf(string.valueof(ex.getLineNumber() )) );
           insert l;
        }    
    }         
}