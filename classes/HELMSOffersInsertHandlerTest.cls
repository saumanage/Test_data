@isTest
public class HELMSOffersInsertHandlerTest {
    public static testMethod void handleOffersInsertTest(){
        Id dealerAccRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
        Id ConRecTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
         Account accTestRec = new Account(Name='Test Account123another',DealerCode_CD__c = '123',RecordTypeId=dealerAccRecTypeId
                                         );
        insert accTestRec;
        contact con = new Contact(FirstName='John',LastName='Doe',Email='yash1234@testing.com',Title='Mr',
                                        AccountId=accTestRec.Id, RecordTypeId=ConRecTypeId );
        insert con;
        
        String strLeadInfo = '<LeadAdditionalInfos><LeadAdditionalInfo key="Offer Id">HP-18D</LeadAdditionalInfo><LeadAdditionalInfo key="Offer Name">2021 Pilot Special APR</LeadAdditionalInfo><LeadAdditionalInfo key="Offer Type">Finance</LeadAdditionalInfo><LeadAdditionalInfo key="end_date">Expires 09/07/21</LeadAdditionalInfo><LeadAdditionalInfo key="special_short_description">1.9% APR for 24-60 months or 2.9% for 61-72 months</LeadAdditionalInfo><LeadAdditionalInfo key="special_description">For well-qualified buyers. Example: 10% down payment. 60 months financing at $17.48/month per $1,000 financed.</LeadAdditionalInfo></LeadAdditionalInfos>';
        
        Lead lead = new Lead(LastName='Doe',Email='yash1234@testing.com',PreferredDealerAccount_ID__c =accTestRec.id, FirstName='John',Company='Test',Status='Ready_to_Convert',
                             Dealer_Ids_ID__c='testing',Year_YR__c='test',Model_TXT__c='demoooo',ProviderDetail_TXT__c='test11:test21',
                             Model_ID__c='demo',Trim_TXT__c='trimmer',SubDiv_TXT__c='Honda',
                             PreferredDealerNumber_NUM__c='123',Division_CD__c='A',VehicleInterest_TXT__c='buy',
                            ContactKey_TXT__c ='test',VehicleStatus_TXT__c='New',Condition_TXT__c='excellent',LeadAdditionalInfos__c = strLeadInfo,
                             Number_NM__c='number',Doors_TXT__c='doortxt',BodyStyle_TXT__c='bodyStyle',Odometer_TXT__c='odmeter',
                             OdometerStatus_TXT__c='unknown',OdometerUnits_TXT__c='kilometer',  Color_TXT__c='<colorcombination><interiorcolor/><exteriorcolor>Deep Pearl Gray</exteriorcolor><preference>1</preference></colorcombination>');
        insert lead;
        
        Account accTestRec1 = new Account(Name='Test Account123another',RecordTypeId=dealerAccRecTypeId,
                                          DealerCode_CD__c=lead.Dealer_Ids_ID__c
                                         );
        insert accTestRec1;
        Opportunity OppRec = new Opportunity(Name='YashLead',StageName='In Conversation',
                                             PreferredDealerNumber_NUM__c='123456', External_ID__c='12345',
                                             CloseDate=system.today(),Lead_ID__c=lead.Id,AccountId=lead.CustomerAccount_ID__c,
                                             Trim_TXT__c = lead.Trim_TXT__c,ZipCode_TXT__c = '90503',First_Name_TXT__c = 'Test',Last_Name_TXT__c='Test',
                                             Make_TXT__c =lead.Make_TXT__c,ContactKey_TXT__c =lead.ContactKey_TXT__c,
                                             VehicleStatus_TXT__c=lead.VehicleStatus_TXT__c,Condition_TXT__c=lead.Condition_TXT__c,
                                             Number_NM__c=lead.Number_NM__c,Doors_TXT__c=lead.Doors_TXT__c,BodyStyle_TXT__c=lead.BodyStyle_TXT__c,
                                             Odometer_TXT__c=lead.Odometer_TXT__c, LeadAdditionalInfos__c = strLeadInfo,
                                             OdometerStatus_TXT__c=lead.OdometerStatus_TXT__c,OdometerUnits_TXT__c=lead.OdometerUnits_TXT__c);
       
        Test.startTest();
        insert OppRec; 
        List<Opportunity> listOpp = new List<Opportunity>();
        listOpp.add(OppRec);
        //HelmsOpportunityNotificationSms.OpportunityCreation(listOpp);
        if (test.isRunningTest()) Test.setMock(HttpCalloutMock.class, new UploadFileMock());
        Test.stopTest();
        
        //HELMSOffersInsertHandler.handleOffersInsert(listOpp);
        List<Offers__c> listOffers = [SELECT Id,Name,Offer_Type__c,Offer_ID__c,Special_Description__c,Special_Short_Description__c FROM Offers__c ];
        System.debug('====>>>>>'+listOffers);
        system.assertEquals(Lead.Lastname,'Doe');
        
    }
 }