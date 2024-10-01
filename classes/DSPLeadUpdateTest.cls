/****  Test Name:DSPLeadUpdateTest
Test class for DSPLeadUpdateHandler
****/
@isTest
public class DSPLeadUpdateTest {
    

    @isTest static void testUpdateLeads(){
        RecordType providerRecordType = [SELECT Id FROM RecordType WHERE DeveloperName = 'Provider' AND SObjectType = 'Account' LIMIT 1];
        Account providerAccount = new Account(Name = 'TEST PROVIDER', RecordTypeId = providerRecordType.Id);
        insert providerAccount;
        
        User integrationUser = [SELECT Id FROM User WHERE Name = :System.Label.PlatformEventUSerProfileName AND isactive = true AND Profile.Name = :System.Label.PEProfile LIMIT 1];
        List<Lead> dspLeads = new List<Lead>();

        Lead dspLead = new Lead();
        dspLead.Source_Unique_ID__c='316753';
        dspLead.FirstName= 'Test 1';
        dspLead.MiddleName= 'lead Record';
        dspLead.LastName= '4 APR 2023';
     //   dspLead.Salesforce_Order_Number__c ='123456';
        insert dspLead;

        Lead dspLead1 = new Lead();
        dspLead1.Source_Unique_ID__c='316754';
        dspLead1.FirstName= 'Test 2';
        dspLead1.MiddleName= 'lead Record';
        dspLead1.LastName= '4 APR 2023';
     //   dspLead1.Salesforce_Order_Number__c ='123456';
        insert dspLead1;

        dspLeads.add(dspLead);
        dspLeads.add(dspLead1);
        
        List<DSP_Lead_Update__e> dspLeadCreations = new List<DSP_Lead_Update__e>();
        
        DSP_Lead_Update__e dspLeadCreation1 = new DSP_Lead_Update__e();
        dspLeadCreation1.Source_Unique_ID__c='316753';
        dspLeadCreation1.Model_Name_NM__c='test';
        dspLeadCreation1.ProviderDetails_TXT__c = 'ABC:xyz';
        dspLeadCreation1.Lead_Provider_Name__c = 'Test Provider Name';
        dspLeadCreation1.Vehicle_IDs__c = 'Test Vehicle><I<D';
        dspLeadCreation1.Dealer_IDs__c = 'Test Dealer><0<0';
        dspLeadCreation1.Provider_IDs__c = 'Test Provider ID';
        dspLeadCreation1.Business_Unit_Code_CD__c = 'Test Business Unit Code';
        dspLeadCreation1.BusinessUnitSubDivision_CD__c = 'Test Business Unit Sub Division';
        dspLeadCreation1.Vehicle_Interest_TXT__c = 'Test Vehicle Interest';
        dspLeadCreation1.Vehicle_Status_TX__c = 'Test Vehicle Status';
        dspLeadCreation1.Make_TXT__c = 'Test Make';
        dspLeadCreation1.Model_TXT__c = 'Test Model';
        dspLeadCreation1.Transmission_TXT__c = 'abcd';
        dspLeadCreation1.FirstName_NM__c = 'happy siri testing testing testing testing testing';
        dspLeadCreation1.LastName_NM__c = 'lavanya siri testing testing testing testing testing testing testing testing testing testing testing';
        dspLeadCreation1.Email_TXT__c = 'lavanya@gmail.com'; 
        dspLeadCreation1.Phone_TXT__c = '8976543210'; 
        dspLeadCreation1.Mobile_TXT__c = '90876543210';
        dspLeadCreation1.ContactMethod_TXT__c = 'HomePhone';
        dspLeadCreation1.Description_DESC__c = 'comments'; 
        dspLeadCreation1.Provider_Tool__c = 'abcd'; 
        dspLeadCreation1.Model_Trim_TXT__c = 'abcd';
        dspLeadCreation1.MSRP_AMT__c='23,000';
        dspLeadCreation1.Year_YR__c=2022; 
        dspLeadCreation1.Vin_Number_NUM__c='1HGEJ8145WL012057'; 
        dspLeadCreation1.Body_Style_TXT__c='Test Style'; 
        dspLeadCreation1.Odometer_TXT__c='Test Odometer Text'; 
        dspLeadCreation1.Odometer_Status_TXT__c='unknown';
        dspLeadCreation1.Odometer_Units_TXT__c='091308'; 
        dspLeadCreation1.Stock_Number_NUM__c='100'; 
        dspLeadCreation1.Color_TXT__c='red'; 
        dspLeadCreation1.MiddleName_NM__c='ABC'; 
        dspLeadCreation1.AddressType_TXT__c='home';
        dspLeadCreation1.AddressLine1_TXT__c='Test Addr1'; 
        dspLeadCreation1.AddressLine2_TXT__c='Test Addr2'; 
        dspLeadCreation1.AddressLine3_TXT__c='Test Addr3'; 
        dspLeadCreation1.AddressLine4_TXT__c='Test Addr4'; 
        dspLeadCreation1.AddressLine5_TXT__c='Test Addr5';
        dspLeadCreation1.ApartmentNumber_NUM__c='1-100'; 
        dspLeadCreation1.City_TXT__c='Dublin'; 
        dspLeadCreation1.State_TXT__c='OH'; 
        dspLeadCreation1.Country_TXT__c='United States';
        dspLeadCreation1.ZipCode_TXT__c='43017';
        dspLeadCreation1.ProviderContactDetails_TXT__c='test provider contact ';
        dspLeadCreation1.OtherLeadProvider_TXT__c='test';
        
        dspLeadCreation1.Appointment_Date_and_Time__c='10 AM 4/4/2023';
        dspLeadCreation1.Appointment_Location__c='test dublin';
        DSPLeadCreation1.Appointment_Notes__c='test';
        dspLeadCreation1.ApartmentNumber_NUM__c='1-102/1';
        dspLeadCreation1.Deposit_Amount__c=827394.00;
        dspLeadCreation1.Contact_person__c='TEST SIRI';
        dspLeadCreation1.Salesforce_Order_Number__c='647847';
        dspLeadCreation1.Deal_ID__c='1234567890';
        dspLeadCreation1.Deal_Link__c='deal link';
        
        DSP_Lead_Update__e dspLeadCreation2 = new DSP_Lead_Update__e();
        dspLeadCreation2.Source_Unique_ID__c='316754';
        dspLeadCreation2.Model_Name_NM__c='test';
        dspLeadCreation2.ProviderDetails_TXT__c = 'ABC:xyz';
        dspLeadCreation2.Lead_Provider_Name__c = 'Test Provider Name';
        dspLeadCreation2.Vehicle_IDs__c = 'Test Vehicle><I<D';
        dspLeadCreation2.Dealer_IDs__c = 'Test Dealer><0<0';
        dspLeadCreation2.Provider_IDs__c = 'Test Provider ID';
        dspLeadCreation2.Business_Unit_Code_CD__c = 'Test Business Unit Code';
        dspLeadCreation2.BusinessUnitSubDivision_CD__c = 'Test Business Unit Sub Division';
        dspLeadCreation2.Vehicle_Interest_TXT__c = 'Test Vehicle Interest';
        dspLeadCreation2.Vehicle_Status_TX__c = 'Test Vehicle Status';
        dspLeadCreation2.Make_TXT__c = 'Test Make';
        dspLeadCreation2.Model_TXT__c = 'Test Model';
        dspLeadCreation2.Transmission_TXT__c = 'abcd';
        dspLeadCreation2.FirstName_NM__c = 'happy siri testing testing testing testing testing';
        dspLeadCreation2.LastName_NM__c = 'lavanya siri testing testing testing testing testing testing testing testing testing testing testing';
        dspLeadCreation2.Email_TXT__c = 'lavanya@gmail.com'; 
        dspLeadCreation2.Phone_TXT__c = '8976543210'; 
        dspLeadCreation2.Mobile_TXT__c = '90876543210';
        dspLeadCreation2.ContactMethod_TXT__c = 'HomePhone';
        dspLeadCreation2.Description_DESC__c = 'comments'; 
        dspLeadCreation2.Provider_Tool__c = 'abcd'; 
        dspLeadCreation2.Model_Trim_TXT__c = 'abcd';
        dspLeadCreation2.MSRP_AMT__c='23,000';
        dspLeadCreation2.Year_YR__c=2022; 
        dspLeadCreation2.Vin_Number_NUM__c='1HGEJ8145WL012057'; 
        dspLeadCreation2.Body_Style_TXT__c='Test Style'; 
        dspLeadCreation2.Odometer_TXT__c='Test Odometer Text'; 
        dspLeadCreation2.Odometer_Status_TXT__c='unknown';
        dspLeadCreation2.Odometer_Units_TXT__c='091308'; 
        dspLeadCreation2.Stock_Number_NUM__c='100'; 
        dspLeadCreation2.Color_TXT__c='red'; 
        dspLeadCreation2.MiddleName_NM__c='ABC'; 
        dspLeadCreation2.AddressType_TXT__c='home';
        dspLeadCreation2.AddressLine1_TXT__c='Test Addr1'; 
        dspLeadCreation2.AddressLine2_TXT__c='Test Addr2'; 
        dspLeadCreation2.AddressLine3_TXT__c='Test Addr3'; 
        dspLeadCreation2.AddressLine4_TXT__c='Test Addr4'; 
        dspLeadCreation2.AddressLine5_TXT__c='Test Addr5';
        dspLeadCreation2.ApartmentNumber_NUM__c='1-100'; 
        dspLeadCreation2.City_TXT__c='Dublin'; 
        dspLeadCreation2.State_TXT__c='OH'; 
        dspLeadCreation2.Country_TXT__c='United States';
        dspLeadCreation2.ZipCode_TXT__c='43017';
        dspLeadCreation2.ProviderContactDetails_TXT__c='test provider contact ';
        dspLeadCreation2.OtherLeadProvider_TXT__c='test';
       
        dspLeadCreation2.Appointment_Date_and_Time__c='10 AM 4/4/2023';
        dspLeadCreation2.Appointment_Location__c='test dublin';
        dspLeadCreation2.Appointment_Notes__c='test';
        dspLeadCreation2.Appointment_type__c='test';
        dspLeadCreation2.ApartmentNumber_NUM__c='1-102/1';
        dspLeadCreation2.Deposit_Amount__c=827394.00;
        dspLeadCreation2.Contact_person__c='TEST SIRI';
        dspLeadCreation2.Salesforce_Order_Number__c='647847';
        dspLeadCreation2.Deal_ID__c='1234567899';
        dspLeadCreation2.Deal_Link__c='deal link';

        dspLeadCreations.add(dspLeadCreation1);
        dspLeadCreations.add(dspLeadCreation2);
       
       Test.startTest();
        
       eventbus.publish(dspLeadCreations);
       DSPLeadUpdateHandler.updateLeads(dspLeadCreations);
        
       Test.stopTest();
        
        
       List<Lead> checkUpdateLeads = [Select Id,CreatedById,ownerid,Vehicle_Ids_ID__c,Model_ID__c,Dealer_Ids_ID__c,PreferredDealerNumber_NUM__c,Dealer_Assignment_Type__c,Provider_Ids_ID__c,Division_CD__c,SubDiv_TXT__c,VehicleInterest_TXT__c,VehicleStatus_TXT__c,Make_TXT__c,Model_TXT__c,Trim_TXT__c,Model_Name_NM__c,MSRP_AMT__c,Year_YR__c,Number_NM__c,BodyStyle_TXT__c,Odometer_TXT__c,OdometerStatus_TXT__c,OdometerUnits_TXT__c,Transmission_TXT__c,InventoryNumber_TXT__c,Color_TXT__c,FirstName,LastName,MiddleName,AddressType_TXT__c,Street,AppartmentNumber_TXT__c,City,state,Country,PostalCode,Email,Phone,MobilePhone,ContactMethod_TXT__c,Description,LeadProvider_ID__c,ProviderContactDetail_TXT__c,OtherLeadProvider_TXT__c,Provider_Tool_Name__c,Source_Unique_ID__c,Appointment_Location__c,Appointment_Notes__c,Contact_person__c,Deposit_Sales_Order_Number__c,DEPOSIT_AMOUNT__c,ProviderDetail_TXT__c, Deal_ID__c, Deal_Link__c From Lead];
       System.debug('checkUpdateLeads-----'+checkUpdateLeads); 
        
       System.assertEquals('test', checkUpdateLeads[0].Model_Name_NM__c);
       System.assertEquals('ABC:xyz', checkUpdateLeads[0].ProviderDetail_TXT__c);
       System.assertEquals('Test Vehicle><I<D',checkUpdateLeads[0].Vehicle_Ids_ID__c);
       System.assertEquals('Test Dealer><0<0',checkUpdateLeads[0].Dealer_Ids_ID__c );
       System.assertEquals('Test Provider ID', checkUpdateLeads[0].Provider_Ids_ID__c);
    }
    
    @isTest static void testUpdateLeads1(){
        
        Lead dspLead1 = new Lead();
        dspLead1.Source_Unique_ID__c='316753';
        dspLead1.FirstName= 'Test 1';
        dspLead1.MiddleName= 'Lead Record';
        dspLead1.LastName= '4 APR 2023';
        //dspLead1.Salesforce_Order_Number__c ='123456';
        insert DspLead1;
        
        DSP_Lead_Update__e dspLeadCreation=new DSP_Lead_Update__e();
        dspLeadCreation.Source_Unique_ID__c='316753';
        dspLeadCreation.FirstName_NM__c='happy';
        dspLeadCreation.LastName_NM__c='SIRI';
        dspLeadCreation.Model_Name_NM__c='test';
        dspLeadCreation.MSRP_AMT__c='1000';
        dspLeadCreation.ProviderDetails_TXT__c='test';
        dspLeadCreation.Dealer_IDs__c='1234';
        dspLeadCreation.Vehicle_IDs__c='1234';
        
        Test.startTest();
        
        List<DSP_Lead_Update__e> dspupdateLeadTest = new List<DSP_Lead_Update__e>{dspLeadCreation};
        eventbus.publish(dspupdateLeadTest);
        DSPLeadUpdateHandler.updateLeads(dspupdateLeadTest);
        
        Test.stopTest();
    }
    
    @IsTest
    static void testUpdateOpportunity(){
        
        // Create test data
        Account providerAccount = new Account(Name = 'Test Provider Account', RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider').getRecordTypeId());
        insert providerAccount;
        User integrationUser = [SELECT Id FROM User WHERE Name = :System.Label.PlatformEventUSerProfileName AND IsActive = true AND Profile.Name = :System.Label.PEProfile LIMIT 1];
        
        Lead testLead = new Lead(FirstName = 'Test', LastName = 'Lead', Company = 'Test Company', Email = 'test@test.com',Source_Unique_ID__c = '123456789', ConvertedAccountId = providerAccount.Id,  Isconverted = true);
        insert testLead;
       	
        Opportunity dspOppCreation = new Opportunity();
        dspOppCreation.Source_Unique_ID__c ='123456789';
		dspOppCreation.First_Name_TXT__c = 'Test 1';
        dspOppCreation.Middle_Name_TXT__c= 'Opp Record';
        dspOppCreation.Last_Name_TXT__c = '4 APR 2023';
       // dspOppCreation.Salesforce_Order_Number__c ='123456';
        dspOppCreation.Name='Test 1 - siri Opp Record 4 APR 2023';
        dspOppCreation.StageName='Assigned to Dealer';
        dspOppCreation.CloseDate=Date.newInstance(2023, 4, 11);
        dspOppCreation.Lead_ID__c = testLead.Id;
        insert dspOppCreation;
        
        // Create test Opportunity data
        DSP_Lead_Update__e dspOppCreationEvent = new DSP_Lead_Update__e();
        dspOppCreationEvent.Source_Unique_ID__c='123456789';
        dspOppCreationEvent.Lead_Provider_Name__c = providerAccount.Name;
        dspOppCreationEvent.Business_Unit_Code_CD__c = 'Test';
        dspOppCreationEvent.BusinessUnitSubDivision_CD__c = 'Test';
        dspOppCreationEvent.ProviderDetails_TXT__c = 'Test Provider:Test Details';
        dspOppCreationEvent.Vehicle_Interest_TXT__c = 'Test Vehicle Interest';
        dspOppCreationEvent.Vehicle_Status_TX__c = 'Test Vehicle Status';
        dspOppCreationEvent.Make_TXT__c = 'Test Make';
        dspOppCreationEvent.Model_TXT__c = 'Test Model';
        dspOppCreationEvent.Model_Trim_TXT__c='abcd';
        dspOppCreationEvent.MSRP_AMT__c='23,000';
       	dspOppCreationEvent.Year_YR__c=2022; 
        dspOppCreationEvent.Vin_Number_NUM__c='1HGEJ8145WL012057'; 
       	dspOppCreationEvent.Body_Style_TXT__c='Test Style'; 
        dspOppCreationEvent.Odometer_TXT__c='Test Odometer Text'; 
       	dspOppCreationEvent.Odometer_Status_TXT__c='unknown';
        dspOppCreationEvent.Odometer_Units_TXT__c='091308'; 
        dspOppCreationEvent.Stock_Number_NUM__c='100'; 
        dspOppCreationEvent.Color_TXT__c='red';
        dspOppCreationEvent.AddressType_TXT__c='home';
        dspOppCreationEvent.AddressLine1_TXT__c='Test Addr1'; 
        dspOppCreationEvent.AddressLine2_TXT__c='Test Addr2'; 
        dspOppCreationEvent.AddressLine3_TXT__c='Test Addr3'; 
        dspOppCreationEvent.AddressLine4_TXT__c='Test Addr4'; 
        dspOppCreationEvent.AddressLine5_TXT__c='Test Addr5';
        dspOppCreationEvent.Transmission_TXT__c = 'abcd';
        dspOppCreationEvent.Model_Name_NM__c='test';
       	dspOppCreationEvent.Vehicle_IDs__c = 'Test Vehicle><I<D';
        dspOppCreationEvent.Dealer_IDs__c = 'Test Dealer><0<0';
        dspOppCreationEvent.Provider_IDs__c = 'Test Provider ID';
        
        dspOppCreationEvent.Appointment_Date_and_Time__c='10 AM 4/4/2023';
        dspOppCreationEvent.Appointment_Location__c='test dublin';
        dspOppCreationEvent.Appointment_Notes__c='test';
        dspOppCreationEvent.Appointment_type__c='test';
        dspOppCreationEvent.ApartmentNumber_NUM__c='1-102/1';
        dspOppCreationEvent.Deposit_Amount__c=827394.00;
        dspOppCreationEvent.Contact_person__c='TEST SIRI';
        dspOppCreationEvent.Salesforce_Order_Number__c='647847';
        dspOppCreationEvent.ProviderContactDetails_TXT__c='test provider contact ';
        dspOppCreationEvent.OtherLeadProvider_TXT__c='test';
        dspOppCreationEvent.Email_TXT__c = 'lavanya@gmail.com'; 
        dspOppCreationEvent.Phone_TXT__c = '8976543210'; 
        dspOppCreationEvent.Mobile_TXT__c = '90876543210';
        dspOppCreationEvent.ContactMethod_TXT__c = 'HomePhone';
        dspOppCreationEvent.Description_DESC__c = 'comments';
        dspOppCreationEvent.City_TXT__c='Dublin'; 
        dspOppCreationEvent.State_TXT__c='OH'; 
        dspOppCreationEvent.Country_TXT__c='United States';
        dspOppCreationEvent.ZipCode_TXT__c='43017';
        dspOppCreationEvent.FirstName_NM__c='testing testing testing testing testing testing';
        dspOppCreationEvent.LastName_NM__c='testing testing testing testing testing testing testing testing testing testing testing testing';
        dspOppCreationEvent.MiddleName_NM__c='test';
        dspOppCreationEvent.Deal_ID__c='1234567890';
        dspOppCreationEvent.Deal_Link__c='deal link';

        // Test updateOpportunity method
        Test.startTest();
        
        List<DSP_Lead_Update__e> opportunityList = new List<DSP_Lead_Update__e>{dspOppCreationEvent};
        eventbus.publish(opportunityList);
        DSPLeadUpdateHandler.updateOpportunity(opportunityList);
        
        Test.stopTest();

        List<Opportunity> checkUpdatedOpportunity = [Select Id,CreatedById,ownerid,Vehicle_Ids_ID__c,Model_ID__c,Dealer_Ids_ID__c,PreferredDealerNumber_NUM__c,Dealer_Assignment_Type__c,Provider_Ids_ID__c,Division_CD__c,SubDiv_TXT__c,VehicleInterest_TXT__c,VehicleStatus_TXT__c,Make_TXT__c,Model_TXT__c,Trim_TXT__c,Model_Name_NM__c,MSRP_AMT__c,Year_YR__c,Number_NM__c,BodyStyle_TXT__c,Odometer_TXT__c,OdometerStatus_TXT__c,OdometerUnits_TXT__c,Transmission_TXT__c,InventoryNumber_TXT__c,Color_TXT__c,AddressType_TXT__c,AppartmentNumber_TXT__c,ContactMethod_TXT__c,Description,LeadProvider_ID__c,ProviderContactDetail_TXT__c,OtherLeadProvider_TXT__c,Provider_Tool_Name__c,Source_Unique_ID__c,Appointment_Location__c,Appointment_Notes__c,Contact_person__c,Deposit_Sales_Order_Number__c,DEPOSIT_AMOUNT__c,First_Name_TXT__c,Last_Name_TXT__c,Middle_Name_TXT__c,City_TXT__c,State_TXT__c,Country_TXT__c,ZipCode_TXT__c,Street_TXT__c,Email__c,MobilePhone__c,Phone__c From Opportunity];
        System.debug('checkUpdatedOpportunity----'+checkUpdatedOpportunity);
    
    }
    
    @isTest Static void testUpdateOpportunity1(){
        
        // Create test data
        Account providerAccount = new Account(Name = 'Test Provider Account', RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider').getRecordTypeId());
        insert providerAccount;
        User integrationUser = [SELECT Id FROM User WHERE Name = :System.Label.PlatformEventUSerProfileName AND IsActive = true AND Profile.Name = :System.Label.PEProfile LIMIT 1];
        
        Lead testLead = new Lead(FirstName = 'Test1', LastName = 'Lead', Company = 'Test Company', Email = 'test@test.com', Isconverted = true, Source_Unique_ID__c = '1234567', ConvertedAccountId = providerAccount.Id);
        insert testLead;
        
        Opportunity dspOpp =new Opportunity();
        dspOpp.Source_Unique_ID__c ='1234567';
		dspOpp.First_Name_TXT__c = 'Test 1 - siri';
        dspOpp.Middle_Name_TXT__c= 'Opp Record';
        dspOpp.Last_Name_TXT__c = '4 APR 2023';
        //dspOpp.Salesforce_Order_Number__c ='123456';
        dspOpp.Name='Test 1 - siri Opp Record 4 APR 2023';
        dspOpp.StageName='Assigned to Dealer';
        dspOpp.CloseDate=Date.newInstance(2023, 4, 11);
        dspOpp.Lead_ID__c = testLead.Id;
        insert dspOpp;
        
        DSP_Lead_Update__e oppCreation = new DSP_Lead_Update__e();
        oppCreation.Source_Unique_ID__c='1234567';
        oppCreation.Model_Name_NM__c='test';
        oppCreation.MSRP_AMT__c='1000';
        oppCreation.ProviderDetails_TXT__c='test';
        oppCreation.Dealer_IDs__c='1234';
        oppCreation.Vehicle_IDs__c='1234';
        oppCreation.LastName_NM__c='siri';
        oppCreation.FirstName_NM__c='test';
        
        Test.startTest();
        
        List<DSP_Lead_Update__e> testUpdatedOpp = new List<DSP_Lead_Update__e>{oppCreation};
        eventbus.publish(testUpdatedOpp);
        DSPLeadUpdateHandler.updateOpportunity(testUpdatedOpp);
        
        Test.stopTest();
    }
    
    @IsTest static void testUpdateOpportunity2() {
        
      // Create test data
      Account providerAccount = new Account(Name = 'Test Provider Account', RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider').getRecordTypeId());
      insert providerAccount;
      User integrationUser = [SELECT Id FROM User WHERE Name = :System.Label.PlatformEventUSerProfileName AND IsActive = true AND Profile.Name = :System.Label.PEProfile LIMIT 1];
        
      Lead testLead = new Lead(FirstName = 'Test2 bruno', LastName = 'Lead', Company = 'Test Company 2', Email = 'testbruno@test.com', Isconverted = true, ConvertedAccountId = providerAccount.Id);
      insert testLead;
          
      Opportunity dspOpp =new Opportunity();
        
	  dspOpp.First_Name_TXT__c = 'Test 2 - bruno';
      dspOpp.Middle_Name_TXT__c= 'Opp Record';
      dspOpp.Last_Name_TXT__c = '6 APR 2023';
     // dspOpp.Salesforce_Order_Number__c ='12345996';
      dspOpp.Name='Test 2 - bruno Opp Record 6 APR 2023';
      dspOpp.StageName='Assigned to Dealer';
      dspOpp.CloseDate=Date.newInstance(2023, 6, 11);
      dspOpp.Lead_ID__c = testLead.Id;
      insert dspOpp;
          
      DSP_Lead_Update__e oppCreation = new DSP_Lead_Update__e();
        
      oppCreation.Model_Name_NM__c='test';
      oppCreation.MSRP_AMT__c='1000';
      oppCreation.ProviderDetails_TXT__c='test';
      oppCreation.Dealer_IDs__c='1234';
      oppCreation.Vehicle_IDs__c='1234';
      oppCreation.LastName_NM__c='bruno';
      oppCreation.FirstName_NM__c='test';

      Test.startTest();
       
      List<DSP_Lead_Update__e> testUpdatedOpp = new List<DSP_Lead_Update__e>{oppCreation};
      eventbus.publish(testUpdatedOpp);
      DSPLeadUpdateHandler.updateOpportunity(testUpdatedOpp);
        
      Test.stopTest();
        
	}
     
}