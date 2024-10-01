/**
 * HELMSLeadEnrichmentTest class tests the functionality of HELMSLeadEnrichment class.
 * @author Lee
 * @version 1.0
 * @since 2024-03-14
 */
@isTest
class HELMSLeadEnrichmentTest {
    @testSetup static void setup() {
        List<Account> accounts = new List<Account>();
        Map<String, Id> recordTypes = HELMSUtility.AccountRecordTypes;
        Account dealer = new Account(Name = 'Test Dealer', RecordTypeId = recordTypes.get('Dealer'), DealerCode_CD__c = '205666');
        Account provider = new Account(Name ='Test Provider', RecordTypeId = recordTypes.get('Provider'));
        accounts.add(dealer);
        accounts.add(provider);
        insert accounts;

        List<Lead> leads = new List<Lead>();        
        Lead lead = new Lead(LastName='Test',FirstName='John',Lead_Group_ID__c = '123',Company='Test',Status='New',StatusReason_TXT__c='',
                             Dealer_Ids_ID__c='testing',Year_YR__c='test',Model_TXT__c='demoooo',phone='7894563212',PostalCode='50081',
                             Model_ID__c='demo',Trim_TXT__c='trimmer',SubDiv_TXT__c='Honda', PreferredDealerAccount_ID__c=dealer.id , ProviderDetail_TXT__c='abe:xyz:',LeadProvider_ID__c = provider.id,
                             PreferredDealerNumber_NUM__c='301514',Division_CD__c='A',VehicleInterest_TXT__c='buy',
                            ContactKey_TXT__c ='test',VehicleStatus_TXT__c='New',Condition_TXT__c='excellent',
                             Number_NM__c='number',Doors_TXT__c='doortxt',BodyStyle_TXT__c='bodyStyle',Odometer_TXT__c='odmeter',
                             Color_TXT__c='<colorcombination><interiorcolor>Gray</interiorcolor><exteriorcolor>Basque Red</exteriorcolor><preference>1</preference></colorcombination>',
                             OdometerStatus_TXT__c='unknown',OdometerUnits_TXT__c='kilometer');
        leads.add(lead);
        insert leads;                            
    }
    @isTest static void testExecute() {
        List<Lead> leads = [SELECT Id, Name, FirstName, LastName, ContactKey_TXT__c, PostalCode FROM Lead WHERE Status = 'New' and CreatedDate = TODAY and Enrichment_Receive_Date_Time__c = null];

        HELMSLeadEnrichment instance = new HELMSLeadEnrichment();
        Test.startTest();
        instance.execute(null);
        Test.stopTest();
        
        System.assertEquals(1, [SELECT count() FROM AsyncApexJob WHERE JobType = 'BatchApex']);
        
    }
}