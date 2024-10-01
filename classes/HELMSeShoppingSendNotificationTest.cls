@isTest
public class HELMSeShoppingSendNotificationTest {
    @isTest
    static void method1(){
        
        Id dealerAccRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Provider').getRecordTypeId();
        Id conRecTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Provider').getRecordTypeId();
        Account accTestRec = new Account(Name='Test Account123another',DealerCode_CD__c = '123',RecordTypeId=dealerAccRecTypeId,
                                         Send_Customer_Acknowledgement_Email_Flag__c=true
                                        );
        insert accTestRec;
         Id dealerAccRecTypeId1 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
      
        Account accTestRec1 = new Account(Name='Test Account123another1',DealerCode_CD__c = '1231',RecordTypeId=dealerAccRecTypeId1,
                                         Send_Customer_Acknowledgement_Email_Flag__c=true
                                        );
        insert accTestRec1;
        
        contact con = new Contact(FirstName='John',LastName='Doe',Email='yash1234@testing.com',Title='Mr',
                                  AccountId=accTestRec.Id, RecordTypeId=conRecTypeId );
        insert con;
        
         Opportunity oppRec = new Opportunity(Name='YashLead',
                                             StageName='In Conversation',
                                             PreferredDealerNumber_NUM__c='123456', External_ID__c='12345',
                                             CloseDate=system.today(),
                                            // Lead_ID__c=lead1.Id,
                                             AccountId=accTestRec.Id,
                                             First_Name_TXT__c='qqq1',Last_Name_TXT__c='aqa1'
                                             //   Trim_TXT__c = lead.Trim_TXT__c,ZipCode_TXT__c = '90503',First_Name_TXT__c = 'Test',Last_Name_TXT__c='Test',
                                             //   Make_TXT__c =lead.Make_TXT__c,ContactKey_TXT__c =lead.ContactKey_TXT__c,
                                             //     VehicleStatus_TXT__c=lead.VehicleStatus_TXT__c,Condition_TXT__c=lead.Condition_TXT__c,
                                             //     Number_NM__c=lead.Number_NM__c,Doors_TXT__c=lead.Doors_TXT__c,BodyStyle_TXT__c=lead.BodyStyle_TXT__c,
                                             //     Odometer_TXT__c=lead.Odometer_TXT__c,
                                             //    OdometerStatus_TXT__c=lead.OdometerStatus_TXT__c,
                                             //    OdometerUnits_TXT__c=lead.OdometerUnits_TXT__c
                                            );
        
        
        insert oppRec; 
        
        
        List<Lead> leadList = new List<Lead>(); 
       // set<id> leadListIds=new set<id>();
        Lead lead1 = new Lead(LastName='Doe',Email='yash1234@testing.com',PreferredDealerAccount_ID__c =accTestRec1.id, FirstName='John',
                              Company='Trance',LeadProvider_ID__c=accTestRec.id,
                              MSRP_AMT__c=6000,ModelDestinationCharge_AM__c=9000,ModelDealerAccessoryPrice_AM__c=9877,
                              Interior_Color__c='white',Exterior_Color__c='black',Transmission_TXT__c='aazzzz',
                              Address_Street__c='321',
                              State='telangana',Marketing_Campaign_Name__c='qqqqq',Make_TXT__c='kkkk',
                              Dealer_Ids_ID__c='testing',Year_YR__c='test',Model_TXT__c='demoooo',ProviderDetail_TXT__c='test11:test21',
                              Model_ID__c='demo',Trim_TXT__c='trimmer',SubDiv_TXT__c='Honda',Source_Name__c='Facebook',
                              isConverted=true,Send_confirmation_Email__c=true,
                              ConvertedAccountId=accTestRec.Id,
                              ConvertedOpportunityId=oppRec.id,
                              PreferredDealerNumber_NUM__c='123',
                              Division_CD__c='A',VehicleInterest_TXT__c='buy',
                              ContactKey_TXT__c ='test',VehicleStatus_TXT__c='New',Condition_TXT__c='excellent',
                              Number_NM__c='number',Doors_TXT__c='doortxt',BodyStyle_TXT__c='bodyStyle',Odometer_TXT__c='odmeter',
                              OdometerStatus_TXT__c='unknown',OdometerUnits_TXT__c='kilometer',  Color_TXT__c='<colorcombination><interiorcolor/><exteriorcolor>Deep Pearl Gray</exteriorcolor><preference>1</preference></colorcombination>');
        insert lead1;
        
         Opportunity oppRec1 = new Opportunity();
        oppRec1.id = oppRec.id;
        oppRec1.Lead_ID__c=lead1.Id;       
        update OppRec1;        
       // leadListIds.add(lead1.id);
        leadList.add(lead1);
        
       
        
        Offers__c offer1 = new Offers__c(
            Opportunity__c=oppRec1.Id, Offer_ID__c='AQA'
            
        );
        
        
        insert offer1;
        
        /*      List<Lead> listLead = [Select Id, FirstName,Odometer_TXT__c, BodyStyle_TXT__c,  MSRP_AMT__c, ModelDestinationCharge_AM__c, 
ModelDealerAccessoryPrice_AM__c, Interior_Color__c, Exterior_Color__c, Transmission_TXT__c,
Address_Street__c, Model_ID__c, 
State, Marketing_Campaign_Name__c, Make_TXT__c, Year_YR__c, ConvertedOpportunityId, LastName, Source_Name__c,
Division_CD__c, 
Address, street,City, PostalCode, Email, PreferredDealerAccount_ID__c, PreferredDealerNumber_NUM__c, 
LeadProvider_ID__r.Send_Customer_Acknowledgement_Email_Flag__c From Lead where SubDiv_TXT__c='Honda' 
AND isConverted = true AND Send_confirmation_Email__c = true AND
LeadProvider_ID__r.Send_Customer_Acknowledgement_Email_Flag__c= true AND Id IN : leadIds];*/
        
         
        
        
        
        //  HelmsOpportunityNotificationSms.OpportunityCreation(oppList);      
        if (test.isRunningTest()){
     
        Test.setMock(HttpCalloutMock.class, new UploadFileMock());
        Test.startTest();
       HELMSeShoppingSendNotification.eshoppingAPi(leadList);
        Test.stopTest();
                   
        }
    }
    
}