@isTest
public class OpportunityRoutableBatchTest {
	@isTest static void exc(){
     Datetime dt = System.now();
     // adding minutes in negative, effectively subtracts 30 mins
     dt = dt.addMinutes(-60);
     Id dealerAccRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
     account acc=new account();
     acc.Name = 'Syam Mohan Ac';
     acc.RecordTypeId = dealerAccRecTypeId;
     acc.DealerCode_CD__c='1234562';
     insert acc;
     
     Routing_Acknowledgement_No_Response__c r1 = new Routing_Acknowledgement_No_Response__c();
     r1.Opportunity_SF_ID__c = '123456';
     r1.CreatedDate = dt;
     insert r1;
 	
     List<opportunity> opps = new  List<opportunity>();
     opportunity opp= new opportunity(Stagename='Assigned to Dealer',PreferredDealerAccount_TXT__c=acc.id,Name='Syam Mohan',First_Name_TXT__c='Mohan', 
     LeadProvider_ID__c=acc.id,Last_Name_TXT__c = 'Mohan',Email__c='syam.gm@gmail.com', ZipCode_TXT__c='12345',Opportunity_SF_ID__c='123456',
     Routable_FLG__c = true,Disposition_Started__c = false,CreatedDate = Date.today().addDays(-2),Lead_Dealer_Acknowledgement_Status_Code__c = '3' );
     opp.CloseDate= system.Today();
     opp.CreatedDate = dt;
     insert opp;
     opps.add(opp);
        
     Test.startTest();
     OpportunityRoutableBatch ba = new OpportunityRoutableBatch();
	 ba.execute(null,opps);
	 ba.Finish(null);
     Test.stopTest();  
    }
    
    @isTest static void testOpportunityRoutableBatch() {
        
        // Test data setup
        Account acc = new Account(name ='Test1 Ac1', DealerCode_CD__c='30Z514', recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Dealer').getRecordTypeId()) ;
        insert acc;
        Account acc1 = new Account(name ='Test1 Ac2', recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider').getRecordTypeId()) ;
        insert acc1;
        
        List<Opportunity> opportunities = new List<Opportunity>();
        Opportunity opps = new Opportunity();
       
        opps.Lead_Dealer_Acknowledgement_Status_Code__c = 'sampleStatusCode';
        opps.Street_TXT__c = 'sampleStreet';
        opps.AddressType_TXT__c = 'sampleAddressType';
        opps.AppartmentNumber_TXT__c = 'sampleAppartmentNumber';
        opps.BodyStyle_TXT__c = 'sampleBodyStyle';
        opps.City_TXT__c = 'sampleCity';
        opps.Color_XML__c = 'sampleColor';
        opps.Condition_TXT__c = 'sampleCondition';
        opps.ContactTime_TXT__c = 'sampleContactTime';
        opps.ContactType_TXT__c = 'sampleContactType';
        opps.ContactMethod_TXT__c = 'sampleContactMethod';
        opps.Country_TXT__c = 'sampleCountry';
        opps.Customer_Ids_ID__c = 'sampleCustomerIds';
        opps.StageName = 'Closed Won';
        opps.CloseDate = Date.newInstance(2023, 6, 22);
        opps.PreferredDealerNumber_NUM__c = '123312';
        opps.PSPOwnershipStatus_TXT__c = 'samplePSPOwnershipStatus';
        opps.PSPCurrentProductsOwned_TXT__c = 'samplePSPCurrentProductsOwned';
        opps.PSPCurrentProductsOwned2_TXT__c = 'samplePSPCurrentProductsOwned2';
        opps.PSPOwnershipStatusHousehold_TXT__c = 'samplePSPOwnershipStatusHousehold';
        opps.PEOwnershipStatus_TXT__c = 'samplePEOwnershipStatus';
        opps.PECurrentProductsOwned_TXT__c = 'samplePECurrentProductsOwned';
        opps.PEOwnershipStatusHousehold_TXT__c = 'samplePEOwnershipStatusHousehold';
        opps.HondaOwnershipStatus_TXT__c = 'sampleHondaOwnershipStatus';
        opps.HondaCurrentProductsOwned_TXT__c = 'sampleHondaCurrentProductsOwned';
        opps.HondaCurrentProductsOwned2_TXT__c = 'sampleHondaCurrentProductsOwned2';
        opps.HondaHighValueTrimlinePropensity_NUM__c = 10.5;
        opps.HondaOwnershipStatusHousehold_TXT__c = 'sampleHondaOwnershipStatusHousehold';
        opps.AcuraOwnershipStatus_TXT__c = 'sampleAcuraOwnershipStatus';
        opps.AcuraCurrentProductsOwned_TXT__c = 'sampleAcuraCurrentProductsOwned';
        opps.AcuraCurrentProductsOwned2_TXT__c = 'sampleAcuraCurrentProductsOwned2';
        opps.AcuraHighValueTrimlinePropensity_NUM__c = 20.5;
        opps.AcuraOwnershipStatusHousehold_TXT__c = 'sampleAcuraOwnershipStatusHousehold';
        opps.YourDealershipServicesLast60Mths_NUM__c = 20.5;
        opps.Chat_Transcript__c = 'sampleChatTranscript';
        opps.YourDealershipSvsSpentLast60Mth_NUM__c = 12.5;
        opps.DateofLastService_DT__c = Date.newInstance(2023, 6, 26);
        opps.SalesRelatedDealerNumber__c = 'sampleSalesRelatedDealerNumber';
        opps.ServiceRelatedDealerNumber__c = 'sampleServiceRelatedDealerNumber';
        opps.LeadAdditionalInfos__c = 'sampleLeadAdditionalInfos';
        opps.Description = 'sampleDescription';
        opps.Doors_TXT__c = 'sampleDoors';
        opps.Email__c = 'sampleEmail@gmail.com';
        opps.Fax__c = 'sampleFax';
        opps.FinancialDetails_TXT__c = 'sampleFinancialDetails';
        opps.First_Name_TXT__c = 'sampleFirstName';
        opps.Last_Name_TXT__c = 'sampleLastName';
        opps.Make_TXT__c = 'sampleMake';
        opps.Middle_Name_TXT__c = 'sampleMiddleName';
        opps.PhoneType_NM__c = 'samplePhoneType';
        opps.MiddlewareUUID__c = 'sampleMiddlewareUUID';
        opps.MobilePhone__c = 'sampleMobilePhone';
        opps.Trim_TXT__c = 'sampleTrim';
        opps.Model_TXT__c = 'sampleModel';
        opps.MSRP_AMT__c = 10000.0; // Replace with actual value
        opps.Name = 'sampleName';
        opps.OdometerStatus_TXT__c = 'sampleOdometerStatus';
        opps.Odometer_TXT__c = 'sampleOdometer';
        opps.OdometerUnits_TXT__c = 'sampleOdometerUnits';
        opps.Options_TXT__c = 'sampleOptions';
        opps.OtherContacts_TXT__c = 'sampleOtherContacts';
        opps.OtherLeadProvider_TXT__c = 'sampleOtherLeadProvider';
        opps.Pager_TXT__c = 'samplePager';
        opps.Phone__c = 'samplePhone';
        opps.Prospect_Ids_ID__c = 'sampleProspectIds';
        opps.Provider_Ids_ID__c = 'sampleProviderIds';
        opps.Routing_Status__c = 'sampleRoutingStatus';
        opps.ProviderContactDetail_TXT__c = 'sampleProviderContactDetail';
        opps.ProviderDetail_TXT__c = 'sampleProviderDetail';
        opps.PurchaseEarliestDate_DT__c = 'test';
        opps.PurchaseHorizon_TXT__c = 'samplePurchaseHorizon';
        opps.PurchaseLatestDate_DT__c = 'test';
        opps.Quote_AMT__c = 5000.0; // Replace with actual value
        opps.Source_Name__c = 'sampleSourceName';
        opps.SourceUser_TXT__c = 'sampleSourceUser';
        opps.State_TXT__c = 'sampleState';
        opps.Suffix_TXT__c = 'sampleSuffix';
        opps.InventoryNumber_TXT__c = 'sampleInventoryNumber';
        opps.TradeBalanceOwed_TXT__c = 'sampleTradeBalanceOwed';
        opps.TradeMake_TXT__c = 'sampleTradeMake';
        opps.TradeMileage_TXT__c = 'sampleTradeMileage';
        opps.TradeModel_TXT__c = 'sampleTradeModel';
        opps.TradeStatus_TXT__c = 'sampleTradeStatus';
        opps.TradeValue_TXT__c = 'sampleTradeValue';
        opps.TradeYear_YR__c = '2023';
        opps.Transmission_TXT__c = 'sampleTransmission';
        opps.TriggerTypeCode__c = 'sampleTriggerTypeCode';
        opps.TriggerSendbyDate_DT__c = Date.newInstance(2023, 6, 22);
        opps.Vehicle_Ids_ID__c = 'sampleVehicleIds';
        opps.VehicleInterest_TXT__c = 'sampleVehicleInterest';
        opps.VehicleStatus_TXT__c = 'sampleVehicleStatus';
        opps.Number_NM__c = 'sampleNumber';
        opps.Year_YR__c = '2023';
        opps.ZipCode_TXT__c = '11111100';
        opps.SendOnlyToUrbanScience__c = false; // Replace with actual value
        opps.Provider_Tool_Name__c = 'sampleProviderToolName';
        opps.External_Lead_Reference_Number__c = 'sampleExternalLeadReferenceNumber';
        opps.LeadProvider_ID__c = acc1.Id;
        opps.Is_Third_Party_Duplicate__c = false; // Replace with actual value
        opps.Duplicate_Similar__c = false; // Replace with actual value
        opps.Routable_FLG__c = true; // Replace with actual value
        opps.Deposit_Confirmation_Number__c = 'sampleDepositConfirmationNumber';
        opps.Deposit_Sales_Order_Number__c = 'sampleDepositSalesOrderNumber';
        opps.DEPOSIT_AMOUNT__c = 1000.0; // Replace with actual value
        opps.PreferredDealerAccount_TXT__c = acc.Id;
        opps.Opportunity_SF_ID__c = 'sampleOpportunitySFId';
        opps.Disposition_Started__c = false; // Replace with actual value
        opps.ENR_CI_Children_in_Household__c = 'a'; // Replace with actual value
        opps.ENR_CI_Likely_to_Buy_Acura__c = 's'; // Replace with actual value
        opps.ENR_CI_Likely_to_Buy_Honda__c = 'g'; // Replace with actual value
        opps.ENR_CI_Likely_to_Buy_PSP__c = 's'; // Replace with actual value
        opps.ENR_CI_Ownership__c = 'a';
        opps.ENR_CI_Ownership_Details__c = 'h';
        opps.ENR_CI_Service_History__c = 's';
        opps.DMGR_Environmental_Issues__c = true;
        opps.DMGR_Green_Living__c = true; // Replace with actual value
        opps.DMGR_Baseball__c = true; // Replace with actual value
        opps.DMGR_Basketball__c = true; // Replace with actual value
        opps.DMGR_Football__c = true; // Replace with actual value
        opps.DMGR_US_Travel__c = true; // Replace with actual value
        opps.DMGR_Hockey__c = true; // Replace with actual value
        opps.DMGR_Skiing__c = true; // Replace with actual value
        opps.DMGR_Golf__c = true; // Replace with actual value
        opps.DMGR_Vehicle_Known_Owned__c = true;
        opps.DMGR_Age__c = 30; // Replace with actual value
        opps.DMGR_Income__c = '50000'; // Replace with actual value
        opps.DMGR_Children__c = '1'; // Replace with actual value
        opps.DMGR_Income_Estate_HHLD_Higher_Ranges__c = 'true'; // Replace with actual value
        opps.DMGR_Marital_Status__c = 'sampleMaritalStatus';
        opps.DMGR_Occupation__c = 'sampleOccupation';
        opps.DMGR_Home_Owner_or_Renter__c = 'sampleHomeOwnerOrRenter';
        opps.DMGR_Occupation_Detailed__c = 'sampleOccupationDetailed';
        opps.DMGR_Household_Size__c = 3; // Replace with actual value
        opps.DMGR_Education_Level__c = 'sampleEducationLevel';
        opps.ENR_CI_Event_Attendance__c = 'a'; // Replace with actual value
        opps.ENR_CI_Extended_Warranty__c = 's'; // Replace with actual value
        opps.ENR_Acura_Vehicles_Owned__c = 2; // Replace with actual value
        opps.ENR_Honda_Vehicles_Owned__c = 2; // Replace with actual value
        opportunities.add(opps);
        insert opps;
        
        // Perform the batch execution
        Test.startTest();
        String query = 'SELECT Id, Lead_Dealer_Acknowledgement_Status_Code__c FROM Opportunity';
        OpportunityRoutableBatch batch = new OpportunityRoutableBatch(query);
        Database.executeBatch(batch, 1);
        String sch = '0 0 23 * * ?';
        system.schedule('Testing', sch, batch );
        Test.stopTest();
        
    }

}