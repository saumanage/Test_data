global class HELMSOpportunityRoutingDispositionBatch implements Database.Batchable<sObject>,Database.Stateful,Schedulable{
    
    global final string query;
    
    global HELMSOpportunityRoutingDispositionBatch(){
               
    }
    global HELMSOpportunityRoutingDispositionBatch(string query){
        this.query=query;
        
    }
    
    // Start Method
    global Database.QueryLocator start(Database.BatchableContext BC) {
          
        /*
        String query = 'Select id,Name,Arrival_Time_DT_c__c,Auto_Response__c,Current_Status__c,  HELMS_Opportunity_External_Key__c, OwnerId,The_Last_Event__c from Routing_Dealer_CRM_Disposition__c';
        system.debug(' Inside start method $$ '+query);
        */
        return Database.getQueryLocator(query);

    }

    // Execute method
    global void execute(Database.BatchableContext BC, List<Routing_Dealer_CRM_Disposition__c> newOppotunityEnrichmentRes) {
        //System.debug(' inside execute method ');
        try{ 
            Map<String,Routing_Dealer_CRM_Disposition__c> OppEnMap = new Map<String,Routing_Dealer_CRM_Disposition__c>();
            Map<Id, Opportunity> mapOpportunity = new Map<Id, Opportunity>();
            Map<String, Disposition_code__mdt> mapDispCode = new Map<String, Disposition_code__mdt>();
            List<Logs__c> insertLogs = new List<Logs__c>();
            List<Task> insertTasks = new List<Task>();
        
            List<Routing_Dealer_CRM_Disposition__c> DispoProcessedUpdate =new List<Routing_Dealer_CRM_Disposition__c>(); 
            // store the Opportunity external key and Dealer CRM Disposition Record in to map.   
            for (Routing_Dealer_CRM_Disposition__c OppEnriRes : newOppotunityEnrichmentRes){
                  //changes Start HPT-340/HPT-353 - GLavanya
              /*  if(OppEnriRes.HELMS_Opportunity_External_Key__c!=null){
                    //OpptyIdsSet.add(OppEnriRes.HELMS_Opportunity_External_Key_TXT__c);
                    OppEnMap.put(OppEnriRes.HELMS_Opportunity_External_Key__c, OppEnriRes);
                    OppEnriRes.Is_Processed_Job__c = true ;
                    DispoProcessedUpdate.add(OppEnriRes);
                }*/
                
                 if (!OppEnMap.containsKey(OppEnriRes.HELMS_Opportunity_External_Key__c) || 
                    OppEnriRes.CreatedDate > OppEnMap.get(OppEnriRes.HELMS_Opportunity_External_Key__c).CreatedDate) {
                        OppEnMap.put(OppEnriRes.HELMS_Opportunity_External_Key__c, OppEnriRes);
                    }

                OppEnriRes.Is_Processed_Job__c = true;
               DispoProcessedUpdate.add(OppEnriRes);
            }
              //changes End HPT-340/HPT-353 - GLavanya
            List<Opportunity> updateOpportunity = new List<Opportunity>();
            List<Disposition_code__mdt> listDispCodes = [Select Id, MasterLabel,DeveloperName, Oppty_Stage__c, Oppty_Status__c from Disposition_code__mdt];
             
            //Store the Dispostion Code masterlabel and Dispostion code record into map. 
            for(Disposition_code__mdt dCode : listDispCodes){
               mapDispCode.put(dCode.MasterLabel, dCode);
            }
        
            if(OppEnMap.size()>0){
                        
                //Get Opportunity records by using OppEnMap keyset.
                for (Opportunity opp : [Select id,Name,StageName,Response_Date_Time__c,Routing_Status_Message__c,RoutedDateTime__c,OpportunityStatus_TXT__c,Opportunity_SF_ID__c,Routing_Status__c,Disposition_Started__c,Routing_Success_Date_Time__c from Opportunity where Opportunity_SF_ID__c IN:OppEnMap.keyset()]){
                    
                    // Check whether the map oppEnMap contains this Opportunity SF ID.       
                    if(OppEnMap!=null && OppEnMap.containskey(opp.Opportunity_SF_ID__c)){
                        
                    //Set Opportunity Stage name based on the LastEvent TXT.  
                        if(OppEnMap.get(opp.Opportunity_SF_ID__c).The_Last_Event__c != null && mapDispCode.containskey(OppEnMap.get(opp.Opportunity_SF_ID__c).The_Last_Event__c) ){
                            
                            if(mapDispCode.get(OppEnMap.get(opp.Opportunity_SF_ID__c).The_Last_Event__c).Oppty_Stage__c != null){
                                opp.StageName = mapDispCode.get(OppEnMap.get(opp.Opportunity_SF_ID__c).The_Last_Event__c).Oppty_Stage__c;    
                            }
                            //Set Opportunity Staus TXT based on the LastEvent TXT.           
                            if(mapDispCode.get(OppEnMap.get(opp.Opportunity_SF_ID__c).The_Last_Event__c).Oppty_Status__c != null){
                                if(String.ValueOf(OppEnMap.get(opp.Opportunity_SF_ID__c).Auto_Response__c) == 'False' && OppEnMap.get(opp.Opportunity_SF_ID__c).The_Last_Event__c == '5' ){
                                    opp.OpportunityStatus_TXT__c = 'Lead Opened';
                                }else{
                                    opp.OpportunityStatus_TXT__c =  mapDispCode.get(OppEnMap.get(opp.Opportunity_SF_ID__c).The_Last_Event__c).Oppty_Status__c;    
                                }
                            }
                            opp.Opportunity_Received__c = false;
                            if(!opp.Disposition_Started__c){
                                opp.Disposition_Started__c = true;
                                if(opp.Routing_Status__c != 'Success'){
                                    opp.Routing_Status__c = 'Success';
                                    opp.Routing_Success_Date_Time__c = opp.RoutedDateTime__c;
                                    opp.Routing_Status_Message__c = 'Success - Based of Disposition';
                                }
                            }
                            if(OppEnMap.get(opp.Opportunity_SF_ID__c).Response_Time__c!=null && opp.Response_Date_Time__c==null && opp.StageName!='Acknowledged'){
                                opp.Response_Date_Time__c = OppEnMap.get(opp.Opportunity_SF_ID__c).Response_Time__c;
                            }
                            updateOpportunity.add(opp);  
                            
                            //Create new task.         
                            Task tas = new Task();
                            tas.Subject = mapDispCode.get(OppEnMap.get(opp.Opportunity_SF_ID__c).The_Last_Event__c).DeveloperName;
                            tas.Disposition_Code_CD__c = mapDispCode.get(OppEnMap.get(opp.Opportunity_SF_ID__c).The_Last_Event__c).MasterLabel;
                            tas.Opportunity_Stage_TXT__c = mapDispCode.get(OppEnMap.get(opp.Opportunity_SF_ID__c).The_Last_Event__c).Oppty_Stage__c;
                            if(String.ValueOf(OppEnMap.get(opp.Opportunity_SF_ID__c).Auto_Response__c) == 'False' && OppEnMap.get(opp.Opportunity_SF_ID__c).The_Last_Event__c == '5' ){
                                tas.Opportunity_Status_TXT__c = 'Lead Opened';
                            }else{
                                tas.Opportunity_Status_TXT__c = mapDispCode.get(OppEnMap.get(opp.Opportunity_SF_ID__c).The_Last_Event__c).Oppty_Status__c;
                            }
                            tas.Arrival_Time_DT__c = OppEnMap.get(opp.Opportunity_SF_ID__c).Arrival_Time_DT_c__c;
                            tas.Response_Time_TXT__c = String.ValueOf(OppEnMap.get(opp.Opportunity_SF_ID__c).Auto_Response__c);
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
                    //System.debug(' Updated updateOpportunity  $$$ :: '+updateOpportunity);
                insert insertTasks;
                    //System.debug(' Created Task :: $$$ '+insertTasks);
                for (Integer i = 0; i < updateOpportunity.size(); i++) {
                    Database.SaveResult s = results[i];
                    Opportunity origRecord = updateOpportunity[i]; 
                    if (!s.isSuccess()) {
                        for(Database.Error error : results[i].getErrors()) {
                           Logs__c  l =new Logs__c (SF_Rec_Id__c = updateOpportunity[i].Opportunity_SF_ID__c,name='Routing Disposition Update Batch',Trigger_or_Class_Name__c='HELMSOpportunityRoutingDispositionBatch', Error_Message__c =error.getMessage()
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
            
            if(DispoProcessedUpdate.size() > 0){
                update DispoProcessedUpdate;
            }
            
        
        }Catch(Exception ex){
                       
            Logs__c  l =new Logs__c (name='Routing Disposition Update Batch',Trigger_or_Class_Name__c='HELMSOpportunityRoutingDispositionBatch', Error_Message__c =ex.getMessage(), Error_Line_Number__c =Integer.valueOf(string.valueof(ex.getLineNumber() )) );
           insert l;
        } 
         
        
    }   

    // Finish Method

    global void finish(Database.BatchableContext BC) {

    }
    
    global void execute (SchedulableContext sc){
        //string query='Select id,Name,Arrival_Time_DT_c__c,Auto_Response__c,Current_Status__c,Is_Processed_Job__c,Response_Time__c, HELMS_Opportunity_External_Key__c, OwnerId,The_Last_Event__c from Routing_Dealer_CRM_Disposition__c where Is_Processed_Job__c !=true and HELMS_Opportunity_External_Key__c!=null order by CreatedDate asc';
        //changes start HPT-340/HPT-353 - GLavanya
        //string query='Select id,Name,Arrival_Time_DT_c__c,Auto_Response__c,Current_Status__c,Is_Processed_Job__c,Response_Time__c, HELMS_Opportunity_External_Key__c, OwnerId,The_Last_Event__c from Routing_Dealer_CRM_Disposition__c where Is_Processed_Job__c !=true and HELMS_Opportunity_External_Key__c!=null order by HELMS_Opportunity_External_Key__c';
        string query='Select id,Name,Arrival_Time_DT_c__c,Auto_Response__c,Current_Status__c,Is_Processed_Job__c,Response_Time__c, HELMS_Opportunity_External_Key__c, OwnerId,The_Last_Event__c,CreatedDate from Routing_Dealer_CRM_Disposition__c where Is_Processed_Job__c !=true and HELMS_Opportunity_External_Key__c!=null order by CreatedDate asc';
            //changes End HPT-340/HPT-353 - GLavanya
        HELMSOpportunityRoutingDispositionBatch DispoBatch = new HELMSOpportunityRoutingDispositionBatch(query);
        
        HELMS_Batch_Size__mdt loc = HELMS_Batch_Size__mdt.getInstance('RoutingDispositionBatchSize');
        //Id batchId = Database.executeBatch(DispoBatch,200);
        Id batchId = Database.executeBatch(DispoBatch, Integer.valueOf(loc.BatchSize__c) );
        
    }

}