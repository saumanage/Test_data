@isTest
public class HELMSLeadStatusToUrbanScienceTest {
    public static testMethod void handleOffersInsertTest(){
        Id dealerAccRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
        Id conRecTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
        Account accTestRec = new Account(Name='Test Account123another',DealerCode_CD__c = '123',RecordTypeId=dealerAccRecTypeId
                                         );
        insert accTestRec;
        contact con = new Contact(FirstName='John',LastName='Doe',Email='yash1234@testing.com',Title='Mr',
                                        AccountId=accTestRec.Id, RecordTypeId=conRecTypeId );
        insert con; 
        
        String strLeadInfo = '<LeadAdditionalInfos><LeadAdditionalInfo key="Offer Id">HP-18D</LeadAdditionalInfo><LeadAdditionalInfo key="Offer Name">2021 Pilot Special APR</LeadAdditionalInfo><LeadAdditionalInfo key="Offer Type">Finance</LeadAdditionalInfo><LeadAdditionalInfo key="end_date">Expires 09/07/21</LeadAdditionalInfo><LeadAdditionalInfo key="special_short_description">1.9% APR for 24-60 months or 2.9% for 61-72 months</LeadAdditionalInfo><LeadAdditionalInfo key="special_description">For well-qualified buyers. Example: 10% down payment. 60 months financing at $17.48/month per $1,000 financed.</LeadAdditionalInfo></LeadAdditionalInfos>';
        
        Lead lead = new Lead(LastName='Doe',Email='yash1234@testing.com',PreferredDealerAccount_ID__c =accTestRec.id, FirstName='John',Company='Test',Status='Ready_to_Convert',
                             Dealer_Ids_ID__c='testing',Year_YR__c='test',Model_TXT__c='demoooo',ProviderDetail_TXT__c='test11:test21',
                             Model_ID__c='demo',Trim_TXT__c='trimmer',SubDiv_TXT__c='Honda',
                             PreferredDealerNumber_NUM__c='123',Division_CD__c='A',VehicleInterest_TXT__c='buy',StatusReason_TXT__c = 'Third Party Duplicate',  External_Lead_Reference_Number__c = '123',
                            ContactKey_TXT__c ='test',VehicleStatus_TXT__c='New',Condition_TXT__c='excellent',LeadAdditionalInfos__c = strLeadInfo,
                             Number_NM__c='number',Doors_TXT__c='doortxt',BodyStyle_TXT__c='bodyStyle',Odometer_TXT__c='odmeter',
                             OdometerStatus_TXT__c='unknown',OdometerUnits_TXT__c='kilometer',Is_Third_Party_Duplicate_Lead__c=true,  Color_TXT__c='<colorcombination><interiorcolor/><exteriorcolor>Deep Pearl Gray</exteriorcolor><preference>1</preference></colorcombination>');
        insert lead;
        
        lead.Error_Details_Urban_Science__c = 'Test Duplicate';
        Test.startTest();
        update lead;
        Test.stopTest();
        System.assertEquals( 1, HELMSLeadStatusToUrbanScience.listUrbanEvents.size());
    }  
}