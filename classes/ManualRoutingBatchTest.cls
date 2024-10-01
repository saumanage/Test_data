@isTest (isParallel=false)
public class ManualRoutingBatchTest 
{
   
    @isTest static void testMethodM1() 
    {
           UserRole r = new UserRole(DeveloperName = 'HELMS_Standard', Name = 'HELMS_Standard');
        insert r;
        //System.debug('r'+r);

             Profile profile_1 = [SELECT Id FROM Profile WHERE Name = 'Partner Community User' LIMIT 1];  
            Profile profile_2 = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
            User admin = new User( 
            Email = 'Test123username@gmail.com',
            ProfileId = profile_2.Id, 
            UserRoleId = r.Id,
            UserName = 'Test31name@gmail.com', 
            Alias = 'Test',
            TimeZoneSidKey = 'America/New_York',
            EmailEncodingKey = 'ISO-8859-1',
            LocaleSidKey = 'en_US', 
            LanguageLocaleKey = 'en_US',
            PortalRole = 'Manager',
            FirstName = 'Firstname',
            LastName = 'Lastname'
        );
        insert admin;
        //System.debug('admin'+admin);
        
        User user_1;
        
         System.runAs(admin) {  
             
        List<Account> alist = new List<Account>();
            Account ac3 = new Account(name ='Grazitti', DealerCode_CD__c='30Z514', recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Dealer').getRecordTypeId()) ;
            
            insert ac3;
            ac3.name ='Grazitti';
           
            alist.add(ac3); 
            update alist;
             
            Id conRecordTypeId = Schema.SObjectType.contact.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
            Contact conTestRec = new Contact(FirstName='YashLead1234',LastName='Record1234',Email='yash1234@testing.com',Title='Mr',
                                             AccountId=alist[0].Id,RecordTypeId=conRecordTypeId,HelmsCRMEligible_FLAG__c=false);
            insert conTestRec;
            
                      
        
            user_1 = new User( 
                Email = 'Test1233username@gmail.com',
              //  ProfileId = '00e7c000000I2AVAA0', 
                   ProfileId =  profile_1.Id, 
             //   UserRoleId = r.Id,
                UserName = 'Test321name@gmail.com', 
                Alias = 'Test',
                TimeZoneSidKey = 'America/New_York',
                EmailEncodingKey = 'ISO-8859-1',
                IsActive = true,
                LocaleSidKey = 'en_US', 
                LanguageLocaleKey = 'en_US',
                ContactId = conTestRec.Id,
                PortalRole = 'Manager',
                FirstName = 'Firstname',
                LastName = 'Lastname'
            );
            insert user_1;
         }
        
            System.runAs(admin) {  
         Dealer_Deprovision__c dp1=new Dealer_Deprovision__c(FirstName__c='Carl101',LastName__c='TEST101',
                            Dealer_Number__c='313975');
          dp1.CreatedDate= system.now();  
        insert dp1;
          }

                Test.startTest();
        System.runAs(user_1) {
            System.assertEquals(UserInfo.getUserId(), user_1.Id);
            // your test code for Salesforce Community
        }
         ManualRoutingBatch obj = new ManualRoutingBatch();
            DataBase.executeBatch(obj); 
        Test.stopTest();
 

               }
     @isTest static void updateOpportunityOnDealerAcknowledgementM2(){
          List<Opportunity> routableOpportunity1=new List<Opportunity>(); 
         
      Id devRecordTypeId = Schema.getGlobalDescribe().get('Opportunity').getDescribe().getRecordTypeInfosByName().get('Acura Opportunity').getRecordTypeId();
        //Id conRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Acura Opportunity').getRecordTypeId();
        Opportunity o = new Opportunity ();
        o.Name='test';
        o.Routable_FLG__c= true;
        //o.RecordTypeId = conRecordTypeId;
        o.Opportunity_SF_ID__c='20210810061445QBuOx';
       // o.Routing_Status__c='Success';
        o.Routing_Failure_Date_Time__c=system.now();
        o.Routing_Success_Date_Time__c=system.now();
        o.StageName='closed won';
        o.CloseDate=system.today();
        o.Email__c='ghou@gmail.com';
        o.ZipCode_TXT__c='89010';
        o.First_Name_TXT__c='test1';
        o.Last_Name_TXT__c='test2';
        o.Street_TXT__c='testing';
        o.AddressType_TXT__c='test Address';
        o.AppartmentNumber_TXT__c='122322';
        o.BodyStyle_TXT__c='body style';
        o.City_TXT__c='CA';
        o.Color_XML__c='Red';
        o.Condition_TXT__c='Fine';
        o.ContactTime_TXT__c='12:00AM';
        o.ContactType_TXT__c='Phone';
        o.ContactMethod_TXT__c='Call';
        o.Country_TXT__c='India';
        o.Customer_Ids_ID__c='12312SE1';
        o.DealerID_ID__c='ABEDF23';
        o.DealerAccountfromADF_TXT__c='Test';
        o.DealerContactfromADF_TXT__c='IND';
        o.Description='Test Description';
        //o.Division_CD__c='Acura';
        o.Doors_TXT__c='2';
        o.Email__c='testing@dealer.com';
        o.Fax__c='1232123';
        o.FinancialDetails_TXT__c='12,300';
        o.First_Name_TXT__c='Tester';
        o.Last_Name_TXT__c='Last name';
        o.Make_TXT__c='2011';
        o.Middle_Name_TXT__c='Testing';
        o.MiddlewareUUID__c='UUID';
        o.MobilePhone__c='983292321';
         o.Trim_TXT__c='trim';
         o.Model_TXT__c='2011';
         o.MSRP_AMT__c=1232;
        o.OdometerStatus_TXT__c='Open';
        o.Odometer_TXT__c='Meter';
        o.OdometerUnits_TXT__c='units';
        o.Options_TXT__c='Options';
        o.OtherContacts_TXT__c='other contacts';
        o.OtherLeadProvider_TXT__c='test lead';
        o.Pager_TXT__c='pageer';
        o.Phone__c='950238236';
        o.Prospect_Ids_ID__c='3112313';
        o.Provider_Ids_ID__c='2313';
        o.ProviderContactDetail_TXT__c='Test Contact';
        o.ProviderDetail_TXT__c='Test provider';
        o.PurchaseEarliestDate_DT__c='Yesterday';
        o.PurchaseLatestDate_DT__c='Last month';
        o.Quote_AMT__c=12;
        o.Source_Name__c='Sorce';
        o.SourceUser_TXT__c='Sorce User';
        o.State_TXT__c='CA';
        //o.SubDiv_TXT__c='Acura';
        o.Suffix_TXT__c='MR';
        o.TradeBalanceOwed_TXT__c='owed';
        o.TradeMake_TXT__c='trade';
        
        o.TradeMileage_TXT__c='12kmpl';
        o.TradeModel_TXT__c='2011';
        o.TradeStatus_TXT__c='Good';
        o.TradeValue_TXT__c='Open';
        o.TradeYear_YR__c='2011';
        o.Transmission_TXT__c='test';
        o.TriggerSendbyDate_DT__c=System.today();
        o.Vehicle_Ids_ID__c='232';
        o.VehicleInterest_TXT__c='Yes';
        o.Year_YR__c='2011';
        o.Number_NM__c = 'NM numgber';
        o.VehicleStatus_TXT__c='good';
        o.LeadAdditionalInfos__c ='<LeadAdditionalInfos><LeadAdditionalInfo key="PriceComment"/><LeadAdditionalInfo key="VehicleComment"/><LeadAdditionalInfo key="CustomerComment"/></LeadAdditionalInfos>';
        
        insert o;
        routableOpportunity1.add(o);
        ManualRoutingBatch obj = new ManualRoutingBatch(routableOpportunity1);
        
      
    }

         @isTest static void updateOpportunityOnDealerAcknowledgementM3(){
          List<Opportunity> routableOpportunity2=new List<Opportunity>(); 
         
      Id devRecordTypeId = Schema.getGlobalDescribe().get('Opportunity').getDescribe().getRecordTypeInfosByName().get('Acura Opportunity').getRecordTypeId();
        //Id conRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Acura Opportunity').getRecordTypeId();
        Opportunity o = new Opportunity ();
        o.Name='test';
        o.Routable_FLG__c= true;
        //o.RecordTypeId = conRecordTypeId;
        o.Opportunity_SF_ID__c='20210810061445QBuOx';
       // o.Routing_Status__c='Success';
        o.Routing_Failure_Date_Time__c=system.now();
        o.Routing_Success_Date_Time__c=system.now();
        o.StageName='closed won';
        o.CloseDate=system.today();
        o.Email__c='ghou@gmail.com';
        o.ZipCode_TXT__c='89010';
        o.First_Name_TXT__c='test1';
        o.Last_Name_TXT__c='test2';
        o.Street_TXT__c='testing';
        o.AddressType_TXT__c='test Address';
        o.AppartmentNumber_TXT__c='122322';
        o.BodyStyle_TXT__c='body style';
        o.City_TXT__c='CA';
        o.Color_XML__c='Red';
        o.Condition_TXT__c='Fine';
        o.ContactTime_TXT__c='12:00AM';
        o.ContactType_TXT__c='Phone';
        o.ContactMethod_TXT__c='Call';
        o.Country_TXT__c='India';
        o.Customer_Ids_ID__c='12312SE1';
        o.DealerID_ID__c='ABEDF23';
        o.DealerAccountfromADF_TXT__c='Test';
        o.DealerContactfromADF_TXT__c='IND';
        o.Description='Test Description';
        //o.Division_CD__c='Acura';
        o.Doors_TXT__c='2';
        o.Email__c='testing@dealer.com';
        o.Fax__c='1232123';
        o.FinancialDetails_TXT__c='12,300';
        o.First_Name_TXT__c='Tester';
        o.Last_Name_TXT__c='Last name';
        o.Make_TXT__c='2011';
        o.Middle_Name_TXT__c='Testing';
        o.MiddlewareUUID__c='UUID';
        o.MobilePhone__c='983292321';
         o.Trim_TXT__c='trim';
         o.Model_TXT__c='2011';
         o.MSRP_AMT__c=1232;
        o.OdometerStatus_TXT__c='Open';
        o.Odometer_TXT__c='Meter';
        o.OdometerUnits_TXT__c='units';
        o.Options_TXT__c='Options';
        o.OtherContacts_TXT__c='other contacts';
        o.OtherLeadProvider_TXT__c='test lead';
        o.Pager_TXT__c='pageer';
        o.Phone__c='950238236';
        o.Prospect_Ids_ID__c='3112313';
        o.Provider_Ids_ID__c='2313';
        o.ProviderContactDetail_TXT__c='Test Contact';
        o.ProviderDetail_TXT__c='Test provider';
        o.PurchaseEarliestDate_DT__c='Yesterday';
        o.PurchaseLatestDate_DT__c='Last month';
        o.Quote_AMT__c=12;
        o.Source_Name__c='Sorce';
        o.SourceUser_TXT__c='Sorce User';
        o.State_TXT__c='CA';
        //o.SubDiv_TXT__c='Acura';
        o.Suffix_TXT__c='MR';
        o.TradeBalanceOwed_TXT__c='owed';
        o.TradeMake_TXT__c='trade';
        
        o.TradeMileage_TXT__c='12kmpl';
        o.TradeModel_TXT__c='2011';
        o.TradeStatus_TXT__c='Good';
        o.TradeValue_TXT__c='Open';
        o.TradeYear_YR__c='2011';
        o.Transmission_TXT__c='test';
        o.TriggerSendbyDate_DT__c=System.today();
        o.Vehicle_Ids_ID__c='232';
        o.VehicleInterest_TXT__c='Yes';
        o.Year_YR__c='2011';
        o.Number_NM__c = 'NM numgber';
        o.VehicleStatus_TXT__c='good';
        o.LeadAdditionalInfos__c ='<LeadAdditionalInfos><LeadAdditionalInfo key="PriceComment"/><LeadAdditionalInfo key="VehicleComment"/><LeadAdditionalInfo key="CustomerComment"/></LeadAdditionalInfos>';
        
       insert o;
        routableOpportunity2.add(o);
             
           
         
        List<Lead_Dealer_Acknowledgement_ADF__e> lst = new List<Lead_Dealer_Acknowledgement_ADF__e>();
        Lead_Dealer_Acknowledgement_ADF__e LDA = new Lead_Dealer_Acknowledgement_ADF__e();
        LDA.Oppotunity_SF_ID__c='20210810061445QBuOx';
        LDA.Status_Code__c='0';
        Lead_Dealer_Acknowledgement_ADF__e LDA1 = new Lead_Dealer_Acknowledgement_ADF__e();
        LDA1.Oppotunity_SF_ID__c='20210810061445QBuOx';
        LDA1.Status_Code__c='2';
        lst.add(LDA);
        //insert lst;
        List<Database.SaveResult> sr = EventBus.publish(lst);
          Test.startTest();
             
           ManualRoutingBatch obj = new ManualRoutingBatch();
           DataBase.executeBatch(obj); 
           obj.execute(null,routableOpportunity2);
         
        HELMSLeadDealerAssignmentADFHandler hndlr = new HELMSLeadDealerAssignmentADFHandler();
        hndlr.updateOpportunityOnDealerAcknowledgement(lst);
        hndlr.newLeadDispositionADFs(routableOpportunity2);
        

        Test.stopTest();
 
        
      
    }
        
    }