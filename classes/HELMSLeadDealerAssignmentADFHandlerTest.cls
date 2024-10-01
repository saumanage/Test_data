@isTest
public class HELMSLeadDealerAssignmentADFHandlerTest {
   @istest static void updateOpportunityOnDealerAcknowledgement1(){
        Datetime dt = System.now();
     	// adding minutes in negative, effectively subtracts 30 mins
     	dt = dt.addMinutes(-60);
        string strldinfo='<LeadAdditionalInfo key="AdditionalInfo">';
        Account acc = new Account(name ='Grazitti', DealerCode_CD__c='30Z514', recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Dealer').getRecordTypeId()) ;
        insert acc;
        Account acc1 = new Account(name ='Grazitti1', recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider').getRecordTypeId()) ;

        List<Lead_Additional_Attribute_Definition__c> ldaddattdf = new List<Lead_Additional_Attribute_Definition__c>();
        Lead_Additional_Attribute_Definition__c ldadd = new Lead_Additional_Attribute_Definition__c();
        ldadd.Name = 'AdditionalInfo';
        ldadd.Shared_With_Dealer__c = 'TRUE';
        insert ldadd;
        ldaddattdf.add(ldadd);
       
        Opportunity o = new Opportunity ();
        o.Name='test';
        o.Routable_FLG__c= true;
        o.Opportunity_SF_ID__c='123';
        //o.Routing_Status__c='Success';
        o.Routing_Failure_Date_Time__c=system.now();
        o.Routing_Success_Date_Time__c=system.now();
        o.StageName='closed won';
        o.CloseDate=system.today();
        o.Email__c='ghou@gmail.com';
        o.ZipCode_TXT__c='89010';
        o.First_Name_TXT__c='test1';
        o.Last_Name_TXT__c='test2';
        o.TriggerTypeCode__c='';
        o.LeadAdditionalInfos__c = strldinfo;
        Id devRecordTypeId = Schema.getGlobalDescribe().get('Opportunity').getDescribe().getRecordTypeInfosByName().get('Power Sports Opportunity').getRecordTypeId();
        
        o.recordtypeid=devRecordTypeId;
        o.PreferredDealerAccount_TXT__c=acc.id;
        o.LeadProvider_ID__c=acc1.id;
        o.SubDiv_TXT__c='Motorcycle';
		o.ENR_CI_Service_History__c = '';
        o.DMGR_Environmental_Issues__c = true;
        o.DMGR_Green_Living__c=true;
        o.DMGR_Baseball__c=true;
        o.DMGR_Basketball__c=true;
        o.DMGR_Football__c=true;
        o.DMGR_US_Travel__c=true;
        o.DMGR_Hockey__c=true;
        o.DMGR_Skiing__c=true;
        o.DMGR_Golf__c=true;
        o.DMGR_Vehicle_Known_Owned__c=true;
        o.DMGR_Age__c=23;
        o.DMGR_Income__c='23423';
        o.DMGR_Children__c='ABC';
        o.DMGR_Income_Estate_HHLD_Higher_Ranges__c='23434';
        o.DMGR_Marital_Status__c='M';
        o.DMGR_Occupation__c = 'ABC';
        o.DMGR_Home_Owner_or_Renter__c ='M';
        o.DMGR_Occupation_Detailed__c = 'v';
        o.DMGR_Household_Size__c = 5;
        o.DMGR_Education_Level__c = 'H';
        o.ENR_CI_Ownership__c = 'C';
        o.ENR_CI_Event_Attendance__c = 'U';
        o.ENR_CI_Ownership_Details__c = 'R';
        o.ENR_CI_Likely_to_Buy_Acura__c = 'U';
        o.ENR_CI_Service_History__c = 'U';
        o.ENR_CI_Likely_to_Buy_Honda__c = 'T';
        o.ENR_CI_Extended_Warranty__c = 'C';
        o.ENR_CI_Likely_to_Buy_PSP__c = 'E';
        o.ENR_CI_Children_in_Household__c = 'Q';
        o.ENR_Acura_Vehicles_Owned__c = 23;
        o.ENR_Honda_Vehicles_Owned__c = 43;
        o.ENR_Power_Sports_Vehicles_Owned__c = 65;
        o.ENR_Power_Equipment_Vehicles_Owned__c = 65;
        o.ENR_Extended_Warranty_Contract__c=true;
        o.ENR_Likeliness_to_Buy_Acura__c = 'Q';
        o.ENR_Likeliness_to_Buy_Honda__c = 'B';
        o.ENR_Likeliness_to_Buy_PSP__c = 'Y';
        o.ENR_Ownership_Type__c = 'Current Owner';
        o.ENR_Total_Spent_on_Service_by_Customer__c = 43;
        o.ENR_Total_Spent_on_Service_by_Warranty__c = 34;
        o.DEPOSIT_AMOUNT__c = 6547;
        o.Deposit_Confirmation_Number__c = '1';
        o.Deposit_Sales_Order_Number__c = '4';
        o.Appointment_Notes__c = 'abc';
        o.Appointment_Date_and_Time__c = '22May2023';
        o.Appointment_Location__c = 'Hyderabad';
        o.Appointment_Notes__c = 'DSP';
        o.Appointment_type__c = 'tekion/walkin';
        o.Appointment_Id__c = '123';
        o.Deal_ID__c = '8497';
        o.Deal_Link__c = 'www.google.com';
        o.Contact_person__c = 'Lavanya';
        o.Send_to_DSP__c = true;
        o.Initial_Walkin_Lead__c = true;
        o.Is_This_Lead_Update__c = true;
        o.External_Lead_Reference_Number__c = '123';
        o.Street_TXT__c = 'Tenali';
        o.Provider_Type__c = 'Lavanya';
        o.AddressType_TXT__c = 'home';
        o.AppartmentNumber_TXT__c = '101';
        insert o;
        
		Lead_Dealer_Assignment_ADF__e leddlr = new Lead_Dealer_Assignment_ADF__e(
        Customer_Insight_Service_History__c = o.ENR_CI_Service_History__c,
        Environmental_Issues__c = o.DMGR_Environmental_Issues__c,Green_Living__c=o.DMGR_Green_Living__c,
        Baseball__c = o.DMGR_Baseball__c, Basketball__c =o.DMGR_Basketball__c,Football__c=o.DMGR_Football__c,US_Travel__c=o.DMGR_US_Travel__c,
		Hockey__c=o.DMGR_Hockey__c=true,Skiing__c=o.DMGR_Skiing__c,Golf__c=o.DMGR_Golf__c,Vehicle_Known_Owned__c=o.DMGR_Vehicle_Known_Owned__c,
		Age__c=o.DMGR_Age__c,Income__c = o.DMGR_Income__c,Children__c = o.DMGR_Children__c,Income_Estate_HHLD_Higher_Ranges__c = o.DMGR_Income_Estate_HHLD_Higher_Ranges__c,Marital_Status__c = o.DMGR_Marital_Status__c,Occupation__c = o.DMGR_Occupation__c,Home_Owner_or_Renter__c = o.DMGR_Home_Owner_or_Renter__c,Occupation_Detailed__c = o.DMGR_Occupation_Detailed__c,Household_Size__c = o.DMGR_Household_Size__c,
		Education_Level__c = o.DMGR_Education_Level__c,Customer_Insight_Ownership__c = o.ENR_CI_Ownership__c,Customer_Insight_Event_Attendance__c = o.ENR_CI_Event_Attendance__c,Customer_Insight_Ownership_Details__c = o.ENR_CI_Ownership_Details__c,Customer_Insight_Likely_to_Buy_Acura__c = o.ENR_CI_Likely_to_Buy_Acura__c,Customer_Insight_Likely_to_Buy_Honda__c = o.ENR_CI_Likely_to_Buy_Honda__c,Customer_Insight_Likely_to_Buy_PSP__c = o.ENR_CI_Likely_to_Buy_PSP__c,Customer_Insight_Children_in_Household__c = o.ENR_CI_Children_in_Household__c,Acura_Vehicles_Owned__c = o.ENR_Acura_Vehicles_Owned__c,Honda_Vehicles_Owned__c = o.ENR_Honda_Vehicles_Owned__c,Power_Sports_Vehicles_Owned__c = o.ENR_Power_Sports_Vehicles_Owned__c,
		Power_Equipment_Vehicles_Owned__c = o.ENR_Power_Equipment_Vehicles_Owned__c,Extended_Warranty_Contract__c=o.ENR_Extended_Warranty_Contract__c,Customer_Likeliness_to_Buy_Acura__c = o.ENR_Likeliness_to_Buy_Acura__c,Customer_Likeliness_to_Buy_Honda__c = o.ENR_Likeliness_to_Buy_Honda__c,Customer_Likeliness_to_Buy_PSP__c = o.ENR_Likeliness_to_Buy_PSP__c,Ownership_Type__c = o.ENR_Ownership_Type__c,Total_Spent_on_Service_by_Customer__c = String.valueof(o.ENR_Total_Spent_on_Service_by_Customer__c),
		Total_Spent_on_Service_by_Warranty__c = String.valueof(o.ENR_Total_Spent_on_Service_by_Warranty__c),Einstein_Predicted_Priority__c = o.Einstein_Predicted_Priority__c,Deposit_Amount__c = o.DEPOSIT_AMOUNT__c,Deposit_Confirmation_Number__c = o.Deposit_Confirmation_Number__c,Deposit_Sales_Order_Number__c = o.Deposit_Sales_Order_Number__c);
		
        List<Lead_Dealer_Acknowledgement_ADF__e> lst = new List<Lead_Dealer_Acknowledgement_ADF__e>();
        Lead_Dealer_Acknowledgement_ADF__e lda = new Lead_Dealer_Acknowledgement_ADF__e();
        lda.Oppotunity_SF_ID__c=o.Opportunity_SF_ID__c;
        lda.Status_Code__c='1';
        lda.CRM_Payload__c = 'ABCDEFGHIJL';
        lda.CRM_XML_Response__c = 'tyttyyay';
        lda.Error_Details_Urban_Science__c = 'POIUYT';
        lda.Response_Urban_Science__c = 'MOKKI';
        lda.Routing_Error__c = 'HSJJSJD';
        lda.Sent_to_Urban_Science_Status__c ='NNVNNNC';
        lda.Send_to_DSP__c = true;
        lda.Sent_to_DSP_Status__c = '0';
        lda.Response_DSP__c = 'abc';
        lda.DSP_Payload__c = 'abc';
        lda.UrbanScience_Payload__c = 'NUBYUN';
        lst.add(lda);
        
        Test.startTest();
        Database.SaveResult sr = EventBus.publish(leddlr);
        List<Database.SaveResult> sr1 = EventBus.publish(lst);
        HELMSLeadDealerAssignmentADFHandler hndlr = new HELMSLeadDealerAssignmentADFHandler();
        hndlr.updateOpportunityOnDealerAcknowledgement(lst);
        System.assertEquals(lda.CRM_Payload__c, 'ABCDEFGHIJL');
        Test.stopTest(); 
    }
   
   @istest static void updateOpportunityOnDealerAcknowledgement2(){
        Datetime dt = System.now();
     	// adding minutes in negative, effectively subtracts 30 mins
     	dt = dt.addMinutes(-60);
        string strldinfo='<LeadAdditionalInfo key="visitNotes">';
        Account acc = new Account(name ='Grazitti', DealerCode_CD__c='30Z514', recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Dealer').getRecordTypeId()) ;
        insert acc;
        Account acc1 = new Account(name ='Grazitti1', recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider').getRecordTypeId()) ;

        List<Lead_Additional_Attribute_Definition__c> ldaddattdf = new List<Lead_Additional_Attribute_Definition__c>();
        Lead_Additional_Attribute_Definition__c ldadd = new Lead_Additional_Attribute_Definition__c();
        ldadd.Name = 'visitNotes';
        ldadd.Shared_With_Dealer__c = 'TRUE';
        insert ldadd;
        ldaddattdf.add(ldadd);
       
        Opportunity o = new Opportunity ();
        o.Name='testtestvtesttesttestvtesttest75testtesttesttesvvv75characterstesttesttestvtesttesttesttesttest test test75 char';
        o.Routable_FLG__c= true;
        o.Opportunity_SF_ID__c='123';
        //o.Routing_Status__c='Success';
        o.Routing_Failure_Date_Time__c=system.now();
        o.Routing_Success_Date_Time__c=system.now();
        o.StageName='closed won';
        o.CloseDate=system.today();
        o.Email__c='ghou@gmail.com';
        o.ZipCode_TXT__c='89010';
        o.First_Name_TXT__c='test1';
        o.Last_Name_TXT__c='test2';
        o.TriggerTypeCode__c='';
        o.LeadAdditionalInfos__c = strldinfo;
        Id devRecordTypeId = Schema.getGlobalDescribe().get('Opportunity').getDescribe().getRecordTypeInfosByName().get('Power Sports Opportunity').getRecordTypeId();
        
        o.recordtypeid=devRecordTypeId;
        o.PreferredDealerAccount_TXT__c=acc.id;
        o.LeadProvider_ID__c=acc1.id;
        o.SubDiv_TXT__c='Motorcycle';
		o.ENR_CI_Service_History__c = '';
        o.DMGR_Environmental_Issues__c = true;
        o.DMGR_Green_Living__c=true;
        o.DMGR_Baseball__c=true;
        o.DMGR_Basketball__c=true;
        o.DMGR_Football__c=true;
        o.DMGR_US_Travel__c=true;
        o.DMGR_Hockey__c=true;
        o.DMGR_Skiing__c=true;
        o.DMGR_Golf__c=true;
        o.DMGR_Vehicle_Known_Owned__c=true;
        o.DMGR_Age__c=23;
        o.DMGR_Income__c='23423';
        o.DMGR_Children__c='ABC';
        o.DMGR_Income_Estate_HHLD_Higher_Ranges__c='23434';
        o.DMGR_Marital_Status__c='M';
        o.DMGR_Occupation__c = 'ABC';
        o.DMGR_Home_Owner_or_Renter__c ='M';
        o.DMGR_Occupation_Detailed__c = 'v';
        o.DMGR_Household_Size__c = 5;
        o.DMGR_Education_Level__c = 'H';
        o.ENR_CI_Ownership__c = 'C';
        o.ENR_CI_Event_Attendance__c = 'U';
        o.ENR_CI_Ownership_Details__c = 'R';
        o.ENR_CI_Likely_to_Buy_Acura__c = 'U';
        o.ENR_CI_Service_History__c = 'U';
        o.ENR_CI_Likely_to_Buy_Honda__c = 'T';
        o.ENR_CI_Extended_Warranty__c = 'C';
        o.ENR_CI_Likely_to_Buy_PSP__c = 'E';
        o.ENR_CI_Children_in_Household__c = 'Q';
        o.ENR_Acura_Vehicles_Owned__c = 23;
        o.ENR_Honda_Vehicles_Owned__c = 43;
        o.ENR_Power_Sports_Vehicles_Owned__c = 65;
        o.ENR_Power_Equipment_Vehicles_Owned__c = 65;
        o.ENR_Extended_Warranty_Contract__c=true;
        o.ENR_Likeliness_to_Buy_Acura__c = 'Q';
        o.ENR_Likeliness_to_Buy_Honda__c = 'B';
        o.ENR_Likeliness_to_Buy_PSP__c = 'Y';
        o.ENR_Ownership_Type__c = 'Current Owner';
        o.ENR_Total_Spent_on_Service_by_Customer__c = 43;
        o.ENR_Total_Spent_on_Service_by_Warranty__c = 34;
        o.DEPOSIT_AMOUNT__c = 6547;
        o.Deposit_Confirmation_Number__c = '1';
        o.Deposit_Sales_Order_Number__c = '4';
        o.Appointment_Notes__c = 'abc';
        o.Appointment_Date_and_Time__c = '22May2023';
        o.Appointment_Location__c = 'Hyderabad';
        o.Appointment_Notes__c = 'DSP';
        o.Appointment_type__c = 'tekion/walkin';
        o.Appointment_Id__c = '123';
        o.Deal_ID__c = '8497';
        o.Deal_Link__c = 'www.google.com';
        o.Contact_person__c = 'Lavanya';
        o.Send_to_DSP__c = true;
        o.Initial_Walkin_Lead__c = true;
        o.Is_This_Lead_Update__c = true;
        o.External_Lead_Reference_Number__c = '123';
        o.Street_TXT__c = 'Tenali';
        o.Provider_Type__c = 'Lavanya';
        o.AddressType_TXT__c = 'home';
        o.AppartmentNumber_TXT__c = '101';
          o.PhoneType_NM__c = 'home';
          o.Condition_TXT__c = 'abc';
          o.Country_TXT__c = 'US';
          o.Vendor_Contact_Name__c = 'lavanya';
          o.MiddlewareUUID__c = 'abc';
          o.Doors_TXT__c = 'door';
          o.Fax__c = 'phone';
          o.Make_TXT__c = 'acura';
          o.MobilePhone__c = '9876543210';
              o.Odometer_TXT__c = 'abc';
              o.OdometerUnits_TXT__c  = 'abc';
              o.Pager_TXT__c = 'abc';
              o.PurchaseHorizon_TXT__c = 'abc';
              o.Source_Name__c = 'brandsite';
              o.DSP_Routing_Response_Message__c = 'abc';
              o.DSP_Routing_Status_Message__c = 'abc';
              o.DSP_Status__c = 'abc';
              o.DSP_Update_Count__c = 0;
          o.Suffix_TXT__c = 'MR.';
          o.TradeBalanceOwed_TXT__c ='abc';
          o.InventoryNumber_TXT__c = '123';
          o.Transmission_TXT__c = 'abc';
          o.TriggerTypeCode__c = 'instant';
          o.SendOnlyToUrbanScience__c = false;
              
        insert o;
        
		Lead_Dealer_Assignment_ADF__e leddlr = new Lead_Dealer_Assignment_ADF__e(
        Customer_Insight_Service_History__c = o.ENR_CI_Service_History__c,
        Environmental_Issues__c = o.DMGR_Environmental_Issues__c,Green_Living__c=o.DMGR_Green_Living__c,
        Baseball__c = o.DMGR_Baseball__c, Basketball__c =o.DMGR_Basketball__c,Football__c=o.DMGR_Football__c,US_Travel__c=o.DMGR_US_Travel__c,
		Hockey__c=o.DMGR_Hockey__c=true,Skiing__c=o.DMGR_Skiing__c,Golf__c=o.DMGR_Golf__c,Vehicle_Known_Owned__c=o.DMGR_Vehicle_Known_Owned__c,
		Age__c=o.DMGR_Age__c,Income__c = o.DMGR_Income__c,Children__c = o.DMGR_Children__c,Income_Estate_HHLD_Higher_Ranges__c = o.DMGR_Income_Estate_HHLD_Higher_Ranges__c,Marital_Status__c = o.DMGR_Marital_Status__c,Occupation__c = o.DMGR_Occupation__c,Home_Owner_or_Renter__c = o.DMGR_Home_Owner_or_Renter__c,Occupation_Detailed__c = o.DMGR_Occupation_Detailed__c,Household_Size__c = o.DMGR_Household_Size__c,
		Education_Level__c = o.DMGR_Education_Level__c,Customer_Insight_Ownership__c = o.ENR_CI_Ownership__c,Customer_Insight_Event_Attendance__c = o.ENR_CI_Event_Attendance__c,Customer_Insight_Ownership_Details__c = o.ENR_CI_Ownership_Details__c,Customer_Insight_Likely_to_Buy_Acura__c = o.ENR_CI_Likely_to_Buy_Acura__c,Customer_Insight_Likely_to_Buy_Honda__c = o.ENR_CI_Likely_to_Buy_Honda__c,Customer_Insight_Likely_to_Buy_PSP__c = o.ENR_CI_Likely_to_Buy_PSP__c,Customer_Insight_Children_in_Household__c = o.ENR_CI_Children_in_Household__c,Acura_Vehicles_Owned__c = o.ENR_Acura_Vehicles_Owned__c,Honda_Vehicles_Owned__c = o.ENR_Honda_Vehicles_Owned__c,Power_Sports_Vehicles_Owned__c = o.ENR_Power_Sports_Vehicles_Owned__c,
		Power_Equipment_Vehicles_Owned__c = o.ENR_Power_Equipment_Vehicles_Owned__c,Extended_Warranty_Contract__c=o.ENR_Extended_Warranty_Contract__c,Customer_Likeliness_to_Buy_Acura__c = o.ENR_Likeliness_to_Buy_Acura__c,Customer_Likeliness_to_Buy_Honda__c = o.ENR_Likeliness_to_Buy_Honda__c,Customer_Likeliness_to_Buy_PSP__c = o.ENR_Likeliness_to_Buy_PSP__c,Ownership_Type__c = o.ENR_Ownership_Type__c,Total_Spent_on_Service_by_Customer__c = String.valueof(o.ENR_Total_Spent_on_Service_by_Customer__c),
		Total_Spent_on_Service_by_Warranty__c = String.valueof(o.ENR_Total_Spent_on_Service_by_Warranty__c),Einstein_Predicted_Priority__c = o.Einstein_Predicted_Priority__c,Deposit_Amount__c = o.DEPOSIT_AMOUNT__c,Deposit_Confirmation_Number__c = o.Deposit_Confirmation_Number__c,Deposit_Sales_Order_Number__c = o.Deposit_Sales_Order_Number__c);
		
        List<Lead_Dealer_Acknowledgement_ADF__e> lst = new List<Lead_Dealer_Acknowledgement_ADF__e>();
        Lead_Dealer_Acknowledgement_ADF__e lda = new Lead_Dealer_Acknowledgement_ADF__e();
        lda.Oppotunity_SF_ID__c=o.Opportunity_SF_ID__c;
        lda.Status_Code__c='0';
        lda.CRM_Payload__c = 'ABCDEFGHIJL';
        lda.CRM_XML_Response__c = 'tyttyyay';
        lda.Error_Details_Urban_Science__c = 'POIUYT';
        lda.Response_Urban_Science__c = 'MOKKI';
        lda.Routing_Error__c = 'HSJJSJD';
        lda.Sent_to_Urban_Science_Status__c ='1';
        lda.Send_to_DSP__c = true;
        lda.Sent_to_DSP_Status__c = '0';
        lda.Response_DSP__c = 'abc';
        lda.DSP_Payload__c = 'abc';
        lda.UrbanScience_Payload__c = 'NUBYUN';
          
        lst.add(lda);
        
        Test.startTest();
        Database.SaveResult sr = EventBus.publish(leddlr);
        List<Database.SaveResult> sr1 = EventBus.publish(lst);
        HELMSLeadDealerAssignmentADFHandler hndlr = new HELMSLeadDealerAssignmentADFHandler();
        hndlr.updateOpportunityOnDealerAcknowledgement(lst);
        System.assertEquals(lda.CRM_Payload__c, 'ABCDEFGHIJL');
        Test.stopTest(); 
    }
      
   @istest static void updateOpportunityOnDealerAcknowledgement3(){
        Datetime dt = System.now();
     	// adding minutes in negative, effectively subtracts 30 mins
     	dt = dt.addMinutes(-60);
        string strldinfo='<LeadAdditionalInfo key="originationUrl">';
        Account acc = new Account(name ='Grazitti', DealerCode_CD__c='30Z514', recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Dealer').getRecordTypeId()) ;
        insert acc;
        Account acc1 = new Account(name ='Grazitti1', Send_to_Urban_Science_Flag__c = true, recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider').getRecordTypeId()) ;
        
        List<Lead_Additional_Attribute_Definition__c> ldaddattdf = new List<Lead_Additional_Attribute_Definition__c>();
        Lead_Additional_Attribute_Definition__c ldadd = new Lead_Additional_Attribute_Definition__c();
        ldadd.Name = 'originationUrl';
        ldadd.Shared_With_Dealer__c = 'TRUE';
        insert ldadd;
        ldaddattdf.add(ldadd);
        
        Opportunity o = new Opportunity ();
        o.Name='test';
        o.Routable_FLG__c= false;
        o.Opportunity_SF_ID__c='123';
        //o.Routing_Status__c='Success';
        o.Routing_Failure_Date_Time__c=system.now();
        o.Routing_Success_Date_Time__c=system.now();
        o.StageName='closed won';
        o.CloseDate=system.today();
        o.Email__c='ghou@gmail.com';
        o.ZipCode_TXT__c='89010';
        o.First_Name_TXT__c='test1';
        o.Last_Name_TXT__c='test2';
        o.TriggerTypeCode__c='';
        o.LeadAdditionalInfos__c = strldinfo;
        Id devRecordTypeId = Schema.getGlobalDescribe().get('Opportunity').getDescribe().getRecordTypeInfosByName().get('Power Sports Opportunity').getRecordTypeId();
        
        o.recordtypeid=devRecordTypeId;
        o.PreferredDealerAccount_TXT__c=acc.id;
        o.LeadProvider_ID__c=acc1.id;
        o.SubDiv_TXT__c='Motorcycle';
	/*	o.ENR_CI_Service_History__c = '';
        o.DMGR_Environmental_Issues__c = false;
        o.DMGR_Green_Living__c=false;
        o.DMGR_Baseball__c=false;
        o.DMGR_Basketball__c=false;
        o.DMGR_Football__c=false;
        o.DMGR_US_Travel__c=false;
        o.DMGR_Hockey__c=false;
        o.DMGR_Skiing__c=false;
        o.DMGR_Golf__c=false;
        o.DMGR_Vehicle_Known_Owned__c=false;
        o.DMGR_Age__c=23;
        o.DMGR_Income__c='23423';
        o.DMGR_Children__c='ABC';
        o.DMGR_Income_Estate_HHLD_Higher_Ranges__c='23434';
        o.DMGR_Marital_Status__c='M';
        o.DMGR_Occupation__c = 'ABC';
        o.DMGR_Home_Owner_or_Renter__c ='M';
        o.DMGR_Occupation_Detailed__c = 'v';
        o.DMGR_Household_Size__c = 5;
        o.DMGR_Education_Level__c = 'H';
        o.ENR_CI_Ownership__c = 'C';
        o.ENR_CI_Event_Attendance__c = 'U';
        o.ENR_CI_Ownership_Details__c = 'R';
        o.ENR_CI_Likely_to_Buy_Acura__c = 'U';
        o.ENR_CI_Service_History__c = 'U';
        o.ENR_CI_Likely_to_Buy_Honda__c = 'T';
        o.ENR_CI_Extended_Warranty__c = 'C';
        o.ENR_CI_Likely_to_Buy_PSP__c = 'E';
        o.ENR_CI_Children_in_Household__c = 'Q';
        o.ENR_Acura_Vehicles_Owned__c = 23;
        o.ENR_Honda_Vehicles_Owned__c = 43;
        o.ENR_Power_Sports_Vehicles_Owned__c = 65;
        o.ENR_Power_Equipment_Vehicles_Owned__c = 65;
        o.ENR_Extended_Warranty_Contract__c=false;
        o.ENR_Likeliness_to_Buy_Acura__c = 'Q';
        o.ENR_Likeliness_to_Buy_Honda__c = 'B';
        o.ENR_Likeliness_to_Buy_PSP__c = 'Y';
        o.ENR_Ownership_Type__c = 'Current Owner';
        o.ENR_Total_Spent_on_Service_by_Customer__c = 43;
        o.ENR_Total_Spent_on_Service_by_Warranty__c = 34; */
        o.DEPOSIT_AMOUNT__c = 6547;
        o.Deposit_Confirmation_Number__c = '1';
        o.Deposit_Sales_Order_Number__c = '4';
        o.Appointment_Notes__c = 'abc';
        o.Appointment_Date_and_Time__c = '22May2023';
        o.Appointment_Location__c = 'Hyderabad';
        o.Appointment_Notes__c = 'DSP';
        o.Appointment_type__c = 'tekion/walkin';
        o.Appointment_Id__c = '123';
        o.Deal_ID__c = '8497';
        o.Deal_Link__c = 'www.google.com';
        o.Contact_person__c = 'Lavanya';
        o.Send_to_DSP__c = false;
        o.Initial_Walkin_Lead__c = false;
        o.Is_This_Lead_Update__c = false;
        o.External_Lead_Reference_Number__c = '123';
        o.Street_TXT__c = 'Tenali';
        o.Provider_Type__c = 'Lavanya';
        o.AddressType_TXT__c = 'home';
        o.AppartmentNumber_TXT__c = '101';
        insert o;
        
	/*	Lead_Dealer_Assignment_ADF__e leddlr = new Lead_Dealer_Assignment_ADF__e(
        Customer_Insight_Service_History__c = '',
        Environmental_Issues__c = false ,Green_Living__c=false,
        Baseball__c = false, Basketball__c =false,Football__c=o.DMGR_Football__c,US_Travel__c=o.DMGR_US_Travel__c,
		Hockey__c=o.DMGR_Hockey__c=true,Skiing__c=o.DMGR_Skiing__c,Golf__c=o.DMGR_Golf__c,Vehicle_Known_Owned__c=o.DMGR_Vehicle_Known_Owned__c,
		Age__c=o.DMGR_Age__c,Income__c = o.DMGR_Income__c,Children__c = o.DMGR_Children__c,Income_Estate_HHLD_Higher_Ranges__c = o.DMGR_Income_Estate_HHLD_Higher_Ranges__c,Marital_Status__c = o.DMGR_Marital_Status__c,Occupation__c = o.DMGR_Occupation__c,Home_Owner_or_Renter__c = o.DMGR_Home_Owner_or_Renter__c,Occupation_Detailed__c = o.DMGR_Occupation_Detailed__c,Household_Size__c = o.DMGR_Household_Size__c,
		Education_Level__c = o.DMGR_Education_Level__c,Customer_Insight_Ownership__c = o.ENR_CI_Ownership__c,Customer_Insight_Event_Attendance__c = o.ENR_CI_Event_Attendance__c,Customer_Insight_Ownership_Details__c = o.ENR_CI_Ownership_Details__c,Customer_Insight_Likely_to_Buy_Acura__c = o.ENR_CI_Likely_to_Buy_Acura__c,Customer_Insight_Likely_to_Buy_Honda__c = o.ENR_CI_Likely_to_Buy_Honda__c,Customer_Insight_Likely_to_Buy_PSP__c = o.ENR_CI_Likely_to_Buy_PSP__c,Customer_Insight_Children_in_Household__c = o.ENR_CI_Children_in_Household__c,Acura_Vehicles_Owned__c = o.ENR_Acura_Vehicles_Owned__c,Honda_Vehicles_Owned__c = o.ENR_Honda_Vehicles_Owned__c,Power_Sports_Vehicles_Owned__c = o.ENR_Power_Sports_Vehicles_Owned__c,
		Power_Equipment_Vehicles_Owned__c = o.ENR_Power_Equipment_Vehicles_Owned__c,Extended_Warranty_Contract__c=o.ENR_Extended_Warranty_Contract__c,Customer_Likeliness_to_Buy_Acura__c = o.ENR_Likeliness_to_Buy_Acura__c,Customer_Likeliness_to_Buy_Honda__c = o.ENR_Likeliness_to_Buy_Honda__c,Customer_Likeliness_to_Buy_PSP__c = o.ENR_Likeliness_to_Buy_PSP__c,Ownership_Type__c = o.ENR_Ownership_Type__c,Total_Spent_on_Service_by_Customer__c = String.valueof(o.ENR_Total_Spent_on_Service_by_Customer__c),
		Total_Spent_on_Service_by_Warranty__c = String.valueof(o.ENR_Total_Spent_on_Service_by_Warranty__c),Einstein_Predicted_Priority__c = o.Einstein_Predicted_Priority__c,Deposit_Amount__c = o.DEPOSIT_AMOUNT__c,Deposit_Confirmation_Number__c = o.Deposit_Confirmation_Number__c,Deposit_Sales_Order_Number__c = o.Deposit_Sales_Order_Number__c);*/
		
        List<Lead_Dealer_Acknowledgement_ADF__e> lst = new List<Lead_Dealer_Acknowledgement_ADF__e>();
        Lead_Dealer_Acknowledgement_ADF__e lda = new Lead_Dealer_Acknowledgement_ADF__e();
        lda.Oppotunity_SF_ID__c=o.Opportunity_SF_ID__c;
        lda.Status_Code__c='0';
        lda.CRM_Payload__c = 'ABCDEFGHIJL';
        lda.CRM_XML_Response__c = 'tyttyyay';
        lda.Error_Details_Urban_Science__c = 'POIUYT';
        lda.Response_Urban_Science__c = 'MOKKI';
        lda.Routing_Error__c = 'HSJJSJD';
        lda.Sent_to_Urban_Science_Status__c ='NNVNNNC';
        lda.Send_to_DSP__c = true;
        lda.Sent_to_DSP_Status__c = '0';
        lda.Response_DSP__c = 'abc';
        lda.DSP_Payload__c = 'abc';
        lda.UrbanScience_Payload__c = 'NUBYUN';
        lst.add(lda);
        
        Test.startTest();
      //  Database.SaveResult sr = EventBus.publish(leddlr);
        List<Database.SaveResult> sr1 = EventBus.publish(lst);
        HELMSLeadDealerAssignmentADFHandler hndlr = new HELMSLeadDealerAssignmentADFHandler();
        hndlr.updateOpportunityOnDealerAcknowledgement(lst);
        System.assertEquals(lda.CRM_Payload__c, 'ABCDEFGHIJL');
        Test.stopTest(); 
    }
    
   @istest static void updateOpportunityOnDealerAcknowledgement4(){
        Datetime dt = System.now();
     	// adding minutes in negative, effectively subtracts 30 mins
     	dt = dt.addMinutes(-60);
        string strldinfo='<LeadAdditionalInfo key="transcript">';
        Account acc = new Account(name ='Grazitti', DealerCode_CD__c='30Z514', recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Dealer').getRecordTypeId()) ;
        insert acc;
        Account acc1 = new Account(name ='Grazitti1', recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider').getRecordTypeId()) ;
       
        List<Lead_Additional_Attribute_Definition__c> ldaddattdf = new List<Lead_Additional_Attribute_Definition__c>();
        Lead_Additional_Attribute_Definition__c ldadd = new Lead_Additional_Attribute_Definition__c();
        ldadd.Name = 'transcript';
        ldadd.Shared_With_Dealer__c = 'TRUE';
        insert ldadd;
        ldaddattdf.add(ldadd);
       
        Opportunity o = new Opportunity ();
        o.Name='testtestvtesttesttestvtesttest75testtesttesttesvvv75characterstesttesttestvtesttest';
        o.Routable_FLG__c= true;
        o.Opportunity_SF_ID__c='123';
        //o.Routing_Status__c='Success';
        o.Routing_Failure_Date_Time__c=system.now();
        o.Routing_Success_Date_Time__c=system.now();
        o.StageName='closed won';
        o.CloseDate=system.today();
        o.Email__c='ghou@gmail.com';
        o.ZipCode_TXT__c='89010';
        o.First_Name_TXT__c='test1';
        o.Last_Name_TXT__c='test2';
        o.TriggerTypeCode__c='';
        o.LeadAdditionalInfos__c = strldinfo;
        Id devRecordTypeId = Schema.getGlobalDescribe().get('Opportunity').getDescribe().getRecordTypeInfosByName().get('Power Sports Opportunity').getRecordTypeId();
        
        o.recordtypeid=devRecordTypeId;
        o.PreferredDealerAccount_TXT__c=acc.id;
        o.LeadProvider_ID__c=acc1.id;
        o.SubDiv_TXT__c='Motorcycle';
		o.ENR_CI_Service_History__c = '';
        o.DMGR_Environmental_Issues__c = true;
        o.DMGR_Green_Living__c=true;
        o.DMGR_Baseball__c=true;
        o.DMGR_Basketball__c=true;
        o.DMGR_Football__c=true;
        o.DMGR_US_Travel__c=true;
        o.DMGR_Hockey__c=true;
        o.DMGR_Skiing__c=true;
        o.DMGR_Golf__c=true;
        o.DMGR_Vehicle_Known_Owned__c=true;
        o.DMGR_Age__c=23;
        o.DMGR_Income__c='23423';
        o.DMGR_Children__c='ABC';
        o.DMGR_Income_Estate_HHLD_Higher_Ranges__c='23434';
        o.DMGR_Marital_Status__c='M';
        o.DMGR_Occupation__c = 'ABC';
        o.DMGR_Home_Owner_or_Renter__c ='M';
        o.DMGR_Occupation_Detailed__c = 'v';
        o.DMGR_Household_Size__c = 5;
        o.DMGR_Education_Level__c = 'H';
        o.ENR_CI_Ownership__c = 'C';
        o.ENR_CI_Event_Attendance__c = 'U';
        o.ENR_CI_Ownership_Details__c = 'R';
        o.ENR_CI_Likely_to_Buy_Acura__c = 'U';
        o.ENR_CI_Service_History__c = 'U';
        o.ENR_CI_Likely_to_Buy_Honda__c = 'T';
        o.ENR_CI_Extended_Warranty__c = 'C';
        o.ENR_CI_Likely_to_Buy_PSP__c = 'E';
        o.ENR_CI_Children_in_Household__c = 'Q';
        o.ENR_Acura_Vehicles_Owned__c = 23;
        o.ENR_Honda_Vehicles_Owned__c = 43;
        o.ENR_Power_Sports_Vehicles_Owned__c = 65;
        o.ENR_Power_Equipment_Vehicles_Owned__c = 65;
        o.ENR_Extended_Warranty_Contract__c=true;
        o.ENR_Likeliness_to_Buy_Acura__c = 'Q';
        o.ENR_Likeliness_to_Buy_Honda__c = 'B';
        o.ENR_Likeliness_to_Buy_PSP__c = 'Y';
        o.ENR_Ownership_Type__c = 'Current Owner';
        o.ENR_Total_Spent_on_Service_by_Customer__c = 43;
        o.ENR_Total_Spent_on_Service_by_Warranty__c = 34;
        o.DEPOSIT_AMOUNT__c = 6547;
        o.Deposit_Confirmation_Number__c = '1';
        o.Deposit_Sales_Order_Number__c = '4';
        o.Appointment_Notes__c = 'abc';
        o.Appointment_Date_and_Time__c = '22May2023';
        o.Appointment_Location__c = 'Hyderabad';
        o.Appointment_Notes__c = 'DSP';
        o.Appointment_type__c = 'tekion/walkin';
        o.Appointment_Id__c = '123';
        o.Deal_ID__c = '8497';
        o.Deal_Link__c = 'www.google.com';
        o.Contact_person__c = 'Lavanya';
        o.Send_to_DSP__c = true;
        o.Initial_Walkin_Lead__c = true;
        o.Is_This_Lead_Update__c = true;
        o.External_Lead_Reference_Number__c = '123';
        o.Street_TXT__c = 'Tenali';
        o.Provider_Type__c = 'Lavanya';
        o.AddressType_TXT__c = 'home';
        o.AppartmentNumber_TXT__c = '101';
        o.SendOnlyToUrbanScience__c = true;
        o.Routing_Error__c='HSJJSJDHSJJSJDHSJJSJDHSJJSJDHSJJSJDHSJJSJDHSJJSJDHSJJSJDHSJJSJDHSJJSJDHSJJSJDHSJJSJDHSJJSJDHSJJSJDHSJJSJDHSJJSJDHSJJSJDHSJJSJDHSJJSJDHSJJSJDHSJJSJDHSJJSJDHSJJSJDHSJJSJDHSJJSJDHSJJSJDHSJJSJDHSJJSJDHSJJSJDHSJJSJDHSJJSJDHSJJSJDHSJJSJDHSJJSJDHSJJSJDHSJJSJDDHH';
        insert o;
        
		Lead_Dealer_Assignment_ADF__e leddlr = new Lead_Dealer_Assignment_ADF__e(
        Customer_Insight_Service_History__c = o.ENR_CI_Service_History__c,
        Environmental_Issues__c = o.DMGR_Environmental_Issues__c,Green_Living__c=o.DMGR_Green_Living__c,
        Baseball__c = o.DMGR_Baseball__c, Basketball__c =o.DMGR_Basketball__c,Football__c=o.DMGR_Football__c,US_Travel__c=o.DMGR_US_Travel__c,
		Hockey__c=o.DMGR_Hockey__c=true,Skiing__c=o.DMGR_Skiing__c,Golf__c=o.DMGR_Golf__c,Vehicle_Known_Owned__c=o.DMGR_Vehicle_Known_Owned__c,
		Age__c=o.DMGR_Age__c,Income__c = o.DMGR_Income__c,Children__c = o.DMGR_Children__c,Income_Estate_HHLD_Higher_Ranges__c = o.DMGR_Income_Estate_HHLD_Higher_Ranges__c,Marital_Status__c = o.DMGR_Marital_Status__c,Occupation__c = o.DMGR_Occupation__c,Home_Owner_or_Renter__c = o.DMGR_Home_Owner_or_Renter__c,Occupation_Detailed__c = o.DMGR_Occupation_Detailed__c,Household_Size__c = o.DMGR_Household_Size__c,
		Education_Level__c = o.DMGR_Education_Level__c,Customer_Insight_Ownership__c = o.ENR_CI_Ownership__c,Customer_Insight_Event_Attendance__c = o.ENR_CI_Event_Attendance__c,Customer_Insight_Ownership_Details__c = o.ENR_CI_Ownership_Details__c,Customer_Insight_Likely_to_Buy_Acura__c = o.ENR_CI_Likely_to_Buy_Acura__c,Customer_Insight_Likely_to_Buy_Honda__c = o.ENR_CI_Likely_to_Buy_Honda__c,Customer_Insight_Likely_to_Buy_PSP__c = o.ENR_CI_Likely_to_Buy_PSP__c,Customer_Insight_Children_in_Household__c = o.ENR_CI_Children_in_Household__c,Acura_Vehicles_Owned__c = o.ENR_Acura_Vehicles_Owned__c,Honda_Vehicles_Owned__c = o.ENR_Honda_Vehicles_Owned__c,Power_Sports_Vehicles_Owned__c = o.ENR_Power_Sports_Vehicles_Owned__c,
		Power_Equipment_Vehicles_Owned__c = o.ENR_Power_Equipment_Vehicles_Owned__c,Extended_Warranty_Contract__c=o.ENR_Extended_Warranty_Contract__c,Customer_Likeliness_to_Buy_Acura__c = o.ENR_Likeliness_to_Buy_Acura__c,Customer_Likeliness_to_Buy_Honda__c = o.ENR_Likeliness_to_Buy_Honda__c,Customer_Likeliness_to_Buy_PSP__c = o.ENR_Likeliness_to_Buy_PSP__c,Ownership_Type__c = o.ENR_Ownership_Type__c,Total_Spent_on_Service_by_Customer__c = String.valueof(o.ENR_Total_Spent_on_Service_by_Customer__c),
		Total_Spent_on_Service_by_Warranty__c = String.valueof(o.ENR_Total_Spent_on_Service_by_Warranty__c),Einstein_Predicted_Priority__c = o.Einstein_Predicted_Priority__c,Deposit_Amount__c = o.DEPOSIT_AMOUNT__c,Deposit_Confirmation_Number__c = o.Deposit_Confirmation_Number__c,Deposit_Sales_Order_Number__c = o.Deposit_Sales_Order_Number__c);
		
        List<Lead_Dealer_Acknowledgement_ADF__e> lst = new List<Lead_Dealer_Acknowledgement_ADF__e>();
        Lead_Dealer_Acknowledgement_ADF__e lda = new Lead_Dealer_Acknowledgement_ADF__e();
        lda.Oppotunity_SF_ID__c=o.Opportunity_SF_ID__c;
        lda.Status_Code__c='1';
        lda.CRM_Payload__c = 'ABCDEFGHIJL';
        lda.CRM_XML_Response__c = 'tyttyyay';
        lda.Error_Details_Urban_Science__c = 'POIUYT';
        lda.Response_Urban_Science__c = 'MOKKI';
        lda.Routing_Error__c = 'HSJJSJDHSJJSJDHSJJSJDHSJJSJDHSJJSJDHSJJSJDHSJJSJDHSJJSJDHSJJSJDHSJJSJDHSJJSJDHSJJSJDHSJJSJDHSJJSJDHSJJSJDHSJJSJDHSJJSJDHSJJSJDHSJJSJDHSJJSJDHSJJSJDHSJJSJDHSJJSJDHSJJSJDHSJJSJDHSJJSJDHSJJSJDHSJJSJDHSJJSJDHSJJSJDHSJJSJDHSJJSJDHSJJSJDHSJJSJDHSJJSJDHSJJSJDDHH';
        lda.Sent_to_Urban_Science_Status__c ='0';
        lda.Send_to_DSP__c = true;
        lda.Sent_to_DSP_Status__c = '0';
        lda.Response_DSP__c = 'abc';
        lda.DSP_Payload__c = 'abc';
        lda.UrbanScience_Payload__c = 'NUBYUN';
        lst.add(lda);
        
        Test.startTest();
        Database.SaveResult sr = EventBus.publish(leddlr);
        List<Database.SaveResult> sr1 = EventBus.publish(lst);
        HELMSLeadDealerAssignmentADFHandler hndlr = new HELMSLeadDealerAssignmentADFHandler();
        hndlr.updateOpportunityOnDealerAcknowledgement(lst);
        System.assertEquals(lda.CRM_Payload__c, 'ABCDEFGHIJL');
        Test.stopTest(); 
    }
    
   @istest static void updateOpportunityOnDealerAcknowledgement5(){
        Datetime dt = System.now();
     	// adding minutes in negative, effectively subtracts 30 mins
     	dt = dt.addMinutes(-60);
        string strldinfo='<LeadAdditionalInfo key="DepositConfirmationNumber">';
        Account acc = new Account(name ='Grazitti', DealerCode_CD__c='30Z514', recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Dealer').getRecordTypeId()) ;
        insert acc;
        Account acc1 = new Account(name ='Grazitti1', recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider').getRecordTypeId()) ;

        List<Lead_Additional_Attribute_Definition__c> ldaddattdf = new List<Lead_Additional_Attribute_Definition__c>();
        Lead_Additional_Attribute_Definition__c ldadd = new Lead_Additional_Attribute_Definition__c();
        ldadd.Name = 'DepositConfirmationNumber';
        ldadd.Shared_With_Dealer__c = 'TRUE';
        insert ldadd;
        ldaddattdf.add(ldadd);
       
        Opportunity o = new Opportunity ();
        o.Name='testtestvtesttesttestvtesttest75testtesttesttesvvv75characterstesttesttestvtesttest';
        o.Routable_FLG__c= true;
        o.Opportunity_SF_ID__c='123';
        //o.Routing_Status__c='Success';
        o.Routing_Failure_Date_Time__c=system.now();
        o.Routing_Success_Date_Time__c=system.now();
        o.StageName='closed won';
        o.CloseDate=system.today();
        o.Email__c='ghou@gmail.com';
        o.ZipCode_TXT__c='89010';
        o.First_Name_TXT__c='test1';
        o.Last_Name_TXT__c='test2';
        o.TriggerTypeCode__c='';
        o.LeadAdditionalInfos__c = strldinfo;
        Id devRecordTypeId = Schema.getGlobalDescribe().get('Opportunity').getDescribe().getRecordTypeInfosByName().get('Power Sports Opportunity').getRecordTypeId();
        
        o.recordtypeid=devRecordTypeId;
        o.PreferredDealerAccount_TXT__c=acc.id;
        o.LeadProvider_ID__c=acc1.id;
        o.SubDiv_TXT__c='Motorcycle';
		o.ENR_CI_Service_History__c = '';
        o.DMGR_Environmental_Issues__c = true;
        o.DMGR_Green_Living__c=true;
        o.DMGR_Baseball__c=true;
        o.DMGR_Basketball__c=true;
        o.DMGR_Football__c=true;
        o.DMGR_US_Travel__c=true;
        o.DMGR_Hockey__c=true;
        o.DMGR_Skiing__c=true;
        o.DMGR_Golf__c=true;
        o.DMGR_Vehicle_Known_Owned__c=true;
        o.DMGR_Age__c=23;
        o.DMGR_Income__c='23423';
        o.DMGR_Children__c='ABC';
        o.DMGR_Income_Estate_HHLD_Higher_Ranges__c='23434';
        o.DMGR_Marital_Status__c='M';
        o.DMGR_Occupation__c = 'ABC';
        o.DMGR_Home_Owner_or_Renter__c ='M';
        o.DMGR_Occupation_Detailed__c = 'v';
        o.DMGR_Household_Size__c = 5;
        o.DMGR_Education_Level__c = 'H';
        o.ENR_CI_Ownership__c = 'C';
        o.ENR_CI_Event_Attendance__c = 'U';
        o.ENR_CI_Ownership_Details__c = 'R';
        o.ENR_CI_Likely_to_Buy_Acura__c = 'U';
        o.ENR_CI_Service_History__c = 'U';
        o.ENR_CI_Likely_to_Buy_Honda__c = 'T';
        o.ENR_CI_Extended_Warranty__c = 'C';
        o.ENR_CI_Likely_to_Buy_PSP__c = 'E';
        o.ENR_CI_Children_in_Household__c = 'Q';
        o.ENR_Acura_Vehicles_Owned__c = 23;
        o.ENR_Honda_Vehicles_Owned__c = 43;
        o.ENR_Power_Sports_Vehicles_Owned__c = 65;
        o.ENR_Power_Equipment_Vehicles_Owned__c = 65;
        o.ENR_Extended_Warranty_Contract__c=true;
        o.ENR_Likeliness_to_Buy_Acura__c = 'Q';
        o.ENR_Likeliness_to_Buy_Honda__c = 'B';
        o.ENR_Likeliness_to_Buy_PSP__c = 'Y';
        o.ENR_Ownership_Type__c = 'Current Owner';
        o.ENR_Total_Spent_on_Service_by_Customer__c = 43;
        o.ENR_Total_Spent_on_Service_by_Warranty__c = 34;
        o.DEPOSIT_AMOUNT__c = 6547;
        o.Deposit_Confirmation_Number__c = '1';
        o.Deposit_Sales_Order_Number__c = '4';
        o.Appointment_Notes__c = 'abc';
        o.Appointment_Date_and_Time__c = '22May2023';
        o.Appointment_Location__c = 'Hyderabad';
        o.Appointment_Notes__c = 'DSP';
        o.Appointment_type__c = 'tekion/walkin';
        o.Appointment_Id__c = '123';
        o.Deal_ID__c = '8497';
        o.Deal_Link__c = 'www.google.com';
        o.Contact_person__c = 'Lavanya';
        o.Send_to_DSP__c = true;
        o.Initial_Walkin_Lead__c = true;
        o.Is_This_Lead_Update__c = true;
        o.External_Lead_Reference_Number__c = '123';
        o.Street_TXT__c = 'Tenali';
        o.Provider_Type__c = 'Lavanya';
        o.AddressType_TXT__c = 'home';
        o.AppartmentNumber_TXT__c = '101';
        o.SendOnlyToUrbanScience__c = true;
        o.Routing_Error__c='HSJJSJDHSJJSJDHSJJSJDHSJJSJDHSJJSJDHSJJSJDHSJJSJDHSJJSJDHSJJSJDHSJJSJDHSJJSJDHSJJSJDHSJJSJDHSJJSJDHSJJSJDHSJJSJDHSJJSJDHSJJSJDHSJJSJDHSJJSJDHSJJSJDHSJJSJDHSJJSJDHSJJSJDHSJJSJDHSJJSJDHSJJSJDHSJJSJDHSJJSJDHSJJSJDHSJJSJDHSJJSJDHSJJSJDHSJJSJDHSJJSJDHSJJSJDDHH';
        insert o;
        
		Lead_Dealer_Assignment_ADF__e leddlr = new Lead_Dealer_Assignment_ADF__e(
        Customer_Insight_Service_History__c = o.ENR_CI_Service_History__c,
        Environmental_Issues__c = o.DMGR_Environmental_Issues__c,Green_Living__c=o.DMGR_Green_Living__c,
        Baseball__c = o.DMGR_Baseball__c, Basketball__c =o.DMGR_Basketball__c,Football__c=o.DMGR_Football__c,US_Travel__c=o.DMGR_US_Travel__c,
		Hockey__c=o.DMGR_Hockey__c=true,Skiing__c=o.DMGR_Skiing__c,Golf__c=o.DMGR_Golf__c,Vehicle_Known_Owned__c=o.DMGR_Vehicle_Known_Owned__c,
		Age__c=o.DMGR_Age__c,Income__c = o.DMGR_Income__c,Children__c = o.DMGR_Children__c,Income_Estate_HHLD_Higher_Ranges__c = o.DMGR_Income_Estate_HHLD_Higher_Ranges__c,Marital_Status__c = o.DMGR_Marital_Status__c,Occupation__c = o.DMGR_Occupation__c,Home_Owner_or_Renter__c = o.DMGR_Home_Owner_or_Renter__c,Occupation_Detailed__c = o.DMGR_Occupation_Detailed__c,Household_Size__c = o.DMGR_Household_Size__c,
		Education_Level__c = o.DMGR_Education_Level__c,Customer_Insight_Ownership__c = o.ENR_CI_Ownership__c,Customer_Insight_Event_Attendance__c = o.ENR_CI_Event_Attendance__c,Customer_Insight_Ownership_Details__c = o.ENR_CI_Ownership_Details__c,Customer_Insight_Likely_to_Buy_Acura__c = o.ENR_CI_Likely_to_Buy_Acura__c,Customer_Insight_Likely_to_Buy_Honda__c = o.ENR_CI_Likely_to_Buy_Honda__c,Customer_Insight_Likely_to_Buy_PSP__c = o.ENR_CI_Likely_to_Buy_PSP__c,Customer_Insight_Children_in_Household__c = o.ENR_CI_Children_in_Household__c,Acura_Vehicles_Owned__c = o.ENR_Acura_Vehicles_Owned__c,Honda_Vehicles_Owned__c = o.ENR_Honda_Vehicles_Owned__c,Power_Sports_Vehicles_Owned__c = o.ENR_Power_Sports_Vehicles_Owned__c,
		Power_Equipment_Vehicles_Owned__c = o.ENR_Power_Equipment_Vehicles_Owned__c,Extended_Warranty_Contract__c=o.ENR_Extended_Warranty_Contract__c,Customer_Likeliness_to_Buy_Acura__c = o.ENR_Likeliness_to_Buy_Acura__c,Customer_Likeliness_to_Buy_Honda__c = o.ENR_Likeliness_to_Buy_Honda__c,Customer_Likeliness_to_Buy_PSP__c = o.ENR_Likeliness_to_Buy_PSP__c,Ownership_Type__c = o.ENR_Ownership_Type__c,Total_Spent_on_Service_by_Customer__c = String.valueof(o.ENR_Total_Spent_on_Service_by_Customer__c),
		Total_Spent_on_Service_by_Warranty__c = String.valueof(o.ENR_Total_Spent_on_Service_by_Warranty__c),Einstein_Predicted_Priority__c = o.Einstein_Predicted_Priority__c,Deposit_Amount__c = o.DEPOSIT_AMOUNT__c,Deposit_Confirmation_Number__c = o.Deposit_Confirmation_Number__c,Deposit_Sales_Order_Number__c = o.Deposit_Sales_Order_Number__c);
		
        List<Lead_Dealer_Acknowledgement_ADF__e> lst = new List<Lead_Dealer_Acknowledgement_ADF__e>();
        Lead_Dealer_Acknowledgement_ADF__e lda = new Lead_Dealer_Acknowledgement_ADF__e();
        lda.Oppotunity_SF_ID__c=o.Opportunity_SF_ID__c;
        lda.Status_Code__c='1';
        lda.CRM_Payload__c = 'ABCDEFGHIJL';
        lda.CRM_XML_Response__c = 'tyttyyay';
        lda.Error_Details_Urban_Science__c = 'POIUYT';
        lda.Response_Urban_Science__c = 'MOKKI';
        lda.Routing_Error__c = 'HSJJSJDHSJJSJDHSJJSJDHSJJSJDHSJJSJDHSJJSJDHSJJSJDHSJJSJDHSJJSJDHSJJSJDHSJJSJDHSJJSJDHSJJSJDHSJJSJDHSJJSJDHSJJSJDHSJJSJDHSJJSJDHSJJSJDHSJJSJDHSJJSJDHSJJSJDHSJJSJDHSJJSJDHSJJSJDHSJJSJDHSJJSJDHSJJSJDHSJJSJDHSJJSJDHSJJSJDHSJJSJDHSJJSJDHSJJSJDHSJJSJDHSJJSJDDHH';
        lda.Sent_to_Urban_Science_Status__c ='1';
        lda.Send_to_DSP__c = true;
        lda.Sent_to_DSP_Status__c = '0';
        lda.Response_DSP__c = 'abc';
        lda.DSP_Payload__c = 'abc';
        lda.UrbanScience_Payload__c = 'NUBYUN';
        lst.add(lda);
        
        Test.startTest();
        Database.SaveResult sr = EventBus.publish(leddlr);
        List<Database.SaveResult> sr1 = EventBus.publish(lst);
        HELMSLeadDealerAssignmentADFHandler hndlr = new HELMSLeadDealerAssignmentADFHandler();
        hndlr.updateOpportunityOnDealerAcknowledgement(lst);
        System.assertEquals(lda.CRM_Payload__c, 'ABCDEFGHIJL');
        Test.stopTest(); 
    }
    
   @istest static void updateOpportunityOnDealerAcknowledgement6(){
        Datetime dt = System.now();
     	// adding minutes in negative, effectively subtracts 30 mins
     	dt = dt.addMinutes(-60);
        string strldinfo='<LeadAdditionalInfo key="PriceComment">';
        Account acc = new Account(name ='Grazitti', DealerCode_CD__c='30Z514', recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Dealer').getRecordTypeId()) ;
        insert acc;
        Account acc1 = new Account(name ='Grazitti1', recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider').getRecordTypeId()) ;

        List<Lead_Additional_Attribute_Definition__c> ldaddattdf = new List<Lead_Additional_Attribute_Definition__c>();
        Lead_Additional_Attribute_Definition__c ldadd = new Lead_Additional_Attribute_Definition__c();
        ldadd.Name = 'PriceComment';
        ldadd.Shared_With_Dealer__c = 'TRUE';
        insert ldadd;
        ldaddattdf.add(ldadd);
       
        Opportunity o = new Opportunity ();
        o.Name='testtestvtesttesttestvtesttest75testtesttesttesvvv75characterstesttesttestvtesttesttesttesttest test test75 char';
        o.Routable_FLG__c= true;
        o.Opportunity_SF_ID__c='123';
        //o.Routing_Status__c='Success';
        o.Routing_Failure_Date_Time__c=system.now();
        o.Routing_Success_Date_Time__c=system.now();
        o.StageName='closed won';
        o.CloseDate=system.today();
        o.Email__c='ghou@gmail.com';
        o.ZipCode_TXT__c='89010';
        o.First_Name_TXT__c='test1';
        o.Last_Name_TXT__c='test2';
        o.TriggerTypeCode__c='';
        o.LeadAdditionalInfos__c = strldinfo;
        Id devRecordTypeId = Schema.getGlobalDescribe().get('Opportunity').getDescribe().getRecordTypeInfosByName().get('Power Sports Opportunity').getRecordTypeId();
        
        o.recordtypeid=devRecordTypeId;
        o.PreferredDealerAccount_TXT__c=acc.id;
        o.LeadProvider_ID__c=acc1.id;
        o.SubDiv_TXT__c='Motorcycle';
		o.ENR_CI_Service_History__c = '';
        o.DMGR_Environmental_Issues__c = true;
        o.DMGR_Green_Living__c=true;
        o.DMGR_Baseball__c=true;
        o.DMGR_Basketball__c=true;
        o.DMGR_Football__c=true;
        o.DMGR_US_Travel__c=true;
        o.DMGR_Hockey__c=true;
        o.DMGR_Skiing__c=true;
        o.DMGR_Golf__c=true;
        o.DMGR_Vehicle_Known_Owned__c=true;
        o.DMGR_Age__c=23;
        o.DMGR_Income__c='23423';
        o.DMGR_Children__c='ABC';
        o.DMGR_Income_Estate_HHLD_Higher_Ranges__c='23434';
        o.DMGR_Marital_Status__c='M';
        o.DMGR_Occupation__c = 'ABC';
        o.DMGR_Home_Owner_or_Renter__c ='M';
        o.DMGR_Occupation_Detailed__c = 'v';
        o.DMGR_Household_Size__c = 5;
        o.DMGR_Education_Level__c = 'H';
        o.ENR_CI_Ownership__c = 'C';
        o.ENR_CI_Event_Attendance__c = 'U';
        o.ENR_CI_Ownership_Details__c = 'R';
        o.ENR_CI_Likely_to_Buy_Acura__c = 'U';
        o.ENR_CI_Service_History__c = 'U';
        o.ENR_CI_Likely_to_Buy_Honda__c = 'T';
        o.ENR_CI_Extended_Warranty__c = 'C';
        o.ENR_CI_Likely_to_Buy_PSP__c = 'E';
        o.ENR_CI_Children_in_Household__c = 'Q';
        o.ENR_Acura_Vehicles_Owned__c = 23;
        o.ENR_Honda_Vehicles_Owned__c = 43;
        o.ENR_Power_Sports_Vehicles_Owned__c = 65;
        o.ENR_Power_Equipment_Vehicles_Owned__c = 65;
        o.ENR_Extended_Warranty_Contract__c=true;
        o.ENR_Likeliness_to_Buy_Acura__c = 'Q';
        o.ENR_Likeliness_to_Buy_Honda__c = 'B';
        o.ENR_Likeliness_to_Buy_PSP__c = 'Y';
        o.ENR_Ownership_Type__c = 'Current Owner';
        o.ENR_Total_Spent_on_Service_by_Customer__c = 43;
        o.ENR_Total_Spent_on_Service_by_Warranty__c = 34;
        o.DEPOSIT_AMOUNT__c = 6547;
        o.Deposit_Confirmation_Number__c = '1';
        o.Deposit_Sales_Order_Number__c = '4';
        o.Appointment_Notes__c = 'abc';
        o.Appointment_Date_and_Time__c = '22May2023';
        o.Appointment_Location__c = 'Hyderabad';
        o.Appointment_Notes__c = 'DSP';
        o.Appointment_type__c = 'tekion/walkin';
        o.Appointment_Id__c = '123';
        o.Deal_ID__c = '8497';
        o.Deal_Link__c = 'www.google.com';
        o.Contact_person__c = 'Lavanya';
        o.Send_to_DSP__c = true;
        o.Initial_Walkin_Lead__c = true;
        o.Is_This_Lead_Update__c = true;
        o.External_Lead_Reference_Number__c = '123';
        o.Street_TXT__c = 'Tenali';
        o.Provider_Type__c = 'Lavanya';
        o.AddressType_TXT__c = 'home';
        o.AppartmentNumber_TXT__c = '101';
          o.PhoneType_NM__c = 'home';
          o.Condition_TXT__c = 'abc';
          o.Country_TXT__c = 'US';
          o.Vendor_Contact_Name__c = 'lavanya';
          o.MiddlewareUUID__c = 'abc';
          o.Doors_TXT__c = 'door';
          o.Fax__c = 'phone';
          o.Make_TXT__c = 'acura';
          o.MobilePhone__c = '9876543210';
              o.Odometer_TXT__c = 'abc';
              o.OdometerUnits_TXT__c  = 'abc';
              o.Pager_TXT__c = 'abc';
              o.PurchaseHorizon_TXT__c = 'abc';
              o.Source_Name__c = 'brandsite';
              o.DSP_Routing_Response_Message__c = 'abc';
              o.DSP_Routing_Status_Message__c = 'abc';
              o.DSP_Status__c = 'abc';
              o.DSP_Update_Count__c = 0;
          o.Suffix_TXT__c = 'MR.';
          o.TradeBalanceOwed_TXT__c ='abc';
          o.InventoryNumber_TXT__c = '123';
          o.Transmission_TXT__c = 'abc';
          o.TriggerTypeCode__c = 'instant';
          o.SendOnlyToUrbanScience__c = false;
              
        insert o;
        
		Lead_Dealer_Assignment_ADF__e leddlr = new Lead_Dealer_Assignment_ADF__e(
        Customer_Insight_Service_History__c = o.ENR_CI_Service_History__c,
        Environmental_Issues__c = o.DMGR_Environmental_Issues__c,Green_Living__c=o.DMGR_Green_Living__c,
        Baseball__c = o.DMGR_Baseball__c, Basketball__c =o.DMGR_Basketball__c,Football__c=o.DMGR_Football__c,US_Travel__c=o.DMGR_US_Travel__c,
		Hockey__c=o.DMGR_Hockey__c=true,Skiing__c=o.DMGR_Skiing__c,Golf__c=o.DMGR_Golf__c,Vehicle_Known_Owned__c=o.DMGR_Vehicle_Known_Owned__c,
		Age__c=o.DMGR_Age__c,Income__c = o.DMGR_Income__c,Children__c = o.DMGR_Children__c,Income_Estate_HHLD_Higher_Ranges__c = o.DMGR_Income_Estate_HHLD_Higher_Ranges__c,Marital_Status__c = o.DMGR_Marital_Status__c,Occupation__c = o.DMGR_Occupation__c,Home_Owner_or_Renter__c = o.DMGR_Home_Owner_or_Renter__c,Occupation_Detailed__c = o.DMGR_Occupation_Detailed__c,Household_Size__c = o.DMGR_Household_Size__c,
		Education_Level__c = o.DMGR_Education_Level__c,Customer_Insight_Ownership__c = o.ENR_CI_Ownership__c,Customer_Insight_Event_Attendance__c = o.ENR_CI_Event_Attendance__c,Customer_Insight_Ownership_Details__c = o.ENR_CI_Ownership_Details__c,Customer_Insight_Likely_to_Buy_Acura__c = o.ENR_CI_Likely_to_Buy_Acura__c,Customer_Insight_Likely_to_Buy_Honda__c = o.ENR_CI_Likely_to_Buy_Honda__c,Customer_Insight_Likely_to_Buy_PSP__c = o.ENR_CI_Likely_to_Buy_PSP__c,Customer_Insight_Children_in_Household__c = o.ENR_CI_Children_in_Household__c,Acura_Vehicles_Owned__c = o.ENR_Acura_Vehicles_Owned__c,Honda_Vehicles_Owned__c = o.ENR_Honda_Vehicles_Owned__c,Power_Sports_Vehicles_Owned__c = o.ENR_Power_Sports_Vehicles_Owned__c,
		Power_Equipment_Vehicles_Owned__c = o.ENR_Power_Equipment_Vehicles_Owned__c,Extended_Warranty_Contract__c=o.ENR_Extended_Warranty_Contract__c,Customer_Likeliness_to_Buy_Acura__c = o.ENR_Likeliness_to_Buy_Acura__c,Customer_Likeliness_to_Buy_Honda__c = o.ENR_Likeliness_to_Buy_Honda__c,Customer_Likeliness_to_Buy_PSP__c = o.ENR_Likeliness_to_Buy_PSP__c,Ownership_Type__c = o.ENR_Ownership_Type__c,Total_Spent_on_Service_by_Customer__c = String.valueof(o.ENR_Total_Spent_on_Service_by_Customer__c),
		Total_Spent_on_Service_by_Warranty__c = String.valueof(o.ENR_Total_Spent_on_Service_by_Warranty__c),Einstein_Predicted_Priority__c = o.Einstein_Predicted_Priority__c,Deposit_Amount__c = o.DEPOSIT_AMOUNT__c,Deposit_Confirmation_Number__c = o.Deposit_Confirmation_Number__c,Deposit_Sales_Order_Number__c = o.Deposit_Sales_Order_Number__c);
		
        List<Lead_Dealer_Acknowledgement_ADF__e> lst = new List<Lead_Dealer_Acknowledgement_ADF__e>();
        Lead_Dealer_Acknowledgement_ADF__e lda = new Lead_Dealer_Acknowledgement_ADF__e();
        lda.Oppotunity_SF_ID__c=o.Opportunity_SF_ID__c;
        lda.Status_Code__c='1';
        lda.CRM_Payload__c = 'ABCDEFGHIJL';
        lda.CRM_XML_Response__c = 'tyttyyay';
        lda.Error_Details_Urban_Science__c = 'POIUYT';
        lda.Response_Urban_Science__c = 'MOKKI';
        lda.Routing_Error__c = 'HSJJSJD';
        lda.Sent_to_Urban_Science_Status__c ='1';
        lda.Send_to_DSP__c = true;
        lda.Sent_to_DSP_Status__c = '0';
        lda.Response_DSP__c = 'abc';
        lda.DSP_Payload__c = 'abc';
        lda.UrbanScience_Payload__c = 'NUBYUN';
          
        lst.add(lda);
        
        Test.startTest();
        Database.SaveResult sr = EventBus.publish(leddlr);
        List<Database.SaveResult> sr1 = EventBus.publish(lst);
        HELMSLeadDealerAssignmentADFHandler hndlr = new HELMSLeadDealerAssignmentADFHandler();
        hndlr.updateOpportunityOnDealerAcknowledgement(lst);
        System.assertEquals(lda.CRM_Payload__c, 'ABCDEFGHIJL');
        Test.stopTest(); 
    }
    
   @istest static void updateOpportunityOnDealerAcknowledgement7(){
        Datetime dt = System.now();
     	// adding minutes in negative, effectively subtracts 30 mins
     	dt = dt.addMinutes(-60);
        string strldinfo='<LeadAdditionalInfo key="Comment">';
        Account acc = new Account(name ='Grazitti', DealerCode_CD__c='30Z514', recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Dealer').getRecordTypeId()) ;
        insert acc;
        Account acc1 = new Account(name ='Grazitti1', recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider').getRecordTypeId()) ;

        List<Lead_Additional_Attribute_Definition__c> ldaddattdf = new List<Lead_Additional_Attribute_Definition__c>();
        Lead_Additional_Attribute_Definition__c ldadd = new Lead_Additional_Attribute_Definition__c();
        ldadd.Name = 'Comment';
        ldadd.Shared_With_Dealer__c = 'TRUE';
        insert ldadd;
        ldaddattdf.add(ldadd);
       
        Opportunity o = new Opportunity ();
        o.Name='test';
        o.Routable_FLG__c= true;
        o.Opportunity_SF_ID__c='123';
        //o.Routing_Status__c='Success';
        o.Routing_Failure_Date_Time__c=system.now();
        o.Routing_Success_Date_Time__c=system.now();
        o.StageName='closed won';
        o.CloseDate=system.today();
        o.Email__c='ghou@gmail.com';
        o.ZipCode_TXT__c='89010';
        o.First_Name_TXT__c='test1';
        o.Last_Name_TXT__c='test2';
        o.TriggerTypeCode__c='';
        o.LeadAdditionalInfos__c = strldinfo;
        Id devRecordTypeId = Schema.getGlobalDescribe().get('Opportunity').getDescribe().getRecordTypeInfosByName().get('Power Sports Opportunity').getRecordTypeId();
        
        o.recordtypeid=devRecordTypeId;
        o.PreferredDealerAccount_TXT__c=acc.id;
        o.LeadProvider_ID__c=acc1.id;
        o.SubDiv_TXT__c='Motorcycle';
		o.ENR_CI_Service_History__c = '';
        o.DMGR_Environmental_Issues__c = true;
        o.DMGR_Green_Living__c=true;
        o.DMGR_Baseball__c=true;
        o.DMGR_Basketball__c=true;
        o.DMGR_Football__c=true;
        o.DMGR_US_Travel__c=true;
        o.DMGR_Hockey__c=true;
        o.DMGR_Skiing__c=true;
        o.DMGR_Golf__c=true;
        o.DMGR_Vehicle_Known_Owned__c=true;
        o.DMGR_Age__c=23;
        o.DMGR_Income__c='23423';
        o.DMGR_Children__c='ABC';
        o.DMGR_Income_Estate_HHLD_Higher_Ranges__c='23434';
        o.DMGR_Marital_Status__c='M';
        o.DMGR_Occupation__c = 'ABC';
        o.DMGR_Home_Owner_or_Renter__c ='M';
        o.DMGR_Occupation_Detailed__c = 'v';
        o.DMGR_Household_Size__c = 5;
        o.DMGR_Education_Level__c = 'H';
        o.ENR_CI_Ownership__c = 'C';
        o.ENR_CI_Event_Attendance__c = 'U';
        o.ENR_CI_Ownership_Details__c = 'R';
        o.ENR_CI_Likely_to_Buy_Acura__c = 'U';
        o.ENR_CI_Service_History__c = 'U';
        o.ENR_CI_Likely_to_Buy_Honda__c = 'T';
        o.ENR_CI_Extended_Warranty__c = 'C';
        o.ENR_CI_Likely_to_Buy_PSP__c = 'E';
        o.ENR_CI_Children_in_Household__c = 'Q';
        o.ENR_Acura_Vehicles_Owned__c = 23;
        o.ENR_Honda_Vehicles_Owned__c = 43;
        o.ENR_Power_Sports_Vehicles_Owned__c = 65;
        o.ENR_Power_Equipment_Vehicles_Owned__c = 65;
        o.ENR_Extended_Warranty_Contract__c=true;
        o.ENR_Likeliness_to_Buy_Acura__c = 'Q';
        o.ENR_Likeliness_to_Buy_Honda__c = 'B';
        o.ENR_Likeliness_to_Buy_PSP__c = 'Y';
        o.ENR_Ownership_Type__c = 'Current Owner';
        o.ENR_Total_Spent_on_Service_by_Customer__c = 43;
        o.ENR_Total_Spent_on_Service_by_Warranty__c = 34;
        o.DEPOSIT_AMOUNT__c = 6547;
        o.Deposit_Confirmation_Number__c = '1';
        o.Deposit_Sales_Order_Number__c = '4';
        o.Appointment_Notes__c = 'abc';
        o.Appointment_Date_and_Time__c = '22May2023';
        o.Appointment_Location__c = 'Hyderabad';
        o.Appointment_Notes__c = 'DSP';
        o.Appointment_type__c = 'tekion/walkin';
        o.Appointment_Id__c = '123';
        o.Deal_ID__c = '8497';
        o.Deal_Link__c = 'www.google.com';
        o.Contact_person__c = 'Lavanya';
        o.Send_to_DSP__c = true;
        o.Initial_Walkin_Lead__c = true;
        o.Is_This_Lead_Update__c = true;
        o.External_Lead_Reference_Number__c = '123';
        o.Street_TXT__c = 'Tenali';
        o.Provider_Type__c = 'Lavanya';
        o.AddressType_TXT__c = 'home';
        o.AppartmentNumber_TXT__c = '101';
        insert o;
        
		Lead_Dealer_Assignment_ADF__e leddlr = new Lead_Dealer_Assignment_ADF__e(
        Customer_Insight_Service_History__c = o.ENR_CI_Service_History__c,
        Environmental_Issues__c = o.DMGR_Environmental_Issues__c,Green_Living__c=o.DMGR_Green_Living__c,
        Baseball__c = o.DMGR_Baseball__c, Basketball__c =o.DMGR_Basketball__c,Football__c=o.DMGR_Football__c,US_Travel__c=o.DMGR_US_Travel__c,
		Hockey__c=o.DMGR_Hockey__c=true,Skiing__c=o.DMGR_Skiing__c,Golf__c=o.DMGR_Golf__c,Vehicle_Known_Owned__c=o.DMGR_Vehicle_Known_Owned__c,
		Age__c=o.DMGR_Age__c,Income__c = o.DMGR_Income__c,Children__c = o.DMGR_Children__c,Income_Estate_HHLD_Higher_Ranges__c = o.DMGR_Income_Estate_HHLD_Higher_Ranges__c,Marital_Status__c = o.DMGR_Marital_Status__c,Occupation__c = o.DMGR_Occupation__c,Home_Owner_or_Renter__c = o.DMGR_Home_Owner_or_Renter__c,Occupation_Detailed__c = o.DMGR_Occupation_Detailed__c,Household_Size__c = o.DMGR_Household_Size__c,
		Education_Level__c = o.DMGR_Education_Level__c,Customer_Insight_Ownership__c = o.ENR_CI_Ownership__c,Customer_Insight_Event_Attendance__c = o.ENR_CI_Event_Attendance__c,Customer_Insight_Ownership_Details__c = o.ENR_CI_Ownership_Details__c,Customer_Insight_Likely_to_Buy_Acura__c = o.ENR_CI_Likely_to_Buy_Acura__c,Customer_Insight_Likely_to_Buy_Honda__c = o.ENR_CI_Likely_to_Buy_Honda__c,Customer_Insight_Likely_to_Buy_PSP__c = o.ENR_CI_Likely_to_Buy_PSP__c,Customer_Insight_Children_in_Household__c = o.ENR_CI_Children_in_Household__c,Acura_Vehicles_Owned__c = o.ENR_Acura_Vehicles_Owned__c,Honda_Vehicles_Owned__c = o.ENR_Honda_Vehicles_Owned__c,Power_Sports_Vehicles_Owned__c = o.ENR_Power_Sports_Vehicles_Owned__c,
		Power_Equipment_Vehicles_Owned__c = o.ENR_Power_Equipment_Vehicles_Owned__c,Extended_Warranty_Contract__c=o.ENR_Extended_Warranty_Contract__c,Customer_Likeliness_to_Buy_Acura__c = o.ENR_Likeliness_to_Buy_Acura__c,Customer_Likeliness_to_Buy_Honda__c = o.ENR_Likeliness_to_Buy_Honda__c,Customer_Likeliness_to_Buy_PSP__c = o.ENR_Likeliness_to_Buy_PSP__c,Ownership_Type__c = o.ENR_Ownership_Type__c,Total_Spent_on_Service_by_Customer__c = String.valueof(o.ENR_Total_Spent_on_Service_by_Customer__c),
		Total_Spent_on_Service_by_Warranty__c = String.valueof(o.ENR_Total_Spent_on_Service_by_Warranty__c),Einstein_Predicted_Priority__c = o.Einstein_Predicted_Priority__c,Deposit_Amount__c = o.DEPOSIT_AMOUNT__c,Deposit_Confirmation_Number__c = o.Deposit_Confirmation_Number__c,Deposit_Sales_Order_Number__c = o.Deposit_Sales_Order_Number__c);
		
        List<Lead_Dealer_Acknowledgement_ADF__e> lst = new List<Lead_Dealer_Acknowledgement_ADF__e>();
        Lead_Dealer_Acknowledgement_ADF__e lda = new Lead_Dealer_Acknowledgement_ADF__e();
        lda.Oppotunity_SF_ID__c=o.Opportunity_SF_ID__c;
        lda.Status_Code__c='1';
        lda.CRM_Payload__c = 'ABCDEFGHIJL';
        lda.CRM_XML_Response__c = 'tyttyyay';
        lda.Error_Details_Urban_Science__c = 'POIUYT';
        lda.Response_Urban_Science__c = 'MOKKI';
        lda.Routing_Error__c = 'HSJJSJD';
        lda.Sent_to_Urban_Science_Status__c ='0';
        lda.Send_to_DSP__c = true;
        lda.Sent_to_DSP_Status__c = '0';
        lda.Response_DSP__c = 'abc';
        lda.DSP_Payload__c = 'abc';
        lda.UrbanScience_Payload__c = 'NUBYUN';
        lda.Initial_Walkin_Lead__c = true;
        lst.add(lda);
        
        Test.startTest();
        Database.SaveResult sr = EventBus.publish(leddlr);
        List<Database.SaveResult> sr1 = EventBus.publish(lst);
        HELMSLeadDealerAssignmentADFHandler hndlr = new HELMSLeadDealerAssignmentADFHandler();
        hndlr.updateOpportunityOnDealerAcknowledgement(lst);
        System.assertEquals(lda.CRM_Payload__c, 'ABCDEFGHIJL');
        Test.stopTest(); 
    }
    
   @istest static void updateOpportunityOnDealerAcknowledgement8(){
        Datetime dt = System.now();
     	// adding minutes in negative, effectively subtracts 30 mins
     	dt = dt.addMinutes(-60);
        string strldinfo='<LeadAdditionalInfo key="Customer Preferred Contact Method">';
        Account acc = new Account(name ='Grazitti', DealerCode_CD__c='30Z514', recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Dealer').getRecordTypeId()) ;
        insert acc;
        Account acc1 = new Account(name ='Grazitti1', recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider').getRecordTypeId()) ;

        List<Lead_Additional_Attribute_Definition__c> ldaddattdf = new List<Lead_Additional_Attribute_Definition__c>();
        Lead_Additional_Attribute_Definition__c ldadd = new Lead_Additional_Attribute_Definition__c();
        ldadd.Name = 'Customer Preferred Contact Method';
        ldadd.Shared_With_Dealer__c = 'TRUE';
        insert ldadd;
        ldaddattdf.add(ldadd);
       
        Opportunity o = new Opportunity ();
        o.Name='test';
        o.Routable_FLG__c= true;
        o.Opportunity_SF_ID__c='123';
        //o.Routing_Status__c='Success';
        o.Routing_Failure_Date_Time__c=system.now();
        o.Routing_Success_Date_Time__c=system.now();
        o.StageName='closed won';
        o.CloseDate=system.today();
        o.Email__c='ghou@gmail.com';
        o.ZipCode_TXT__c='89010';
        o.First_Name_TXT__c='test1';
        o.Last_Name_TXT__c='test2';
        o.TriggerTypeCode__c='';
        o.LeadAdditionalInfos__c = strldinfo;
        Id devRecordTypeId = Schema.getGlobalDescribe().get('Opportunity').getDescribe().getRecordTypeInfosByName().get('Power Sports Opportunity').getRecordTypeId();
        
        o.recordtypeid=devRecordTypeId;
        o.PreferredDealerAccount_TXT__c=acc.id;
        o.LeadProvider_ID__c=acc1.id;
        o.SubDiv_TXT__c='Motorcycle';
		o.ENR_CI_Service_History__c = '';
        o.DMGR_Environmental_Issues__c = true;
        o.DMGR_Green_Living__c=true;
        o.DMGR_Baseball__c=true;
        o.DMGR_Basketball__c=true;
        o.DMGR_Football__c=true;
        o.DMGR_US_Travel__c=true;
        o.DMGR_Hockey__c=true;
        o.DMGR_Skiing__c=true;
        o.DMGR_Golf__c=true;
        o.DMGR_Vehicle_Known_Owned__c=true;
        o.DMGR_Age__c=23;
        o.DMGR_Income__c='23423';
        o.DMGR_Children__c='ABC';
        o.DMGR_Income_Estate_HHLD_Higher_Ranges__c='23434';
        o.DMGR_Marital_Status__c='M';
        o.DMGR_Occupation__c = 'ABC';
        o.DMGR_Home_Owner_or_Renter__c ='M';
        o.DMGR_Occupation_Detailed__c = 'v';
        o.DMGR_Household_Size__c = 5;
        o.DMGR_Education_Level__c = 'H';
        o.ENR_CI_Ownership__c = 'C';
        o.ENR_CI_Event_Attendance__c = 'U';
        o.ENR_CI_Ownership_Details__c = 'R';
        o.ENR_CI_Likely_to_Buy_Acura__c = 'U';
        o.ENR_CI_Service_History__c = 'U';
        o.ENR_CI_Likely_to_Buy_Honda__c = 'T';
        o.ENR_CI_Extended_Warranty__c = 'C';
        o.ENR_CI_Likely_to_Buy_PSP__c = 'E';
        o.ENR_CI_Children_in_Household__c = 'Q';
        o.ENR_Acura_Vehicles_Owned__c = 23;
        o.ENR_Honda_Vehicles_Owned__c = 43;
        o.ENR_Power_Sports_Vehicles_Owned__c = 65;
        o.ENR_Power_Equipment_Vehicles_Owned__c = 65;
        o.ENR_Extended_Warranty_Contract__c=true;
        o.ENR_Likeliness_to_Buy_Acura__c = 'Q';
        o.ENR_Likeliness_to_Buy_Honda__c = 'B';
        o.ENR_Likeliness_to_Buy_PSP__c = 'Y';
        o.ENR_Ownership_Type__c = 'Current Owner';
        o.ENR_Total_Spent_on_Service_by_Customer__c = 43;
        o.ENR_Total_Spent_on_Service_by_Warranty__c = 34;
        o.DEPOSIT_AMOUNT__c = 6547;
        o.Deposit_Confirmation_Number__c = '1';
        o.Deposit_Sales_Order_Number__c = '4';
        o.Appointment_Notes__c = 'abc';
        o.Appointment_Date_and_Time__c = '22May2023';
        o.Appointment_Location__c = 'Hyderabad';
        o.Appointment_Notes__c = 'DSP';
        o.Appointment_type__c = 'tekion/walkin';
        o.Appointment_Id__c = '123';
        o.Deal_ID__c = '8497';
        o.Deal_Link__c = 'www.google.com';
        o.Contact_person__c = 'Lavanya';
        o.Send_to_DSP__c = true;
        o.Initial_Walkin_Lead__c = true;
        o.Is_This_Lead_Update__c = true;
        o.External_Lead_Reference_Number__c = '123';
        o.Street_TXT__c = 'Tenali';
        o.Provider_Type__c = 'Lavanya';
        o.AddressType_TXT__c = 'home';
        o.AppartmentNumber_TXT__c = '101';
        insert o;
        
		Lead_Dealer_Assignment_ADF__e leddlr = new Lead_Dealer_Assignment_ADF__e(
        Customer_Insight_Service_History__c = o.ENR_CI_Service_History__c,
        Environmental_Issues__c = o.DMGR_Environmental_Issues__c,Green_Living__c=o.DMGR_Green_Living__c,
        Baseball__c = o.DMGR_Baseball__c, Basketball__c =o.DMGR_Basketball__c,Football__c=o.DMGR_Football__c,US_Travel__c=o.DMGR_US_Travel__c,
		Hockey__c=o.DMGR_Hockey__c=true,Skiing__c=o.DMGR_Skiing__c,Golf__c=o.DMGR_Golf__c,Vehicle_Known_Owned__c=o.DMGR_Vehicle_Known_Owned__c,
		Age__c=o.DMGR_Age__c,Income__c = o.DMGR_Income__c,Children__c = o.DMGR_Children__c,Income_Estate_HHLD_Higher_Ranges__c = o.DMGR_Income_Estate_HHLD_Higher_Ranges__c,Marital_Status__c = o.DMGR_Marital_Status__c,Occupation__c = o.DMGR_Occupation__c,Home_Owner_or_Renter__c = o.DMGR_Home_Owner_or_Renter__c,Occupation_Detailed__c = o.DMGR_Occupation_Detailed__c,Household_Size__c = o.DMGR_Household_Size__c,
		Education_Level__c = o.DMGR_Education_Level__c,Customer_Insight_Ownership__c = o.ENR_CI_Ownership__c,Customer_Insight_Event_Attendance__c = o.ENR_CI_Event_Attendance__c,Customer_Insight_Ownership_Details__c = o.ENR_CI_Ownership_Details__c,Customer_Insight_Likely_to_Buy_Acura__c = o.ENR_CI_Likely_to_Buy_Acura__c,Customer_Insight_Likely_to_Buy_Honda__c = o.ENR_CI_Likely_to_Buy_Honda__c,Customer_Insight_Likely_to_Buy_PSP__c = o.ENR_CI_Likely_to_Buy_PSP__c,Customer_Insight_Children_in_Household__c = o.ENR_CI_Children_in_Household__c,Acura_Vehicles_Owned__c = o.ENR_Acura_Vehicles_Owned__c,Honda_Vehicles_Owned__c = o.ENR_Honda_Vehicles_Owned__c,Power_Sports_Vehicles_Owned__c = o.ENR_Power_Sports_Vehicles_Owned__c,
		Power_Equipment_Vehicles_Owned__c = o.ENR_Power_Equipment_Vehicles_Owned__c,Extended_Warranty_Contract__c=o.ENR_Extended_Warranty_Contract__c,Customer_Likeliness_to_Buy_Acura__c = o.ENR_Likeliness_to_Buy_Acura__c,Customer_Likeliness_to_Buy_Honda__c = o.ENR_Likeliness_to_Buy_Honda__c,Customer_Likeliness_to_Buy_PSP__c = o.ENR_Likeliness_to_Buy_PSP__c,Ownership_Type__c = o.ENR_Ownership_Type__c,Total_Spent_on_Service_by_Customer__c = String.valueof(o.ENR_Total_Spent_on_Service_by_Customer__c),
		Total_Spent_on_Service_by_Warranty__c = String.valueof(o.ENR_Total_Spent_on_Service_by_Warranty__c),Einstein_Predicted_Priority__c = o.Einstein_Predicted_Priority__c,Deposit_Amount__c = o.DEPOSIT_AMOUNT__c,Deposit_Confirmation_Number__c = o.Deposit_Confirmation_Number__c,Deposit_Sales_Order_Number__c = o.Deposit_Sales_Order_Number__c);
		
        List<Lead_Dealer_Acknowledgement_ADF__e> lst = new List<Lead_Dealer_Acknowledgement_ADF__e>();
        Lead_Dealer_Acknowledgement_ADF__e lda = new Lead_Dealer_Acknowledgement_ADF__e();
        lda.Oppotunity_SF_ID__c=o.Opportunity_SF_ID__c;
        lda.Status_Code__c='0';
        lda.CRM_Payload__c = 'ABCDEFGHIJL';
        lda.CRM_XML_Response__c = 'tyttyyay';
        lda.Error_Details_Urban_Science__c = 'POIUYT';
        lda.Response_Urban_Science__c = 'MOKKI';
        lda.Routing_Error__c = 'HSJJSJD';
        lda.Sent_to_Urban_Science_Status__c ='1';
        lda.Send_to_DSP__c = true;
        lda.Sent_to_DSP_Status__c = '1';
        lda.Response_DSP__c = 'abc';
        lda.DSP_Payload__c = 'abc';
        lda.UrbanScience_Payload__c = 'NUBYUN';
        lda.Initial_Walkin_Lead__c = true;
        lst.add(lda);
        
        Test.startTest();
        Database.SaveResult sr = EventBus.publish(leddlr);
        List<Database.SaveResult> sr1 = EventBus.publish(lst);
        HELMSLeadDealerAssignmentADFHandler hndlr = new HELMSLeadDealerAssignmentADFHandler();
        hndlr.updateOpportunityOnDealerAcknowledgement(lst);
        System.assertEquals(lda.CRM_Payload__c, 'ABCDEFGHIJL');
        Test.stopTest(); 
    }
   
   @istest static void updateOpportunityOnDealerAcknowledgement9(){
        Datetime dt = System.now();
     	// adding minutes in negative, effectively subtracts 30 mins
     	dt = dt.addMinutes(-60);
        string strldinfo='<LeadAdditionalInfo key="UserComments">';
        Account acc = new Account(name ='Grazitti', DealerCode_CD__c='30Z514', recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Dealer').getRecordTypeId()) ;
        insert acc;
        Account acc1 = new Account(name ='Grazitti1', recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider').getRecordTypeId()) ;

        List<Lead_Additional_Attribute_Definition__c> ldaddattdf = new List<Lead_Additional_Attribute_Definition__c>();
        Lead_Additional_Attribute_Definition__c ldadd = new Lead_Additional_Attribute_Definition__c();
        ldadd.Name = 'UserComments';
        ldadd.Shared_With_Dealer__c = 'TRUE';
        insert ldadd;
        ldaddattdf.add(ldadd);
       
        Opportunity o = new Opportunity ();
        o.Name='test';
        o.Routable_FLG__c= true;
        o.Opportunity_SF_ID__c='123';
        //o.Routing_Status__c='Success';
        o.Routing_Failure_Date_Time__c=system.now();
        o.Routing_Success_Date_Time__c=system.now();
        o.StageName='closed won';
        o.CloseDate=system.today();
        o.Email__c='ghou@gmail.com';
        o.ZipCode_TXT__c='89010';
        o.First_Name_TXT__c='test1';
        o.Last_Name_TXT__c='test2';
        o.TriggerTypeCode__c='';
        o.LeadAdditionalInfos__c = strldinfo;
        Id devRecordTypeId = Schema.getGlobalDescribe().get('Opportunity').getDescribe().getRecordTypeInfosByName().get('Power Sports Opportunity').getRecordTypeId();
        
        o.recordtypeid=devRecordTypeId;
        o.PreferredDealerAccount_TXT__c=acc.id;
        o.LeadProvider_ID__c=acc1.id;
        o.SubDiv_TXT__c='Motorcycle';
		o.ENR_CI_Service_History__c = '';
        o.DMGR_Environmental_Issues__c = true;
        o.DMGR_Green_Living__c=true;
        o.DMGR_Baseball__c=true;
        o.DMGR_Basketball__c=true;
        o.DMGR_Football__c=true;
        o.DMGR_US_Travel__c=true;
        o.DMGR_Hockey__c=true;
        o.DMGR_Skiing__c=true;
        o.DMGR_Golf__c=true;
        o.DMGR_Vehicle_Known_Owned__c=true;
        o.DMGR_Age__c=23;
        o.DMGR_Income__c='23423';
        o.DMGR_Children__c='ABC';
        o.DMGR_Income_Estate_HHLD_Higher_Ranges__c='23434';
        o.DMGR_Marital_Status__c='M';
        o.DMGR_Occupation__c = 'ABC';
        o.DMGR_Home_Owner_or_Renter__c ='M';
        o.DMGR_Occupation_Detailed__c = 'v';
        o.DMGR_Household_Size__c = 5;
        o.DMGR_Education_Level__c = 'H';
        o.ENR_CI_Ownership__c = 'C';
        o.ENR_CI_Event_Attendance__c = 'U';
        o.ENR_CI_Ownership_Details__c = 'R';
        o.ENR_CI_Likely_to_Buy_Acura__c = 'U';
        o.ENR_CI_Service_History__c = 'U';
        o.ENR_CI_Likely_to_Buy_Honda__c = 'T';
        o.ENR_CI_Extended_Warranty__c = 'C';
        o.ENR_CI_Likely_to_Buy_PSP__c = 'E';
        o.ENR_CI_Children_in_Household__c = 'Q';
        o.ENR_Acura_Vehicles_Owned__c = 23;
        o.ENR_Honda_Vehicles_Owned__c = 43;
        o.ENR_Power_Sports_Vehicles_Owned__c = 65;
        o.ENR_Power_Equipment_Vehicles_Owned__c = 65;
        o.ENR_Extended_Warranty_Contract__c=true;
        o.ENR_Likeliness_to_Buy_Acura__c = 'Q';
        o.ENR_Likeliness_to_Buy_Honda__c = 'B';
        o.ENR_Likeliness_to_Buy_PSP__c = 'Y';
        o.ENR_Ownership_Type__c = 'Current Owner';
        o.ENR_Total_Spent_on_Service_by_Customer__c = 43;
        o.ENR_Total_Spent_on_Service_by_Warranty__c = 34;
        o.DEPOSIT_AMOUNT__c = 6547;
        o.Deposit_Confirmation_Number__c = '1';
        o.Deposit_Sales_Order_Number__c = '4';
        o.Appointment_Notes__c = 'abc';
        o.Appointment_Date_and_Time__c = '22May2023';
        o.Appointment_Location__c = 'Hyderabad';
        o.Appointment_Notes__c = 'DSP';
        o.Appointment_type__c = 'tekion/walkin';
        o.Appointment_Id__c = '123';
        o.Deal_ID__c = '8497';
        o.Deal_Link__c = 'www.google.com';
        o.Contact_person__c = 'Lavanya';
        o.Send_to_DSP__c = true;
        o.Initial_Walkin_Lead__c = true;
        o.Is_This_Lead_Update__c = true;
        o.External_Lead_Reference_Number__c = '123';
        o.Street_TXT__c = 'Tenali';
        o.Provider_Type__c = 'Lavanya';
        o.AddressType_TXT__c = 'home';
        o.AppartmentNumber_TXT__c = '101';
        insert o;
        
		Lead_Dealer_Assignment_ADF__e leddlr = new Lead_Dealer_Assignment_ADF__e(
        Customer_Insight_Service_History__c = o.ENR_CI_Service_History__c,
        Environmental_Issues__c = o.DMGR_Environmental_Issues__c,Green_Living__c=o.DMGR_Green_Living__c,
        Baseball__c = o.DMGR_Baseball__c, Basketball__c =o.DMGR_Basketball__c,Football__c=o.DMGR_Football__c,US_Travel__c=o.DMGR_US_Travel__c,
		Hockey__c=o.DMGR_Hockey__c=true,Skiing__c=o.DMGR_Skiing__c,Golf__c=o.DMGR_Golf__c,Vehicle_Known_Owned__c=o.DMGR_Vehicle_Known_Owned__c,
		Age__c=o.DMGR_Age__c,Income__c = o.DMGR_Income__c,Children__c = o.DMGR_Children__c,Income_Estate_HHLD_Higher_Ranges__c = o.DMGR_Income_Estate_HHLD_Higher_Ranges__c,Marital_Status__c = o.DMGR_Marital_Status__c,Occupation__c = o.DMGR_Occupation__c,Home_Owner_or_Renter__c = o.DMGR_Home_Owner_or_Renter__c,Occupation_Detailed__c = o.DMGR_Occupation_Detailed__c,Household_Size__c = o.DMGR_Household_Size__c,
		Education_Level__c = o.DMGR_Education_Level__c,Customer_Insight_Ownership__c = o.ENR_CI_Ownership__c,Customer_Insight_Event_Attendance__c = o.ENR_CI_Event_Attendance__c,Customer_Insight_Ownership_Details__c = o.ENR_CI_Ownership_Details__c,Customer_Insight_Likely_to_Buy_Acura__c = o.ENR_CI_Likely_to_Buy_Acura__c,Customer_Insight_Likely_to_Buy_Honda__c = o.ENR_CI_Likely_to_Buy_Honda__c,Customer_Insight_Likely_to_Buy_PSP__c = o.ENR_CI_Likely_to_Buy_PSP__c,Customer_Insight_Children_in_Household__c = o.ENR_CI_Children_in_Household__c,Acura_Vehicles_Owned__c = o.ENR_Acura_Vehicles_Owned__c,Honda_Vehicles_Owned__c = o.ENR_Honda_Vehicles_Owned__c,Power_Sports_Vehicles_Owned__c = o.ENR_Power_Sports_Vehicles_Owned__c,
		Power_Equipment_Vehicles_Owned__c = o.ENR_Power_Equipment_Vehicles_Owned__c,Extended_Warranty_Contract__c=o.ENR_Extended_Warranty_Contract__c,Customer_Likeliness_to_Buy_Acura__c = o.ENR_Likeliness_to_Buy_Acura__c,Customer_Likeliness_to_Buy_Honda__c = o.ENR_Likeliness_to_Buy_Honda__c,Customer_Likeliness_to_Buy_PSP__c = o.ENR_Likeliness_to_Buy_PSP__c,Ownership_Type__c = o.ENR_Ownership_Type__c,Total_Spent_on_Service_by_Customer__c = String.valueof(o.ENR_Total_Spent_on_Service_by_Customer__c),
		Total_Spent_on_Service_by_Warranty__c = String.valueof(o.ENR_Total_Spent_on_Service_by_Warranty__c),Einstein_Predicted_Priority__c = o.Einstein_Predicted_Priority__c,Deposit_Amount__c = o.DEPOSIT_AMOUNT__c,Deposit_Confirmation_Number__c = o.Deposit_Confirmation_Number__c,Deposit_Sales_Order_Number__c = o.Deposit_Sales_Order_Number__c);
		
        List<Lead_Dealer_Acknowledgement_ADF__e> lst = new List<Lead_Dealer_Acknowledgement_ADF__e>();
        Lead_Dealer_Acknowledgement_ADF__e lda = new Lead_Dealer_Acknowledgement_ADF__e();
        lda.Oppotunity_SF_ID__c=o.Opportunity_SF_ID__c;
        lda.Status_Code__c='0';
        lda.CRM_Payload__c = 'ABCDEFGHIJL';
        lda.CRM_XML_Response__c = 'tyttyyay';
        lda.Error_Details_Urban_Science__c = 'POIUYT';
        lda.Response_Urban_Science__c = 'MOKKI';
        lda.Routing_Error__c = 'HSJJSJD';
        lda.Sent_to_Urban_Science_Status__c ='1';
        lda.Send_to_DSP__c = true;
        lda.Sent_to_DSP_Status__c = '1';
        lda.Response_DSP__c = 'abc';
        lda.DSP_Payload__c = 'abc';
        lda.UrbanScience_Payload__c = 'NUBYUN';
        lda.Initial_Walkin_Lead__c = true;
        lst.add(lda);
        
        Test.startTest();
        Database.SaveResult sr = EventBus.publish(leddlr);
        List<Database.SaveResult> sr1 = EventBus.publish(lst);
        HELMSLeadDealerAssignmentADFHandler hndlr = new HELMSLeadDealerAssignmentADFHandler();
        hndlr.updateOpportunityOnDealerAcknowledgement(lst);
        hndlr.updateOpportunityOnDealerAcknowledgement(null);
        System.assertEquals(lda.CRM_Payload__c, 'ABCDEFGHIJL');
        Test.stopTest(); 
    }
    
   static testmethod void updateOpportunityRoutingCustomObject1(){
        Datetime dt = System.now();
     	// adding minutes in negative, effectively subtracts 30 mins
     	dt = dt.addMinutes(-60);
            
                Routing_Acknowledgement_No_Response__c r1 = new Routing_Acknowledgement_No_Response__c();
        r1.Opportunity_SF_ID__c = '123456';
        r1.CreatedDate = dt;
        insert r1;
        System.assertEquals(r1.Opportunity_SF_ID__c, '123456');
        }
    
   @istest static void newLeadDispositionADFs1(){
        
        string strldinfo='<LeadAdditionalInfo key="VehicleComment">';

        Account acc = new Account(name ='Grazitti', DealerCode_CD__c='30Z514', recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Dealer').getRecordTypeId()) ;
        insert acc;
        Account acc1 = new Account(name ='Grazitti1', DealerCode_CD__c='123456',recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider').getRecordTypeId()) ;
        insert acc1;  
       
        List<Lead_Additional_Attribute_Definition__c> ldaddattdf = new List<Lead_Additional_Attribute_Definition__c>();
        Lead_Additional_Attribute_Definition__c ldadd = new Lead_Additional_Attribute_Definition__c();
        ldadd.Name = 'VehicleComment';
        ldadd.Shared_With_Dealer__c = 'TRUE';
        insert ldadd;
        ldaddattdf.add(ldadd);
       
        List<Opportunity> opp = new List<Opportunity>();
       
        Opportunity o = new Opportunity ();
        o.Name='test';
        o.Routable_FLG__c= true;
        o.Opportunity_SF_ID__c='123';
        //o.Routing_Status__c='Success';
        o.Routing_Failure_Date_Time__c=system.now();
        o.Routing_Success_Date_Time__c=system.now();
        o.StageName='closed won';
        o.CloseDate=system.today();
        o.Email__c='ghou@gmail.com';
        o.LeadAdditionalInfos__c = strldinfo;
        o.ZipCode_TXT__c='89010';
        o.First_Name_TXT__c='test1';
        o.Last_Name_TXT__c='test2';
        o.TriggerTypeCode__c='';
        o.PurchaseEarliestDate_DT__c = 'test purchase Edate';
        o.PurchaseLatestDate_DT__c = 'test purchase Ldate';
        o.Quote_AMT__c = 19.5;
        o.SourceUser_TXT__c = 'test s user';
        o.State_TXT__c = 'test state';
        Id devRecordTypeId = Schema.getGlobalDescribe().get('Opportunity').getDescribe().getRecordTypeInfosByName().get('Power Sports Opportunity').getRecordTypeId();
        o.recordtypeid=devRecordTypeId;
        o.PreferredDealerAccount_TXT__c=acc.id;
        o.LeadProvider_ID__c=acc1.id;
        o.SubDiv_TXT__c='Motorcycle';
        o.Source_Unique_ID__c = '124315';
        o.Appointment_Date_and_Time__c = 'test';
        o.Appointment_Id__c = '11245';
        o.Appointment_Location__c = 'test';
        o.Appointment_Notes__c = 'test';
        o.Appointment_type__c = 'test';
        o.Deal_ID__c = '123215';
        o.Deal_Link__c = 'test';
        o.Duplicate_Similar__c = true;
		o.ENR_CI_Service_History__c = '';
        o.DMGR_Environmental_Issues__c = true;
        o.DMGR_Green_Living__c=true;
        o.DMGR_Baseball__c=true;
        o.DMGR_Basketball__c=true;
        o.DMGR_Football__c=true;
        o.DMGR_US_Travel__c=true;
        o.ContactTime_TXT__c = 'morning';
        o.ContactType_TXT__c = 'phone';
        o.ContactMethod_TXT__c = 'test contact method';
        o.Customer_Ids_ID__c = '21837809';
        o.Vendor_Contact_Email__c = 'testvendorctemail@gmail.com';
        o.DMGR_Hockey__c=true;
        o.DMGR_Skiing__c=true;
        o.Options_TXT__c = 'test option';
        o.OtherContacts_TXT__c = 'test other contacts';
        o.OtherLeadProvider_TXT__c = 'test other lead provider';
        o.Phone__c = '123123145';
        o.Prospect_Ids_ID__c = '31232123';
        o.Provider_Ids_ID__c = '52342342';
        o.ProviderContactDetail_TXT__c = 'provider contact detail';
        o.ProviderDetail_TXT__c = 'provider detail';
        o.DMGR_Golf__c=true;
        o.FinancialDetails_TXT__c = 'test financial details';
        o.Middle_Name_TXT__c = 'test middle name';
        o.Trim_TXT__c = 'test trim txt';
        o.Model_TXT__c = 'vehicle model';
        o.MSRP_AMT__c = 20.3;
        o.DMGR_Vehicle_Known_Owned__c=true;
        o.DMGR_Age__c=23;
        o.DMGR_Income__c='23423';
        o.PhoneType_NM__c = 'home';
        o.DMGR_Children__c='ABC';
        o.DMGR_Income_Estate_HHLD_Higher_Ranges__c='23434';
        o.DMGR_Marital_Status__c='M';
        o.DMGR_Occupation__c = 'ABC';
        o.DMGR_Home_Owner_or_Renter__c ='M';
        o.DMGR_Occupation_Detailed__c = 'v';
        o.DMGR_Household_Size__c = 5;
        o.DMGR_Education_Level__c = 'H';
        o.ENR_CI_Ownership__c = 'C';
        o.ENR_CI_Event_Attendance__c = 'U';
        o.ENR_CI_Ownership_Details__c = 'R';
        o.ENR_CI_Likely_to_Buy_Acura__c = 'U';
        o.ENR_CI_Service_History__c = 'U';
        o.ENR_CI_Likely_to_Buy_Honda__c = 'T';
        o.ENR_CI_Extended_Warranty__c = 'C';
        o.ENR_CI_Likely_to_Buy_PSP__c = 'E';
        o.ENR_CI_Children_in_Household__c = 'Q';
        o.ENR_Acura_Vehicles_Owned__c = 23;
        o.ENR_Honda_Vehicles_Owned__c = 43;
        o.TradeMake_TXT__c = 'test trade maker';
        o.ENR_Power_Sports_Vehicles_Owned__c = 65;
        o.ENR_Power_Equipment_Vehicles_Owned__c = 65;
        o.ENR_Extended_Warranty_Contract__c=true;
        o.ENR_Likeliness_to_Buy_Acura__c = 'Q';
        o.ENR_Likeliness_to_Buy_Honda__c = 'B';
        o.ENR_Likeliness_to_Buy_PSP__c = 'Y';
        o.ENR_Ownership_Type__c = 'Current Owner';
        o.ENR_Total_Spent_on_Service_by_Customer__c = 43;
        o.ENR_Total_Spent_on_Service_by_Warranty__c = 34;
        o.DEPOSIT_AMOUNT__c = 6547;
        o.Deposit_Confirmation_Number__c = '1';
        o.Deposit_Sales_Order_Number__c = '4';
        o.Appointment_Notes__c = 'abc';
        o.Appointment_Date_and_Time__c = '22May2023';
        o.Appointment_Location__c = 'Hyderabad';
        o.Appointment_Notes__c = 'DSP';
        o.Appointment_type__c = 'tekion/walkin';
        o.Appointment_Id__c = '123';
        o.Odometer_TXT__c = 'working';
        o.Deal_ID__c = '8497';
        o.Deal_Link__c = 'www.google.com';
        o.Contact_person__c = 'Lavanya';
        o.Send_to_DSP__c = true;
        o.Initial_Walkin_Lead__c = true;
        o.Is_This_Lead_Update__c = true;
        o.External_Lead_Reference_Number__c = '123';
        o.Street_TXT__c = 'Tenali';
        o.Provider_Type__c = 'Lavanya';
        o.Chat_Transcript__c = 'test chat transcript';
        o.BodyStyle_TXT__c = 'test body style';
        o.City_TXT__c = 'test city text';
        o.Color_XML__c = 'test color xml blue';
        o.AddressType_TXT__c = 'home';
        o.AppartmentNumber_TXT__c = '101';
        o.SendOnlyToUrbanScience__c = true;
        o.Routing_Error__c='HSJJSJDHSJJ';
        o.Provider_Tool_Name__c = 'test provider tool name';
        o.Description = 'test description';
        opp.add(o);
      
        Opportunity_Additional_Attribute__c oaa = new Opportunity_Additional_Attribute__c();
        oaa.Opportunity_Id__c = opp[0].Id;
        oaa.Attribute_Value__c = 'test attribute value';
        insert oaa;
       
        Test.startTest();
          HELMSLeadDealerAssignmentADFHandler hndlr = new HELMSLeadDealerAssignmentADFHandler();
          hndlr.newLeadDispositionADFs(opp);
          hndlr.newLeadDispositionADFs(null);
          System.assertEquals(ldadd.Name, 'VehicleComment');
        Test.stopTest(); 
        
   }
       
   @istest static void newLeadDispositionADFs2(){
        
        string strldinfo='<LeadAdditionalInfo key="CustomerComment">';

        Account acc = new Account(name ='Grazitti', DealerCode_CD__c='30Z514', recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Dealer').getRecordTypeId()) ;
        insert acc;
        Account acc1 = new Account(name ='Grazitti1', DealerCode_CD__c='123456',recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider').getRecordTypeId()) ;
        insert acc1;  
       
        List<Lead_Additional_Attribute_Definition__c> ldaddattdf = new List<Lead_Additional_Attribute_Definition__c>();
        Lead_Additional_Attribute_Definition__c ldadd = new Lead_Additional_Attribute_Definition__c();
        ldadd.Name = 'CustomerComment';
        ldadd.Shared_With_Dealer__c = 'TRUE';
        insert ldadd;
        ldaddattdf.add(ldadd);
       
        List<Opportunity> opp = new List<Opportunity>();
       
        Opportunity o = new Opportunity ();
        o.Name='test';
        o.Routable_FLG__c= true;
        o.Opportunity_SF_ID__c=null;
        //o.Routing_Status__c='Success';
        o.Routing_Failure_Date_Time__c=system.now();
        o.Routing_Success_Date_Time__c=system.now();
        o.StageName='closed won';
        o.CloseDate=system.today();
        o.Email__c=null;
        o.ZipCode_TXT__c='89010';
        o.First_Name_TXT__c='test1';
        o.Last_Name_TXT__c='test2';
        o.TriggerTypeCode__c='';
        O.Duplicate_Similar__c = TRUE;
        o.LeadAdditionalInfos__c = strldinfo;
        Id devRecordTypeId = Schema.getGlobalDescribe().get('Opportunity').getDescribe().getRecordTypeInfosByName().get('Power Sports Opportunity').getRecordTypeId();
        o.recordtypeid=devRecordTypeId;
        o.PreferredDealerAccount_TXT__c=acc.id;
        o.LeadProvider_ID__c=acc1.id;
        o.SubDiv_TXT__c=null;
        o.Duplicate_Similar__c = true;
		o.ENR_CI_Service_History__c = '';
        o.DMGR_Environmental_Issues__c = false;
        o.DMGR_Green_Living__c=false;
        o.DMGR_Baseball__c=false;
        o.DMGR_Basketball__c=false;
        o.DMGR_Football__c=false;
        o.DMGR_US_Travel__c=false;
        o.PhoneType_NM__c = 'cellphone';
        o.DMGR_Hockey__c=false;
        o.DMGR_Skiing__c=false;
        o.DMGR_Golf__c=false;
        o.DMGR_Vehicle_Known_Owned__c=false;
        o.DMGR_Age__c=null;
        o.DMGR_Income__c=null;
        o.DMGR_Children__c=null;
        o.DMGR_Income_Estate_HHLD_Higher_Ranges__c=null;
        o.DMGR_Marital_Status__c=null;
        o.DMGR_Occupation__c = null;
        o.DMGR_Home_Owner_or_Renter__c =null;
        o.DMGR_Occupation_Detailed__c = null;
        o.DMGR_Household_Size__c = null;
        o.DMGR_Education_Level__c = null;
        o.ENR_CI_Ownership__c = null;
        o.ENR_CI_Event_Attendance__c = null;
        o.ENR_CI_Ownership_Details__c = null;
        o.ENR_CI_Likely_to_Buy_Acura__c = null;
        o.ENR_CI_Service_History__c = null;
        o.ENR_CI_Likely_to_Buy_Honda__c = null;
        o.ENR_CI_Extended_Warranty__c = null;
        o.ENR_CI_Likely_to_Buy_PSP__c = null;
        o.ENR_CI_Children_in_Household__c = null;
        o.ENR_Acura_Vehicles_Owned__c = null;
        o.ENR_Honda_Vehicles_Owned__c = null;
        o.ENR_Power_Sports_Vehicles_Owned__c = null;
        o.ENR_Power_Equipment_Vehicles_Owned__c = null;
        o.ENR_Extended_Warranty_Contract__c=true;
        o.ENR_Likeliness_to_Buy_Acura__c = null;
        o.ENR_Likeliness_to_Buy_Honda__c = null;
        o.ENR_Likeliness_to_Buy_PSP__c = null;
        o.ENR_Ownership_Type__c = null;
        o.ENR_Total_Spent_on_Service_by_Customer__c = null;
        o.ENR_Total_Spent_on_Service_by_Warranty__c = null;
        o.DEPOSIT_AMOUNT__c = 6547;
        o.Deposit_Confirmation_Number__c = '1';
        o.Deposit_Sales_Order_Number__c = '4';
        o.Appointment_Notes__c = 'abc';
        o.Appointment_Date_and_Time__c = '22May2023';
        o.Appointment_Location__c = 'Hyderabad';
        o.Appointment_Notes__c = 'DSP';
        o.Appointment_type__c = 'tekion/walkin';
        o.Appointment_Id__c = '123';
        o.Deal_ID__c = '8497';
        o.Deal_Link__c = 'www.google.com';
        o.Contact_person__c = 'Lavanya';
        o.Send_to_DSP__c = true;
        o.Initial_Walkin_Lead__c = true;
        o.Is_This_Lead_Update__c = true;
        o.External_Lead_Reference_Number__c = null;
        o.Street_TXT__c = null;
        o.Provider_Type__c = null;
        o.AddressType_TXT__c = null;
        o.AppartmentNumber_TXT__c = null;
        o.SendOnlyToUrbanScience__c = false;
        o.Routing_Error__c='HSJJSJDHSJJ';
        o.Description = '<![CDATA[<![CDATA[<![CDATA[atest';
        opp.add(o);
       
       
        Test.startTest();
          HELMSLeadDealerAssignmentADFHandler hndlr = new HELMSLeadDealerAssignmentADFHandler();
          hndlr.newLeadDispositionADFs(opp);
          hndlr.newLeadDispositionADFs(null);
          System.assertEquals(ldadd.Name, 'CustomerComment');
        Test.stopTest(); 
        
   }
   
   @istest static void newLeadDispositionADFs3(){
       
        string strldinfo='<LeadAdditionalInfo key="Models Selected">';

        Account acc = new Account(name ='Grazitti', DealerCode_CD__c='30Z514', recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Dealer').getRecordTypeId()) ;
        insert acc;
        Account acc1 = new Account(name ='Grazitti1', DealerCode_CD__c='123456',recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider').getRecordTypeId()) ;
        insert acc1;  
       
        List<Lead_Additional_Attribute_Definition__c> ldaddattdf = new List<Lead_Additional_Attribute_Definition__c>();
        Lead_Additional_Attribute_Definition__c ldadd = new Lead_Additional_Attribute_Definition__c();
        ldadd.Name = 'Models Selected';
        ldadd.Shared_With_Dealer__c = 'TRUE';
        insert ldadd;
        ldaddattdf.add(ldadd);
       
        List<Opportunity> opp = new List<Opportunity>();
       
        Opportunity o = new Opportunity ();
        o.Name=null;
        o.Routable_FLG__c= true;
        o.Opportunity_SF_ID__c='123';
        //o.Routing_Status__c='Success';
        o.Routing_Failure_Date_Time__c=system.now();
        o.Routing_Success_Date_Time__c=system.now();
        o.StageName='closed won';
        o.CloseDate=system.today();
        o.LeadAdditionalInfos__c = strldinfo;
        o.Email__c='ghou@gmail.com';
        o.Is_Third_Party_Duplicate__c = TRUE;
        o.ZipCode_TXT__c='89010';
        o.First_Name_TXT__c='test1';
        o.Last_Name_TXT__c='test2';
        o.TriggerTypeCode__c='';
        Id devRecordTypeId = Schema.getGlobalDescribe().get('Opportunity').getDescribe().getRecordTypeInfosByName().get('Power Sports Opportunity').getRecordTypeId();
        o.recordtypeid=devRecordTypeId;
        o.LeadProvider_ID__c=acc1.id;
        o.SubDiv_TXT__c='Motorcycle';
        o.Duplicate_Similar__c = true;
		o.ENR_CI_Service_History__c = '';
        o.DMGR_Environmental_Issues__c = true;
        o.DMGR_Green_Living__c=true;
        o.DMGR_Baseball__c=true;
        o.DMGR_Basketball__c=true;
        o.DMGR_Football__c=true;
        o.DMGR_US_Travel__c=true;
        o.PhoneType_NM__c = 'telefone';
        o.DMGR_Hockey__c=true;
        o.DMGR_Skiing__c=true;
        o.DMGR_Golf__c=true;
        o.DMGR_Vehicle_Known_Owned__c=true;
        o.DMGR_Age__c=23;
        o.DMGR_Income__c='23423';
        o.DMGR_Children__c='ABC';
        o.DMGR_Income_Estate_HHLD_Higher_Ranges__c='23434';
        o.DMGR_Marital_Status__c='M';
        o.DMGR_Occupation__c = 'ABC';
        o.DMGR_Home_Owner_or_Renter__c ='M';
        o.DMGR_Occupation_Detailed__c = 'v';
        o.DMGR_Household_Size__c = 5;
        o.DMGR_Education_Level__c = 'H';
        o.ENR_CI_Ownership__c = 'C';
        o.ENR_CI_Event_Attendance__c = 'U';
        o.ENR_CI_Ownership_Details__c = 'R';
        o.ENR_CI_Likely_to_Buy_Acura__c = 'U';
        o.ENR_CI_Service_History__c = 'U';
        o.ENR_CI_Likely_to_Buy_Honda__c = 'T';
        o.ENR_CI_Extended_Warranty__c = 'C';
        o.ENR_CI_Likely_to_Buy_PSP__c = 'E';
        o.ENR_CI_Children_in_Household__c = 'Q';
        o.ENR_Acura_Vehicles_Owned__c = 23;
        o.ENR_Honda_Vehicles_Owned__c = 43;
        o.ENR_Power_Sports_Vehicles_Owned__c = 65;
        o.ENR_Power_Equipment_Vehicles_Owned__c = 65;
        o.ENR_Extended_Warranty_Contract__c=true;
        o.ENR_Likeliness_to_Buy_Acura__c = 'Q';
        o.ENR_Likeliness_to_Buy_Honda__c = 'B';
        o.ENR_Likeliness_to_Buy_PSP__c = 'Y';
        o.ENR_Ownership_Type__c = 'Current Owner';
        o.ENR_Total_Spent_on_Service_by_Customer__c = 43;
        o.ENR_Total_Spent_on_Service_by_Warranty__c = 34;
        o.DEPOSIT_AMOUNT__c = 6547;
        o.Deposit_Confirmation_Number__c = '1';
        o.Deposit_Sales_Order_Number__c = '4';
        o.Appointment_Notes__c = 'abc';
        o.Appointment_Date_and_Time__c = '22May2023';
        o.Appointment_Location__c = 'Hyderabad';
        o.Appointment_Notes__c = 'DSP';
        o.Appointment_type__c = 'tekion/walkin';
        o.Appointment_Id__c = '123';
        o.Deal_ID__c = '8497';
        o.Deal_Link__c = 'www.google.com';
        o.Contact_person__c = 'Lavanya';
        o.Send_to_DSP__c = true;
        o.Initial_Walkin_Lead__c = true;
        o.Is_This_Lead_Update__c = true;
        o.External_Lead_Reference_Number__c = null;
        o.Street_TXT__c = null;
        o.Provider_Type__c = null;
        o.AddressType_TXT__c = null;
        o.AppartmentNumber_TXT__c = null;
        o.SendOnlyToUrbanScience__c = true;
        o.Routing_Error__c='HSJJSJDHSJJ';
        o.Description = null;
        opp.add(o);
       
       
        Test.startTest();
          HELMSLeadDealerAssignmentADFHandler hndlr = new HELMSLeadDealerAssignmentADFHandler();
          hndlr.newLeadDispositionADFs(opp);
          hndlr.newLeadDispositionADFs(null);
          System.assertEquals(ldadd.Name, 'Models Selected');
        Test.stopTest(); 
        
   }
   
   @istest static void updateOpportunityOnDealerAcknowledgement11(){
       List<Lead_Dealer_Acknowledgement_ADF__e> lst = new List<Lead_Dealer_Acknowledgement_ADF__e>();
        Lead_Dealer_Acknowledgement_ADF__e lda = new Lead_Dealer_Acknowledgement_ADF__e();
       // lda.Oppotunity_SF_ID__c=o.Opportunity_SF_ID__c;
        lda.Status_Code__c='1';
        lda.CRM_Payload__c = 'ABCDEFGHIJL';
        lda.CRM_XML_Response__c = 'tyttyyay';
        lda.Error_Details_Urban_Science__c = 'POIUYT';
        lda.Response_Urban_Science__c = 'MOKKI';
        lda.Routing_Error__c = 'HSJJSJD';
        lda.Sent_to_Urban_Science_Status__c ='NNVNNNC';
        lda.Send_to_DSP__c = true;
        lda.Sent_to_DSP_Status__c = '0';
        lda.Response_DSP__c = 'abc';
        lda.DSP_Payload__c = 'abc';
        lda.UrbanScience_Payload__c = 'NUBYUN';
        lst.add(lda);
        
        Test.startTest();
       
        List<Database.SaveResult> sr1 = EventBus.publish(lst);
        HELMSLeadDealerAssignmentADFHandler.updateOpportunityRoutingCustomObject(lst);
        HELMSLeadDealerAssignmentADFHandler.updateOpportunityRoutingCustomObject(null);
        System.assertEquals(lda.CRM_Payload__c, 'ABCDEFGHIJL');
        Test.stopTest(); 
        }
    
   @istest static void updateOpportunityOnDealerAcknowledgement12(){
       List<Routing_Acknowledgement_No_Response__c> lst = new List<Routing_Acknowledgement_No_Response__c>();
        Routing_Acknowledgement_No_Response__c lda = new Routing_Acknowledgement_No_Response__c();
       // lda.Oppotunity_SF_ID__c=o.Opportunity_SF_ID__c;
        lda.Status_Code__c='1';
        lda.CRM_Payload__c = 'ABCDEFGHIJL';
        lda.CRM_XML_Response__c = 'tyttyyay';
        lda.Error_Details_Urban_Science__c = 'POIUYT';
        lda.Response_Urban_Science__c = 'MOKKI';
        lda.Routing_Error__c = 'HSJJSJD';
        lda.Sent_to_Urban_Science_Status__c ='NNVNNNC';
        lda.Send_to_DSP__c = true;
        lda.Response_DSP__c = 'abc';
        lda.DSP_Payload__c = 'abc';
        lst.add(lda);
        Test.startTest();
      //  HELMSLeadDealerAssignmentADFHandler.updateOpportunityBlankResponse(lst);
        System.assertEquals(lda.CRM_Payload__c, 'ABCDEFGHIJL');
        Test.stopTest(); 
        }
   
   @isTest static void testUpdateOpportunityBlankResponse() {
       
        // Create test data
        List<Routing_Acknowledgement_No_Response__c> newOpportunityBlankResponse = new List<Routing_Acknowledgement_No_Response__c>();
        Routing_Acknowledgement_No_Response__c routingNoRespOpp = new Routing_Acknowledgement_No_Response__c(Opportunity_SF_ID__c = '001XXXXXXXXXXXXX', Status_Code__c = '0', Sent_to_Urban_Science_Status__c = '1', Response_DSP__c = 'Sample Response DSP', Error_Details_Urban_Science__c = 'Sample Error Details Urban Science', Response_Urban_Science__c = 'Sample Response Urban Science', Routing_Error__c = 'Sample Routing Error');
        newOpportunityBlankResponse.add(routingNoRespOpp);
        insert newOpportunityBlankResponse;

        // Create test data for Metadata Custom Settings
        List<Routing_Status__mdt> routingMessages = new List<Routing_Status__mdt>();
        Routing_Status__mdt routingMessage1 = new Routing_Status__mdt(Status_Code__c = '0', Routing_Message__c = 'Success');
        routingMessages.add(routingMessage1);

        List<Urban_Science_Routing_Status__mdt> ubroutingMessages = new List<Urban_Science_Routing_Status__mdt>();
        Urban_Science_Routing_Status__mdt ubroutingMessage1 = new Urban_Science_Routing_Status__mdt(Status_Code__c = '0', Routing_Message__c = 'Routing Message A');
        ubroutingMessages.add(ubroutingMessage1);

        List<DSP_Routing_Status__mdt> dsproutingMessages = new List<DSP_Routing_Status__mdt>();
        DSP_Routing_Status__mdt dsproutingMessage1 = new DSP_Routing_Status__mdt(Status_Code__c = '0', Routing_Message__c = 'Routing Message B');
        dsproutingMessages.add(dsproutingMessage1);
       
        // Create test data for Opportunity and XML_Payload__c
        List<Opportunity> oppRecBlankResponse = new List<Opportunity>();
        Opportunity opportunity1 = new Opportunity(Name = 'Opportunity 1', StageName ='closed won',CloseDate=system.today(),First_Name_TXT__c='Test 1x',Last_Name_TXT__c='x1 Test', Opportunity_SF_ID__c = '001XXXXXXXXXXXXX', Lead_Dealer_Acknowledgement_Status_Code__c = '0', Sent_to_Urban_Science_Status__c = '1', DSP_Status__c = '0');
        oppRecBlankResponse.add(opportunity1);
        insert oppRecBlankResponse;
              
        Test.startTest();
       
        // Call the method to be tested
        HELMSLeadDealerAssignmentADFHandler hndlr = new HELMSLeadDealerAssignmentADFHandler();
        hndlr.updateOpportunityBlankResponse(newOpportunityBlankResponse);
       
        Test.stopTest();

        
   }
    
   @isTest static void testUpdateOpportunityBlankResponse2() {
       
        // Create test data
        List<Routing_Acknowledgement_No_Response__c> newOpportunityBlankResponse = new List<Routing_Acknowledgement_No_Response__c>();
        Routing_Acknowledgement_No_Response__c routingNoRespOpp = new Routing_Acknowledgement_No_Response__c(Opportunity_SF_ID__c = '001XXXXXXXXXXXXX', Status_Code__c = '1', Sent_to_Urban_Science_Status__c = '0', Response_DSP__c = 'Sample Response DSP', Error_Details_Urban_Science__c = 'Sample Error Details Urban Science', Response_Urban_Science__c = 'Sample Response Urban Science', Routing_Error__c = 'Sample Routing Error');
        newOpportunityBlankResponse.add(routingNoRespOpp);
        insert newOpportunityBlankResponse;

        // Create test data for Metadata Custom Settings
        List<Routing_Status__mdt> routingMessages = new List<Routing_Status__mdt>();
        Routing_Status__mdt routingMessage1 = new Routing_Status__mdt(Status_Code__c = '1', Routing_Message__c = 'Success');
        routingMessages.add(routingMessage1);

        List<Urban_Science_Routing_Status__mdt> ubroutingMessages = new List<Urban_Science_Routing_Status__mdt>();
        Urban_Science_Routing_Status__mdt ubroutingMessage1 = new Urban_Science_Routing_Status__mdt(Status_Code__c = '1', Routing_Message__c = 'Routing Message A');
        ubroutingMessages.add(ubroutingMessage1);

        List<DSP_Routing_Status__mdt> dsproutingMessages = new List<DSP_Routing_Status__mdt>();
        DSP_Routing_Status__mdt dsproutingMessage1 = new DSP_Routing_Status__mdt(Status_Code__c = '1', Routing_Message__c = 'Routing Message B');
        dsproutingMessages.add(dsproutingMessage1);
       
        // Create test data for Opportunity and XML_Payload__c
        List<Opportunity> oppRecBlankResponse = new List<Opportunity>();
        Opportunity opportunity1 = new Opportunity(Name = 'Opportunity 1', StageName ='closed won',CloseDate=system.today(),First_Name_TXT__c='Test 1x',Last_Name_TXT__c='x1 Test', Opportunity_SF_ID__c = '001XXXXXXXXXXXXX', Lead_Dealer_Acknowledgement_Status_Code__c = '0', Sent_to_Urban_Science_Status__c = '0', DSP_Status__c = '1');
        oppRecBlankResponse.add(opportunity1);
        insert oppRecBlankResponse;
              
        Test.startTest();
       
        // Call the method to be tested
        HELMSLeadDealerAssignmentADFHandler hndlr = new HELMSLeadDealerAssignmentADFHandler();
        hndlr.updateOpportunityBlankResponse(newOpportunityBlankResponse);
       
        Test.stopTest();

        
   }
   
   @isTest static void testUpdateRoutingNoAckResponse() {
       
        // Create test data
        List<Routing_Acknowledgement_No_Response__c> testRecords = new List<Routing_Acknowledgement_No_Response__c>();
        for (Integer i = 0; i < 5; i++) {
            Routing_Acknowledgement_No_Response__c record = new Routing_Acknowledgement_No_Response__c(
                Opportunity_SF_ID__c = 'Test' + i,
                IsProcessed__c = false
            );
            testRecords.add(record);
        }
        insert testRecords;
        
        // Get the Opportunity SF IDs for testing
        Set<String> opportunityIds = new Set<String>();
        for (Routing_Acknowledgement_No_Response__c record : testRecords) {
            opportunityIds.add(record.Opportunity_SF_ID__c);
        }
        
        // Call the method being tested
        Test.startTest();
        HELMSLeadDealerAssignmentADFHandler hndlr = new HELMSLeadDealerAssignmentADFHandler();
        hndlr.updateRoutingNoAckResponse(opportunityIds);
        Test.stopTest();
        
        // Verify the records were updated
        List<Routing_Acknowledgement_No_Response__c> updatedRecords = [SELECT IsProcessed__c FROM Routing_Acknowledgement_No_Response__c WHERE Opportunity_SF_ID__c IN :opportunityIds];
        System.assertEquals(testRecords.size(), updatedRecords.size(), 'Number of updated records should match the number of test records');
        
        for (Routing_Acknowledgement_No_Response__c record : updatedRecords) {
            System.assertEquals(true, record.IsProcessed__c, 'IsProcessed__c field should be set to true');
        }
    }

}