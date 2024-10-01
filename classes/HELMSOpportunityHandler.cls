/*----------------------------------------------------------------------------------------------------------------------------------------------------
Class Name : HELMSOpportunityHandler 
Test Class Name : HELMSOpportunityHandlerTest
Last Modified Version Owner : 
Comments : Code check routable opportunities, update same lead group id leads, send email.
-------------------------------------------------------------------------------------------------------------------------------------------------------
*/
public with sharing class HELMSOpportunityHandler {
    // Boolean flags to block recursive trigger.
    public static boolean isUpdatedMultiLeadProviderOpportunity = false;
    public static boolean isUpdatedOpportunityStatus = false;
    public static boolean isUpdatedRoutedStatus = false;    
    
    public void checkRoutableOpportunities(List<Opportunity> listopps){
        //System.debug('Inside Check Routable');
        try{
            Set<Id> preferredDealerAccountSet = new Set<Id>(); //Preferred Dealer Account Set
            Set<Id> leadProviderSet = new Set<Id>();
            Set<Id> dealerParticipationSet = new Set<Id>(); //CAPS-895
            List<Opportunity> oppListRoutable = new List<Opportunity>(); //Routable Opportunities
            Set<String> oppSubDiv = new Set<String>(); //Opportunity SubDivision Set
            Map<Id, Boolean> hondaDigitalSolution = new Map<Id, Boolean>(); // Honda Digital Solution
            Map<Id, Boolean> leadProviderRoutable = new Map<Id, Boolean>(); // Lead Provider Routable
            Map<Id, Boolean> leadProviderSendToUrbanScience = new Map<Id, Boolean>(); // Lead Provider Send to Urban Science
            Map<String, Boolean> dealerDivExist = new Map<String, Boolean>(); //Dealer SubDivision Internet Certified
            Map<String, Boolean> dealerParticipationExist = new Map<String, Boolean>(); //Dealer SubDivision Internet Certified
            // Map to add those Dealer to block the Routing, if Dealer Participation is not added - Syam Mohan
            Map<String, String> blockingRoutingMap = new Map<String, String>(); //Blocking Routable for HELMS, as there is no Dealer Participation
            // Map to add those Dealer to block the Routing, if Dealer Participation is not added - Syam Mohan
            for (Opportunity opp : listopps){
                preferredDealerAccountSet.add(opp.PreferredDealerAccount_TXT__c);
                leadProviderSet.add(opp.LeadProvider_ID__c);
                oppSubDiv.add(opp.SubDiv_TXT__c);
                //opp.Routable_FLG__c = false;
                if(opp.Source_Unique_ID__c!= null && opp.Provider_Type__c == HELMSConstants.DealerOriginatedLead ){
                    opp.Initial_Walkin_Lead__c = true;
                }
            }
            
            /* Adding Honda Digital Solutions value to the Map with Preferred Dealer Account Id */
            for(Account accList : [SELECT Id, HondaDigitalSolutions_FLG__c FROM Account WHERE Id IN : preferredDealerAccountSet ]){
               if(accList.HondaDigitalSolutions_FLG__c){
                    hondaDigitalSolution.put(accList.Id,true);
                }else{
                    hondaDigitalSolution.put(accList.Id,false);                    
                }
                //hondaDigitalSolution.put(accList.Id,true);
            }
            /* Adding Honda Digital Solutions value to the Map with Preferred Dealer Account Id */
            
            /* Adding LeadProvider Routable value to the Map with LeadProvider Id */
            //System.debug('SELECT Id, Routable_FLG__c FROM Account WHERE Id IN : '+leadProviderSet+'');
            for(Account accList1 : [SELECT Id, Routable_FLG__c, Send_to_Urban_Science_Flag__c FROM Account WHERE Id IN : leadProviderSet]){
                if(accList1.Routable_FLG__c){
                    leadProviderRoutable.put(accList1.Id,true);
                }else{
                    leadProviderRoutable.put(accList1.Id,false);
                }
                //leadProviderRoutable.put(accList1.Id,true);
                
                if(accList1.Send_to_Urban_Science_Flag__c){
                    leadProviderSendToUrbanScience.put(accList1.Id,true);
                }else{
                    leadProviderSendToUrbanScience.put(accList1.Id,false);
                }
            }
            /* Adding LeadProvider Routable value to the Map with LeadProvider Id */
            /* Checking the Internet Certified */
            for(Dealer_Division__c dealerDivList : [SELECT Id, First_Name_TXT__c, InternetCertified_FLG__c, Dealer_ID__c,SubDiv_TXT__c FROM Dealer_Division__c WHERE Dealer_ID__c IN : preferredDealerAccountSet and SubDiv_TXT__c IN : oppSubDiv and isActive_FLG__c=true ]){
                dealerDivExist.put(dealerDivList.Dealer_ID__c, dealerDivList.InternetCertified_FLG__c);
            }
            //System.debug('dealerDivExist : '+dealerDivExist);
            /* Checking the Internet Certified */
            /* Dealer Participation IsActive */
            //System.debug('SELECT Id, Active_FLG__c, DealerAccount_ID__c, Dealer_Subdivision__r.SubDiv_TXT__c FROM Dealer_Participation__c WHERE DealerAccount_ID__c IN : '+preferredDealerAccountSet+' and Dealer_Subdivision__r.SubDiv_TXT__c IN :'+oppSubDiv+'');
            //Dealer_Subdivision__r.SubDiv_TXT__c

            /** CAPS-895
            for(Dealer_Participation__c dealerParticipationList : [SELECT Id,Is_Active__c, DealerAccount_ID__c, Dealer_Subdivision__r.SubDiv_TXT__c, CRM_System__r.Name FROM Dealer_Participation__c WHERE Is_Active__c = true and DealerAccount_ID__c IN : preferredDealerAccountSet and Dealer_Subdivision__r.SubDiv_TXT__c IN :oppSubDiv ]){
                //DealerParticipationExist.put(dealerParticipationList.DealerAccount_ID__c+''+dealerParticipationList.Dealer_Subdivision__c,dealerParticipationList.ISActive_FLG__c);
                dealerParticipationExist.put(dealerParticipationList.DealerAccount_ID__c+''+dealerParticipationList.Dealer_Subdivision__r.SubDiv_TXT__c,dealerParticipationList.Is_Active__c);
            	blockingRoutingMap.put(dealerParticipationList.DealerAccount_ID__c+''+dealerParticipationList.Dealer_Subdivision__r.SubDiv_TXT__c,dealerParticipationList.CRM_System__r.Name);
            }
            */
            for(Dealer_Participation__c dealerParticipationList : [SELECT Id,Is_Active__c, DealerAccount_ID__c, Dealer_Subdivision__r.SubDiv_TXT__c, CRM_System__r.Name FROM Dealer_Participation__c WHERE Is_Active__c = true and DealerAccount_ID__c IN : preferredDealerAccountSet ]){
                //DealerParticipationExist.put(dealerParticipationList.DealerAccount_ID__c+''+dealerParticipationList.Dealer_Subdivision__c,dealerParticipationList.ISActive_FLG__c);
                dealerParticipationExist.put(dealerParticipationList.DealerAccount_ID__c+''+dealerParticipationList.Dealer_Subdivision__r.SubDiv_TXT__c,dealerParticipationList.Is_Active__c);
            	blockingRoutingMap.put(dealerParticipationList.DealerAccount_ID__c, dealerParticipationList.CRM_System__r.Name);
                dealerParticipationSet.add(dealerParticipationList.DealerAccount_ID__c);
            }

            //System.debug('dealerParticipationExist : '+dealerParticipationExist);
            /* Dealer Participation IsActive */
            
            /* Send to Urban Science in Lead Provider */
           /* for(Account accList3 : [SELECT Id, Send_to_Urban_Science_Flag__c FROM Account WHERE Id IN : leadProviderSet]){
                if(accList3.Send_to_Urban_Science_Flag__c){
                    leadProviderSendToUrbanScience.put(accList3.Id,true);
                }else{
                    leadProviderSendToUrbanScience.put(accList3.Id,false);
                }
            }
            */
            //System.debug('leadProviderSendToUrbanScience : '+leadProviderSendToUrbanScience);
            /* Send to Urban Science in Lead Provider */
            
            for(Opportunity oppRec : listopps){
                if(oppRec.LeadProvider_ID__c == null || oppRec.PreferredDealerAccount_TXT__c == null || !dealerParticipationSet.contains(oppRec.PreferredDealerAccount_TXT__c) || (blockingRoutingMap.containskey(oppRec.PreferredDealerAccount_TXT__c) && (blockingRoutingMap.get(oppRec.PreferredDealerAccount_TXT__c) == 'HELMS'))){
                    continue;
                }
                if(oppRec.Division_CD__c == 'A' || oppRec.Division_CD__c == 'B'){
                    if(leadProviderRoutable.get(oppRec.LeadProvider_ID__c)){
                        oppListRoutable.add(oppRec);
                    }
                    if(!leadProviderRoutable.get(oppRec.LeadProvider_ID__c) && hondaDigitalSolution.get(oppRec.PreferredDealerAccount_TXT__c) && dealerParticipationSet.contains(oppRec.PreferredDealerAccount_TXT__c) && dealerDivExist.get(oppRec.PreferredDealerAccount_TXT__c)){
                        oppListRoutable.add(oppRec);
                    }

                    /*
                    if(oppRec.Division_CD__c == 'A' && !dealerParticipationExist.containskey(oppRec.PreferredDealerAccount_TXT__c+''+oppRec.SubDiv_TXT__c) && leadProviderSendToUrbanScience.containskey(oppRec.LeadProvider_ID__c) && leadProviderSendToUrbanScience.get(oppRec.LeadProvider_ID__c)){
                       oppRec.SendOnlyToUrbanScience__c = true; 
                    }
                    
                    if(leadProviderRoutable.size() > 0 && 
                       leadProviderRoutable.containskey(oppRec.LeadProvider_ID__c) && 
                       hondaDigitalSolution.size() > 0 && 
                       hondaDigitalSolution.containskey(oppRec.PreferredDealerAccount_TXT__c) && 
                       ( blockingRoutingMap.size() > 0 && blockingRoutingMap.containskey(oppRec.PreferredDealerAccount_TXT__c+''+oppRec.SubDiv_TXT__c) && (blockingRoutingMap.get(oppRec.PreferredDealerAccount_TXT__c+''+oppRec.SubDiv_TXT__c) != 'HELMS') ) && 
                       ( (dealerParticipationExist.size() > 0 && dealerParticipationExist.containskey(oppRec.PreferredDealerAccount_TXT__c+''+oppRec.SubDiv_TXT__c)) || leadProviderSendToUrbanScience.containskey(oppRec.LeadProvider_ID__c) ) && 
                       dealerDivExist.size() > 0 && 
                       dealerDivExist.containskey(oppRec.PreferredDealerAccount_TXT__c+''+oppRec.SubDiv_TXT__c)){
                           //System.debug('INside A || B **');
                           //System.debug('Before Checking');
                           //System.debug('JJ1 '+leadProviderRoutable.get(oppRec.LeadProvider_ID__c));
                           //System.debug('JJ1 '+hondaDigitalSolution.get(oppRec.PreferredDealerAccount_TXT__c));
                           //System.debug('JJ1 '+hondaDigitalSolution.get(oppRec.PreferredDealerAccount_TXT__c));
                            if( leadProviderRoutable.get(oppRec.LeadProvider_ID__c) && hondaDigitalSolution.get(oppRec.PreferredDealerAccount_TXT__c) && ( (dealerParticipationExist.containskey(oppRec.PreferredDealerAccount_TXT__c+''+oppRec.SubDiv_TXT__c) && dealerParticipationExist.get(oppRec.PreferredDealerAccount_TXT__c+''+oppRec.SubDiv_TXT__c)) || leadProviderSendToUrbanScience.get(oppRec.LeadProvider_ID__c)) && dealerDivExist.get(oppRec.PreferredDealerAccount_TXT__c+''+oppRec.SubDiv_TXT__c) ){
                                //System.debug('Checking 1');
                                oppListRoutable.add(oppRec);
                            }
                            
                            else if( leadProviderRoutable.get(oppRec.LeadProvider_ID__c) && !hondaDigitalSolution.get(oppRec.PreferredDealerAccount_TXT__c) && ((dealerParticipationExist.containskey(oppRec.PreferredDealerAccount_TXT__c+''+oppRec.SubDiv_TXT__c) && dealerParticipationExist.get(oppRec.PreferredDealerAccount_TXT__c+''+oppRec.SubDiv_TXT__c)) || leadProviderSendToUrbanScience.get(oppRec.LeadProvider_ID__c)) && dealerDivExist.get(oppRec.PreferredDealerAccount_TXT__c+''+oppRec.SubDiv_TXT__c) ){
                                //System.debug('Checking 2');
                                oppListRoutable.add(oppRec);
                            } else if( !leadProviderRoutable.get(oppRec.LeadProvider_ID__c) && hondaDigitalSolution.get(oppRec.PreferredDealerAccount_TXT__c) && ((dealerParticipationExist.containskey(oppRec.PreferredDealerAccount_TXT__c+''+oppRec.SubDiv_TXT__c) && dealerParticipationExist.get(oppRec.PreferredDealerAccount_TXT__c+''+oppRec.SubDiv_TXT__c)) || leadProviderSendToUrbanScience.get(oppRec.LeadProvider_ID__c)) && dealerDivExist.get(oppRec.PreferredDealerAccount_TXT__c+''+oppRec.SubDiv_TXT__c) ){
                                //System.debug('Checking 3');
                                oppListRoutable.add(oppRec);
                            }
                            /*
                                //System.debug('Checking 4');
                                oppListRoutable.add(oppRec);
                            } else if( leadProviderRoutable.get(oppRec.LeadProvider_ID__c) && !hondaDigitalSolution.get(oppRec.PreferredDealerAccount_TXT__c) && ((DealerParticipationExist.containskey(oppRec.PreferredDealerAccount_TXT__c+''+oppRec.SubDiv_TXT__c) && !DealerParticipationExist.get(oppRec.PreferredDealerAccount_TXT__c+''+oppRec.SubDiv_TXT__c)) || leadProviderSendToUrbanScience.get(oppRec.LeadProvider_ID__c)) && !DealerDivExist.get(oppRec.PreferredDealerAccount_TXT__c+''+oppRec.SubDiv_TXT__c) ){
                                //System.debug('Checking 5');
                                oppListRoutable.add(oppRec);
                            }//else{
                                //oppListRoutable.add(oppRec); 
                                //System.debug('Checking 6');
                            //}
                            
                            
                    }

                     */   /* HPS - 416 */ 
                        if(leadProviderSendToUrbanScience.containskey(oppRec.LeadProvider_ID__c) && leadProviderSendToUrbanScience.get(oppRec.LeadProvider_ID__c) && !leadProviderRoutable.get(oppRec.LeadProvider_ID__c) && !hondaDigitalSolution.get(oppRec.PreferredDealerAccount_TXT__c)){
                        //    System.debug('Else If. INside Send Only To UB');
                            oppRec.SendOnlyToUrbanScience__c = true; 
                       }
                        /* HPS - 416 */
                    
                }else if(oppRec.Division_CD__c == 'M' || oppRec.Division_CD__c == 'P'){
                    if(dealerParticipationSet.contains(oppRec.PreferredDealerAccount_TXT__c) && dealerDivExist.get(oppRec.PreferredDealerAccount_TXT__c)){
                        oppListRoutable.add(oppRec);
                    }
                    /*
                    if(leadProviderRoutable.size() > 0 && 
                       leadProviderRoutable.containskey(oppRec.LeadProvider_ID__c) && 
                       hondaDigitalSolution.size() > 0 && hondaDigitalSolution.containskey(oppRec.PreferredDealerAccount_TXT__c) && 
                       ( blockingRoutingMap.size() > 0 && blockingRoutingMap.containskey(oppRec.PreferredDealerAccount_TXT__c+''+oppRec.SubDiv_TXT__c) && (blockingRoutingMap.get(oppRec.PreferredDealerAccount_TXT__c+''+oppRec.SubDiv_TXT__c) != 'HELMS') ) && 
                       dealerParticipationExist.size() > 0 && dealerParticipationExist.containskey(oppRec.PreferredDealerAccount_TXT__c+''+oppRec.SubDiv_TXT__c) && 
                       dealerDivExist.size() > 0 && dealerDivExist.containskey(oppRec.PreferredDealerAccount_TXT__c+''+oppRec.SubDiv_TXT__c)){
                       //     System.debug('Inside M || P ');   
                            if( dealerParticipationExist.get(oppRec.PreferredDealerAccount_TXT__c+''+oppRec.SubDiv_TXT__c) && dealerDivExist.get(oppRec.PreferredDealerAccount_TXT__c+''+oppRec.SubDiv_TXT__c) ){
                                oppListRoutable.add(oppRec);
                            }
                       }
                       */
                }
            }
            //System.debug('Inside A || B ** ** ');
            //System.debug('Final List : '+oppListRoutable);
            List<Opportunity> oppList = new List<Opportunity>();
            if(oppListRoutable.size() > 0){
                //System.debug('INside Routable List ');
                for(Opportunity oppRec : oppListRoutable){
                    //System.debug('Routable : '+oppRec.Routable_FLG__c);
                    if(!oppRec.Routable_FLG__c){
                        //System.debug('Checking Routable to True');
                        oppRec.Routable_FLG__c = true;
                    }
                    /*if(oppRec.Opportunity_SF_ID__c == null || oppRec.Opportunity_SF_ID__c == ''){
                        System.debug('Inside OPP SF ID');
                        String encryptedId = RecordIdEncryptionUtil.generateRandomString(5);
                        //System.debug('OPP SF ID : '+encryptedId);
                        oppRec.Opportunity_SF_ID__c = encryptedId;
                    }*/
                }
            }    
        }catch(Exception e){
            //System.debug('Exception at line : ' + e.getLineNumber());
            //System.debug('Exception Message : ' + e.getMessage());
            Logs__c l = new Logs__c(name = 'checkRoutableOpportunities', Trigger_or_Class_Name__c = 'HELMSOpportunityHandler', Error_Message__c = e.getMessage(), Error_Line_Number__c = Integer.valueOf(string.valueof(e.getLineNumber())));
            insert l;
        }
    }
    
    /*public void oppMultipleLeadProvider(List<Opportunity> listopps){
        Set<Id> oppIdSet = new Set<Id>();
        Map<Id, String> multipleProviderMap = new Map<Id, String>();
        List<Opportunity> oppToUpdate = new List<Opportunity>();
        for(Opportunity opp : listopps){
             oppIdSet.add(opp.Id);
        }
        for(Lead lead : [SELECT Id, Multiple_Lead_Providers__c From Lead WHERE Id IN : oppIdSet]){
            //Fetching Multiple Lead Provider from Lead and adding to map
            multipleProviderMap.put(lead.Id,lead.Multiple_Lead_Providers__c); 
        }
        for(Opportunity opp1 : listopps){
            if(multipleProviderMap.containsKey(opp1.Id) && opp1.Multiple_Lead_Providers__c != multipleProviderMap.get(opp1.Id) ){
               opp1.Multiple_Lead_Providers__c =  multipleProviderMap.get(opp1.Id);
                oppToUpdate.add(opp1);
            }
        }
        if(oppToUpdate.size()>0){
            //HELMSOpportunityHandler.isUpdatedMultiLeadProviderOpportunity = true;
            update oppToUpdate;
        }
    }*/

    public void updateSameLeadGroupIdLeads(Set < String > setLeadGroupId, Map<string, opportunity> oppMap){
        // Update Leads to Related Opportunity if any of the Oppoertunity is closed from the Duplicate Leads.
        try{
            //System.debug('Inside Opp Handler'+setLeadGroupId);
            List<Lead> leadsToUpdate = new List<Lead>();
            List<Opportunity> oppToClose = new List<Opportunity>();
            for(Lead leadRec : [SELECT Id, Lead_Group_ID__c, Status, StatusReason_TXT__c,IsConverted FROM LEAD WHERE IsConverted=false and Lead_Group_ID__c IN : setLeadGroupId]){
                if(!leadRec.IsConverted){
                    leadRec.Status = HELMSConstants.CNC;
                    leadRec.StatusReason_TXT__c = 'Related Opportunity closed';
                    leadsToUpdate.add(leadRec);
                }               
            }
            if(leadsToUpdate.size() > 0){
              //System.debug('leadsToUpdate : '+leadsToUpdate);
              update leadsToUpdate;    
            }         
           
            List<Opportunity> listOppToClose = new List<Opportunity>();
            //Updating the Opportunity status if any of the related Opportuninty is status changed to Closed.
            for(Opportunity opp:[select Id, StageName, OpportunityStatus_TXT__c, IsClosed,Lead_Group_ID__c from opportunity where Lead_Group_ID__c IN : setLeadGroupId]){
                if(oppMap.get(opp.Lead_Group_ID__c).StageName == 'Closed Inactive'){
                    //System.debug('opp : '+opp);
                    opp.StageName = 'Closed Lost';
                    opp.OpportunityStatus_TXT__c = 'Lead set to inactive/Lead deleted';
                    listOppToClose.add(opp);
                }else{
                    opp.StageName = oppMap.get(opp.Lead_Group_ID__c).StageName;
                    opp.OpportunityStatus_TXT__c = 'Customer Survey';
                    listOppToClose.add(opp);
                }
            }
            
            if(listOppToClose.size() > 0 && HELMSOpportunityHandler.isUpdatedOpportunityStatus == false){
              HELMSOpportunityHandler.isUpdatedOpportunityStatus = true;
              update listOppToClose;    
            }
        }catch(Exception e){
            //System.debug('Exception at line : ' + e.getLineNumber());
            //System.debug('Exception Message : ' + e.getMessage());
            Logs__c l = new Logs__c(name = 'updateSameLeadGroupIdLeads', Trigger_or_Class_Name__c = 'HELMSOpportunityHandler', Error_Message__c = e.getMessage(), Error_Line_Number__c = Integer.valueOf(string.valueof(e.getLineNumber())));
            insert l;
        }
    }  

    
    
  /* public static void sendEmail(List < Opportunity > lstOpps) {
    try {
        List < User > userList;
        List < Id > preferredIds = new List < Id > (); 
      List < Id > preferredIds = new List < Id > ();
        List < Id > preferredIds = new List < Id > (); 
        set < Id > setPreIds = new set < Id > (); 
        Set < String > divsnSet = new Set < String > ();
        Set < String > subdivSet = new Set < String > ();
        for (Opportunity opp: lstOpps) {       
      for (Opportunity opp: lstOpps) {
        for (Opportunity opp: lstOpps) {       
            preferredIds.add(opp.PreferredDealerAccount_TXT__c);  
        preferredIds.add(opp.PreferredDealerAccount_TXT__c);
            preferredIds.add(opp.PreferredDealerAccount_TXT__c);  
            divsnSet.add(opp.Division_CD__c);
            subdivSet.add(opp.SubDiv_TXT__c);
        }
        List<Dealer_Division__c> listDiv=[Select id,Dealer_ID__c From Dealer_Division__c Where Division_CD__c in :divsnSet and SubDiv_TXT__c in :subdivSet and Dealer_ID__c in :preferredIds and Dealer_Access_Level__c='Full Access'];
        
        for(Dealer_Division__c divsn:listDiv){
            setPreIds.add(divsn.Dealer_ID__c);
        }
        
        Set < String > stringEmail = new Set < String > ();
        Map < Id, String > usermap = new map < Id, String > ();
        Map < Id, list<String> > dlrvsemailmap = new map < Id, list<String> > ();
        set < Id > userId = new Set < Id > ();     
      set < Id > userId = new Set < Id > ();
        set < Id > userId = new Set < Id > ();     
        for (User u: [select ContactId, AccountId,Contact.email, Email from User where Contact.AccountId IN: setPreIds and IsActive = true and Contact.email!=null]) {      
            userId.add(u.Id);
            usermap.put(u.AccountId, u.ContactId);
            if(dlrvsemailmap.get(u.AccountId)!=null){
                dlrvsemailmap.get(u.AccountId).add(u.Contact.email);
            }else{
                dlrvsemailmap.put(u.AccountId,new list<string>());
                dlrvsemailmap.get(u.AccountId).add(u.Contact.email);
            }        
        }
            }        
        }

        for (Opportunity opp: lstOpps) {
            if (dlrvsemailmap.get(opp.PreferredDealerAccount_TXT__c)!=null && dlrvsemailmap.get(opp.PreferredDealerAccount_TXT__c).size() > 0) {         
        if (dlrvsemailmap.get(opp.PreferredDealerAccount_TXT__c)!=null && dlrvsemailmap.get(opp.PreferredDealerAccount_TXT__c).size() > 0) {
            if (dlrvsemailmap.get(opp.PreferredDealerAccount_TXT__c)!=null && dlrvsemailmap.get(opp.PreferredDealerAccount_TXT__c).size() > 0) {         
                EmailTemplate et = [Select id, Subject, Body from EmailTemplate where name = 'New Opportunity'];
                OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'yourhonda@ebizmail.honda.com'];
                Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();     
          Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();     
                if ( owea.size() > 0 ) {
                    message.setOrgWideEmailAddressId(owea.get(0).Id);
                }    
            }    
                }    
                message.setTemplateId(et.Id);
                message.setTargetObjectId(usermap.get(opp.PreferredDealerAccount_TXT__c));
                message.setTreatTargetObjectAsRecipient(false); 
          message.setTreatTargetObjectAsRecipient(false); 
                message.setTreatTargetObjectAsRecipient(false); 
                message.setToAddresses(dlrvsemailmap.get(opp.PreferredDealerAccount_TXT__c));
                message.setWhatId(opp.id);

                List < Messaging.SingleEmailMessage > messages = new List < Messaging.SingleEmailMessage > {message};
                Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
            
            }
        }
    }

    Catch(Exception ex) {
        Logs__c l = new Logs__c(name = 'Opportunity - Send Email', Trigger_or_Class_Name__c = 'HELMSOpportunityHandler', Error_Message__c = ex.getMessage(), Error_Line_Number__c = Integer.valueOf(string.valueof(ex.getLineNumber())));
        insert l;
    }

  }*/
        
}