@isTest
public class HELMSLeadEnrichmentResponsePEHandlerTest {
    @isTest static void leadenrichment()
    {
        Id personAccRecType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        //Id dealerAccRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Provider').getRecordTypeId();
        Account personAccTest = new Account(FirstName='Test Person Account',LastName='person',RecordTypeId=personAccRecType);
        Insert personAccTest;
        Account ac1 = new Account(name ='Graz33itti' ,DealerCode_CD__c='301515', recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Dealer').getRecordTypeId()) ;
        insert ac1; 
        Account ac2 = new Account(name ='abc' ,  recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider').getRecordTypeId()) ;
        insert ac2;
        Lead ldRec1 = new Lead(FirstName='Test First',LastName='LastName',ValidEmail_FLG__c=true,
                              ValidPhoneNum_FLG__c=true,ValidAddress_FLG__c=true,ValidMobile_FLG__c=true,
                              CustomerAccount_ID__c=personAccTest.Id,Division_CD__c='A',PostalCode='12341',
                              SubDiv_TXT__c='Honda',PreferredDealerAccount_ID__c=ac1.id,LeadProvider_ID__c=ac2.id,
                              Triggertypecode__c='Instant');
        insert ldRec1;
        List<Lead> leadList = new List<Lead>();
        leadList.add(ldRec1);
        Lead_Enrichment_Response__e leadcreation=new Lead_Enrichment_Response__e(AcuraCurrentProductsOwned_TXT__c='1234',
                                                                    AcuraCurrentProductsOwned2_TXT__c='1234',
                                                                    AcuraHighValueTrimlinePropensity_NUM__c=1234,
                                                                    AcuraOwnershipStatus_TXT__c='1234',
                                                                    AcuraOwnershipStatusHousehold_TXT__c='Honda',
                                                                    Address_Error_CD__c='1234',
                                                                    Address_Error_Description_TXT__c='1234',
                                                                    Address_Status_TXT__c ='A',
                                                                    Cell_Phone_Error_CD__c ='345r6', 
                                                                    Cell_Phone_Error_Description_TXT__c='2345678',
                                                                    CleansedAddress_TXT__c='test',
                                                                    DateofLastService_DT__c = System.today(),
                                                                    Email_CheckedDate_TXT__c ='test',
                                                                    Email_Error_CD__c='test',
                                                                    Email_Error_Description_TXT__c ='test',
                                                                    Home_Phone_Error_CD__c='test',
                                                                    Home_Phone_Error_Description_TXT__c='test',
                                                                    HondaCurrentProductsOwned_TXT__c='test',
                                                                    HondaCurrentProductsOwned2_TXT__c='test',
                                                                    HondaHighValueTrimlinePropensity_NUM__c=1234,
                                                                    HondaOwnershipStatus_TXT__c='test',
                                                                    HondaOwnershipStatusHousehold_TXT__c='test',
                                                                    Lead_SF_ID__c=ldRec1.Lead_SF_ID__c,
                                                                    Location_Description_TXT__c ='FinancialDetails',
                                                                    Location_Error_CD__c ='FN',
                                                                    Location_Error_Description_TXT__c = 'LN',
                                                                    Location_Status_TXT__c = 'MN',
                                                                    Model_Error_CD__c = 's',
                                                                    Model_Error_Description_TXT__c = 'abcd',
                                                                    Model_IMG__c = 'bedc',
                                                                    Model_Name_NM__c = 'cdef',
                                                                    PECurrentProductsOwned_TXT__c = '522201',
                                                                    PEOwnershipStatus_TXT__c = 'abcd@gmail.com',
                                                                    PEOwnershipStatusHousehold_TXT__c = '8679876',
                                                                    PreferredDealerNumber_NUM__c = '123456',
                                                                    PSPCurrentProductsOwned_TXT__c = 'abcdef',
                                                                    PSPCurrentProductsOwned2_TXT__c = '12345',
                                                                    PSPOwnershipStatus_TXT__c ='abcde',
                                                                    PSPOwnershipStatusHousehold_TXT__c = '12345',
                                                                    SalesRelatedDealerNumber__c = 'abcd',
                                                                    ServiceRelatedDealerNumber__c = 'standard',
                                                               //     SFMC_description_TXT__c = 'abcd',
                                                               //     SFMC_errorcode_TXT__c = 'abcd',
                                                               //     SFMC_errordescription_TXT__c = 'abcd',
                                                               //     SFMC_status_TXT__c = 'abcd',
                                                                    
                                                                 //   SFMC_Sales_status__c = 'abcd',
                                                                    SFMC_Sales_status__c = 'abcd',
                                                                    SFMC_Sales_description__c = 'abcd',
                                                                    SFMC_Sales_errorcode__c = 'abcd',
                                                                    SFMC_Sales_errordescription__c = 'abcd',
                                                                    SFMC_Service_status__c = 'abcd',
                                                                    SFMC_Service_description__c = 'abcd',
                                                                    SFMC_Service_errordescription__c = 'abcd',
                                                                    SFMC_Service_errorcode__c = 'abcd',             
                                                                    ValidAddress_FLG__c = true,
                                                                    ValidCellPhone_FLG__c = true,
                                                                    ValidEmail_FLG__c = true,
                                                                    Valid_Model_ID_FLG__c = true,
                                                                    ValidPhoneNum_FLG__c = true,
                                                                    YourDealershipServicesLast60Mths_NUM__c = 0,
                                                                    YourDealershipSvsSpentLast60Mth_NUM__c = 0
                     );
        Test.startTest();
        EventBus.publish(leadcreation);
        HELMSLeadEnrichmentResponsePEHandler.updateCustomObject(leadList);
        System.assertEquals(ldRec1.LastName, 'LastName');
        Test.stopTest();    
    }
}