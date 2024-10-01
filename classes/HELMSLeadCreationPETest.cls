/****************************************************************************** 
File Name:      HELMSLeadCreationPEHandler   
Test Classes:   HELMSLeadCreationPETest        
===============================================================================
Modification Log:14th April 2023 by Bruno Costa
*******************************************************************************
*/
@isTest
public class HELMSLeadCreationPETest{
    @isTest static void lCPETest()
    {
        Test.startTest();
        List<Lead_Creation_ADF__e> lCPETest = new List<Lead_Creation_ADF__e>();
         Lead_Creation_ADF__e leadcreation=new Lead_Creation_ADF__e(Prospect_IDs__c ='122ee');
         EventBus.publish(leadcreation);
        Test.stopTest(); 
    }
     @isTest static void lCPE()
    {
          Account ac1 = new Account(name ='abc' , recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider').getRecordTypeId()) ;
        insert ac1;
         Account ac2 = new Account(name ='abc' ,DealerCode_CD__c= '10509', ShippingLatitude=39.850583,ShippingLongitude=-74.90814, recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Dealer').getRecordTypeId()) ;
        insert ac2;
        
        List<Lead_Creation_ADF__e> lCPETest = new List<Lead_Creation_ADF__e>();
         Lead_Creation_ADF__e leadcreation=new Lead_Creation_ADF__e(Vehicle_Interest_TXT__c='1234',
                                                                    Dealer_IDs__c='1234',
                                                                    Customer_IDs__c='1234',
                                                                    Vehicle_IDs__c='1234',
                                                                    BusinessUnitSubDivision_CD__c='Honda',
                                                                    Provider_IDs__c='1234',
                                                                    /*DSP Code test - start - BrunoC- DS-1182*/
                                                                    Source_Unique_ID__c='386774',
                                                                    Appointment_Date_and_Time__c='15 pm 4/17/2023',
        															Appointment_Location__c='test dublin',
  															        Appointment_Notes__c='test',
            														Appointment_type__c='test',
        															Deposit_Amount__c=827394.00,
        															Contact_person__c='TEST BRUNO',
        															Salesforce_Order_Number__c='647847',
        															Deal_ID__c='1234567899',
        															Deal_Link__c='deal link',
                                                                    Vendor_Contact_Name__c='test name',
                                                                    Vendor_Contact_Email__c='test@gmail.com',
                                                                    Appointment_Id__c='000000001',
																	/*DSP Code test - end - BrunoC- DS-1182*/
                                                                    Business_Unit_Code_CD__c='1234',
                                                                    Vehicle_Status_TX__c ='A',
                                                                    Odometer_Status_TXT__c ='345r6', 
                                                                    Odometer_TXT__c='2345678',
                                                                    Make_TXT__c='test',
                                                                    Model_TXT__c ='test',
                                                                    Model_Trim_TXT__c ='test',
                                                                    Year_YR__c=1244,
                                                                    Condition_TXT__c ='test',
                                                                    Vin_Number_NUM__c='test',
                                                                    Doors_TXT__c='test',
                                                                    Body_Style_TXT__c='test',
                                                                    Odometer_Units_TXT__c='test',
                                                                    Transmission_TXT__c='test',
                                                                    Stock_Number_NUM__c='test',
                                                                    Options_TXT__c='test',
                                                                    Color_TXT__c='test',
                                                                    Financial_Details_TXT__c ='FinancialDetails',
                                                                    FirstName_NM__c ='FN',
                                                                   LastName_NM__c = 'LN',
                                                                    MiddleName_NM__c = 'MN',
                                                                    Suffix_INIT__c = 's',
                                                                    City_TXT__c = 'abcd',
                                                                    State_TXT__c = 'bedc',
                                                                    Country_TXT__c = 'cdef',
                                                                    ZipCode_TXT__c = '522201',
                                                                    Email_TXT__c = 'abcd@gmail.com',
                                                                    Phone_TXT__c = '8679876',
                                                                    Mobile_TXT__c = '123456',
                                                                    Fax_TXT__c = 'abcdef',
                                                                    Pager_TXT__c = '12345',
                                                                    ContactMethod_TXT__c ='abcde',
                                                                    Contact_Time_TM__c = '12345',
                                                                    Contact_type_TXT__c = 'abcd',
                                                                    AddressType_TXT__c = 'standard',
                                                                    AddressLine1_TXT__c = 'abcd',
                                                                    AddressLine2_TXT__c = 'abcd',
                                                                    AddressLine3_TXT__c = 'abcd',
                                                                    AddressLine4_TXT__c = 'abcd',
                                                                    AddressLine5_TXT__c = 'abcde',
                                                                    ApartmentNumber_NUM__c = '201',
                                                                    PurchaseHorizon_TXT__c = 'accd',
                                                                    PurchaseEarliestDate_DT__c = '22/02/2021',
                                                                    PurchaseLatestDate_DT__c = '18022021',
                                                                    OtherContacts_TXT__c = 'lavanya',
                                                                    OtherLeadProvider_TXT__c = 'abbb',
                                                                    Description_DESC__c = 'aaa',
                                                                    DealerAccountfromADF_TXT__c = 'aaa',
                                                                    DealerContactfromADF_TXT__c = 'aaa',
                                                                    ProviderContactDetails_TXT__c = 'aaa',
                                                                    Quote_AMT__c='23,000',
                                                                    MSRP_AMT__c ='23,000',
                                                                    ProviderDetails_TXT__c='abc:xyz',
                                                                    TradeBalanceOwed_TXT__c= 'aaa',
                                                                    TradeMake_TXT__c= 'aaa',
                                                                    TradeMileage_TXT__c= 'aaa',
                                                                    TradeModel_TXT__c= 'aaa',
                                                                    TradeValue_TXT__c= 'aaa',
                                                                    Source_Name__c = 'Facebook',
                                                                    Source_User__c = 'aaa',
                                                                    MiddlewareUUID__c = 'aaa',
                                                                    Tigger_Send_By_Date__c = '18022021',
                                                                    Transaction_Code__c = 'aaa',
                                                                    Trigger_type_Code__c = 'Instant', 
                                                                    Lead_Provider_Name__c = 'acura',
                                                                    Provider_Type__c = 'Customer Originated lead',
                                                                    Provider_Service__c = 'Honda', 
                                                                    Model_Name_NM__c = 'acura', 
                                                                   External_Lead_Reference_Number__c= '12345678');
        
       	Test.startTest();
        
        EventBus.publish(leadcreation);
       
        Test.stopTest(); 
        
        
        /*DSP Code test - start - BrunoC- DS-1182*/
        List<Lead> test12 = [SELECT Id,Source_Unique_ID__c,Appointment_Date_and_Time__c,Appointment_Location__c,Appointment_Notes__c,Appointment_type__c FROM Lead];
        System.debug('===111=='+test12);

        /*DSP Code test - end - BrunoC- DS-1182*/
        
        
        
        
    }
}