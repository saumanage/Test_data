/**** Opp Trigger Handler Name;HELMSPlatformEventLeadDisposition
User story Number : LMS-1553
SFDC will publish to a platform event queue for any Opportunity disposition data
****/
public class HELMSPlatformEventLeadDisposition{
    List<Lead_Disposition__e> publishEvents = new List<Lead_Disposition__e>();
    public void newLeadDispositionADFs(List<Opportunity> opty , Map<Id, Opportunity> oldMap , Boolean isInsert, Boolean isUpdate){
        try{
            Map<String,Lead_Disposition_Last_Event_Status__c> custom = new Map<string,Lead_Disposition_Last_Event_Status__c>();
            List<Lead_Disposition_Last_Event_Status__c> leadDis = Lead_Disposition_Last_Event_Status__c.getall().values();
                     
            for(Opportunity opp : opty){
                if(opp.External_ID__c!=null){
                    if( (isInsert && opp.StageName!=null) || (isUpdate && opp.StageName!=null && ((oldMap.get(opp.id)!=null && opp.StageName != oldMap.get(opp.id).StageName) || (oldMap.get(opp.id)!=null && opp.OpportunityStatus_TXT__c != oldMap.get(opp.id).OpportunityStatus_TXT__c) ))) {
                        Lead_Disposition__e eve = new Lead_Disposition__e();
                        eve.ArrivalTime_DT__c = opp.CreatedDate;
                        eve.AutoResponse_FLG__c = true ;
                        eve.Id_TXT__c = opp.External_ID__c ;                
                        eve.ResponseTime_DT__c = opp.LastModifiedDate ; 
                        
                        for(Lead_Disposition_Last_Event_Status__c sc:leadDis){
                            if((sc.StageName__c!=null && sc.StageName__c==opp.StageName && sc.Status__c!=null && sc.Status__c==opp.OpportunityStatus_TXT__c) || (sc.StageName__c!=null && sc.StageName__c==opp.StageName && sc.Status__c==null )){
                                eve.CurrentStatus_NM__c = sc.CurrentStatus__c ;  
                                eve.LastEvent_NM__c = sc.Last_Event__c ;
                                publishEvents.add(eve); 
                            }       
                                                     
                        }
                        
                                    
                        //publishEvents.add(eve); 
                    }
                }
            }    
            if(publishEvents.size()>0){
                //EventBus.publish(publishEvents);
                System.debug('--publish Lead disposition event---');
                
                
                // Call method to publish events
                List<Database.SaveResult> results = EventBus.publish(publishEvents);

                // Inspect publishing result for each event
                for (Database.SaveResult sr : results) {
                    if (sr.isSuccess()) {
                        System.debug('Successfully published event.');
                    } else {
                        for(Database.Error err : sr.getErrors()) {
                            System.debug('Error returned: ' +
                                        err.getStatusCode() +
                                        ' - ' +
                                        err.getMessage());
                            Logs__c  l =new Logs__c (name='Lead Disposition ADF- Trigger Handler',Trigger_or_Class_Name__c='HELMSPlatformEventLeadDisposition', Error_Message__c =err.getMessage() );
                            insert l;
                        }
                    }       
                }


            }
        
        }Catch(Exception ex){
            System.debug('Exception at line : '+ ex.getLineNumber());
            System.debug('Exception Message : '+ ex.getMessage());
            
            Logs__c  l =new Logs__c (name='Lead Disposition ADF- Trigger Handler',Trigger_or_Class_Name__c='HELMSPlatformEventLeadDisposition', Error_Message__c =ex.getMessage(), Error_Line_Number__c =Integer.valueOf(string.valueof(ex.getLineNumber() )) );
           insert l;
        }   
    }
    
}