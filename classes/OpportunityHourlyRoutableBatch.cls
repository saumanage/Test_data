global class OpportunityHourlyRoutableBatch implements Database.Batchable<sObject>,Database.Stateful,Schedulable { 
//global class OpportunityHourlyRoutableBatch implements Database.Batchable<sObject>,Database.Stateful { 
    
    global string query = '';
    global datetime dt=system.now().addhours(-3);
    global OpportunityHourlyRoutableBatch(){
        
    }
    
    global OpportunityHourlyRoutableBatch(string query){
        this.query=query;
    }
    
    global Database.QueryLocator start(Database.BatchableContext bc){  
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext bc, List<Opportunity> routableOpportunity){
        try{
            if(routableOpportunity.size() > 0){
                HELMSLeadDealerAssignmentADFHandler dealerAssignObj = new HELMSLeadDealerAssignmentADFHandler();
                HELMSLeadDealerAssignmentADFHandler.isRoutingBatchProcess = true;
                dealerAssignObj.newLeadDispositionADFs(routableOpportunity);      
            } 
        }Catch(Exception ex){                       
            Logs__c  l =new Logs__c (name='OpportunityHourlyRoutableBatch',Trigger_or_Class_Name__c='OpportunityHourlyRoutableBatch', Error_Message__c =ex.getMessage(), Error_Line_Number__c =Integer.valueOf(string.valueof(ex.getLineNumber() )) );
           insert l;
        }
    }
        
    global void finish(Database.BatchableContext bc){
        
    }  
    
    global void execute (SchedulableContext sc){
        datetime dt=system.now().addhours(-3);
        string query= 'SELECT Id,Lead_Dealer_Acknowledgement_Status_Code__c,Street_TXT__c,AddressType_TXT__c,AppartmentNumber_TXT__c,BodyStyle_TXT__c,City_TXT__c,';
        query= query+'Color_XML__c,Condition_TXT__c,ContactTime_TXT__c,ContactType_TXT__c,ContactMethod_TXT__c,Country_TXT__c,Customer_Ids_ID__c,';
        query= query+'PreferredDealerNumber_NUM__c,Division_CD__c,PSPOwnershipStatus_TXT__c,';
        query= query+'PSPCurrentProductsOwned_TXT__c,PSPCurrentProductsOwned2_TXT__c,PSPOwnershipStatusHousehold_TXT__c,';
        query= query+'PEOwnershipStatus_TXT__c,PECurrentProductsOwned_TXT__c,PEOwnershipStatusHousehold_TXT__c,';
        query= query+'HondaOwnershipStatus_TXT__c,HondaCurrentProductsOwned_TXT__c,HondaCurrentProductsOwned2_TXT__c,';
        query= query+'HondaHighValueTrimlinePropensity_NUM__c,HondaOwnershipStatusHousehold_TXT__c,AcuraOwnershipStatus_TXT__c,';
        query= query+'AcuraCurrentProductsOwned_TXT__c,AcuraCurrentProductsOwned2_TXT__c,AcuraHighValueTrimlinePropensity_NUM__c,';
        query= query+'AcuraOwnershipStatusHousehold_TXT__c,YourDealershipServicesLast60Mths_NUM__c,Chat_Transcript__c,';
        query= query+'YourDealershipSvsSpentLast60Mth_NUM__c,DateofLastService_DT__c,SalesRelatedDealerNumber__c,';
        query= query+'ServiceRelatedDealerNumber__c,LeadAdditionalInfos__c,Description,Doors_TXT__c,Email__c,Fax__c,';
        query= query+'FinancialDetails_TXT__c,First_Name_TXT__c,Last_Name_TXT__c,Make_TXT__c,Middle_Name_TXT__c,PhoneType_NM__c,';
        query= query+'MiddlewareUUID__c,MobilePhone__c,Trim_TXT__c,Model_TXT__c,MSRP_AMT__c,Name,OdometerStatus_TXT__c,';
        query= query+'Odometer_TXT__c,OdometerUnits_TXT__c,Options_TXT__c,OtherContacts_TXT__c,OtherLeadProvider_TXT__c,';
        query= query+'Pager_TXT__c,Phone__c,Prospect_Ids_ID__c,Provider_Ids_ID__c,Routing_Status__c,ProviderContactDetail_TXT__c,';
        query= query+'ProviderDetail_TXT__c,PurchaseEarliestDate_DT__c,PurchaseHorizon_TXT__c,PurchaseLatestDate_DT__c,';
        query= query+'Quote_AMT__c,Source_Name__c,SourceUser_TXT__c,State_TXT__c,Suffix_TXT__c,InventoryNumber_TXT__c,';
        query= query+'TradeBalanceOwed_TXT__c,TradeMake_TXT__c,TradeMileage_TXT__c,TradeModel_TXT__c,TradeStatus_TXT__c,';
        query= query+'TradeValue_TXT__c,TradeYear_YR__c,Transmission_TXT__c,TriggerTypeCode__c,TriggerSendbyDate_DT__c,';
        query= query+'Vehicle_Ids_ID__c,VehicleInterest_TXT__c,VehicleStatus_TXT__c,Number_NM__c,Year_YR__c,ZipCode_TXT__c,';
        query= query+'SendOnlyToUrbanScience__c,Provider_Tool_Name__c, External_Lead_Reference_Number__c,LeadProvider_ID__c,';
        query= query+'Is_Third_Party_Duplicate__c,Duplicate_Similar__c,Routable_FLG__c,Deposit_Confirmation_Number__c,Deposit_Sales_Order_Number__c,';
        query= query+'DEPOSIT_AMOUNT__c,PreferredDealerAccount_TXT__c, SubDiv_TXT__c, Opportunity_SF_ID__c,';
        query= query+'Disposition_Started__c,ENR_CI_Children_in_Household__c,';
        query= query+'ENR_CI_Likely_to_Buy_Acura__c,ENR_CI_Likely_to_Buy_Honda__c,ENR_CI_Likely_to_Buy_PSP__c,ENR_CI_Ownership__c,';
        query= query+'ENR_CI_Ownership_Details__c,ENR_CI_Service_History__c,DMGR_Environmental_Issues__c,';
        query= query+'DMGR_Green_Living__c,DMGR_Baseball__c,DMGR_Basketball__c,DMGR_Football__c,DMGR_US_Travel__c,DMGR_Hockey__c,';
        query= query+'DMGR_Skiing__c,DMGR_Golf__c,DMGR_Vehicle_Known_Owned__c,DMGR_Age__c,DMGR_Income__c,DMGR_Children__c,';
        query= query+'DMGR_Income_Estate_HHLD_Higher_Ranges__c,DMGR_Marital_Status__c,DMGR_Occupation__c,DMGR_Home_Owner_or_Renter__c,';
        query= query+'DMGR_Occupation_Detailed__c,DMGR_Household_Size__c,DMGR_Education_Level__c,ENR_CI_Event_Attendance__c,';
        query= query+'ENR_CI_Extended_Warranty__c,ENR_Acura_Vehicles_Owned__c,';
        query= query+'ENR_Honda_Vehicles_Owned__c,ENR_Power_Sports_Vehicles_Owned__c,ENR_Power_Equipment_Vehicles_Owned__c,ENR_Extended_Warranty_Contract__c,';
        query= query+'ENR_Likeliness_to_Buy_Acura__c,ENR_Likeliness_to_Buy_Honda__c,ENR_Likeliness_to_Buy_PSP__c,ENR_Ownership_Type__c,';
        query= query+'ENR_Total_Spent_on_Service_by_Customer__c,ENR_Total_Spent_on_Service_by_Warranty__c,Einstein_Predicted_Priority__c,';
        query= query+'Appointment_Notes__c, Initial_Walkin_Lead__c,Is_This_Lead_Update__c, Contact_person__c, Deal_ID__c, Deal_Link__c,';
        query= query+'Deposit_IP_Addres_URL__c, Provider_Type__c, Vendor_Contact_Email__c,Vendor_Contact_Name__c,Send_to_DSP__c, Appointment_Date_and_Time__c,Appointment_Location__c,Source_Unique_ID__c, Appointment_Id__c, Appointment_type__c FROM Opportunity ';
        query= query+'WHERE Routable_FLG__c = true AND Disposition_Started__c = false AND createddate >=:dt AND  (Lead_Dealer_Acknowledgement_Status_Code__c = \'\' OR Lead_Dealer_Acknowledgement_Status_Code__c = \'3\' OR Lead_Dealer_Acknowledgement_Status_Code__c = \'4\' OR Lead_Dealer_Acknowledgement_Status_Code__c = \'5\' OR Lead_Dealer_Acknowledgement_Status_Code__c = \'6\' ) LIMIT 9999 ';
        OpportunityHourlyRoutableBatch RoutingBatch = new OpportunityHourlyRoutableBatch(query);
        Id batchId = Database.executeBatch(RoutingBatch,1);
    }

    
}