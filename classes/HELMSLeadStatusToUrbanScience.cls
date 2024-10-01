public with sharing class HELMSLeadStatusToUrbanScience {
    @testVisible public static List<Sending_Lead_Status_To_Urban_Science__e> listUrbanEvents = new List<Sending_Lead_Status_To_Urban_Science__e>();
    public static void sendLeadStatus(List<Lead> listLead){
        //List<Sending_Lead_Status_To_Urban_Science__e> listUrbanEvents = new List<Sending_Lead_Status_To_Urban_Science__e>();
        for(Lead l : listLead){
            Sending_Lead_Status_To_Urban_Science__e ubEvent = new Sending_Lead_Status_To_Urban_Science__e();
            //ubEvent.Reason_For_Rejection__c = l.StatusReason_TXT__c;
            
            if(l.Is_Duplicate_Similar_Lead__c == true){
                ubEvent.Reason_For_Rejection__c =  HELMSConstants.Dupsim;
            }else if(l.Is_Third_Party_Duplicate_Lead__c == true){
                ubEvent.Reason_For_Rejection__c =  HELMSConstants.TPD;
            }
            ubEvent.External_Reference_ID__c = l.External_Lead_Reference_Number__c;
            //system.debug ('==============>'+ubEvent.Reason_For_Rejection__c);
            //system.debug ('==============>'+ubEvent.External_Reference_ID__c);
      //      ubEvent.Acknowledge_Duplicate_Error_Details__c = l.Sent_to_Urban_Science_Status__c;
     //       ubEvent.Acknowledge_Duplicate_Rejection_Status__c = l.Error_Details_Urban_Science__c;
            listUrbanEvents.add(ubEvent);
        }
        try{
            If(listUrbanEvents.Size() > 0){
                List<Database.SaveResult> results = EventBus.publish(listUrbanEvents);
            }  
        }Catch(Exception ex){           
            Logs__c  l =new Logs__c (name='HELMSLeadStatusToUrbanScience- Trigger Handler',Trigger_or_Class_Name__c='HELMSLeadStatusToUrbanScience', Error_Message__c =ex.getMessage(), Error_Line_Number__c =Integer.valueOf(string.valueof(ex.getLineNumber() )) );
            insert l;
        }    
    }
}