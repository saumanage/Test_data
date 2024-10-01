@IsTest
public class HELMS_OpportunityCreationLeadTest {
    
    @testSetup
    public static void testSetup() {
        
        Id dealerAccRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
        Id personAccRecType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        List<Account> accList = new List<Account>();
        Account accTestRec = new Account(Name='Test Account123',RecordTypeId=dealerAccRecTypeId,
                                         DealerCode_CD__c='123456'
                                        );
        Account accTestRec1 = new Account(Name='Test Account123another',RecordTypeId=dealerAccRecTypeId,
                                          DealerCode_CD__c='54321'
                                         );
        Account personAccTest = new Account(FirstName='Test Person Account',LastName='person',RecordTypeId=personAccRecType);
        
        accList.add(accTestRec);
        accList.add(accTestRec1);
        accList.add(personAccTest);
        
        insert accList;
        Lead ldRec = new Lead();
        ldRec.Status='Ready_To_Convert';
        ldRec.PreferredDealerNumber_NUM__c='123456';
        ldRec.FirstName='Test First';
        ldRec.LastName='LastName';
        ldRec.ValidEmail_FLG__c = true;
        ldRec.ValidPhoneNum_FLG__c=true;
        ldRec.PostalCode='11009';
        ldRec.CustomerAccount_ID__c=personAccTest.Id;
        ldRec.Dealer_Ids_ID__c='<id source="DealerPoint" sequence="1">123456</id><id source="DealerPoint" sequence="1">54321</id>';
        insert ldRec;
        
    }
    
    
    
    @isTest static void testBatch(){
        string Label;
        List<HELMS_LeadConversionFieldsToOpportunity__mdt>  accrec = new List<HELMS_LeadConversionFieldsToOpportunity__mdt>();
        HELMS_LeadConversionFieldsToOpportunity__mdt a1 = new HELMS_LeadConversionFieldsToOpportunity__mdt();
        
        a1.Label = 'Label';
        a1.LeadFieldAPIName__c='ModelTrim';
        accrec.add(a1);
        
        Account ac = new Account(name ='Grazitti' ,DealerCode_CD__c='301514', recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Dealer').getRecordTypeId()) ;
        insert ac;
          
        Account ac5 = new Account(name ='abe:xyz:' ,Enrichment__c=true,Routing_Date_Termination__c=Date.newInstance(2023, 7, 25),RoutingDate_DT__c=Date.newInstance(2023, 6, 22), Deduplication__c=true,recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider').getRecordTypeId()) ;
        insert ac5;
        
        List<lead> ld = new  List<lead>();
        Lead lead = new Lead(LastName='Code',FirstName='Test 12',Company='Test',Status='Closed Won',StatusReason_TXT__c=null,CustomerAccount_ID__c = ac.Id,
                             Dealer_Ids_ID__c='testing',Year_YR__c='test',Model_TXT__c='demoooo',PostalCode='50081',isConverted = true,Is_Enrichment_Update__c = true,IsFirstName_FLG__c= TRUE,
                             Model_ID__c='demo',Trim_TXT__c='trimmer',SubDiv_TXT__c='Acura', PreferredDealerAccount_ID__c=ac.id , ProviderDetail_TXT__c='abe:xyz:',LeadProvider_ID__c = ac5.id,
                             PreferredDealerNumber_NUM__c='301514',Division_CD__c='B',VehicleInterest_TXT__c='buy',Email='test@test.com',Phone='2112122',
                            ContactKey_TXT__c ='test',VehicleStatus_TXT__c='New',Condition_TXT__c='excellent',InventoryNumber_TXT__c='23',
                             Number_NM__c='number',Doors_TXT__c='doortxt',BodyStyle_TXT__c='bodyStyle',Odometer_TXT__c='odmeter',ValidEmail_FLG__c = TRUE,
                             Color_TXT__c='<colorcombination><interiorcolor>Gray</interiorcolor><exteriorcolor>Basque Red</exteriorcolor><preference>1</preference></colorcombination>',
                             OdometerStatus_TXT__c='unknown',OdometerUnits_TXT__c='kilometer',External_Lead_Reference_Number__c=null,ValidName_TXT__c = 'Genuine',
                             Address_Cache_Status__c = 'Genuine', Email_Cache_Status__c = 'Genuine',Triggertypecode__c='Instant',TriggerSendbyDate_DT__c= Date.newInstance(2023, 6, 22));
        ld.add(lead);
        

        Test.startTest();
        HELMS_OpportunityCreationLeadBatch  mybatch = new HELMS_OpportunityCreationLeadBatch();
        mybatch.execute(null,ld);
        mybatch.Finish(null);
        String sch = '0 0 5 * * ?';
        system.schedule('Test status Check', sch, mybatch);
        Test.stopTest(); 
    }
    
    
   
   
}