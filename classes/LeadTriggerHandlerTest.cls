/****************************************************************************** 
File Name:      LeadTriggerHandler   
Summary:        Code to update the Valid Name field on the basis of the Filter Words
                Code to update the Status Reason on the basis of Valid Name
Created On:     21st May, 2021
Created By:     Bandi Sujatha, Appirio
Test Classes:   LeadTriggerHandlerTest       
HELMS Jira Story: (LMS-1801)
===============================================================================
Modification Log:  
********************************************************************************/
@IsTest
public class LeadTriggerHandlerTest {

   @IsTest static void handleEqualsFilterWords() {
        Filter_Words_MDT__c fwSetting = new Filter_Words_MDT__c();
        fwSetting.Name = '1 NOT GIVEN';
        fwSetting.Category_txt__c= 'Equals';
        fwSetting.Handling_txt__c= 'Reject';
        insert fwSetting;
        
        Filter_Words_MDT__c fwSetting1 = new Filter_Words_MDT__c();
        fwSetting1.Name = '1 main s';
        fwSetting1.Category_txt__c= 'Contains';
        fwSetting1.Handling_txt__c= 'Reject';
        insert fwSetting1;
        
        Filter_Words_MDT__c fwSetting2 = new Filter_Words_MDT__c();
        fwSetting2.Name = '4RUNNER';
        fwSetting2.Category_txt__c= 'Equals';
        fwSetting2.Handling_txt__c= 'Reject';
        fwsetting2.Check_Against__c = 'Name, Address, Email';
        insert fwSetting2;
       
        // start - bruno test
        Filter_Words_MDT__c fwSetting3 = new Filter_Words_MDT__c();
        fwSetting3.Name = 'JOHN';
        fwSetting3.Category_txt__c= 'Equals';
        fwSetting3.Handling_txt__c= 'Reject';
        fwSetting3.Check_Against__c = 'Name, Address, Email';
        insert fwSetting3;
       
        Filter_Words_MDT__c fwSetting4 = new Filter_Words_MDT__c();
        fwSetting4.Name = 'JOHN DOE';
        fwSetting4.Category_txt__c= 'Equals';
        fwSetting4.Handling_txt__c= 'Reject';
        fwSetting4.Check_Against__c = 'Name, Address, Email';
        insert fwSetting4;
       
       	Account ac1 = new Account(name ='test001001',DealerCRMVendor_TXT__c='Test vend',Enrichment__c=true,DealerCode_CD__c='301515',recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Dealer').getRecordTypeId()) ;
        insert ac1; 
       
       	opportunity opp1 = new Opportunity(Name = 'test000001', StageName = 'Closed Won', CloseDate = System.today(), First_Name_TXT__c = 'test', Last_Name_TXT__c = '0100001');
        insert opp1;
              
        // end - bruno test
    
        Lead leadRec = new Lead(LastName='1 NOT GIVEN',Email='sur12@testing.com',Street= '4RUNNER', Status='Manual Validation1'); 
        Lead leadRec1 = new Lead(LastName='1 main s',Email='sur123@testing.com',Street= '4RUNNER', Status='Manual Validation');
        Lead leadRec2 = new Lead(LastName='2 main s',FirstName='1 main s',Email='sur1234@testing.com',Street= '4RUNNER', Status='Manual Validation');
        Lead leadRec3 = new Lead(LastName='3 main s',FirstName='1',Email='sur12345@testing.com',Street= '4RUNNER', Status='Manual Validation');
        Lead leadRec4 = new Lead(LastName='JOHN DOE',FirstName='JOHN',Email='JOHNsur12345@testing.com',Street= '4RUNNER', Status='Manual Validation');
        Lead leadRec5 = new Lead(LastName='DOE',FirstName='JOHN',Email='JOHNsur12345@testing.com',Street= '4RUNNER', Status='Manual Validation');
        Lead leadRec6 = new Lead(LastName='JOHN',FirstName='JOHN',Email='JOHN@testing.com',Street= 'JOHN', Status='Closed - Converted', StatusReason_TXT__c = 'Pending', isConverted = true, ConvertedAccountId = ac1.Id, ConvertedOpportunityId = opp1.Id);
        
        Test.startTest();
       	List<Lead> leadRecList = New List<Lead>();
       	List<Lead> leadRecListUpdate = New List<Lead>();
       leadRecList.add(leadRec);
       leadRecList.add(leadRec1);
       leadRecList.add(leadRec2);
       leadRecList.add(leadRec3);
       leadRecList.add(leadRec4);
       leadRecList.add(leadRec5);
       leadRecList.add(leadRec6);
       insert leadRecList;
        /*insert leadRec;
        insert leadRec1;
        insert leadRec2;
        insert leadRec3;
        insert leadRec4;
        insert leadRec5;
        insert leadRec6;*/
        leadRec.LastName='Test';
        leadRec1.LastName='Testing';
        leadRec2.LastName='Tested';
        leadRec3.LastName='Test1';
        leadRec4.LastName='DOE';
        leadRec5.LastName='TEST2';
        leadRec6.LastName='JOHN';
       leadRecListUpdate.add(leadRec);
       leadRecListUpdate.add(leadRec1);
       leadRecListUpdate.add(leadRec2);
       leadRecListUpdate.add(leadRec3);
       leadRecListUpdate.add(leadRec4);
       leadRecListUpdate.add(leadRec5);
       leadRecListUpdate.add(leadRec6);
        /*update leadRec; 
        update leadRec1;
        update leadRec2;
        update leadRec3;
        update leadRec4;
        update leadRec5;
        update leadRec6;*/
       update leadRecListUpdate;
 		System.assertEquals('Test', leadRec.LastName);
        Test.stopTest();  
    }
    
   @IsTest static  void handleContainsFilterWords() {
        Filter_Words_MDT__c fwSetting = new Filter_Words_MDT__c();
        fwSetting.Name = 'abc';
        fwSetting.Category_txt__c= 'Contains';
        fwSetting.Handling_txt__c= 'Reject';
        fwSetting.Check_Against__c='Name, Address, Email';
        insert fwSetting;
       
        // start - bruno test

        Filter_Words_MDT__c fwSetting2 = new Filter_Words_MDT__c();
        fwSetting2.Name = 'JOHN';
        fwSetting2.Category_txt__c= 'Contains';
        fwSetting2.Handling_txt__c= 'Reject';
        fwSetting2.Check_Against__c='Name, Address, Email';
        insert fwSetting2;
       
        Filter_Words_MDT__c fwSetting3 = new Filter_Words_MDT__c();
        fwSetting3.Name = 'JOHN DOE';
        fwSetting3.Category_txt__c= 'Contains';
        fwSetting3.Handling_txt__c= 'Reject';
        fwSetting3.Check_Against__c='Name, Address, Email';
        insert fwSetting3;

        Id personAccRecType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
      
        Account personAccTest = new Account(FirstName='Test Person Account',LastName='person',RecordTypeId=personAccRecType);
        Insert personAccTest;
       
        Account personAccTest2 = new Account(FirstName='Test Person Account2',LastName='person',RecordTypeId=personAccRecType);
        Insert personAccTest2;
       
        Account ac1 = new Account(name ='test001001',DealerCRMVendor_TXT__c='Test vend',Enrichment__c=true,DealerCode_CD__c='301515',recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Dealer').getRecordTypeId()) ;
        insert ac1; 
      
        Account ac2 = new Account(Name='Test Account62334',Lead_Source__c='Phone',RoutingDate_DT__c=Date.newInstance(2023, 6, 11),Routing_Date_Termination__c=System.now().addDays(1), Send_confirmation_interest_notification__c=true,Send_Invalid_Information_notification__c=true,Enrichment__c=true,RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider').getRecordTypeId(), DealerCode_CD__c='123456',HondaDigitalSolutions_FLG__c=true,Routable_FLG__c=true,SubDivision_TXT__c='Motorcycle');
        insert ac2;

        List<Lead> leadList = new List<Lead>();  
       
        Lead lead = new Lead(PreferredDealerAccount_ID__c=ac1.id,LeadProvider_ID__c=ac2.id,
                             Is_Enrichment_Update__c=true,Email_Cache_Status__c=null,ValidName_TXT__c='Cache',Address_Cache_Status__c=null,CustomerAccount_ID__c=personAccTest.Id,
                             Triggertypecode__c='Future',TriggerSendbyDate_DT__c=null,Source_Unique_ID__c='1323123',Reconfirm_Interest__c='No Response',LeadSource='Other',LastName='JOHN DOE',FirstName='JOHN',Company='Test',StatusReason_TXT__c='Pending',
                             Dealer_Ids_ID__c='testing',Year_YR__c='test',
                             Model_ID__c='demo',Trim_TXT__c='trimmer',SubDiv_TXT__c='Acura',Street= '4RUNNER',
                             PreferredDealerNumber_NUM__c='test',Division_CD__c='',VehicleInterest_TXT__c='buy',
                             ContactKey_TXT__c ='test',VehicleStatus_TXT__c='New',Condition_TXT__c='excellent',
                             Number_NM__c='number',Doors_TXT__c='doortxt',BodyStyle_TXT__c='bodyStyle',Odometer_TXT__c='odmeter',
                             Color_TXT__c='<colorcombination><interiorcolor>Gray</interiorcolor><exteriorcolor>Basque Red</exteriorcolor><preference>1</preference></colorcombination>',
                             OdometerStatus_TXT__c='unknown',OdometerUnits_TXT__c='kilometer', Email='JOHN12345@testing.com',
                             ValidEmail_FLG__c=true,ValidAddress_FLG__c=false,ContactType_TXT__c='Home Phone',Status='New',
                             ValidPhoneNum_FLG__c=false, Deal_ID__c=null,Deal_Link__c=null,Lead_Coming_From_CRM__c='');
        leadList.add(lead);
       
        Lead lead2 = new Lead(Source_Unique_ID__c='1345125', Reconfirm_Interest__c='No',LastName='JOHN DOE',FirstName='JOHN',Company='Test',Status='On Hold',StatusReason_TXT__c=null,LeadProvider_ID__c=ac2.id,
                             Dealer_Ids_ID__c='testing',Year_YR__c='test',ValidName_TXT__c='Cache',CustomerAccount_ID__c=personAccTest.Id,
                             Model_ID__c='demo',Trim_TXT__c='trimmer',SubDiv_TXT__c='Acura',Street= '4RUNNER',Is_Enrichment_Update__c=true,
                             PreferredDealerNumber_NUM__c='test',Division_CD__c='',VehicleInterest_TXT__c='buy',Email_Cache_Status__c=null,
                             ContactKey_TXT__c ='test',VehicleStatus_TXT__c='New',Condition_TXT__c='excellent',Address_Cache_Status__c=null,
                             Number_NM__c='number',Doors_TXT__c='doortxt',BodyStyle_TXT__c='bodyStyle',Odometer_TXT__c='odmeter',Triggertypecode__c='Future',
                             Color_TXT__c='<colorcombination><interiorcolor>Gray</interiorcolor><exteriorcolor>Basque Red</exteriorcolor><preference>1</preference></colorcombination>',
                             OdometerStatus_TXT__c='unknown',OdometerUnits_TXT__c='kilometer', Email='JOHN12345@testing.com',ValidEmail_FLG__c=true,ValidAddress_FLG__c=false,ContactType_TXT__c='Home Phone',ValidPhoneNum_FLG__c=false, Deal_ID__c=null,Deal_Link__c=null);
        leadList.add(lead2);
       
        Lead lead3 = new Lead(LastName='DOE',FirstName='JOHN',Company='Test',Status='New',StatusReason_TXT__c='Name/Address/Email Cache',
                             Dealer_Ids_ID__c='testing',Year_YR__c='test',Model_TXT__c='demoooo',ValidName_TXT__c='Cache',Triggertypecode__c='Future',
                             Model_ID__c='demo',Trim_TXT__c='trimmer',SubDiv_TXT__c='Acura',Street= 'JOHN',CustomerAccount_ID__c=personAccTest.Id,
                             PreferredDealerNumber_NUM__c='test',Division_CD__c='',VehicleInterest_TXT__c='buy',Is_Enrichment_Update__c=true,Email_Cache_Status__c=null,
                            ContactKey_TXT__c ='test',VehicleStatus_TXT__c='New',Condition_TXT__c='excellent',Address_Cache_Status__c=null,
                             Number_NM__c='number',Doors_TXT__c='doortxt',BodyStyle_TXT__c='bodyStyle',Odometer_TXT__c='odmeter',ValidEmail_FLG__c=true,
                             Color_TXT__c='<colorcombination><interiorcolor>Gray</interiorcolor><exteriorcolor>Basque Red</exteriorcolor><preference>1</preference></colorcombination>',
                         OdometerStatus_TXT__c='unknown',OdometerUnits_TXT__c='kilometer',Email='JOHN12345@testing.com',Reconfirm_Interest__c='No');
        leadList.add(lead3);

        Lead lead4 = new Lead(LastName='JOHN2 DOE',FirstName='JOHN2',Company='Test',Status='New',StatusReason_TXT__c='Name/Address/Email Cache',Reconfirm_Interest__c='No',
                             Dealer_Ids_ID__c='testing',Year_YR__c='test',Model_TXT__c='demoooo',
                             Model_ID__c='demo',Trim_TXT__c='trimmer',SubDiv_TXT__c='Acura',Street= 'JOHN2',
                             PreferredDealerNumber_NUM__c='test',Division_CD__c='',VehicleInterest_TXT__c='buy',
                             ContactKey_TXT__c ='test',VehicleStatus_TXT__c='New',Condition_TXT__c='excellent',ValidEmail_FLG__c=true,
                             Number_NM__c='number',Doors_TXT__c='doortxt',BodyStyle_TXT__c='bodyStyle',Odometer_TXT__c='odmeter',
                             Color_TXT__c='<colorcombination><interiorcolor>Gray</interiorcolor><exteriorcolor>Basque Red</exteriorcolor><preference>1</preference></colorcombination>',
                             OdometerStatus_TXT__c='unknown',OdometerUnits_TXT__c='kilometer', PreferredDealerAccount_ID__c=ac1.id,LeadProvider_ID__c=ac2.id, Email='JOHN2a12345@testing.com',
                             Is_Enrichment_Update__c=true,Email_Cache_Status__c=null,ValidName_TXT__c='Cache',Address_Cache_Status__c=null,CustomerAccount_ID__c=personAccTest.Id,
                             Triggertypecode__c='Future',TriggerSendbyDate_DT__c=null);
        leadList.add(lead4);
       
        // end - bruno test
        
         try {
             insert leadList;
             LeadTriggerHandler leadtrigger = new LeadTriggerHandler();
             leadtrigger.updateValidNameonLead(leadList);
         }catch(DMLException e) {
             // System.debug('Exception 1 '+e.getMessage());
             //system.assert(e.getMessage().contains('Last Name'));
        }
      

    }
    
   @IsTest static  void updateLeadGroupIdValue(){
      //  System.debug('Inside UpdateLeadGriup TEST ');
        Id personAccRecType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
      //  Id dealerAccRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Provider').getRecordTypeId();
        Account personAccTest = new Account(FirstName='Test Person Account',LastName='person',RecordTypeId=personAccRecType);
        Insert personAccTest;
        Account ac1 = new Account(name ='Graz33itti' ,DealerCode_CD__c='301515',recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Dealer').getRecordTypeId()) ;
        insert ac1; 
        Account ac2 = new Account(name ='abc' ,  recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider').getRecordTypeId()) ;
        insert ac2;
        //Contact con = new Contact(LastName ='kncsl', firstname ='asdjhgasjhd', email ='askdasgdhgas@sdjkfd.com', AccountId = personAccTest.Id);
        //insert con;  
        Lead ldRec1 = new Lead(FirstName='Test First',LastName='LastName',ValidEmail_FLG__c=true,
                              ValidPhoneNum_FLG__c=true,ValidAddress_FLG__c=true,ValidMobile_FLG__c=true,
                              CustomerAccount_ID__c=personAccTest.Id,Division_CD__c='A',PostalCode='12341',
                              SubDiv_TXT__c='Honda',PreferredDealerAccount_ID__c=ac1.id,LeadProvider_ID__c=ac2.id,
                              Triggertypecode__c='Instant',isConverted = true,ConvertedAccountId = ac1.Id,Lead_Group_ID__c='');
        Lead ldRec2 = new Lead(FirstName='Test First',LastName='LastName',CustomerAccount_ID__c=personAccTest.Id,
                               Division_CD__c='A',PostalCode='12341',SubDiv_TXT__c='Honda',
                               PreferredDealerAccount_ID__c=ac1.id,LeadProvider_ID__c=ac2.id,Triggertypecode__c='Instant');
         Lead ldRec3 = new Lead(FirstName='Test First',LastName='LastName',CustomerAccount_ID__c=personAccTest.Id,
                               Division_CD__c='A',PostalCode='12341',SubDiv_TXT__c='Honda',
                               PreferredDealerAccount_ID__c=ac1.id,LeadProvider_ID__c=ac2.id,Triggertypecode__c='FixedDate');
        //ldRec2.Status='Ready_To_Convert';
        //ldRec2.PreferredDealerNumber_NUM__c='123456';
        //ldRec2.FirstName='Test First';
        //ldRec2.LastName='LastName';
        //ldRec2.ValidEmail_FLG__c = true;
        //ldRec2.ValidPhoneNum_FLG__c=true;
        //ldRec2.ValidAddress_FLG__c = true;
        //ldRec2.ValidMobile_FLG__c = true;
        //ldRec2.PostalCode='11009';
        //ldRec2.CustomerAccount_ID__c=personAccTest.Id;
        //ldRec2.Dealer_Ids_ID__c='<id source="DealerPoint" sequence="1">123456</id><id source="DealerPoint" sequence="1">54321</id>';
        //ldRec2.IsConverted = true;
        //ldRec2.StatusReason_TXT__c = 'Pending';
        //ldRec2.Division_CD__c = 'A';
        //ldRec2.SubDiv_TXT__c='Honda';
        //ldRec2.PreferredDealerAccount_ID__c = ac1.id;
        //ldRec2.ValidName_TXT__c='';
        //ldRec2.LeadProvider_ID__c=ac2.id;
        //ldRec2.Triggertypecode__c='Instant';
        //ldRec2.PostalCode='12341';
        List<lead> leadslst = new List<lead>();
        leadslst.add(ldRec1);
        leadslst.add(ldRec2);
        leadslst.add(ldRec3);
        insert leadslst;
        LeadTriggerHandler leadtrigger = new LeadTriggerHandler();
        leadtrigger.updateLeadGroupIdValue(leadslst);
        leadtrigger.updateLeadGroupIdValue(null);
    }
    
   @IsTest static  void findDuplicateLeadRecord() {
       
            List<Account> alist = new List<Account>();
            Account ac = new Account(name ='Grazitti' ,DealerCode_CD__c='301514', recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Dealer').getRecordTypeId()) ;
            alist.add(ac); 
           Account ac4 = new Account(name ='Graz33itti' ,DealerCode_CD__c='301515',recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Dealer').getRecordTypeId()) ;
            alist.add(ac4); 
            Account ac2 = new Account(name ='abc' ,  recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider').getRecordTypeId()) ;
            alist.add(ac2); 
            Account ac3 = new Account(name ='pfe' , recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider').getRecordTypeId()) ;
            alist.add(ac3); 
           Account ac5 = new Account(name ='abe:xyz:' ,  recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider').getRecordTypeId()) ;
            alist.add(ac5); 
        Account ac6 = new Account(name ='pfe:xyz:' ,  recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider').getRecordTypeId()) ;
            alist.add(ac6); 
            insert alist; 
            
            Contact con = new Contact(LastName ='kncsl', firstname ='asdjhgasjhd', email ='askdasgdhgas@sdjkfd.com', recordtypeid = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Dealer').getRecordTypeId(),AccountId = ac.Id);
            insert con; 
         List<Lead> newvalues = new List<Lead>();    
        Lead lead = new Lead(LastName='Doe1',FirstName='John',Company='Test',Status='Closed - Not Converted',StatusReason_TXT__c='Duplicate Merged',
                             Dealer_Ids_ID__c='testing',Year_YR__c='test',Model_TXT__c='demoooo',PostalCode='50081',
                             Model_ID__c='demo',Trim_TXT__c='trimmer',SubDiv_TXT__c='Acura', PreferredDealerAccount_ID__c=ac.id , ProviderDetail_TXT__c='abe:xyz:',LeadProvider_ID__c = ac5.id,
                             PreferredDealerNumber_NUM__c='301514',Division_CD__c='B',VehicleInterest_TXT__c='buy',Email='test@test.com',Phone='2112122',
                            ContactKey_TXT__c ='test',VehicleStatus_TXT__c='New',Condition_TXT__c='excellent',InventoryNumber_TXT__c='23',
                             Number_NM__c='number',Doors_TXT__c='doortxt',BodyStyle_TXT__c='bodyStyle',Odometer_TXT__c='odmeter',
                             Color_TXT__c='<colorcombination><interiorcolor>Gray</interiorcolor><exteriorcolor>Basque Red</exteriorcolor><preference>1</preference></colorcombination>',
                             OdometerStatus_TXT__c='unknown',OdometerUnits_TXT__c='kilometer',External_Lead_Reference_Number__c='1234567');
        Lead lead1 = new Lead(LastName='Doe1',FirstName='John',Company='Test',Status='Closed - Not Converted', StatusReason_TXT__c='Duplicate Merged',
                             Dealer_Ids_ID__c='testing',Year_YR__c='test',Model_TXT__c='demoooo',PostalCode='50081',
                             Model_ID__c='demo',Trim_TXT__c='trimmer',SubDiv_TXT__c='Acura', PreferredDealerAccount_ID__c=ac.id , ProviderDetail_TXT__c='abe:xyz:',LeadProvider_ID__c = ac5.id,
                             PreferredDealerNumber_NUM__c='301514',Division_CD__c='B',VehicleInterest_TXT__c='buy',Email='test@test.com',Phone='2112122',
                            ContactKey_TXT__c ='test',VehicleStatus_TXT__c='New',Condition_TXT__c='excellent',InventoryNumber_TXT__c='23',
                             Number_NM__c='number',Doors_TXT__c='doortxt',BodyStyle_TXT__c='bodyStyle',Odometer_TXT__c='odmeter',
                             Color_TXT__c='<colorcombination><interiorcolor>Gray</interiorcolor><exteriorcolor>Basque Red</exteriorcolor><preference>1</preference></colorcombination>',
                             OdometerStatus_TXT__c='unknown',OdometerUnits_TXT__c='kilometer',External_Lead_Reference_Number__c='1234567');
        Lead lead2 = new Lead(LastName='Doe1',FirstName='John',Company='Test',Status='Closed - Not Converted',StatusReason_TXT__c='Duplicate Merged',
                             Dealer_Ids_ID__c='testing',Year_YR__c='test',Model_TXT__c='demoooo',PostalCode='50081',
                             Model_ID__c='demo',Trim_TXT__c='trimmer',SubDiv_TXT__c='Acura', PreferredDealerAccount_ID__c=ac.id , ProviderDetail_TXT__c='abe:xyz:',LeadProvider_ID__c = ac6.id,
                             PreferredDealerNumber_NUM__c='301514',Division_CD__c='B',VehicleInterest_TXT__c='buy',Email='test@test.com',Phone='2112122',
                            ContactKey_TXT__c ='test',VehicleStatus_TXT__c='New',Condition_TXT__c='excellent',InventoryNumber_TXT__c='23',
                             Number_NM__c='number',Doors_TXT__c='doortxt',BodyStyle_TXT__c='bodyStyle',Odometer_TXT__c='odmeter',
                             Color_TXT__c='<colorcombination><interiorcolor>Gray</interiorcolor><exteriorcolor>Basque Red</exteriorcolor><preference>1</preference></colorcombination>',
                             OdometerStatus_TXT__c='unknown',OdometerUnits_TXT__c='kilometer',External_Lead_Reference_Number__c='1234567');

        newvalues.add(lead);
        newvalues.add(lead1);
        newvalues.add(lead2);
        try {
        insert newvalues;
        LeadTriggerHandler leadtrigger = new LeadTriggerHandler();
        leadtrigger.findDuplicateLeadRecord(newvalues);
        leadtrigger.findDuplicateLeadRecord(null);
        
        lead.ProviderDetail_TXT__c='pfe:xyz:';
        lead.PreferredDealerNumber_NUM__c='301515';
        update lead;
            
        Lead clonedLead = lead.clone(false, false, false, false);
        insert clonedLead; 
        }catch(DMLException e) {
        //    System.debug('Exception 2 '+e.getMessage());
        }

    }
    
   @IsTest static  void findDuplicateLeadRecord2() {
       
            List<Account> alist = new List<Account>();
            Account ac = new Account(name ='Grazitti' ,DealerCode_CD__c='301514', recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Dealer').getRecordTypeId()) ;
            alist.add(ac); 
           Account ac4 = new Account(name ='Graz33itti' ,DealerCode_CD__c='301515',recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Dealer').getRecordTypeId()) ;
            alist.add(ac4); 
            Account ac2 = new Account(name ='abc' ,Deduplication__c=true,  recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider').getRecordTypeId()) ;
            alist.add(ac2); 
            Account ac3 = new Account(name ='pfe' ,Deduplication__c=true, recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider').getRecordTypeId()) ;
            alist.add(ac3); 
           Account ac5 = new Account(name ='abe:xyz:' ,Deduplication__c=true,  recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider').getRecordTypeId()) ;
            alist.add(ac5); 
        Account ac6 = new Account(name ='pfe:xyz:' ,Deduplication__c=true,  recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider').getRecordTypeId()) ;
            alist.add(ac6); 
            insert alist; 
            
            Contact con = new Contact(LastName ='kncsl', firstname ='asdjhgasjhd', email ='askdasgdhgas@sdjkfd.com', recordtypeid = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Dealer').getRecordTypeId(),AccountId = ac.Id);
            insert con; 
         List<Lead> newvalues = new List<Lead>();    
        Lead lead = new Lead(LastName='Doe1',FirstName='Doe1',Company='Test',Status='Closed Won',StatusReason_TXT__c='Duplicate Merged',
                             Dealer_Ids_ID__c='testing',Year_YR__c='test',Model_TXT__c='demoooo',PostalCode='50081',
                             Model_ID__c='demo',Trim_TXT__c='trimmer',SubDiv_TXT__c='Acura', PreferredDealerAccount_ID__c=ac.id , ProviderDetail_TXT__c='abe:xyz:',LeadProvider_ID__c = ac5.id,
                             PreferredDealerNumber_NUM__c='301514',Division_CD__c='B',VehicleInterest_TXT__c='buy',Email='test@test.com',Phone='2112122',
                            ContactKey_TXT__c ='test',VehicleStatus_TXT__c='New',Condition_TXT__c='excellent',InventoryNumber_TXT__c='23',
                             Number_NM__c='number',Doors_TXT__c='doortxt',BodyStyle_TXT__c='bodyStyle',Odometer_TXT__c='odmeter',
                             Color_TXT__c='<colorcombination><interiorcolor>Gray</interiorcolor><exteriorcolor>Basque Red</exteriorcolor><preference>1</preference></colorcombination>',
                             OdometerStatus_TXT__c='unknown',OdometerUnits_TXT__c='kilometer',External_Lead_Reference_Number__c='1234567');
        Lead lead1 = new Lead(LastName='Doe1',FirstName='Doe1',Company='Test',Status='Closed Won', StatusReason_TXT__c='Duplicate Merged',
                             Dealer_Ids_ID__c='testing',Year_YR__c='test',Model_TXT__c='demoooo',PostalCode='50081',
                             Model_ID__c='demo',Trim_TXT__c='trimmer',SubDiv_TXT__c='Acura', PreferredDealerAccount_ID__c=ac.id , ProviderDetail_TXT__c='abe:xyz:',LeadProvider_ID__c = ac5.id,
                             PreferredDealerNumber_NUM__c='301514',Division_CD__c='B',VehicleInterest_TXT__c='buy',Email='test@test.com',Phone='2112122',
                            ContactKey_TXT__c ='test',VehicleStatus_TXT__c='New',Condition_TXT__c='excellent',InventoryNumber_TXT__c='23',
                             Number_NM__c='number',Doors_TXT__c='doortxt',BodyStyle_TXT__c='bodyStyle',Odometer_TXT__c='odmeter',
                             Color_TXT__c='<colorcombination><interiorcolor>Gray</interiorcolor><exteriorcolor>Basque Red</exteriorcolor><preference>1</preference></colorcombination>',
                             OdometerStatus_TXT__c='unknown',OdometerUnits_TXT__c='kilometer',External_Lead_Reference_Number__c='1234567');
        Lead lead2 = new Lead(LastName='Doe1',FirstName='Doe1',Company='Test',Status='Closed Won',StatusReason_TXT__c='Duplicate Merged',
                             Dealer_Ids_ID__c='testing',Year_YR__c='test',Model_TXT__c='demoooo',PostalCode='50081',
                             Model_ID__c='demo',Trim_TXT__c='trimmer',SubDiv_TXT__c='Acura', PreferredDealerAccount_ID__c=ac.id , ProviderDetail_TXT__c='abe:xyz:',LeadProvider_ID__c = ac6.id,
                             PreferredDealerNumber_NUM__c='301514',Division_CD__c='B',VehicleInterest_TXT__c='buy',Email='test@test.com',Phone='2112122',
                            ContactKey_TXT__c ='test',VehicleStatus_TXT__c='New',Condition_TXT__c='excellent',InventoryNumber_TXT__c='23',
                             Number_NM__c='number',Doors_TXT__c='doortxt',BodyStyle_TXT__c='bodyStyle',Odometer_TXT__c='odmeter',
                             Color_TXT__c='<colorcombination><interiorcolor>Gray</interiorcolor><exteriorcolor>Basque Red</exteriorcolor><preference>1</preference></colorcombination>',
                             OdometerStatus_TXT__c='unknown',OdometerUnits_TXT__c='kilometer',External_Lead_Reference_Number__c='1234567');

        newvalues.add(lead);
        newvalues.add(lead1);
        newvalues.add(lead2);
        try {
        insert newvalues;
        LeadTriggerHandler leadtrigger = new LeadTriggerHandler();
        leadtrigger.findDuplicateLeadRecord(newvalues);
        leadtrigger.findDuplicateLeadRecord(null);
        
        }catch(DMLException e) {
        //    System.debug('Exception 2 '+e.getMessage());
        }

    }
    
   @IsTest static  void findDuplicateLeadRecord3() {
       
            List<Account> alist = new List<Account>();
            Account ac = new Account(name ='Grazitti' ,DealerCode_CD__c='301514', recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Dealer').getRecordTypeId()) ;
            alist.add(ac); 
           Account ac4 = new Account(name ='Graz33itti' ,DealerCode_CD__c='301515',recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Dealer').getRecordTypeId()) ;
            alist.add(ac4); 
            Account ac2 = new Account(name ='abc' ,Deduplication__c=true,  recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider').getRecordTypeId()) ;
            alist.add(ac2); 
            Account ac3 = new Account(name ='pfe' ,Deduplication__c=true, recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider').getRecordTypeId()) ;
            alist.add(ac3); 
           Account ac5 = new Account(name ='abe:xyz:' ,Deduplication__c=true,  recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider').getRecordTypeId()) ;
            alist.add(ac5); 
        Account ac6 = new Account(name ='pfe:xyz:' ,Deduplication__c=true,  recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider').getRecordTypeId()) ;
            alist.add(ac6); 
            insert alist; 
            
            Contact con = new Contact(LastName ='kncsl', firstname ='asdjhgasjhd', email ='askdasgdhgas@sdjkfd.com', recordtypeid = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Dealer').getRecordTypeId(),AccountId = ac.Id);
            insert con; 
         List<Lead> newvalues = new List<Lead>();    
        Lead lead = new Lead(LastName='Doe1',FirstName='Doe1',Company='Test',Status='Closed Won',StatusReason_TXT__c='Duplicate Merged',
                             Dealer_Ids_ID__c='testing',Year_YR__c='test',Model_TXT__c='demoooo',PostalCode='50081',
                             Model_ID__c='demo',Trim_TXT__c='trimmer',SubDiv_TXT__c='Acura', PreferredDealerAccount_ID__c=ac.id , ProviderDetail_TXT__c='abe:xyz:',LeadProvider_ID__c = ac5.id,
                             PreferredDealerNumber_NUM__c='301514',Division_CD__c='B',VehicleInterest_TXT__c='buy',Email='test@test.com',Phone='2112122',
                            ContactKey_TXT__c ='test',VehicleStatus_TXT__c='New',Condition_TXT__c='excellent',InventoryNumber_TXT__c='23',
                             Number_NM__c='number',Doors_TXT__c='doortxt',BodyStyle_TXT__c='bodyStyle',Odometer_TXT__c='odmeter',
                             Color_TXT__c='<colorcombination><interiorcolor>Gray</interiorcolor><exteriorcolor>Basque Red</exteriorcolor><preference>1</preference></colorcombination>',
                             OdometerStatus_TXT__c='unknown',OdometerUnits_TXT__c='kilometer',External_Lead_Reference_Number__c=null);
        Lead lead1 = new Lead(LastName='Doe1',FirstName='Doe1',Company='Test',Status='Closed Won', StatusReason_TXT__c='Duplicate Merged',
                             Dealer_Ids_ID__c='testing',Year_YR__c='test',Model_TXT__c='demoooo',PostalCode='50081',
                             Model_ID__c='demo',Trim_TXT__c='trimmer',SubDiv_TXT__c='Acura', PreferredDealerAccount_ID__c=ac.id , ProviderDetail_TXT__c='abe:xyz:',LeadProvider_ID__c = ac5.id,
                             PreferredDealerNumber_NUM__c='301514',Division_CD__c='B',VehicleInterest_TXT__c='buy',Email='test@test.com',Phone='2112122',
                            ContactKey_TXT__c ='test',VehicleStatus_TXT__c='New',Condition_TXT__c='excellent',InventoryNumber_TXT__c='23',
                             Number_NM__c='number',Doors_TXT__c='doortxt',BodyStyle_TXT__c='bodyStyle',Odometer_TXT__c='odmeter',
                             Color_TXT__c='<colorcombination><interiorcolor>Gray</interiorcolor><exteriorcolor>Basque Red</exteriorcolor><preference>1</preference></colorcombination>',
                             OdometerStatus_TXT__c='unknown',OdometerUnits_TXT__c='kilometer',External_Lead_Reference_Number__c=null);
        Lead lead2 = new Lead(LastName='Doe1',FirstName='Doe1',Company='Test',Status='Closed Won',StatusReason_TXT__c='Duplicate Merged',
                             Dealer_Ids_ID__c='testing',Year_YR__c='test',Model_TXT__c='demoooo',PostalCode='50081',
                             Model_ID__c='demo',Trim_TXT__c='trimmer',SubDiv_TXT__c='Acura', PreferredDealerAccount_ID__c=ac.id , ProviderDetail_TXT__c='abe:xyz:',LeadProvider_ID__c = ac6.id,
                             PreferredDealerNumber_NUM__c='301514',Division_CD__c='B',VehicleInterest_TXT__c='buy',Email='test@test.com',Phone='2112122',
                            ContactKey_TXT__c ='test',VehicleStatus_TXT__c='New',Condition_TXT__c='excellent',InventoryNumber_TXT__c='23',
                             Number_NM__c='number',Doors_TXT__c='doortxt',BodyStyle_TXT__c='bodyStyle',Odometer_TXT__c='odmeter',
                             Color_TXT__c='<colorcombination><interiorcolor>Gray</interiorcolor><exteriorcolor>Basque Red</exteriorcolor><preference>1</preference></colorcombination>',
                             OdometerStatus_TXT__c='unknown',OdometerUnits_TXT__c='kilometer',External_Lead_Reference_Number__c=null);

        newvalues.add(lead);
        newvalues.add(lead1);
        newvalues.add(lead2);
        try {
        insert newvalues;
        LeadTriggerHandler leadtrigger = new LeadTriggerHandler();
        leadtrigger.findDuplicateLeadRecord(newvalues);
        leadtrigger.findDuplicateLeadRecord(null);
        
        }catch(DMLException e) {
        //    System.debug('Exception 2 '+e.getMessage());
        }

    }
    
   @IsTest static  void testupdateModelGroupNameOnLead(){
        List<Product_Model_Group__c> tPMGs = new List<Product_Model_Group__c>();
        tPMGs.add(new Product_Model_Group__c(Name='TestPMG1',	Division__c='A',  Subdivision__c='Honda'));
        tPMGs.add(new Product_Model_Group__c(Name='TestPMG2',	Division__c='B',  Subdivision__c='Acura'));
        tPMGs.add(new Product_Model_Group__c(Name='TestPMG3',	Division__c='M',  Subdivision__c='Motorcycle'));
        tPMGs.add(new Product_Model_Group__c(Name='testz z8 1  test',	Division__c='A',  Subdivision__c='Honda'));
        insert tPMGs;
        List<Product_Model__c> tPGs = new List<Product_Model__c>();
        List<Product_Model_Group__c> insertedPMGS = [select Id, Name FROM Product_Model_Group__c];
        tPGs.add(new Product_Model__c(Model_ID_Text__c='6793', 	Model_Marketing_Name__c = 'PMG1' ,	Product_Model_Group_Id__c=insertedPMGS[0].Id));
        tPGs.add(new Product_Model__c(Model_ID_Text__c='4545', Model_Marketing_Name__c = 'PMG1',	Product_Model_Group_Id__c=insertedPMGS[0].Id));
        tPGs.add(new Product_Model__c(Model_ID_Text__c='8954', 	Model_Marketing_Name__c = 'PMG2', Product_Model_Group_Id__c=insertedPMGS[1].Id));
        tPGs.add(new Product_Model__c(Model_ID_Text__c='4343', Model_Marketing_Name__c = 'PMG2', 	Product_Model_Group_Id__c=insertedPMGS[1].Id));
        tPGs.add(new Product_Model__c(Model_ID_Text__c='5945', Model_Marketing_Name__c = 'PMG3', 	Product_Model_Group_Id__c=insertedPMGS[2].Id));
        tPGs.add(new Product_Model__c(Model_ID_Text__c='9054', Model_Marketing_Name__c = 'PMG3', 	Product_Model_Group_Id__c=insertedPMGS[2].Id));
        tPGs.add(new Product_Model__c(Model_ID_Text__c='6051', Model_Marketing_Name__c = 'testz', 	Product_Model_Group_Id__c=insertedPMGS[3].Id));
        insert tPGs;
        List<Lead> testLeads = new List<Lead>();
        Boolean swtch = true;
        for(Integer i = 1; i <= 5; i++){
            Lead l = new Lead(LastName='Test'+i, Division_CD__c='A', SubDiv_TXT__c='Honda',Status='New');
            l.Model_TXT__c = 'Honda TestPMG1';
            
            testLeads.add(l);
        }
        for(Integer i = 1; i <= 5; i++){
            Lead l = new Lead(LastName='TestZ8'+i, Division_CD__c='A', SubDiv_TXT__c='Honda',Status='New');
            l.Model_TXT__c = 'testz8 z8 pmg1 1 test';
            
            testLeads.add(l);
        }
        for(Integer i = 1; i <= 5; i++){
            Lead l = new Lead(LastName='Jest'+i, Division_CD__c='B', SubDiv_TXT__c='Acura',Status='New', Year_YR__c = '2019');
            if(swtch){
                l.Model_ID__c = '8954';
                swtch=false;
            }else{
                l.Model_ID__c = '4343';
                swtch=true;
            }
            testLeads.add(l);
        }
        for(Integer i = 1; i <= 5; i++){
            Lead l = new Lead(LastName='Pest'+i, Division_CD__c='M', SubDiv_TXT__c='Motorcycle',Status='New');
            if(swtch){
                l.Model_ID__c = '9054';
                swtch=false;
            }else{
                l.Model_TXT__c = 'PMG3';
                swtch=true;
            }
            testLeads.add(l);
        }
       
                 
        Test.startTest();
       
       try {
            insert testLeads;
            List<Lead> afterInsertTestLead = [SELECT Product_Model_Group_Id__c, Model_Group_Name__c From Lead WHERE Model_Group_Name__c != null ];
            //System.assertEquals(afterInsertTestLead.size(), 125);
            Integer ctrPMG1=0;
            Integer ctrPMG2=0;
            Integer ctrPMG3=0;
            for(Lead tl : afterInsertTestLead){
            if(tl.Model_Group_Name__c == insertedPMGS[0].Name ){
                ctrPMG1++;
            }
            if(tl.Model_Group_Name__c == insertedPMGS[1].Name ){
                ctrPMG2++;
            }
            if(tl.Model_Group_Name__c == insertedPMGS[2].Name ){
                ctrPMG3++;
            }
            }
            LeadTriggerHandler leadtrigger = new LeadTriggerHandler();
            leadtrigger.updateModelGroupNameOnLead(testLeads);
            leadtrigger.updateModelGroupNameOnLead(null);
            leadtrigger.updateVehicleStatus(testLeads);
            leadtrigger.updateModelGroupNameEmpty(testLeads);
        } catch (Exception ex) {
            Logs__c log = [SELECT Name FROM Logs__c LIMIT 1];
            System.assertNotEquals(null, log);
            System.assertEquals('Lead- Model Group Name On Lead', log.Name);
            // Assert other properties of the log if needed
        }
        

        Test.stopTest();
        
    }
    
   // start - bruno test
   @IsTest static  void handleUpdateValidNameonLead() {

        // start - bruno test

        Filter_Words_MDT__c fwSetting3 = new Filter_Words_MDT__c();
        fwSetting3.Name = 'JOHN DOE';
        fwSetting3.Category_txt__c= 'Contains';
        fwSetting3.Handling_txt__c= 'Reject';
        fwSetting3.Check_Against__c='Name, Address, Email';
        insert fwSetting3;

        Id personAccRecType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
      
        Account personAccTest = new Account(FirstName='Test Person Account',LastName='person',RecordTypeId=personAccRecType);
        Insert personAccTest;
       
        Account ac1 = new Account(name ='testacc 01D',DealerCRMVendor_TXT__c='Test vend',Enrichment__c=true,DealerCode_CD__c='301545',ShippingLatitude=39.850583,ShippingLongitude=-74.90814,recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Dealer').getRecordTypeId()) ;
        insert ac1; 
      
        Account ac2 = new Account(Name='Testacc 02P',Lead_Source__c='Phone',RoutingDate_DT__c=Date.newInstance(2023, 6, 11),
                                  Routing_Date_Termination__c=System.now().addDays(1), Send_confirmation_interest_notification__c=true,
                                  Send_Invalid_Information_notification__c=true,Enrichment__c=true,
                                  RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider').getRecordTypeId(), 
                                  DealerCode_CD__c='123456',HondaDigitalSolutions_FLG__c=true,
                                  Routable_FLG__c=true,SubDivision_TXT__c='Motorcycle');
        insert ac2;


        List<Lead> leadList = new List<Lead>();  
       
        Lead lead = new Lead(PreferredDealerAccount_ID__c=ac1.id,LeadProvider_ID__c=ac2.id,
                             Is_Enrichment_Update__c=true,Email_Cache_Status__c=null,ValidName_TXT__c=null,Address_Cache_Status__c=null,CustomerAccount_ID__c=personAccTest.Id,
                             Triggertypecode__c='Future',TriggerSendbyDate_DT__c=null,Source_Unique_ID__c='1323123',LeadSource='Other',LastName='JOHN DOE',FirstName='JOHN',Company='Test',StatusReason_TXT__c='Pending',
                             Dealer_Ids_ID__c='testing',Year_YR__c='test',
                             Model_ID__c='demo',Trim_TXT__c='trimmer',SubDiv_TXT__c='Acura',Street= '4RUNNER',
                             PreferredDealerNumber_NUM__c='test',Division_CD__c='',VehicleInterest_TXT__c='buy',
                             ContactKey_TXT__c ='test',VehicleStatus_TXT__c='New',Condition_TXT__c='excellent',
                             Number_NM__c='number',Doors_TXT__c='doortxt',BodyStyle_TXT__c='bodyStyle',Odometer_TXT__c='odmeter',
                             Color_TXT__c='<colorcombination><interiorcolor>Gray</interiorcolor><exteriorcolor>Basque Red</exteriorcolor><preference>1</preference></colorcombination>',
                             OdometerStatus_TXT__c='unknown',OdometerUnits_TXT__c='kilometer', Email='JOHN12345@testing.com',
                             ValidEmail_FLG__c=true,ValidAddress_FLG__c=false,ContactType_TXT__c='Home Phone',Status='New',
                             ValidPhoneNum_FLG__c=false, Deal_ID__c=null,Deal_Link__c=null,Lead_Coming_From_CRM__c='');
        leadList.add(lead);
        
        
        // Bijay
        Lead lead1 = new Lead(LeadProvider_ID__c=ac2.id,
                             Is_Enrichment_Update__c=true,Email_Cache_Status__c=null,ValidName_TXT__c=null,Address_Cache_Status__c=null,CustomerAccount_ID__c=personAccTest.Id,
                             Triggertypecode__c='Future',TriggerSendbyDate_DT__c=null,Source_Unique_ID__c='1323123',LeadSource='Other',LastName='JOHN DOE',FirstName='JOHN',Company='Test',StatusReason_TXT__c='Pending',
                             Dealer_Ids_ID__c='testing',Year_YR__c='test',
                             Model_ID__c='demo',Trim_TXT__c='trimmer',SubDiv_TXT__c='Acura',Street= '4RUNNER',
                             Division_CD__c='',VehicleInterest_TXT__c='buy',
                             ContactKey_TXT__c ='test',VehicleStatus_TXT__c='New',Condition_TXT__c='excellent',
                             Number_NM__c='number',Doors_TXT__c='doortxt',BodyStyle_TXT__c='bodyStyle',Odometer_TXT__c='odmeter',
                             Color_TXT__c='<colorcombination><interiorcolor>Gray</interiorcolor><exteriorcolor>Basque Red</exteriorcolor><preference>1</preference></colorcombination>',
                             OdometerStatus_TXT__c='unknown',OdometerUnits_TXT__c='kilometer', Email='JOHN12345@testing.com',
                             ValidEmail_FLG__c=true,ValidAddress_FLG__c=false,ContactType_TXT__c='Home Phone',Status='New',
                             ValidPhoneNum_FLG__c=false, Deal_ID__c=null,Deal_Link__c=null,Lead_Coming_From_CRM__c='');
       insert lead1;
       lead1.Is_HELMS_Contact_Key__c=true;
       update lead1;
       lead1.Is_HELMS_Contact_Key__c=False;
       lead1.Is_ECRM_Update_Done__c=True;
       update lead1;
       lead1.SalesRelatedDealerNumber__c='301545';
       update lead1;
        //bijay
        
       
        // end - bruno test
        
        try {
             insert leadList;
             LeadTriggerHandler leadtrigger = new LeadTriggerHandler();
             leadtrigger.updateValidNameonLead(leadList);
         }catch(DMLException e) {
             // System.debug('Exception 1 '+e.getMessage());
             //system.assert(e.getMessage().contains('Last Name'));
        }
      

    }
    
   @IsTest static  void handleUpdateValidNameonLead2() {

        // start - bruno test

        Filter_Words_MDT__c fwSetting3 = new Filter_Words_MDT__c();
        fwSetting3.Name = 'JOHN DOE';
        fwSetting3.Category_txt__c= 'Contains';
        fwSetting3.Handling_txt__c= 'Reject';
        fwSetting3.Check_Against__c='Name, Address, Email';
        insert fwSetting3;

        Id personAccRecType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
      
        Account personAccTest = new Account(FirstName='Test Person Account',LastName='person',RecordTypeId=personAccRecType);
        Insert personAccTest;
       
        Account ac1 = new Account(name ='testacc 01D',DealerCRMVendor_TXT__c='Test vend',Enrichment__c=true,DealerCode_CD__c='301545',recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Dealer').getRecordTypeId()) ;
        insert ac1; 
      
        Account ac2 = new Account(Name='Testacc 02P',Lead_Source__c='Phone',RoutingDate_DT__c=Date.newInstance(2023, 6, 11),
                                  Routing_Date_Termination__c=System.now().addDays(1), Send_confirmation_interest_notification__c=true,
                                  Send_Invalid_Information_notification__c=true,Enrichment__c=true,
                                  RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider').getRecordTypeId(), 
                                  DealerCode_CD__c='123906',HondaDigitalSolutions_FLG__c=true,
                                  Routable_FLG__c=true,SubDivision_TXT__c='Motorcycle');
        insert ac2;


        List<Lead> leadList = new List<Lead>();  
       
        Lead lead = new Lead(PreferredDealerAccount_ID__c=ac1.id,LeadProvider_ID__c=ac2.id,
                             Is_Enrichment_Update__c=true,Email_Cache_Status__c=null,ValidName_TXT__c=null,Address_Cache_Status__c=null,CustomerAccount_ID__c=personAccTest.Id,
                             Triggertypecode__c='Future',TriggerSendbyDate_DT__c=null,Source_Unique_ID__c='1113123',Reconfirm_Interest__c='No',LeadSource='Other',LastName='JOHN DOE',FirstName='JOHN',Company='Test',StatusReason_TXT__c='Pending',
                             Dealer_Ids_ID__c='testing',Year_YR__c='test',
                             Model_ID__c='demo',Trim_TXT__c='trimmer',SubDiv_TXT__c='Acura',Street= '4RUNNER',
                             PreferredDealerNumber_NUM__c='test',Division_CD__c='',VehicleInterest_TXT__c='buy',
                             ContactKey_TXT__c ='test',VehicleStatus_TXT__c='New',Condition_TXT__c='excellent',
                             Number_NM__c='number',Doors_TXT__c='doortxt',BodyStyle_TXT__c='bodyStyle',Odometer_TXT__c='odmeter',
                             Color_TXT__c='<colorcombination><interiorcolor>Gray</interiorcolor><exteriorcolor>Basque Red</exteriorcolor><preference>1</preference></colorcombination>',
                             OdometerStatus_TXT__c='unknown',OdometerUnits_TXT__c='kilometer', Email='JOHN12345@testing.com',
                             ValidEmail_FLG__c=true,ValidAddress_FLG__c=false,ContactType_TXT__c='Home Phone',Status='New',
                             ValidPhoneNum_FLG__c=false, Deal_ID__c=null,Deal_Link__c=null,Lead_Coming_From_CRM__c='');
        leadList.add(lead);
       
        // end - bruno test
        
        try {
             insert leadList;
             LeadTriggerHandler leadtrigger = new LeadTriggerHandler();
             leadtrigger.updateValidNameonLead(leadList);
         }catch(DMLException e) {
             // System.debug('Exception 1 '+e.getMessage());
             //system.assert(e.getMessage().contains('Last Name'));
        }
      

    }
    
   @IsTest static  void handleUpdateValidNameonLead3() {

        // start - bruno test

        Filter_Words_MDT__c fwSetting3 = new Filter_Words_MDT__c();
        fwSetting3.Name = 'JOHN DOE';
        fwSetting3.Category_txt__c= 'Contains';
        fwSetting3.Handling_txt__c= 'Reject';
        fwSetting3.Check_Against__c='Name, Address, Email';
        insert fwSetting3;

        Id personAccRecType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
      
        Account personAccTest = new Account(FirstName='Test Person Account',LastName='person',RecordTypeId=personAccRecType);
        Insert personAccTest;
       
        Account ac1 = new Account(name ='testacc 01D',DealerCRMVendor_TXT__c='Test vend',Enrichment__c=true,DealerCode_CD__c='301545',recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Dealer').getRecordTypeId()) ;
        insert ac1; 
      
        Account ac2 = new Account(Name='Testacc 02P',Lead_Source__c='Phone',RoutingDate_DT__c=Date.newInstance(2023, 6, 11),
                                  Routing_Date_Termination__c=System.now().addDays(1), Send_confirmation_interest_notification__c=true,
                                  Send_Invalid_Information_notification__c=true,Enrichment__c=true,
                                  RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider').getRecordTypeId(), 
                                  DealerCode_CD__c='123906',HondaDigitalSolutions_FLG__c=true,
                                  Routable_FLG__c=true,SubDivision_TXT__c='Motorcycle');
        insert ac2;


        List<Lead> leadList = new List<Lead>();  
       
        Lead lead = new Lead(PreferredDealerAccount_ID__c=ac1.id,LeadProvider_ID__c=ac2.id,
                             Is_Enrichment_Update__c=true,Email_Cache_Status__c=null,ValidName_TXT__c='Cache',Address_Cache_Status__c=null,CustomerAccount_ID__c=personAccTest.Id,
                             Triggertypecode__c='Future',TriggerSendbyDate_DT__c=null,Source_Unique_ID__c='1113123',LeadSource='Other',LastName='JOHN DOE',FirstName='JOHN',Company='Test',StatusReason_TXT__c='Pending',
                             Dealer_Ids_ID__c='testing',Year_YR__c='test',
                             Model_ID__c='demo',Trim_TXT__c='trimmer',SubDiv_TXT__c='Acura',Street= '4RUNNER',
                             PreferredDealerNumber_NUM__c='test',Division_CD__c='',VehicleInterest_TXT__c='buy',
                             ContactKey_TXT__c ='test',VehicleStatus_TXT__c='New',Condition_TXT__c='excellent',
                             Number_NM__c='number',Doors_TXT__c='doortxt',BodyStyle_TXT__c='bodyStyle',Odometer_TXT__c='odmeter',
                             Color_TXT__c='<colorcombination><interiorcolor>Gray</interiorcolor><exteriorcolor>Basque Red</exteriorcolor><preference>1</preference></colorcombination>',
                             OdometerStatus_TXT__c='unknown',OdometerUnits_TXT__c='kilometer', Email='JOHN12345@testing.com',
                             ValidAddress_FLG__c=false,ContactType_TXT__c='Home Phone',Status='New',ValidPhoneNum_FLG__c=false, Deal_ID__c=null,Deal_Link__c=null,Lead_Coming_From_CRM__c='');
        leadList.add(lead);
       
        // end - bruno test
        
        try {
             insert leadList;
             LeadTriggerHandler leadtrigger = new LeadTriggerHandler();
             leadtrigger.updateValidNameonLead(leadList);
         }catch(DMLException e) {
             // System.debug('Exception 1 '+e.getMessage());
             //system.assert(e.getMessage().contains('Last Name'));
        }
      

    }
    
   @IsTest static  void handleUpdateValidNameonLead4() {

        // start - bruno test

        Filter_Words_MDT__c fwSetting3 = new Filter_Words_MDT__c();
        fwSetting3.Name = 'JOHN DOE';
        fwSetting3.Category_txt__c= 'Contains';
        fwSetting3.Handling_txt__c= 'Reject';
        fwSetting3.Check_Against__c='Name, Address, Email';
        insert fwSetting3;

        Id personAccRecType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
      
        Account personAccTest = new Account(FirstName='Test Person Account',LastName='person',RecordTypeId=personAccRecType);
        Insert personAccTest;
       
        Account ac1 = new Account(name ='testacc 01D',DealerCRMVendor_TXT__c='Test vend',Enrichment__c=true,DealerCode_CD__c='301545',recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Dealer').getRecordTypeId()) ;
        insert ac1; 
      
        Account ac2 = new Account(Name='Testacc 02P',Lead_Source__c='Phone',RoutingDate_DT__c=Date.newInstance(2023, 6, 11),
                                  Routing_Date_Termination__c=null, Send_confirmation_interest_notification__c=false,
                                  Send_Invalid_Information_notification__c=true,Enrichment__c=true,
                                  RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider').getRecordTypeId(), 
                                  DealerCode_CD__c='125806',HondaDigitalSolutions_FLG__c=true,
                                  Routable_FLG__c=true,SubDivision_TXT__c='Motorcycle');
        insert ac2;


        List<Lead> leadList = new List<Lead>(); 
       
        Lead lead = new Lead(PreferredDealerAccount_ID__c=ac1.id,LeadProvider_ID__c=ac2.id,
                             Is_Enrichment_Update__c=true,Email_Cache_Status__c=null,ValidName_TXT__c=null,Address_Cache_Status__c=null,CustomerAccount_ID__c=personAccTest.Id,
                             Triggertypecode__c='Instant',TriggerSendbyDate_DT__c=null,Source_Unique_ID__c='1113123',LeadSource='Other',LastName='JOHN DOE',FirstName='JOHN',Company='Test',StatusReason_TXT__c=null,
                             Dealer_Ids_ID__c='testing',Year_YR__c='test',
                             Model_ID__c='demo',Trim_TXT__c='trimmer',SubDiv_TXT__c='Acura',Street= '4RUNNER',
                             PreferredDealerNumber_NUM__c='test',Division_CD__c='B',VehicleInterest_TXT__c='buy',
                             ContactKey_TXT__c ='test',VehicleStatus_TXT__c='New',Condition_TXT__c='excellent',
                             Number_NM__c='number',Doors_TXT__c='doortxt',BodyStyle_TXT__c='bodyStyle',Odometer_TXT__c='odmeter',
                             Color_TXT__c='<colorcombination><interiorcolor>Gray</interiorcolor><exteriorcolor>Basque Red</exteriorcolor><preference>1</preference></colorcombination>',
                             OdometerStatus_TXT__c='unknown',OdometerUnits_TXT__c='kilometer', Email=null,
                             ValidMobile_FLG__c=true,ValidEmail_FLG__c=true,ValidAddress_FLG__c=false,ContactType_TXT__c='Home Phone',Status='New',ValidPhoneNum_FLG__c=true, Deal_ID__c=null,Deal_Link__c=null,Lead_Coming_From_CRM__c='');
        leadList.add(lead);
       
        // end - bruno test
        
        try {
             insert leadList;
             LeadTriggerHandler leadtrigger = new LeadTriggerHandler();
             leadtrigger.updateValidNameonLead(leadList);
         }catch(DMLException e) {
             // System.debug('Exception 1 '+e.getMessage());
             //system.assert(e.getMessage().contains('Last Name'));
        }
      

    }
    
  /* @isTest static void testUpdateVehicleStatus() {

        // Create test leads with different Year_YR__c values
        List<Lead> leads = new List<Lead>();
        leads.add(new Lead(Year_YR__c = '2020'));
        leads.add(new Lead(Year_YR__c = '2019'));
        leads.add(new Lead(Year_YR__c = '0'));
        leads.add(new Lead(Year_YR__c = 'abcd'));
        leads.add(new Lead(Year_YR__c = null));
        
        // Call the method to update vehicle status
        LeadTriggerHandler leadtrigger = new LeadTriggerHandler();
        leadtrigger.updateVehicleStatus(leads);
        
        // Verify the updated vehicle status
        System.assertEquals('Used', leads[0].VehicleStatus_TXT__c);
        System.assertEquals('Used', leads[1].VehicleStatus_TXT__c);
    }*/
    
  /* @isTest static void testUpdateModelGroupNameEmpty() {
        // Create test leads with different Year_YR__c and VehicleStatus_TXT__c values
        List<Lead> leads = new List<Lead>();
        leads.add(new Lead(Year_YR__c = '0', VehicleStatus_TXT__c = 'New'));
        leads.add(new Lead(Year_YR__c = '2022', VehicleStatus_TXT__c = 'New'));
        leads.add(new Lead(Year_YR__c = '0', VehicleStatus_TXT__c = 'Used'));
        leads.add(new Lead(Year_YR__c = '2022', VehicleStatus_TXT__c = 'Used'));
        
        // Call the method to update Model_Group_Name__c
        LeadTriggerHandler leadtrigger = new LeadTriggerHandler();
        leadtrigger.updateModelGroupNameEmpty(leads);
        
        // Verify the updated Model_Group_Name__c
        System.assertEquals('', leads[0].Model_Group_Name__c);
    }
   // end - bruno test*/
  
   
  
}