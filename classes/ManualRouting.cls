//Manual Routing Class to Route the Opportunities
public class ManualRouting {
    
    
    @invocableMethod(label='Opportunity Routing Flow')
    public static void opportunityRoutingFlow(List<FlowOutput> strOppId){
        //System.debug('Inside Routing Flow');
        //System.debug('strOppId : '+strOppId);
        //System.debug('0 : '+strOppId[0].listOfOppIds);
        String[] myCollection = strOppId[0].listOfOppIds;
        //System.debug('myCollection : '+myCollection);
        HELMSLeadDealerAssignmentADFHandler dealerAssignObj = new HELMSLeadDealerAssignmentADFHandler();
        Set<Id> opportunityIdsToRoute = new Set<Id>();
        List<opportunity> notRoutableOpps = new List<opportunity>();
        List<opportunity> oppRecToRoute = new List<opportunity>();
        for(String s: myCollection){
            //System.debug('s : '+s);
            opportunityIdsToRoute.add(Id.valueOf(s));
        }
        List<Opportunity> oppToUpdate = new List<Opportunity>();
        if(opportunityIdsToRoute.size() > 0){
            //System.debug('Inside If **'); //Urban_Science_Routing_Status_Message__c,
            for(Opportunity oppRecord : [SELECT Id,Provider_Type__c, SendOnlyToUrbanScience__c,Routable_FLG__c,Routing_Status__c,Routing_Success_Date_Time__c,Urban_Science_Routing_Response_Message__c,Routing_Status_Message__c FROM Opportunity WHERE ID IN : opportunityIdsToRoute]){
                if(oppRecord.SendOnlyToUrbanScience__c){
                   oppRecord.SendOnlyToUrbanScience__c = false; 
                }
                if(oppRecord.Routable_FLG__c){
                   oppRecord.Routable_FLG__c = false; 
                }
                if(oppRecord.Routing_Status__c != '' && oppRecord.Routing_Status__c != null ){
                   oppRecord.Routing_Status__c = ''; 
                }
                if(oppRecord.Routing_Success_Date_Time__c != null ){
                   oppRecord.Routing_Success_Date_Time__c = null; 
                }
                if(oppRecord.Urban_Science_Routing_Response_Message__c != '' && oppRecord.Urban_Science_Routing_Response_Message__c != null ){
                   oppRecord.Urban_Science_Routing_Response_Message__c = ''; 
                }
                /*if(oppRecord.Urban_Science_Routing_Status_Message__c != '' && oppRecord.Urban_Science_Routing_Status_Message__c != null ){
                   oppRecord.Urban_Science_Routing_Status_Message__c = ''; 
                }*/  
                if(oppRecord.Routing_Status_Message__c != '' && oppRecord.Routing_Status_Message__c != null ){
                   oppRecord.Routing_Status_Message__c = ''; 
                }
                //System.debug('oppRecord : '+oppRecord);
                oppToUpdate.add(oppRecord);
            }
        }
        if(oppToUpdate.size() > 0 && HELMSOpportunityHandler.isUpdatedOpportunityStatus == false){
            HELMSOpportunityHandler.isUpdatedOpportunityStatus = true;
            //System.debug('Inside If ** ** : '+oppToUpdate);
            update oppToUpdate;
        }
        //System.debug('Inside If ** ** ** : '+oppToUpdate);
        if(opportunityIdsToRoute.size() > 0){
            for(Opportunity oppRec : [SELECT Id,Deposit_IP_Addres_URL__c, Provider_Type__c, Is_This_Lead_Update__c, Send_to_DSP__c, Vendor_Contact_Email__c, Vendor_Contact_Name__c, Appointment_Location__c,Initial_Walkin_Lead__c,Source_Unique_ID__c,Appointment_Notes__c, Contact_person__c, Deal_ID__c, Deal_Link__c, Appointment_Date_and_Time__c, Appointment_Id__c, Appointment_type__c, Name,Is_Third_Party_Duplicate__c,Duplicate_Similar__c,Einstein_Predicted_Priority__c,Routable_FLG__c,Opportunity_SF_ID__c,Deposit_Confirmation_Number__c,Deposit_Sales_Order_Number__c,DEPOSIT_AMOUNT__c,PreferredDealerAccount_TXT__c, SubDiv_TXT__c,SendOnlyToUrbanScience__c,Provider_Tool_Name__c, External_Lead_Reference_Number__c,LeadProvider_ID__c,Vehicle_Ids_ID__c,VehicleInterest_TXT__c,VehicleStatus_TXT__c,Number_NM__c,Year_YR__c,ZipCode_TXT__c,TradeValue_TXT__c,TradeYear_YR__c,Transmission_TXT__c,TriggerTypeCode__c,TriggerSendbyDate_DT__c,TradeBalanceOwed_TXT__c,TradeMake_TXT__c,TradeMileage_TXT__c,TradeModel_TXT__c,TradeStatus_TXT__c,Quote_AMT__c,Source_Name__c,SourceUser_TXT__c,State_TXT__c,Suffix_TXT__c,InventoryNumber_TXT__c,ProviderDetail_TXT__c,PurchaseEarliestDate_DT__c,PurchaseHorizon_TXT__c,PurchaseLatestDate_DT__c,Pager_TXT__c,Phone__c,Prospect_Ids_ID__c,Provider_Ids_ID__c,Routing_Status__c,ProviderContactDetail_TXT__c,Odometer_TXT__c,OdometerUnits_TXT__c,Options_TXT__c,OtherContacts_TXT__c,OtherLeadProvider_TXT__c,MiddlewareUUID__c,MobilePhone__c,Trim_TXT__c,Model_TXT__c,MSRP_AMT__c,OdometerStatus_TXT__c,FinancialDetails_TXT__c,First_Name_TXT__c,Last_Name_TXT__c,Make_TXT__c,Middle_Name_TXT__c,PhoneType_NM__c,ServiceRelatedDealerNumber__c,LeadAdditionalInfos__c,Description,Doors_TXT__c,Email__c,Fax__c,YourDealershipSvsSpentLast60Mth_NUM__c,DateofLastService_DT__c,SalesRelatedDealerNumber__c,AcuraOwnershipStatusHousehold_TXT__c,YourDealershipServicesLast60Mths_NUM__c,Chat_Transcript__c,AcuraCurrentProductsOwned_TXT__c,AcuraCurrentProductsOwned2_TXT__c,AcuraHighValueTrimlinePropensity_NUM__c,HondaHighValueTrimlinePropensity_NUM__c,HondaOwnershipStatusHousehold_TXT__c,AcuraOwnershipStatus_TXT__c,HondaOwnershipStatus_TXT__c,HondaCurrentProductsOwned_TXT__c,HondaCurrentProductsOwned2_TXT__c,PEOwnershipStatus_TXT__c,PECurrentProductsOwned_TXT__c,PEOwnershipStatusHousehold_TXT__c,PSPCurrentProductsOwned_TXT__c,PSPCurrentProductsOwned2_TXT__c,PSPOwnershipStatusHousehold_TXT__c,Customer_Ids_ID__c,PreferredDealerNumber_NUM__c,Division_CD__c,PSPOwnershipStatus_TXT__c,Color_XML__c,Condition_TXT__c,ContactTime_TXT__c,ContactType_TXT__c,ContactMethod_TXT__c,Country_TXT__c,Lead_Dealer_Acknowledgement_Status_Code__c,Street_TXT__c,AddressType_TXT__c,AppartmentNumber_TXT__c,BodyStyle_TXT__c,City_TXT__c,ENR_CI_Service_History__c,ENR_CI_Ownership_Details__c,ENR_CI_Ownership__c,ENR_CI_Likely_to_Buy_PSP__c,ENR_CI_Likely_to_Buy_Honda__c,ENR_CI_Likely_to_Buy_Acura__c,ENR_CI_Extended_Warranty__c,ENR_CI_Event_Attendance__c,ENR_CI_Children_in_Household__c,DMGR_Environmental_Issues__c,DMGR_Green_Living__c,DMGR_Baseball__c,DMGR_Basketball__c,DMGR_Football__c,DMGR_US_Travel__c,DMGR_Hockey__c,DMGR_Skiing__c,DMGR_Golf__c,DMGR_Vehicle_Known_Owned__c,DMGR_Age__c,DMGR_Income__c,DMGR_Children__c,DMGR_Income_Estate_HHLD_Higher_Ranges__c,DMGR_Marital_Status__c,DMGR_Occupation__c,DMGR_Home_Owner_or_Renter__c,DMGR_Occupation_Detailed__c,DMGR_Household_Size__c,DMGR_Education_Level__c,ENR_Acura_Vehicles_Owned__c,ENR_Honda_Vehicles_Owned__c,ENR_Power_Sports_Vehicles_Owned__c,ENR_Power_Equipment_Vehicles_Owned__c,ENR_Extended_Warranty_Contract__c,ENR_Likeliness_to_Buy_Acura__c,ENR_Likeliness_to_Buy_Honda__c,ENR_Likeliness_to_Buy_PSP__c,ENR_Ownership_Type__c,ENR_Total_Spent_on_Service_by_Customer__c,ENR_Total_Spent_on_Service_by_Warranty__c From Opportunity WHERE Routable_FLG__c =FALSE AND Id IN : opportunityIdsToRoute]){
                notRoutableOpps.add(oppRec);   
            }
            if(notRoutableOpps.size() > 0){
                //HELMSLeadDealerAssignmentADFHandler routinObj = new HELMSLeadDealerAssignmentADFHandler();
                oppRecToRoute = ManualRouting.checkRoutableForManualRouting(notRoutableOpps);
                for(Opportunity oppRec : oppRecToRoute){
                    //System.debug('Inside FINAL II'+oppRec.Routable_FLG__c);
                    if(oppRec.Routable_FLG__c){
                        //System.debug('Inside FINAL II II');
                        List<Opportunity> oppToRoute = new List<Opportunity>();
                       // System.debug('Inside FINAL II II II');
                        oppToRoute.add(oppRec);
                        //dealerAssignObj.newLeadDispositionADFs(oppToRoute);
                        ManualRoutingBatch RoutingBatch = new ManualRoutingBatch(oppToRoute);
        				Id batchId = Database.executeBatch(RoutingBatch,1);
                    }
                }
            }
        }
        //System.debug('opportunityIdsToRoute : '+opportunityIdsToRoute);
    }
    /* Manaully route opportunities from flow - Invocable Variable */
    public class FlowOutput{
        @InvocableVariable()
        public List<String> listOfOppIds;
    }
    
	/* Manaully route opportunities from flow - Invocable Method */
    //@invocableMethod(label='Manual Routing1')
    public static void manualRouting1(List<FlowStringParameters> oppIds){
      //System.debug('oppIds in Manual Routing1 : '+oppIds);
      List<Id> OppIdsList = new List<Id>();
      for (FlowStringParameters oppId : oppIds) {
      	OppIdsList.add(oppId.OppIdVal);
      }
	}
    
    public class FlowStringParameters{
        @auraenabled
        @InvocableVariable(label='Text type collection of filter values' required = true)
        public String OppIdVal;
        
    }
    
    //Check Routable Flag is true or false
    public static List<Opportunity> checkRoutableForManualRouting(List<Opportunity> listopps){
        //System.debug('Inside checkRoutableForManualRouting');
        List<Opportunity> oppList = new List<Opportunity>();
        try{
            Set<Id> preferredDealerAccountSet = new Set<Id>(); //Preferred Dealer Account Set
            Set<Id> leadProviderSet = new Set<Id>();
            List<Opportunity> oppListRoutable = new List<Opportunity>(); //Routable Opportunities
            Set<String> oppSubDiv = new Set<String>(); //Opportunity SubDivision Set
            Map<Id, Boolean> hondaDigitalSolution = new Map<Id, Boolean>(); // Honda Digital Solution
            Map<Id, Boolean> leadProviderRoutable = new Map<Id, Boolean>(); // Lead Provider Routable
            Map<Id, Boolean> leadProviderSendToUrbanScience = new Map<Id, Boolean>(); // Lead Provider Send to Urban Science
            Map<String, Boolean> DealerDivExist = new Map<String, Boolean>(); //Dealer SubDivision Internet Certified
            Map<String, Boolean> DealerParticipationExist = new Map<String, Boolean>(); //Dealer SubDivision Internet Certified
            Map<String, String> BlockingRoutingMap = new Map<String, String>(); //Blocking Routable for HELMS, as there is no Dealer Participation
            for (Opportunity opp : listopps){
                preferredDealerAccountSet.add(opp.PreferredDealerAccount_TXT__c);
                leadProviderSet.add(opp.LeadProvider_ID__c);
                oppSubDiv.add(opp.SubDiv_TXT__c);
            }
            /* Adding Honda Digital Solutions value to the Map with Preferred Dealer Account Id */
            for(Account accList : [SELECT Id, HondaDigitalSolutions_FLG__c FROM Account WHERE Id IN : preferredDealerAccountSet ]){
               if(accList.HondaDigitalSolutions_FLG__c){
                    hondaDigitalSolution.put(accList.Id,true);
                }else{
                    hondaDigitalSolution.put(accList.Id,false);                    
                }
            }
            /* Adding Honda Digital Solutions value to the Map with Preferred Dealer Account Id */
            
            /* Adding LeadProvider Routable value to the Map with LeadProvider Id */
            for(Account accList1 : [SELECT Id, Routable_FLG__c, Send_to_Urban_Science_Flag__c FROM Account WHERE Id IN : leadProviderSet]){
                if(accList1.Routable_FLG__c){
                    leadProviderRoutable.put(accList1.Id,true);
                }else{
                    leadProviderRoutable.put(accList1.Id,false);
                }
                
                if(accList1.Send_to_Urban_Science_Flag__c){
                    leadProviderSendToUrbanScience.put(accList1.Id,true);
                }else{
                    leadProviderSendToUrbanScience.put(accList1.Id,false);
                }
            }
            /* Adding LeadProvider Routable value to the Map with LeadProvider Id */
            /* Checking the Internet Certified */
            for(Dealer_Division__c dealerDivList : [SELECT Id, First_Name_TXT__c, InternetCertified_FLG__c, Dealer_ID__c,SubDiv_TXT__c FROM Dealer_Division__c WHERE Dealer_ID__c IN : preferredDealerAccountSet and SubDiv_TXT__c IN : oppSubDiv and InternetCertified_FLG__c = true and isActive_FLG__c=true ]){
                DealerDivExist.put(dealerDivList.Dealer_ID__c+''+dealerDivList.SubDiv_TXT__c, dealerDivList.InternetCertified_FLG__c);
            }
            /* Checking the Internet Certified */
            /* Dealer Participation IsActive */
            //Dealer_Subdivision__r.SubDiv_TXT__c
            for(Dealer_Participation__c dealerParticipationList : [SELECT Id,Is_Active__c, DealerAccount_ID__c, Dealer_Subdivision__r.SubDiv_TXT__c, CRM_System__r.Name FROM Dealer_Participation__c WHERE Is_Active__c = true and DealerAccount_ID__c IN : preferredDealerAccountSet and Dealer_Subdivision__r.SubDiv_TXT__c IN :oppSubDiv ]){
                //DealerParticipationExist.put(dealerParticipationList.DealerAccount_ID__c+''+dealerParticipationList.Dealer_Subdivision__c,dealerParticipationList.ISActive_FLG__c);
                DealerParticipationExist.put(dealerParticipationList.DealerAccount_ID__c+''+dealerParticipationList.Dealer_Subdivision__r.SubDiv_TXT__c,dealerParticipationList.Is_Active__c);
                BlockingRoutingMap.put(dealerParticipationList.DealerAccount_ID__c+''+dealerParticipationList.Dealer_Subdivision__r.SubDiv_TXT__c,dealerParticipationList.CRM_System__r.Name);
            }
         
            /* Send to Urban Science in Lead Provider */
            
            for(Opportunity oppRec : listopps){
                if(oppRec.Division_CD__c == 'A' || oppRec.Division_CD__c == 'B'){
                    
                    if(oppRec.Division_CD__c == 'A' && !DealerParticipationExist.containskey(oppRec.PreferredDealerAccount_TXT__c+''+oppRec.SubDiv_TXT__c) && leadProviderSendToUrbanScience.containskey(oppRec.LeadProvider_ID__c) && leadProviderSendToUrbanScience.get(oppRec.LeadProvider_ID__c)){
                       oppRec.SendOnlyToUrbanScience__c = true; 
                    }
                    if(leadProviderRoutable.size() > 0 && 
                       leadProviderRoutable.containskey(oppRec.LeadProvider_ID__c) && 
                       hondaDigitalSolution.size() > 0 && 
                       hondaDigitalSolution.containskey(oppRec.PreferredDealerAccount_TXT__c) && 
                       ( BlockingRoutingMap.size() > 0 && BlockingRoutingMap.containskey(oppRec.PreferredDealerAccount_TXT__c+''+oppRec.SubDiv_TXT__c) && (BlockingRoutingMap.get(oppRec.PreferredDealerAccount_TXT__c+''+oppRec.SubDiv_TXT__c) != 'HELMS') ) && 
                       ( (DealerParticipationExist.size() > 0 && DealerParticipationExist.containskey(oppRec.PreferredDealerAccount_TXT__c+''+oppRec.SubDiv_TXT__c)) || leadProviderSendToUrbanScience.containskey(oppRec.LeadProvider_ID__c) ) && 
                       DealerDivExist.size() > 0 && 
                       DealerDivExist.containskey(oppRec.PreferredDealerAccount_TXT__c+''+oppRec.SubDiv_TXT__c)){
                         	if( leadProviderRoutable.get(oppRec.LeadProvider_ID__c) && hondaDigitalSolution.get(oppRec.PreferredDealerAccount_TXT__c) && ( (DealerParticipationExist.containskey(oppRec.PreferredDealerAccount_TXT__c+''+oppRec.SubDiv_TXT__c) && DealerParticipationExist.get(oppRec.PreferredDealerAccount_TXT__c+''+oppRec.SubDiv_TXT__c)) || leadProviderSendToUrbanScience.get(oppRec.LeadProvider_ID__c)) && DealerDivExist.get(oppRec.PreferredDealerAccount_TXT__c+''+oppRec.SubDiv_TXT__c) ){
                                oppListRoutable.add(oppRec);
                            }
                            else if( leadProviderRoutable.get(oppRec.LeadProvider_ID__c) && !hondaDigitalSolution.get(oppRec.PreferredDealerAccount_TXT__c) && ((DealerParticipationExist.containskey(oppRec.PreferredDealerAccount_TXT__c+''+oppRec.SubDiv_TXT__c) && DealerParticipationExist.get(oppRec.PreferredDealerAccount_TXT__c+''+oppRec.SubDiv_TXT__c)) || leadProviderSendToUrbanScience.get(oppRec.LeadProvider_ID__c)) && DealerDivExist.get(oppRec.PreferredDealerAccount_TXT__c+''+oppRec.SubDiv_TXT__c) ){
                                oppListRoutable.add(oppRec);
                            } else if( !leadProviderRoutable.get(oppRec.LeadProvider_ID__c) && hondaDigitalSolution.get(oppRec.PreferredDealerAccount_TXT__c) && ((DealerParticipationExist.containskey(oppRec.PreferredDealerAccount_TXT__c+''+oppRec.SubDiv_TXT__c) && DealerParticipationExist.get(oppRec.PreferredDealerAccount_TXT__c+''+oppRec.SubDiv_TXT__c)) || leadProviderSendToUrbanScience.get(oppRec.LeadProvider_ID__c)) && DealerDivExist.get(oppRec.PreferredDealerAccount_TXT__c+''+oppRec.SubDiv_TXT__c) ){
                                oppListRoutable.add(oppRec);
                            }
                    }
                    
                }else if(oppRec.Division_CD__c == 'M' || oppRec.Division_CD__c == 'P'){
                    if(leadProviderRoutable.size() > 0 && 
                       leadProviderRoutable.containskey(oppRec.LeadProvider_ID__c) && 
                       hondaDigitalSolution.size() > 0 && hondaDigitalSolution.containskey(oppRec.PreferredDealerAccount_TXT__c) && 
                       ( BlockingRoutingMap.size() > 0 && BlockingRoutingMap.containskey(oppRec.PreferredDealerAccount_TXT__c+''+oppRec.SubDiv_TXT__c) && (BlockingRoutingMap.get(oppRec.PreferredDealerAccount_TXT__c+''+oppRec.SubDiv_TXT__c) != 'HELMS') ) && 
                       DealerParticipationExist.size() > 0 && DealerParticipationExist.containskey(oppRec.PreferredDealerAccount_TXT__c+''+oppRec.SubDiv_TXT__c) && 
                       DealerDivExist.size() > 0 && DealerDivExist.containskey(oppRec.PreferredDealerAccount_TXT__c+''+oppRec.SubDiv_TXT__c)){
                            if( DealerParticipationExist.get(oppRec.PreferredDealerAccount_TXT__c+''+oppRec.SubDiv_TXT__c) && DealerDivExist.get(oppRec.PreferredDealerAccount_TXT__c+''+oppRec.SubDiv_TXT__c) ){
                                oppListRoutable.add(oppRec);
                            }
                       }
                }
            }
            
            
            if(oppListRoutable.size() > 0){
                for(Opportunity oppRec : oppListRoutable){
                    if(!oppRec.Routable_FLG__c){
                        oppRec.Routable_FLG__c = true;
                        oppRec.Routing_Status__c = 'Submitted for Re-Routing';
                        oppList.add(oppRec);
                    }
                }
            }
            
        }catch(Exception e){
            
            Logs__c l = new Logs__c(name = 'updateSameLeadGroupIdLeads', Trigger_or_Class_Name__c = 'HELMSOpportunityHandler', Error_Message__c = e.getMessage(), Error_Line_Number__c = Integer.valueOf(string.valueof(e.getLineNumber())));
            insert l;
        }
        if(oppList.size() > 0){
            update oppList;
        }
        return oppList;
    }
    
    
}