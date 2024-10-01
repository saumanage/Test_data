/*----------------------------------------------------------------------------------------------------------------------------------------------------
Class Name : HELMSOpptystageandstatusonTaskandevent 
Test Class Name : HELMSOpptyStageStatusTestClass
Last Modified Version Owner : Grandhi Lavanya
Comments : Code to update opportuntiy status and stage when task or event or log a call. these options are available in activity section - LMS-4612-R4.2
-------------------------------------------------------------------------------------------------------------------------------------------------------
*/
public class HELMSOpptystageandstatusonTaskandevent {
      /*updateopptyStageandStatusforTask - if we created any task in partner comunity, opportunity stages will update automatically. */
    public static void updateopptyStageandStatusforTask(List<Task> taskList){
    
        set<Id> oppIds = new Set<Id>();
        List<Opportunity> oppty = new List<Opportunity>();  
        
        for(Task t : taskList){
           //  system.debug('t:'+t);
          String wId = t.whatId;
          if(wId!=null && wId.startsWith('006') && t.Subject != null ){
            oppIds.add(t.whatId);
          }
        }
       
        List<Opportunity> opps = [select Id,StageName, OpportunityStatus_TXT__c, SubDiv_TXT__c from opportunity where id in: oppIds];
     //   system.debug('opps:'+opps);
          
        for(Opportunity opp : opps){
            for(Task ta : taskList){
               
                if(ta.Subject == HELMSConstants.inboundCall )
                {
                    if((opp.stageName == HELMSConstants.Acknowledged || opp.stageName == HELMSConstants.Assigned_to_Dealer ||
                        opp.stageName == HELMSConstants.In_Conversation) && opp.OpportunityStatus_TXT__c  != HELMSConstants.CustomerPhoned && opp.SubDiv_TXT__c != HELMSConstants.NSX){
                        
                         opp.stageName = HELMSConstants.In_Conversation;
                        opp.OpportunityStatus_TXT__c  = HELMSConstants.CustomerPhoned;
                    }
                }else if(ta.Subject == HELMSConstants.outboundCall){
                    if((opp.stageName == HELMSConstants.Acknowledged  || opp.stageName == HELMSConstants.Assigned_to_Dealer ||
                       opp.stageName == HELMSConstants.In_Conversation ) &&  opp.SubDiv_TXT__c != HELMSConstants.NSX){
                           
                    opp.stageName = HELMSConstants.In_Conversation;
                  opp.OpportunityStatus_TXT__c  = HELMSConstants.salespersonbyphone;
                }
                }
                if(ta.Subject != HELMSConstants.outboundCall && ta.Subject != HELMSConstants.inboundCall){
                     if(opp.StageName== HELMSConstants.Assigned_to_Dealer && opp.SubDiv_TXT__c != HELMSConstants.NSX){
                         
                              opp.stageName = HELMSConstants.Acknowledged ;
                              opp.OpportunityStatus_TXT__c  = HELMSConstants.LeadOpened;
                              system.debug('stageName ---------> ' + opp.stageName );
                         
                     } else if((opp.stageName == HELMSConstants.In_Conversation && opp.OpportunityStatus_TXT__c != HELMSConstants.Madeappointment) && opp.SubDiv_TXT__c != HELMSConstants.NSX){
                                opp.OpportunityStatus_TXT__c  = HELMSConstants.Madeappointment;
                                                         
                  } 
                }
          oppty.add(opp);
        }
         }  
        
        if(oppty.size()>0)
        {
            update oppty;
        }
    }
    /*updateopptyStageandStatusforEvent - if we created any event in partner comunity, opportunity stages will update automatically. */
    public static void updateopptyStageandStatusforEvent(List<Event> eventList){ 
    
        set<Id> oppIds = new Set<Id>();
        List<Opportunity> oppty = new List<Opportunity>();  
    
        for(Event t : eventList){
          String wId = t.whatId;
          if(wId!=null && wId.startsWith('006') && t.Subject != null){
            oppIds.add(t.whatId);
          }
        }
        
        List<Opportunity> opps = [select Id,StageName, OpportunityStatus_TXT__c, SubDiv_TXT__c from opportunity where id in: oppIds];
            
        for(Opportunity opp : opps){
                     if(opp.StageName== HELMSConstants.Assigned_to_Dealer  &&  opp.SubDiv_TXT__c != HELMSConstants.NSX){
                              opp.stageName = HELMSConstants.Acknowledged ;
                              opp.OpportunityStatus_TXT__c  = HELMSConstants.LeadOpened;
                     } else if((opp.stageName == HELMSConstants.In_Conversation && opp.OpportunityStatus_TXT__c != HELMSConstants.Madeappointment) && opp.SubDiv_TXT__c != HELMSConstants.NSX){
                                opp.OpportunityStatus_TXT__c  = HELMSConstants.Madeappointment;
                                                         
           } 
          oppty.add(opp);   
        }
        if(oppty.size()>0)
        {
            update oppty;
        }
    }
     /*updateopptyStageandStatusforEmailMessage - if we send any mail in partner comunity, opportunity stages will update automatically. */
   public static void updateopptyStageandStatusforEmailMessage(List<EmailMessage> EmailMessage){
    
    set<Id> oppIds = new Set<Id>();
        List<Opportunity> oppty = new List<Opportunity>();  
    
        for(EmailMessage t : EmailMessage){
          String wId = t.RelatedToId;
          if(wId!=null && wId.startsWith('006')){
            oppIds.add(t.RelatedToId);
          }
        }
        
        List<Opportunity> opps = [select Id,StageName, OpportunityStatus_TXT__c, SubDiv_TXT__c from opportunity where id in: oppIds];
    
        for(Opportunity opp : opps){
                     if((opp.StageName== HELMSConstants.Assigned_to_Dealer || opp.stageName == HELMSConstants.In_Conversation || opp.stageName == HELMSConstants.Acknowledged ) &&  opp.SubDiv_TXT__c != HELMSConstants.NSX){
                              opp.stageName = HELMSConstants.In_Conversation;
                              opp.OpportunityStatus_TXT__c  = HELMSConstants.salespersonbyemail;
                         
           } 
          oppty.add(opp);
        }
        if(oppty.size()>0)
        {
            update oppty;
        }
    }
     /*updateopptyStageandStatusforNote - if we created any note in partner comunity, opportunity stages will update automatically. */
      public static void updateopptyStageandStatusforNote(List<ContentDocumentLink> Note){
              set<Id> oppIds = new Set<Id>();
              List<Opportunity> oppty = new List<Opportunity>();
             Set<Id> newSet = new Set<Id>();
         
            for(ContentDocumentLink t : Note){
                 newSet.add(t.ContentDocumentId);
                    
             }
        //   system.debug('newSet---->'+newSet);
     //  List<ContentDocumentLink> conLinks = [select Id, LinkedEntityId,ContentDocumentId from ContentDocumentLink where LinkedEntityId IN :oppIds];
    List<ContentDocumentLink> conLinks = [select Id, LinkedEntityId,ContentDocumentId from ContentDocumentLink where ContentDocumentId IN :newSet];
           for(ContentDocumentLink Cdl : conLinks )   {
         string LinkedEntityId = cdl.LinkedEntityId;
               if(LinkedEntityId.substring(0,3) == '006'){
               oppIds.add(cdl.LinkedEntityId);
               }
           } 
      // system.debug('oppIds---->'+oppIds);
        List<Opportunity> opps = [select Id,StageName, OpportunityStatus_TXT__c, SubDiv_TXT__c from opportunity where id in: oppIds];
        for(Opportunity opp : opps){
                     if(opp.StageName== HELMSConstants.Assigned_to_Dealer){
                              opp.stageName = HELMSConstants.Acknowledged ;
                              opp.OpportunityStatus_TXT__c  = HELMSConstants.LeadOpened;
                         
           } else if(opp.stageName == HELMSConstants.In_Conversation && opp.OpportunityStatus_TXT__c  != HELMSConstants.Note){
                              opp.stageName = HELMSConstants.In_Conversation;
                              opp.OpportunityStatus_TXT__c  = HELMSConstants.Note;
                         
           } 
          oppty.add(opp);
        }
        if(oppty.size()>0)
        {
            update oppty;
        }
    }
    
    
}