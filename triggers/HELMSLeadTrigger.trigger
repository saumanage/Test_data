trigger HELMSLeadTrigger on Lead (before insert,before update,after insert,after update) {
    
    BypassAutomations__c pb = BypassAutomations__c.getInstance(UserInfo.getUserId());
    //System.debug('pb.BypassTrigger__c : '+pb.BypassTrigger__c);
    if(pb.BypassTrigger__c == false){
        
        LeadTriggerHandler ldhandler = new LeadTriggerHandler();
        if(Trigger.isInsert && Trigger.isBefore) {
            
            HELMSLeadTriggerHandlerUpdated.handleLeadInsert(Trigger.new);
            // HPS - 468 - Generating Lead SF ID immediately after creatingLead.
            ldhandler.insertLeadSFID(trigger.new);
            // HPS - 468 - Generating Lead SF ID immediately after creatingLead.
            ldhandler.updateValidNameonLead(trigger.new);
            //ldhandler.updateModelGroupName(trigger.new);  // Commented by Bijay- This method has no use
            //system.debug('In Model update');
            ldhandler.updateModelGroupNameOnLead(Trigger.new);
            ldhandler.updateVehicleStatus(Trigger.new);
            //AMSLM-918
            ldhandler.updateModelGroupNameEmpty(Trigger.new);
            //ldhandler.getECRMData(trigger.new);
            //Logic added as a part of LMS-1568
            if(Trigger.isInsert){
                //System.debug('@@After Insert Running');
                ldhandler.findDuplicateLeadRecord(Trigger.new);
                
            }
            
        }
          
            
        /*
        if(Trigger.isAfter && Trigger.isInsert){ 
            
            //database.executeBatch(new ProductModelBatchUpdate(Trigger.New));
            
        }
        */
        
        if(Trigger.isUpdate && trigger.isBefore) {  
            set<id> listidsupdated =new set<id>();
            set<id> leadsWithCK = new set<id>();
            ldhandler.updateValidNameonLead(trigger.new);
            HELMSLeadTriggerHandlerUpdated.handleLeadUpdate(Trigger.oldMap,Trigger.newMap);
            //as part of AMSLM-693- GL-added recursive method here. below methods are executing repeat mode and getting 50001
              if(HelmsCheckRecursive.isRunOnce()){ 
            
            //ldhandler.updateModelGroupName(trigger.new);
            ldhandler.updateModelGroupNameOnLead(Trigger.new);
            //AMSLM-918
            ldhandler.updateModelGroupNameEmpty(Trigger.new);     
              }
            /* Call Lead Enrichment in Lead Update - Syam */
            for(Lead updateLead : trigger.new){
                //System.debug('Trigger.oldMap : '+Trigger.oldMap.get(updateLead.Id));
                //System.debug('Trigger.newMap : '+Trigger.newMap.get(updateLead.Id));
                if( (Trigger.oldMap.get(updateLead.Id).Email != Trigger.newMap.get(updateLead.Id).Email) || 
                   (Trigger.oldMap.get(updateLead.Id).Phone != Trigger.newMap.get(updateLead.Id).Phone) || 
                   (Trigger.oldMap.get(updateLead.Id).MobilePhone != Trigger.newMap.get(updateLead.Id).MobilePhone) || 
                   (Trigger.oldMap.get(updateLead.Id).PostalCode != Trigger.newMap.get(updateLead.Id).PostalCode) ||
                   (Trigger.oldMap.get(updateLead.Id).PreferredDealerAccount_ID__c != Trigger.newMap.get(updateLead.Id).PreferredDealerAccount_ID__c) || 
                   (Trigger.oldMap.get(updateLead.Id).PreferredDealerNumber_NUM__c != Trigger.newMap.get(updateLead.Id).PreferredDealerNumber_NUM__c) ){
                       listidsupdated.add(updateLead.Id);
                           
                   }
                
                
            }
            if(listidsupdated.size()>0){
                if(HELMSleadEnrichmentIntegrationupdate.flag == false && HELMSAdditionalDataScoringService.flag == true){
                    HELMSleadEnrichmentIntegrationupdate.flag = true;
                    HELMSleadEnrichmentIntegrationupdate.LeadEnrichment(listidsupdated, true);
                }
                
            }
                
            /* Call Lead Enrichment in Lead Update - Syam */
        } 
        
        if(Trigger.isAfter ){
            set<id> listids =new set<id>();
            set<id> leadscoreLeadids =new set<id>();
            // list<string> leids= new list<string>();
            set<id> leadIds =new set<id>();
            //set<id> leadsWithCK = new set<id>();
            List<Lead> leadListRecord =new List<Lead>();
            List<Lead> leadoptIds = new List<Lead>();
            for(Lead led:Trigger.new){
                
                if(Trigger.isInsert){
                    if(led.CustomerAccount_ID__c==null && led.Status != HELMSConstants.CNC){
                        listids.add(led.id);
                        
                    }
                    
                    leadIds.add(led.Id); 
                    
                    if(led.Options_TXT__c!=null){
                        leadoptIds.add(led);
                    }
                    
                    if(leadoptIds.size()>0){
               //system.debug('leadoptIds----->'+leadoptIds);
                        HELMSOptionsinsertHandler.optionsLeadInserthandle(leadoptIds);
                    }
                   
                }
                
                
             //if(!led.isConverted && led.LeadGrade_FLG__c==true && (led.Status=='Ready_to_Convert' || led.Status == 'New'|| led.StatusReason_TXT__c == HELMSConstants.LECE) && led.PreferredDealerAccount_ID__c!=null && led.CustomerAccount_ID__c!=null){
              if(!led.isConverted && led.LeadGrade_FLG__c==true && led.PreferredDealerAccount_ID__c!=null && led.CustomerAccount_ID__c!=null &&  led.Status != HELMSConstants.closedcon &&  led.Status != HELMSConstants.CNC && led.StatusReason_TXT__c != HELMSConstants.WaitforDeal){
                   //System.debug('INside Ready to Convert'); 
                    leadListRecord.add(led);
                 }
                
                if(Trigger.isUpdate && led.ContactKey_TXT__c!=null && Trigger.oldMap.get(led.Id).ContactKey_TXT__c != Trigger.newMap.get(led.Id).ContactKey_TXT__c && led.CustomerAccount_ID__c != null && Trigger.oldMap.get(led.Id).CustomerAccount_ID__c != Trigger.newMap.get(led.id).CustomerAccount_ID__c && !led.Is_HELMS_Contact_Key__c && !led.Is_ECRM_Update_Done__c){
                   // System.debug(led.CustomerAccount_ID__c);
                    leadscoreLeadids.add(led.id);
                }
                
                
                                
            }
           // System.debug('Before Dynamic ');
            if(leadIds.size() > 0){
                HELMSLeadDynamicAttributesCntrl.createDynamicFields(trigger.new);
           // System.debug('After Dynamic ');
           }
            
            if(listids.size()>0){
                if(HELMSleadEnrichmentIntegrationupdate.flag == false){
                    HELMSleadEnrichmentIntegrationupdate.flag = true;
                    //Original Lead Enrichment Call
                   // System.debug('Lead Enrichment Call');
                    HELMSleadEnrichmentIntegrationupdate.LeadEnrichment(listids, false);
                }
                
            }
            
            
         
            if(leadscoreLeadids.size()>0){
                if(HELMSAdditionalDataScoringService.flag == false){ //&& HELMSleadEnrichmentIntegrationupdate.flag == true, HELMSAdditionalDataScoringService.flag == false
                    //HELMSAdditionalDataScoringService.flag =true;
                  //  System.debug('ECRM Enrichment Call');
                 //HELMSAdditionalDataScoringService.GetAdditionaldata(leadscoreLeadids);
                   System.enqueueJob(new AsyncExecutionExample(leadscoreLeadids));
                    
                    HELMSAdditionalDataScoringService.flag =true;
                    //ldhandler.additionalDataScore(leadsWithCK);
                  }
            }   
            
            //if(isAfter && isUpdate){
                //Starts Location API Call.
                
            //}      
           
            
            
          /*  if(Trigger.isInsert){
             if(leadoptIds.size()>0){
                
                HELMSOptionsinsertHandler.optionsLeadInserthandle(leadoptIds);
            }
          }*/
            
            
            if(leadListRecord.size()>0){
               // System.debug('Inside Lead Convert 11 : ');
                if(HELMSLeadConvertToOppHandler.flag == true){                    
                    HELMSLeadConvertToOppHandler.flag = false;                    
                    HELMSLeadConvertToOppHandler.handleLeadToOppInsert(leadListRecord);
                }
            }   
          
            // Added for LMS - 2630
            if(HelmsCheckRecursive.updateLeadGroupIdValueOnceUpdate()){
            ldhandler.updateLeadGroupIdValue(trigger.new);
            }
        }
        
        
        //LMS - 4997 - Location Service API
        if(trigger.isUpdate && trigger.isAfter){
           // System.debug('Inside Location Service API');
            List<Lead> leadForLocationService =  new List<Lead>();
            Set<Id> leadIdForLocationService = new Set<Id>(); // Unique Lead Ids to send to Location Service
            Set<Id> leadIdForCheckDistance = new Set<Id>(); // Unique Lead Ids to check the Distance
            Set<Id> leadIdToUpdateSalesToService = new Set<Id>(); // Unique Lead Ids to Update from Sales to Service
            Set<Id> leadIdToSalesDealer = new Set<Id>(); // Unique Lead Ids Sales
            Map<Id, String> isSalesServiceProximity = new Map<Id, String>(); // Map which telss whether to change to Service or call Location API
            for(Lead l : trigger.new){
                //System.debug('l : '+l); 
               // System.debug('l.PreferredDealerAccount_ID__c : '+l.PreferredDealerAccount_ID__c);
              //  System.debug('l.Is_ECRM_Update_Done__c : '+l.Is_ECRM_Update_Done__c);
              //  System.debug('l.Is_Location_Enrichment_Done__c : '+l.Is_Location_Enrichment_Done__c);
              //  System.debug('Contact Key : '+l.ContactKey_TXT__c);
              //modified as part of CAPS-4294
                if((l.PreferredDealerNumber_NUM__c == '' || l.PreferredDealerNumber_NUM__c == null || l.PreferredDealerNumber_NUM__c == '00000' || l.PreferredDealerNumber_NUM__c == '000000') && l.SalesRelatedDealerNumber__c == null && l.ServiceRelatedDealerNumber__c == null  && l.Is_Location_Enrichment_Done__c == false && l.Is_HELMS_Contact_Key__c){
                  //  System.debug('000000');
                    if(leadIdForLocationService.size() == 0){
                        leadForLocationService.add(l);
                        leadIdForLocationService.add(l.Id);
                    }else if(!leadIdForLocationService.contains(l.Id)){
                        leadForLocationService.add(l);
                        leadIdForLocationService.add(l.Id);
                    }
                }
                //modified as part of CAPS-4294
                else if((l.PreferredDealerNumber_NUM__c == '' || l.PreferredDealerNumber_NUM__c == null || l.PreferredDealerNumber_NUM__c == '00000' || l.PreferredDealerNumber_NUM__c == '000000') && l.SalesRelatedDealerNumber__c == null && l.ServiceRelatedDealerNumber__c == null  && l.Is_Location_Enrichment_Done__c == false && !l.Is_HELMS_Contact_Key__c && l.Is_ECRM_Update_Done__c){
                  //  System.debug('111111 : ');
                    if(leadIdForLocationService.size() == 0){
                        leadForLocationService.add(l);
                        leadIdForLocationService.add(l.Id);
                    }else if(!leadIdForLocationService.contains(l.Id)){
                        leadForLocationService.add(l);
                        leadIdForLocationService.add(l.Id);
                    }
                }
                //modified as part of CAPS-4294
                else if((l.PreferredDealerNumber_NUM__c == '' || l.PreferredDealerNumber_NUM__c == null || l.PreferredDealerNumber_NUM__c == '00000' || l.PreferredDealerNumber_NUM__c == '000000') && l.Is_Location_Enrichment_Done__c == false && l.Is_ECRM_Update_Done__c == true && !l.Is_HELMS_Contact_Key__c && (String.isNotBlank(l.SalesRelatedDealerNumber__c) || String.isNotBlank(l.ServiceRelatedDealerNumber__c)) ){
                  //  System.debug('222222 : ');
                    if(leadIdForCheckDistance.size() == 0){
                       leadIdForCheckDistance.add(l.Id); 
                    }else if(!leadIdForCheckDistance.contains(l.Id)){
                       leadIdForCheckDistance.add(l.Id);  
                    }
                }
                /*if(l.PreferredDealerAccount_ID__c == null && l.Is_Location_Enrichment_Done__c == false){
                    System.debug('333333 : ');
                    if(leadIdForLocationService.size() == 0){
                        leadForLocationService.add(l);
                        leadIdForLocationService.add(l.Id);
                    }else if(!leadIdForLocationService.contains(l.Id)){
                        leadForLocationService.add(l);
                        leadIdForLocationService.add(l.Id);
                    }
                }*/
            }
            
            if(leadIdForCheckDistance.size() > 0){
                isSalesServiceProximity = HelmsDealerLocatorService.checkDistance(leadIdForCheckDistance);
                if(isSalesServiceProximity.size() > 0){
                    for(Id mapkey : isSalesServiceProximity.keyset()){
                        if(isSalesServiceProximity.get(mapkey) == 'Location'){
                            if(leadIdForLocationService.size() == 0){
                              leadIdForLocationService.add(mapKey);  
                            }else if(!leadIdForLocationService.contains(mapKey)){
                              leadIdForLocationService.add(mapKey);  
                            }
                        }
                        else if(isSalesServiceProximity.get(mapkey) == 'Service'){
                            if(leadIdToUpdateSalesToService.size() == 0){
                               leadIdToUpdateSalesToService.add(mapKey); 
                            }else if(!leadIdToUpdateSalesToService.contains(mapKey)){
                                leadIdToUpdateSalesToService.add(mapKey);  
                            } 
                        }
                        else if(isSalesServiceProximity.get(mapkey) == 'Sales'){
                            if(leadIdToSalesDealer.size() == 0){
                               leadIdToSalesDealer.add(mapKey); 
                            }else if(!leadIdToSalesDealer.contains(mapKey)){
                                leadIdToSalesDealer.add(mapKey);  
                            } 
                        }
                        
                        
                    }
                }
            }
            
            if(leadIdToSalesDealer.size() > 0 && HelmsDealerLocatorService.isUpdatedSalesOnly == false){
              //  System.debug('Before Fun. Sales to Service');
                HelmsDealerLocatorService.updateSalesOnly(leadIdToSalesDealer);
            }
            
            
            if(leadIdToUpdateSalesToService.size() > 0 && HelmsDealerLocatorService.isUpdatedSalesToService == false){
               // System.debug('Before Fun. Sales to Service');
                HelmsDealerLocatorService.updateSalesToService(leadIdToUpdateSalesToService);
            }
           // System.debug('Location Set : '+leadIdForLocationService);
          //  System.debug('Locator Flag : '+HelmsDealerLocatorService.dealerLocatorFlag);
            if(leadIdForLocationService.size() > 0 && HelmsDealerLocatorService.dealerLocatorFlag == false){
                System.enqueueJob(new AsyncExecutionLocationAPI(leadIdForLocationService));
                //HelmsDealerLocatorService.dealerLocatorService(leadIdForLocationService);
                HelmsDealerLocatorService.dealerLocatorFlag = true;
            }
        }
        //LMS - 4997 - Location Service API
        
        
        
        // LMS-5401 Vamshi
        //if(Trigger.isAfter && Trigger.isUpdate){
        //if(Trigger.isAfter){ 
        if(Trigger.isAfter && Trigger.isInsert){
         //   System.debug('Inside After and Update');
            List<Lead> listLead = new List<Lead>();
            Set<Id> setConvertedLeads = new Set<Id>();
             
            for(Lead l : trigger.new){
             //   System.debug('Lead===>>>>>'+l);
                //Lead oldLead = trigger.oldMap.get(l.Id);
                if(l.External_Lead_Reference_Number__c != null && (l.Is_Third_Party_Duplicate_Lead__c == true || l.Is_Duplicate_Similar_Lead__c == true || l.StatusReason_TXT__c =='Third Party Duplicate' || l.StatusReason_TXT__c == 'Duplicate Similar')){
                    listLead.add(l);
                }
                /*if(l.Error_Details_Urban_Science__c !=null && l.Error_Details_Urban_Science__c != '' && oldLead.Error_Details_Urban_Science__c != l.Error_Details_Urban_Science__c && l.StatusReason_TXT__c =='Third Party Duplicate') {              
                    listLead.add(l);
                }*/
           /*     if(l.IsConverted == true && oldLead.Status != l.Status && l.Status == 'Closed - Converted'){
                    setConvertedLeads.add(l.Id);
                } */
            }
           // system.debug('>>>>>>>>>>>>>>>>'+listLead);
            if(listLead.size()>0){
                HELMSLeadStatusToUrbanScience.sendLeadStatus(listLead);
            }
        }  
        
    }
    
    
    
}