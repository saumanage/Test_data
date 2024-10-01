/****************************************************************************** 
File Name:      HELMSLeadConvertToOppHandler   
Created On:     19th May, 2021
Created By:     Bandi Sujatha, Appirio
Test Classes:   HELMSLeadConvertToOppHandlerTest        
HELMS Jira Story: 
===============================================================================
Modification Log:14th April 2023 by Bruno Costa
*******************************************************************************
*/

@isTest
public class HELMSLeadConvertToOppHandlerTest {
    public static testMethod void handleLeadToOppInsertTest() {
        List<Lead> leadList = new List<Lead>();    
        Id dealerAccRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
        Id conRecTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
         Account accTestRec = new Account(Name='Test Account123another',DealerCode_CD__c = '123',RecordTypeId=dealerAccRecTypeId
                                         );
        insert accTestRec;
        contact con = new Contact(FirstName='John',LastName='Doe',Email='yash1234@testing.com',Title='Mr',
                                        AccountId=accTestRec.Id, RecordTypeId=conRecTypeId );
        insert con;
        Id personAccRecType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        Account personAccTest = new Account(FirstName='Test Person Account',LastName='person',RecordTypeId=personAccRecType);
        Insert personAccTest;
        Account pro = new Account(name ='abc' ,Send_Customer_Acknowledgement_Email_Flag__c =true,  recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider').getRecordTypeId()) ;
        insert pro; 
        Test.setMock(HttpCalloutMock.class, new LeadEnrichMockTest()); 
        Lead lead = new Lead(LastName='Doe',Email='yash1234@testing.com',CustomerAccount_ID__c=personAccTest.id,PreferredDealerAccount_ID__c =accTestRec.id, FirstName='John',Company='Test',Status='Ready_to_Convert',
                             Dealer_Ids_ID__c='testing',Year_YR__c='test',Model_TXT__c='demoooo',ProviderDetail_TXT__c='test11:test21',
                             Model_ID__c='demo',Trim_TXT__c='trimmer',SubDiv_TXT__c='Marine',PostalCode='12345',
                             PreferredDealerNumber_NUM__c='123',Division_CD__c='P',VehicleInterest_TXT__c='buy',
                            ContactKey_TXT__c ='test',VehicleStatus_TXT__c='New',Condition_TXT__c='excellent',
                             Number_NM__c='number',Doors_TXT__c='doortxt',BodyStyle_TXT__c='bodyStyle',Odometer_TXT__c='odmeter',
                             LeadProvider_ID__c = pro.Id,Send_confirmation_Email__c=true,
                             OdometerStatus_TXT__c='unknown',OdometerUnits_TXT__c='kilometer',  Color_TXT__c='<colorcombination><interiorcolor/><exteriorcolor>Deep Pearl Gray</exteriorcolor><preference>1</preference></colorcombination>');
        leadList.add(lead);
         Lead lead1 = new Lead(LastName='Doe',CustomerAccount_ID__c=personAccTest.id,PreferredDealerAccount_ID__c =accTestRec.id, FirstName='John',Company='Test',Status='Ready_to_Convert',
                             Dealer_Ids_ID__c='testing',Year_YR__c='test',Model_TXT__c='demoooo',ProviderDetail_TXT__c='test11',
                             Model_ID__c='demo',Trim_TXT__c='trimmer',SubDiv_TXT__c='Acura',PostalCode='12345',
                             PreferredDealerNumber_NUM__c='123',Division_CD__c='B',VehicleInterest_TXT__c='buy', LeadProvider_ID__c = pro.Id,Send_confirmation_Email__c=true,
                            ContactKey_TXT__c ='test',VehicleStatus_TXT__c='New',Condition_TXT__c='excellent',
                             Number_NM__c='number',Doors_TXT__c='doortxt',BodyStyle_TXT__c='bodyStyle',Odometer_TXT__c='odmeter',
                             OdometerStatus_TXT__c='unknown',OdometerUnits_TXT__c='kilometer',  Color_TXT__c='<colorcombination><interiorcolor/><exteriorcolor>Deep Pearl Gray</exteriorcolor><preference>1</preference></colorcombination>');
        leadList.add(lead1);
        
       Lead lead2 = new Lead(LastName='Doe',CustomerAccount_ID__c=personAccTest.id,PreferredDealerAccount_ID__c =accTestRec.id, FirstName='John',Company='Test',Status='Ready_to_Convert',
                             Dealer_Ids_ID__c='testing',Year_YR__c='test',Model_TXT__c='demoooo',ProviderDetail_TXT__c='test11',
                             Model_ID__c='demo',Trim_TXT__c='trimmer',SubDiv_TXT__c='Motorcycle',PostalCode='12345',
                             PreferredDealerNumber_NUM__c='123',Division_CD__c='M',VehicleInterest_TXT__c='buy', LeadProvider_ID__c = pro.Id,Send_confirmation_Email__c=true,
                            ContactKey_TXT__c ='test',VehicleStatus_TXT__c='New',Condition_TXT__c='excellent',
                             Number_NM__c='number',Doors_TXT__c='doortxt',BodyStyle_TXT__c='bodyStyle',Odometer_TXT__c='odmeter',
                             OdometerStatus_TXT__c='unknown',OdometerUnits_TXT__c='kilometer',  Color_TXT__c='<colorcombination><interiorcolor/><exteriorcolor>Deep Pearl Gray</exteriorcolor><preference>1</preference></colorcombination>');
        leadList.add(lead2);
        
        insert leadList;
        
        Lead newld = leadList[0];
        newld.ProviderDetail_TXT__c = 'test11:test22';
        update newld;
        
        
     
        Account accTestRec1 = new Account(Name='Test Account123another',RecordTypeId=dealerAccRecTypeId,
                                          DealerCode_CD__c=leadList[0].Dealer_Ids_ID__c
                                         );
        insert accTestRec1;
        
          Lead_Expiration__c le = new Lead_Expiration__c();
        le.A__c = 90;
        le.B__c = 90;
        le.M__c = 90;
        le.P__c = -1;
        insert le;
        
         List<opportunity> opp1 = new list<opportunity>();
  //       String Str = leadList[0].Model_TXT__c;
       // for(i=0;i<=3;i++){
        Opportunity oppRec = new Opportunity(Name='YashLead',StageName='In Conversation',
                                             PreferredDealerNumber_NUM__c='123456', External_ID__c='12345',ZipCode_TXT__c = '12345',
                                             CloseDate=system.today(),Lead_ID__c=leadList[0].Id,AccountId=accTestRec.id,
                                             Trim_TXT__c = leadList[0].Trim_TXT__c,
                                             Make_TXT__c =leadList[0].Make_TXT__c,ContactKey_TXT__c =leadList[0].ContactKey_TXT__c,
                                             VehicleStatus_TXT__c=leadList[0].VehicleStatus_TXT__c,Condition_TXT__c=leadList[0].Condition_TXT__c,
                                             Number_NM__c=leadList[0].Number_NM__c,Doors_TXT__c=leadList[0].Doors_TXT__c,BodyStyle_TXT__c=leadList[0].BodyStyle_TXT__c,
                                             Odometer_TXT__c=leadList[0].Odometer_TXT__c,
                                             OdometerStatus_TXT__c=leadList[0].OdometerStatus_TXT__c,OdometerUnits_TXT__c=leadList[0].OdometerUnits_TXT__c);
        //insert OppRec; 
            opp1.add(oppRec);
    //        System.debug('OppRec1'+oppRec);
       // }
              //  Database.SaveResult[] results = Database.insert(Opp1, false);
               //System.assert(results.isSuccess());
        HELMSLeadConvertToOppHandler.flag =false;
        list<string> ldIds = new list<string>();
        for(Lead ld:leadList) {
            ldIds.add(ld.id);
        }
        
        /*DSP Code test - start - BrunoC- DS-1182*/
        List<Lead> insertedLeads = [SELECT Id FROM Lead WHERE Id IN :leadList];
		System.assertEquals(3, insertedLeads.size(), 'Expected 3 leads to be inserted, but found ' + insertedLeads.size());
        /*DSP Code test - end - BrunoC- DS-1182*/

        HELMSLeadConvertToOppHandler.handleLeadToOppInsert(leadList);
        
        //HELMSLeadConvertToOppHandler.AutoleadConvert(opp1,ldIds);
    }
    static testMethod void TestAutoleadConvert() { 
        SFMCResponse sfm = new SFMCResponse();
        SFMCResponse.responses sfres = new SFMCResponse.responses();
        sfres.hasErrors = false;
        sfres.recipientSendId = 'test';
        sfres.messages = new list<string> {'test'};
        sfm.requestId = 'testId';
        sfm.responses = new list<SFMCResponse.responses> {sfres};
        HelmsCheckRecursive.runOnce();
        Account accTestRec1 = new Account(Name='Test Account123another');
        insert accTestRec1;
        Test.setMock(HttpCalloutMock.class, new LeadEnrichMockTest());
        Lead objLead = new Lead( FirstName = 'Test', LastName = 'Sample', Company = 'Testing Sample Co',Make_TXT__c='vhn',  Color_TXT__c='<colorcombination><interiorcolor/><exteriorcolor>Deep Pearl Gray</exteriorcolor><preference>1</preference></colorcombination>');  
        insert objLead;
        Account pro = new Account(name ='abc' ,  recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider').getRecordTypeId()) ;
        insert pro; 
        
        List<opportunity> opp = new list<opportunity>();
        Opportunity oppr = new Opportunity(Name='YashLead123',StageName='In Conversation',
                                             PreferredDealerNumber_NUM__c='123456', External_ID__c='12345',
                                             ZipCode_TXT__c = '12345',Email__c='testopp@test.com',
                                             PreferredDealerAccount_TXT__c = accTestRec1.Id,First_Name_TXT__c='Test opp19', Last_Name_TXT__c ='Test opp LAst9', LeadProvider_ID__c=pro.id,
                                             CloseDate=system.today(),Lead_ID__c=objLead.Id,Make_TXT__c =objLead.Make_TXT__c);
        opp.add(oppr);              
        insert opp;
        
        
        
        HELMSLeadConvertToOppHandler.AutoleadConvert(opp);
        
       
        
        
    }  
    static testMethod void TestAutoleadUpdate(){
        List<Lead> leadList1 = new List<Lead>();                  
        Lead lead = new Lead(LastName='Doe',FirstName='John',Company='Test',Status='Ready_to_Convert',
                             Model_TXT__c='demoooo',
                             Model_ID__c='demo',Trim_TXT__c='trimmer',
                             PreferredDealerNumber_NUM__c='test',VehicleInterest_TXT__c='buy',
                             ContactKey_TXT__c ='test',VehicleStatus_TXT__c='New',Condition_TXT__c='excellent',
                             Number_NM__c='number',Doors_TXT__c='doortxt',BodyStyle_TXT__c='bodyStyle',Odometer_TXT__c='odmeter',
                             OdometerStatus_TXT__c='unknown',OdometerUnits_TXT__c='kilometer',  Color_TXT__c='<colorcombination><interiorcolor/><exteriorcolor>Deep Pearl Gray</exteriorcolor><preference>1</preference></colorcombination>');
        leadList1.add(lead);
        Test.setMock(HttpCalloutMock.class, new LeadEnrichMockTest());
        insert leadList1;   
        HELMSLeadConvertToOppHandler.handleLeadToOppInsert(leadList1);
        HELMSLeadTriggerHandlerUpdated.handleLeadInsert(leadList1);
        HELMSLeadTriggerHandlerUpdated.handleLeadInsert(null);
        HELMSLeadTriggerHandlerUpdated.getColorCombination('colour');
        HELMSLeadTriggerHandlerUpdated.getColorCombination(null);
        HELMSLeadTriggerHandlerUpdated.handleLeadUpdate(null,null);
    }
}