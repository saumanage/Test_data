trigger HELMSOpportunityTrigger on Opportunity (before insert,before update,after insert,after update) {  
    
    BypassAutomations__c pb = BypassAutomations__c.getInstance(UserInfo.getUserId());
    if(pb.BypassTrigger__c == false){
        
        // For updating Leads when Opportunity status is Closed Won, Closed Lost of same LeadGroupId
        if(Trigger.isAfter && (trigger.isInsert || trigger.isupdate) ){
            //System.debug('Opp Trigger -- ');
            Set<String> leadGroupIdSet = new Set<String>();
            HELMSOpportunityHandler oppHandler = new HELMSOpportunityHandler();
            Map<string,opportunity> oppmap = new Map<string,opportunity>();  
            
            for(Opportunity opp: trigger.new){
                //System.debug('opp : '+opp);
                
                
                
                if( (opp.StageName == 'Closed Won' || opp.StageName == 'Closed Lost') && (opp.Lead_Group_ID__c!=null)){
                    //System.debug('Opp Trigger -- Closed Won');
                    leadGroupIdSet.add(opp.Lead_Group_ID__c);
                    oppmap.put(opp.Lead_Group_ID__c, opp);
                }
                /*if(HELMSOpportunityHandler.isUpdatedMultiLeadProviderOpportunity == false){
                    HELMSOpportunityHandler.isUpdatedMultiLeadProviderOpportunity = true; // Added this code to block recursive call
                    oppHandler.oppMultipleLeadProvider(trigger.new);
                }*/
                
            }
            //System.debug('leadGroupIdSet : '+leadGroupIdSet);
            if(leadGroupIdSet.size() > 0 && HELMSOpportunityHandler.isUpdatedOpportunityStatus == false ){
                //System.debug('Opp Trigger -- > 0');
                oppHandler.updateSameLeadGroupIdLeads(leadGroupIdSet, oppmap); // Sending the Opportunity Map to Handler
            }
        }//LMS-4878 Find Duplicate Opportunity
        if(Trigger.isAfter&&Trigger.isinsert){
                //System.debug('DEBUG 92');
                  HELMSupdateOppHandler handlerCls = new HELMSupdateOppHandler();
               handlerCls.findDuplicateOpportunity(trigger.new);   
        
           }
        if(Trigger.isAfter){
            
            /* LMS - 3636 Opportunity Routing. Assigning Opportunity to Routing Platform Event  */
            if(trigger.isInsert || trigger.isUpdate){
                List<Opportunity> routableOppList = new List<Opportunity>();
                Set<Id> opptySetIds = new Set<Id>();
                for(Opportunity opp:Trigger.new){
                    //System.debug('DEBUG 8');
                    //Bug-LMS-6695 routing only after insert not required in opp update
                    //if( (opp.Routing_Status__c != 'Success') &&  ((trigger.isInsert &&opp.Routable_FLG__c) || (trigger.isUpdate && opp.Routable_FLG__c && opp.Routable_FLG__c != Trigger.oldMap.get(opp.id).Routable_FLG__c)) ){
                    if(trigger.isInsert && (opp.Routable_FLG__c || opp.SendOnlyToUrbanScience__c) && opp.Routing_Status__c != 'Success'){
                        routableOppList.add(opp);  
                        //System.debug('Inside Updation Opportunity =>=>=>=> ');
                    }
                    opptySetIds.add(opp.Id);                
                }
                if(opptySetIds.size() > 0 && trigger.isInsert){
                    HELMSLeadDynamicAttributesCntrl.createOpportunityAttributes(opptySetIds);
                    if(System.Label.HELMSGeoCodesLocationAPIClass=='true' && !System.isBatch() && !System.isFuture())
                    HELMSGeoCodesLocationAPI.getGeocodes(opptySetIds);
                }
                
                if(routableOppList.size() > 0 && HELMSLeadDealerAssignmentADFHandler.isHappenedRouting == false){
                    HELMSLeadDealerAssignmentADFHandler.isHappenedRouting = true;
                 //   System.debug('Opp Trigger 5 =>=> ');
                 //   System.debug('Before Sending to Routing');
                    HELMSLeadDealerAssignmentADFHandler dealerAssignObj = new HELMSLeadDealerAssignmentADFHandler();
                    dealerAssignObj.newLeadDispositionADFs(routableOppList);      
                }
            }
            /* LMS - 3636 Opportunity Routing. Assigning Opportunity to Routing Platform Event  */
            
            
            if(trigger.isInsert){
                Map<Id, Opportunity> oldMap = new Map<Id, Opportunity>();
                HELMSPlatformEventLeadDisposition leaddispo = new HELMSPlatformEventLeadDisposition();
                leaddispo.newLeadDispositionADFs(Trigger.new , oldMap, true, false);
                //HELMSOptionsinsertHandler.handleLeadInsert(Trigger.new , oldMap, true, false);  
                //HELMSOptionsAbhi.handleLeadInsert(Trigger.new , oldMap, true, false); 
                //HELMSOptions.handleLeadInsert(Trigger.new , oldMap, true, false);             
                List<Opportunity> optyIds = new List<Opportunity>();
                List<Opportunity> listOppWithOffers = new List<Opportunity>();
                for(Opportunity opp:Trigger.new){
                    
                    if(opp.Options_TXT__c!=null){
                        optyIds.add(opp);
                    }
                 //   system.debug('>>>>>>>>'+opp.LeadAdditionalInfos__c);
                    //LMS-1950 - Vamshi
                    if(opp.LeadAdditionalInfos__c != null || opp.LeadAdditionalInfos__c != ''){
                        listOppWithOffers.add(opp);
                    }
                   //system.debug('>>>>>>>>'+listOppWithOffers); 
                    
                }
                if(optyIds.size()>0){
                    
                    HELMSOptionsinsertHandler.handleLeadInsert(optyIds);
                    
                }
                //LMS-1950 - Vamshi
               if(listOppWithOffers.Size() > 0){
                   //System.debug('Opp Trigger 6 =>=> ');
                    HELMSOffersInsertHandler.handleOffersInsert(listOppWithOffers);
                } 
                
                //system.debug('@@In After Insert');
            //    HELMSOpportunityHandler.sendEmail(trigger.new);
                
            }
            
            if(trigger.isUpdate){
                
                HELMSPlatformEventLeadDisposition leaddispo = new HELMSPlatformEventLeadDisposition();
                leaddispo.newLeadDispositionADFs(Trigger.new , Trigger.oldMap, false, true);
                
                //HELMSOptionsinsertHandler.handleLeadInsert(Trigger.new , Trigger.oldMap, false, true);
            }
            
            //Sending the Opportunity records to OpportunityRoutable PE.
            
            
        }
               
     
         
        //LMS-5481
        if(Trigger.isBefore){ 
           if(HelmsCheckRecursive.isRunOnce()){
                HELMSResponseTimeTriggerHelper.calculateTime(trigger.new);
        }
        }
 
        
        if(trigger.isBefore ){
            if( trigger.isInsert || trigger.isUpdate ) 
            {
                //System.debug('Inside TRIGGER SCENARIO 422');
                if(HelmsCheckRecursive.opptyisRunOnce()){ 
                HELMSupdateOppHandler a = new HELMSupdateOppHandler();
                a.updateOppAmount(trigger.new);
                // Modified by Harika
                //System.debug('Opp Trigger 12 =>=> ');
                HELMSupdateOppHandler.assignLeadProviders(trigger.new);
                }
                
            }
            //Bug-LMS-6695 routing only after insert not required in opp update
            //if( trigger.isInsert || trigger.isUpdate ){
            if( trigger.isInsert ){
                //System.debug('Iniside');
                /* LMS - 3636 Opportunity Routing. Assigning Routable value in Opportunity  */
                List<Opportunity> oppListRoutable = new List<Opportunity>();
                for(Opportunity opp:Trigger.new){
                    if(opp.Opportunity_SF_ID__c == null || opp.Opportunity_SF_ID__c == ''){
                        String encryptedId = RecordIdEncryptionUtil.generateRandomString(5);
                        opp.Opportunity_SF_ID__c = encryptedId;
                    }
                    if(!opp.NoRoutable_For_Data_Migration__c){
                        oppListRoutable.add(opp);
                   }
                } 
                if(oppListRoutable.size() > 0 && HELMSOpportunityHandler.isUpdatedRoutedStatus == false){
                    HELMSOpportunityHandler.isUpdatedRoutedStatus = true;
                    HELMSOpportunityHandler oppHandle = new HELMSOpportunityHandler();
                    oppHandle.checkRoutableOpportunities(oppListRoutable);
                }             
                /* LMS - 3636 Opportunity Routing. Assigning Routable value in Opportunity */   
            }
            
            
        }
    } 
}