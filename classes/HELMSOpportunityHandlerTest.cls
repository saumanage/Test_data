/****************************************************************************** 
File Name:      HELMSOpportunityHandler  
Summary:        Code to send an email to Dealer notification on Lead Assignment-SP
Created On:     21st May, 2021
Created By:     Bandi Sujatha, Appirio
Test Classes:   HELMSOpportunityHandlerTest
Data I/O:        
HELMS Jira Story: Code to send an email to Dealer notification on Lead Assignment-SP (LMS-1735)
=================================================================================================
*/
@isTest
public class HELMSOpportunityHandlerTest {
    
    /*public static testMethod void handleUpdateSameLeadGroupIdLeads(){          
        Lead leadRec = new Lead(FirstName='Test',LastName='Test',Phone='1234567890',MobilePhone='1234567890',Email='sur12@testing.com',Status='Manual Validation1',PostalCode='56003',Division_CD__c='A',SubDiv_TXT__c='Honda'); 
        
    }*/
    
    public static testMethod void handleupdateOpportunityClosed(){     
        Id dealerAccRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
        Id personAccRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        Account acc = new Account(Name='Test Account12322',RecordTypeId=dealerAccRecTypeId,DealerCode_CD__c='1234');
        insert acc;
        List<Account> alist = new List<Account>();
        //Account ac = new Account(name ='Grazittii' ,DealerCode_CD__c='301514',DealerAccessLevel_TXT__c='Full Access', recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Dealer').getRecordTypeId()) ;
        //alist.add(ac); 
        //Account ac1 = new Account(name ='Grazitti' ,DealerCode_CD__c='301514',DealerAccessLevel_TXT__c='Full Access', recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Dealer').getRecordTypeId()) ;
        //alist.add(ac1); 
        Account ac5 = new Account(name ='abe:xyz:' , recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider').getRecordTypeId()) ;
        alist.add(ac5); 
        insert alist; 
        Account pro = new Account(name ='abc' , recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider').getRecordTypeId()) ;
        insert pro; 
        Opportunity oppRec = new Opportunity(Name='YashLead12345',Lead_Group_ID__c = '123',StageName='In Conversation',PreferredDealerAccount_TXT__c=acc.id, Email__c='abc@test.com', ZipCode_TXT__c='12345',MSRP_AMT__c=200,Quote_AMT__c=500,
                                PreferredDealerNumber_NUM__c='1234', External_ID__c='12345',CloseDate=system.today() , First_Name_TXT__c='Test opp19', Last_Name_TXT__c ='Test opp LAst9', LeadProvider_ID__c=pro.id,
                                Options_TXT__c='<option><optionname>Sport</optionname><manufacturercode>p394</manufacturercode><stock>100</stock><weighting>65</weighting><price>19500</price></option><option><optionname>Sport</optionname><manufacturercode>p394</manufacturercode><stock>100</stock><weighting>65</weighting><price type="invoice" currency="USD" source="Kelley Blue Book">19500</price><price type="appraisal" currency="USD" delta="percentage" relativeto="invoice" source="KBB"/><price type="msrp" currency="USD" delta="relative" relativeto="invoice" source="KBB">200</price><price type="quote" currency="USD" delta="absolute">19000</price><price type="offer" currency="USD" delta="relative" relativeto="invoice" source="KBB">200</price><price type="call" currency="USD" delta="percentage" relativeto="msrp">2</price><price type="asking" currency="USD" delta="percentage" relativeto="msrp">2</price></option>'
                                );
        Opportunity oppRec1 = new Opportunity(Name='YashLead123456',Lead_Group_ID__c = '123',StageName='In Conversation',PreferredDealerAccount_TXT__c=acc.id, Email__c='abc@test.com', ZipCode_TXT__c='12345',MSRP_AMT__c=200,Quote_AMT__c=500,
                                PreferredDealerNumber_NUM__c='1234', External_ID__c='12345',CloseDate=system.today() , First_Name_TXT__c='Test opp19', Last_Name_TXT__c ='Test opp LAst9', LeadProvider_ID__c=pro.id,
                                Options_TXT__c='<option><optionname>Sport</optionname><manufacturercode>p394</manufacturercode><stock>100</stock><weighting>65</weighting><price>19500</price></option><option><optionname>Sport</optionname><manufacturercode>p394</manufacturercode><stock>100</stock><weighting>65</weighting><price type="invoice" currency="USD" source="Kelley Blue Book">19500</price><price type="appraisal" currency="USD" delta="percentage" relativeto="invoice" source="KBB"/><price type="msrp" currency="USD" delta="relative" relativeto="invoice" source="KBB">200</price><price type="quote" currency="USD" delta="absolute">19000</price><price type="offer" currency="USD" delta="relative" relativeto="invoice" source="KBB">200</price><price type="call" currency="USD" delta="percentage" relativeto="msrp">2</price><price type="asking" currency="USD" delta="percentage" relativeto="msrp">2</price></option>'
                                );
        Lead lead = new Lead(LastName='Doe1',FirstName='John',Lead_Group_ID__c = '123',Company='Test',Status='New',StatusReason_TXT__c='',
                             Dealer_Ids_ID__c='testing',Year_YR__c='test',Model_TXT__c='demoooo',phone='7894563212',PostalCode='50081',
                             Model_ID__c='demo',Trim_TXT__c='trimmer',SubDiv_TXT__c='Honda', PreferredDealerAccount_ID__c=acc.id , ProviderDetail_TXT__c='abe:xyz:',LeadProvider_ID__c = ac5.id,
                             PreferredDealerNumber_NUM__c='301514',Division_CD__c='A',VehicleInterest_TXT__c='buy',
                            ContactKey_TXT__c ='test',VehicleStatus_TXT__c='New',Condition_TXT__c='excellent',
                             Number_NM__c='number',Doors_TXT__c='doortxt',BodyStyle_TXT__c='bodyStyle',Odometer_TXT__c='odmeter',
                             Color_TXT__c='<colorcombination><interiorcolor>Gray</interiorcolor><exteriorcolor>Basque Red</exteriorcolor><preference>1</preference></colorcombination>',
                             OdometerStatus_TXT__c='unknown',OdometerUnits_TXT__c='kilometer');
        Lead lead1 = new Lead(LastName='Doe1',FirstName='John',Lead_Group_ID__c = '123',Company='Test',Status='New',StatusReason_TXT__c='',
                             Dealer_Ids_ID__c='testing',Year_YR__c='test',Model_TXT__c='demoooo',phone='7894563212',PostalCode='50081',
                             Model_ID__c='demo',Trim_TXT__c='trimmer',SubDiv_TXT__c='Honda', PreferredDealerAccount_ID__c=acc.id , ProviderDetail_TXT__c='abe:xyz:',LeadProvider_ID__c = ac5.id,
                             PreferredDealerNumber_NUM__c='301514',Division_CD__c='A',VehicleInterest_TXT__c='buy',
                            ContactKey_TXT__c ='test',VehicleStatus_TXT__c='New',Condition_TXT__c='excellent',
                             Number_NM__c='number',Doors_TXT__c='doortxt',BodyStyle_TXT__c='bodyStyle',Odometer_TXT__c='odmeter',
                             Color_TXT__c='<colorcombination><interiorcolor>Gray</interiorcolor><exteriorcolor>Basque Red</exteriorcolor><preference>1</preference></colorcombination>',
                             OdometerStatus_TXT__c='unknown',OdometerUnits_TXT__c='kilometer');
        
        
        test.StartTest();
        
        insert lead;
        insert lead1;
        insert oppRec;
        insert oppRec1;
        
        /*Database.LeadConvert lc = new database.LeadConvert();
        lc.setLeadId(lead1.id);
        lc.setDoNotCreateOpportunity(false);
        lc.setConvertedStatus('Ready_to_Convert');

        Database.LeadConvertResult lcr = Database.convertLead(lc);
        System.assert(lcr.isSuccess());
        
        
        
        OppRec.StageName='Closed Won';
        OppRec.CloseDate=system.today();
        update OppRec;
        OppRec1.StageName='Closed Won';
        OppRec1.CloseDate=system.today();
        update OppRec1;*/
        //HELMSOpportunityHandler oppObj = new HELMSOpportunityHandler();
        //Set<String> LeadGroupId = new Set<String>();
        //LeadGroupId.add('123');
        //oppObj.updateSameLeadGroupIdLeads(LeadGroupId,);
        Test.stopTest();
            
    }
    public static testMethod void handleupdateOpportunityMethod1(){     
        Id dealerAccRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
        Id vendorAccRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Vendor').getRecordTypeId();
        Id oppHondaRecTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Honda Opportunity').getRecordTypeId();
        Id personAccRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        Account acc = new Account(Name='Test Account12322',RecordTypeId=dealerAccRecTypeId,
                                  DealerCode_CD__c='1234',HondaDigitalSolutions_FLG__c=true,
                                 Routable_FLG__c=true,SubDivision_TXT__c='Honda');
        insert acc;
 
        Account acc1 = new Account(Name='Test Account123225',RecordTypeId=dealerAccRecTypeId,
                                  DealerCode_CD__c='12345',HondaDigitalSolutions_FLG__c=true,
                                 Routable_FLG__c=false);
        insert acc1;
        
        
        // start - bruno test 
        Account acc2 = new Account(Name='Test Account62334',RecordTypeId=dealerAccRecTypeId,
                                  DealerCode_CD__c='123456',HondaDigitalSolutions_FLG__c=true,
                                 Routable_FLG__c=true,SubDivision_TXT__c='Motorcycle');
        insert acc2;
        // end - bruno test
        
        Account accVendor = new Account(Name='Hello vendor',RecordTypeId=vendorAccRecTypeId,
                                  DealerCode_CD__c='1234Z',HondaDigitalSolutions_FLG__c=true,
                                 Routable_FLG__c=true);
        insert accVendor;
    //    System.debug('Dealer ID : '+acc.Id+' : '+acc.Name);
   //    System.debug('Dealer ID : '+acc1.Id+' : '+acc1.Name);
        List<Dealer_Division__c> subDivList = new List<Dealer_Division__c>();
        Dealer_Division__c dealerD = new Dealer_Division__c(First_Name_TXT__c='Test', 
                                                            InternetCertified_FLG__c=true, 
                                                            Dealer_ID__c=acc.Id,
                                                            Division_CD__c='A',
                                                           isActive_FLG__c=true,SubDiv_TXT__c='Honda');
        subDivList.add(dealerD);
        Dealer_Division__c dealerD1 = new Dealer_Division__c(First_Name_TXT__c='Test1', 
                                                            InternetCertified_FLG__c=true, 
                                                            Dealer_ID__c=acc1.Id,
                                                            Division_CD__c='A',
                                                           isActive_FLG__c=true,SubDiv_TXT__c='Honda');
        subDivList.add(dealerD1);
        
        // start - bruno test
        Dealer_Division__c dealerD2 = new Dealer_Division__c(First_Name_TXT__c='Test2', 
                                                            InternetCertified_FLG__c=true, 
                                                            Dealer_ID__c=acc2.Id,
                                                            Division_CD__c='M',
                                                           isActive_FLG__c=true,SubDiv_TXT__c='Motorcycle');
        subDivList.add(dealerD2);
        // end - bruno test
        
        insert subDivList;
        for(Dealer_Division__c divRec : subDivList){
       //     System.debug('SUBDIVLIST : '+divRec.First_Name_TXT__c+' : '+divRec.InternetCertified_FLG__c+' : '+divRec.Dealer_ID__c+' : '+divRec.SubDiv_TXT__c);
        }
        CRM_System__c crmSystem = new CRM_System__c(Name='Test crm system',Vendor_ID__c=accVendor.Id,ISActive_FLG__c=true,Division_CD__c ='A');
        insert crmSystem;
        
        // start - bruno test
        CRM_System__c crmSystem2 = new CRM_System__c(Name='Test crm system2',Vendor_ID__c=accVendor.Id,ISActive_FLG__c=true,Division_CD__c ='M');
        insert crmSystem2;
        // end - bruno test
        
        Dealer_Participation__c dealerPart = new Dealer_Participation__c( LeadReceivingStartDate_DT__c=System.NOW()-12,
                                                                         DealerAccount_ID__c=acc.Id, 
                                                                         Division__c='A',
                                                                         Dealer_Subdivision__c=dealerD.Id,
                                                                        CRM_System__c = crmSystem.Id);
        insert dealerPart;
        Dealer_Participation__c dealerPart1 = new Dealer_Participation__c( LeadReceivingStartDate_DT__c=System.NOW()-12,
                                                                         DealerAccount_ID__c=acc1.Id, 
                                                                         Division__c='A',
                                                                         Dealer_Subdivision__c=dealerD1.Id,
                                                                        CRM_System__c = crmSystem.Id);
        insert dealerPart1;
        
        // start - bruno test
        Dealer_Participation__c dealerPart2 = new Dealer_Participation__c( LeadReceivingStartDate_DT__c=System.NOW()-12,
                                                                         DealerAccount_ID__c=acc2.Id, 
                                                                         Division__c='M',
                                                                         Dealer_Subdivision__c=dealerD2.Id,
                                                                        CRM_System__c = crmSystem2.Id);
        insert dealerPart2;
        // end - bruno test
        
        //Dealer_Participation__c dealerParticipationList = new Dealer_Participation__c(DealerAccount_ID__c =accTestRec.Id,Division__c='M',
                                                               //CRM_System__c = crmSystem.Id, LeadReceivingStartDate_DT__c=System.NOW()-12,Dealer_Subdivision__c =dd.id);
       
     // insert dealerParticipationList;
        
    //    List<Account> alist = new List<Account>();
        //Account ac = new Account(name ='Grazittii' ,DealerCode_CD__c='301514',DealerAccessLevel_TXT__c='Full Access', recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Dealer').getRecordTypeId()) ;
        //alist.add(ac); 
        //Account ac1 = new Account(name ='Grazitti' ,DealerCode_CD__c='301514',DealerAccessLevel_TXT__c='Full Access', recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Dealer').getRecordTypeId()) ;
        //alist.add(ac1); 
        Account ac5 = new Account(name ='abe:xyz:' , SubDivision_TXT__c='Honda',Routable_FLG__c=false ,recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider').getRecordTypeId()) ;
        Account pro = new Account(name ='abc',SubDivision_TXT__c='Honda',Routable_FLG__c=true , recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider').getRecordTypeId()) ;
        Account pro1 = new Account(name ='rty',SubDivision_TXT__c='Honda',Routable_FLG__c=false , Send_to_Urban_Science_Flag__c = false, recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider').getRecordTypeId()) ;
        Account pro2 = new Account(name ='abcde',SubDivision_TXT__c='Motorcycle',Routable_FLG__c=true , recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider').getRecordTypeId()) ;
        List<Account> accList3 = new List<Account>();
        accList3.add(ac5);
        accList3.add(pro);
        accList3.add(pro1);
        accList3.add(pro2); 
        insert accList3;
       
        for(Account ad : accList3){
       //     System.debug('Provider ID : '+ad.Id);
      //     System.debug('SubDivision_TXT__c : '+ad.SubDivision_TXT__c);
        }
        Lead lead = new Lead(LastName='Doe1',FirstName='John',Lead_Group_ID__c = '123',Company='Test',Status='New',StatusReason_TXT__c='',
                             Dealer_Ids_ID__c='testing',Year_YR__c='test',Model_TXT__c='demoooo',phone='7894563212',PostalCode='50081',
                             Model_ID__c='demo',Trim_TXT__c='trimmer',SubDiv_TXT__c='Honda', PreferredDealerAccount_ID__c=acc.id , ProviderDetail_TXT__c='abe:xyz:',LeadProvider_ID__c = ac5.id,
                             PreferredDealerNumber_NUM__c='301514',Division_CD__c='A',VehicleInterest_TXT__c='buy',
                            ContactKey_TXT__c ='test',VehicleStatus_TXT__c='New',Condition_TXT__c='excellent',
                             Number_NM__c='number',Doors_TXT__c='doortxt',BodyStyle_TXT__c='bodyStyle',Odometer_TXT__c='odmeter',
                             Color_TXT__c='<colorcombination><interiorcolor>Gray</interiorcolor><exteriorcolor>Basque Red</exteriorcolor><preference>1</preference></colorcombination>',
                             OdometerStatus_TXT__c='unknown',OdometerUnits_TXT__c='kilometer');
        Lead lead1 = new Lead(LastName='Doe1',FirstName='John',Lead_Group_ID__c = '123',Company='Test',Status='New',StatusReason_TXT__c='',
                             Dealer_Ids_ID__c='testing',Year_YR__c='test',Model_TXT__c='demoooo',phone='7894563212',PostalCode='50081',
                             Model_ID__c='demo',Trim_TXT__c='trimmer',SubDiv_TXT__c='Honda', PreferredDealerAccount_ID__c=acc.id , ProviderDetail_TXT__c='abe:xyz:',LeadProvider_ID__c = ac5.id,
                             PreferredDealerNumber_NUM__c='301514',Division_CD__c='A',VehicleInterest_TXT__c='buy',
                            ContactKey_TXT__c ='test',VehicleStatus_TXT__c='New',Condition_TXT__c='excellent',
                             Number_NM__c='number',Doors_TXT__c='doortxt',BodyStyle_TXT__c='bodyStyle',Odometer_TXT__c='odmeter',
                             Color_TXT__c='<colorcombination><interiorcolor>Gray</interiorcolor><exteriorcolor>Basque Red</exteriorcolor><preference>1</preference></colorcombination>',
                             OdometerStatus_TXT__c='unknown',OdometerUnits_TXT__c='kilometer');
        
        // start - bruno test
        Lead lead2 = new Lead(LastName='Doe22',FirstName='Johns',Lead_Group_ID__c = '123',Company='Test',Status='New',StatusReason_TXT__c='',
                             Dealer_Ids_ID__c='testing',Year_YR__c='test',Model_TXT__c='demoooo',phone='7894563212',PostalCode='50081',
                             Model_ID__c='demo',Trim_TXT__c='trimmer',SubDiv_TXT__c='Motorcycle', PreferredDealerAccount_ID__c=acc2.id , ProviderDetail_TXT__c='abcde',LeadProvider_ID__c = pro2.id,
                             PreferredDealerNumber_NUM__c='301514',Division_CD__c='M',VehicleInterest_TXT__c='buy',
                            ContactKey_TXT__c ='test',VehicleStatus_TXT__c='New',Condition_TXT__c='excellent',
                             Number_NM__c='number',Doors_TXT__c='doortxt',BodyStyle_TXT__c='bodyStyle',Odometer_TXT__c='odmeter',
                             Color_TXT__c='<colorcombination><interiorcolor>Gray</interiorcolor><exteriorcolor>Basque Red</exteriorcolor><preference>1</preference></colorcombination>',
                             OdometerStatus_TXT__c='unknown',OdometerUnits_TXT__c='kilometer');
        // end - bruno test
        
        Lead lead3 = new Lead(LastName='Doe1',FirstName='John',Lead_Group_ID__c = '123',Company='Test',Status='New',StatusReason_TXT__c='',
                             Dealer_Ids_ID__c='testing',Year_YR__c='test',Model_TXT__c='demoooo',phone='7894563212',PostalCode='50081',
                             Model_ID__c='demo',Trim_TXT__c='trimmer',SubDiv_TXT__c='Honda', PreferredDealerAccount_ID__c=acc1.id , ProviderDetail_TXT__c='abe:xyz:',LeadProvider_ID__c = pro.id,
                             PreferredDealerNumber_NUM__c='301514',Division_CD__c='A',VehicleInterest_TXT__c='buy',
                            ContactKey_TXT__c ='test',VehicleStatus_TXT__c='New',Condition_TXT__c='excellent',
                             Number_NM__c='number',Doors_TXT__c='doortxt',BodyStyle_TXT__c='bodyStyle',Odometer_TXT__c='odmeter',
                             Color_TXT__c='<colorcombination><interiorcolor>Gray</interiorcolor><exteriorcolor>Basque Red</exteriorcolor><preference>1</preference></colorcombination>',
                             OdometerStatus_TXT__c='unknown',OdometerUnits_TXT__c='kilometer');
        Lead lead4 = new Lead(LastName='Doe2',FirstName='John',Lead_Group_ID__c = '123',Company='Test',Status='New',StatusReason_TXT__c='',
                             Dealer_Ids_ID__c='testing',Year_YR__c='test',Model_TXT__c='demoooo',phone='7894563212',PostalCode='50081',
                             Model_ID__c='demo',Trim_TXT__c='trimmer',SubDiv_TXT__c='Honda', PreferredDealerAccount_ID__c=acc1.id , ProviderDetail_TXT__c='abe:xyz:',LeadProvider_ID__c = pro1.id,
                             PreferredDealerNumber_NUM__c='301514',Division_CD__c='A',VehicleInterest_TXT__c='buy',
                            ContactKey_TXT__c ='test',VehicleStatus_TXT__c='New',Condition_TXT__c='excellent',
                             Number_NM__c='number',Doors_TXT__c='doortxt',BodyStyle_TXT__c='bodyStyle',Odometer_TXT__c='odmeter',
                             Color_TXT__c='<colorcombination><interiorcolor>Gray</interiorcolor><exteriorcolor>Basque Red</exteriorcolor><preference>1</preference></colorcombination>',
                             OdometerStatus_TXT__c='unknown',OdometerUnits_TXT__c='kilometer');
        List<Lead> leadRecList = new List<Lead>();
        leadRecList.add(lead);
        leadRecList.add(lead1);
        leadRecList.add(lead2);
        leadRecList.add(lead3);
        leadRecList.add(lead4);
        insert leadRecList;
        //insert lead;
        //insert lead1;
        //insert lead3;
        //insert lead4;
        
        Opportunity oppRec = new Opportunity(RecordTypeId=oppHondaRecTypeId,Name='OPpForRout1',Lead_Group_ID__c = '123',StageName='In Conversation',PreferredDealerAccount_TXT__c=acc.id, Email__c='abc@test.com', ZipCode_TXT__c='12345',MSRP_AMT__c=200,Quote_AMT__c=500,
                                SubDiv_TXT__c='Honda', External_ID__c='12345',CloseDate=system.today() , First_Name_TXT__c='Test opp19', Last_Name_TXT__c ='Test opp LAst91', LeadProvider_ID__c=ac5.id,
                                Options_TXT__c='<option><optionname>Sport</optionname><manufacturercode>p394</manufacturercode><stock>100</stock><weighting>65</weighting><price>19500</price></option><option><optionname>Sport</optionname><manufacturercode>p394</manufacturercode><stock>100</stock><weighting>65</weighting><price type="invoice" currency="USD" source="Kelley Blue Book">19500</price><price type="appraisal" currency="USD" delta="percentage" relativeto="invoice" source="KBB"/><price type="msrp" currency="USD" delta="relative" relativeto="invoice" source="KBB">200</price><price type="quote" currency="USD" delta="absolute">19000</price><price type="offer" currency="USD" delta="relative" relativeto="invoice" source="KBB">200</price><price type="call" currency="USD" delta="percentage" relativeto="msrp">2</price><price type="asking" currency="USD" delta="percentage" relativeto="msrp">2</price></option>'
                                );
        
        
        Opportunity oppRec2 = new Opportunity(RecordTypeId=oppHondaRecTypeId,Name='OPpForRout2',Lead_Group_ID__c = '123',StageName='In Conversation',PreferredDealerAccount_TXT__c=acc.id, Email__c='abc2@test.com', ZipCode_TXT__c='12345',MSRP_AMT__c=200,Quote_AMT__c=500,
                                SubDiv_TXT__c='Honda', External_ID__c='12345',CloseDate=system.today() , First_Name_TXT__c='Test opp19', Last_Name_TXT__c ='Test opp LAst932', LeadProvider_ID__c=acc.id,
                                Options_TXT__c='<option><optionname>Sport</optionname><manufacturercode>p394</manufacturercode><stock>100</stock><weighting>65</weighting><price>19500</price></option><option><optionname>Sport</optionname><manufacturercode>p394</manufacturercode><stock>100</stock><weighting>65</weighting><price type="invoice" currency="USD" source="Kelley Blue Book">19500</price><price type="appraisal" currency="USD" delta="percentage" relativeto="invoice" source="KBB"/><price type="msrp" currency="USD" delta="relative" relativeto="invoice" source="KBB">200</price><price type="quote" currency="USD" delta="absolute">19000</price><price type="offer" currency="USD" delta="relative" relativeto="invoice" source="KBB">200</price><price type="call" currency="USD" delta="percentage" relativeto="msrp">2</price><price type="asking" currency="USD" delta="percentage" relativeto="msrp">2</price></option>'
                                );
        Opportunity oppRec3 = new Opportunity(RecordTypeId=oppHondaRecTypeId,Name='OPpForRout3',Lead_Group_ID__c = '1235',StageName='In Conversation',PreferredDealerAccount_TXT__c=acc.id, Email__c='abc12@test.com', ZipCode_TXT__c='12345',MSRP_AMT__c=200,Quote_AMT__c=500,
                                SubDiv_TXT__c='Honda', External_ID__c='12345',CloseDate=system.today() , First_Name_TXT__c='Test opp19', Last_Name_TXT__c ='Test opp LAst933', LeadProvider_ID__c=pro.id,
                                Options_TXT__c='');
        Opportunity oppRec4 = new Opportunity(RecordTypeId=oppHondaRecTypeId,Name='OPpForRout4',Lead_Group_ID__c = '1234',StageName='Closed Won',PreferredDealerAccount_TXT__c=acc.id, Email__c='abc22@test.com', ZipCode_TXT__c='12345',MSRP_AMT__c=200,Quote_AMT__c=500,
                                SubDiv_TXT__c='Honda', External_ID__c='12345',CloseDate=system.today() , First_Name_TXT__c='Test opp19', Last_Name_TXT__c ='Test opp LAst934', LeadProvider_ID__c=pro1.id,
                                Options_TXT__c='');
        
        // start - bruno test
        Opportunity oppRec5 = new Opportunity(RecordTypeId=oppHondaRecTypeId,Name='OPpForRout5',Lead_Group_ID__c = '123',StageName='Closed Inactive',PreferredDealerAccount_TXT__c=acc2.id, Email__c='abc92@test.com', ZipCode_TXT__c='12345',MSRP_AMT__c=200,Quote_AMT__c=500,
                                SubDiv_TXT__c='Honda', External_ID__c='12345',CloseDate=system.today() , First_Name_TXT__c='Test opp29', Last_Name_TXT__c ='Test opp LAst93429', LeadProvider_ID__c=pro2.id,
                                Options_TXT__c='');
        // end - bruno test
        
        
        test.StartTest();
        List<Opportunity> oplist = new List<Opportunity>();
        oplist.add(oppRec);
        oplist.add(oppRec2);
        oplist.add(oppRec3);
        oplist.add(oppRec4);
        oplist.add(oppRec5);
        insert oplist;
        Set<String> leadGroupIdSet = new Set<String>();
        Set<String> leadGroupIdSet1 = new Set<String>();
        HELMSOpportunityHandler oppHandler = new HELMSOpportunityHandler();
        Map<string,opportunity> oppmap = new Map<string,opportunity>(); 
        for(Opportunity opp: oplist){
                //System.debug('DEBUG 3');
                if( (opp.StageName == 'Closed Won' || opp.StageName == 'Closed Lost' || opp.StageName == 'Closed Inactive' ) && (opp.Lead_Group_ID__c!=null)){
                    //System.debug('DEBUG 4');
                    leadGroupIdSet.add(opp.Lead_Group_ID__c);
                    oppmap.put(opp.Lead_Group_ID__c, opp);
                }
            }
        for(Lead lrec : leadRecList){
            leadGroupIdSet1.add(lrec.Lead_Group_ID__c);
        }
        oppHandler.updateSameLeadGroupIdLeads(leadGroupIdSet, oppmap); // Sending the Opportunity Map to Handler
        oppHandler.updateSameLeadGroupIdLeads(leadGroupIdSet1, oppmap); // Sending the Opportunity Map to Handler
        //insert OppRec;
        //insert OppRec2;
        //insert OppRec3;insert OppRec4;
        Test.stopTest();
            
    }
    
    
  /*  public static testMethod void handleSendMail(){          
        Test.startTest();
         Set <String> stringEmail = new Set < String > ();
         List <String> EmailTemplate = new List < String > ();
        EmailTemplate et =[Select id, Subject, Body from EmailTemplate where name =: 'NewOpportunity'];
        et.Body= 'EmailTemplate';
        et.Subject= 'NewOpportunity Created';
        Test.stopTest();
                      
    }*/

}