@IsTest
public class HELMSOpportunityTriggerTest{

    @testSetup
    public static void testData()
    {
        Id dealerAccRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
        Account accTestRec = new Account(Name='Test Account123',RecordTypeId=dealerAccRecTypeId,
                                         DealerCode_CD__c='123456'
                                        );
        insert accTestRec;
        system.assertNotEquals(null, accTestRec.Id);
        
        Id conRecTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
        Contact conTestRec = new Contact(FirstName='YashLead1234',LastName='Record1234',Email='yash1234@testing.com',Title='Mr',
                                        AccountId=accTestRec.Id, RecordTypeId=conRecTypeId );
        insert conTestRec;
        
        Account accTestRec2 = new Account(Name='Test Account1232',RecordTypeId=dealerAccRecTypeId,
                                         DealerCode_CD__c='1234562'
                                        );
        insert accTestRec2;
        system.assertNotEquals(null, accTestRec.Id);
        Contact conTestRec2 = new Contact(FirstName='Yashead12342',LastName='Record12342',Email='yash12342@testing.com',Title='Mr',
                                        AccountId=accTestRec2.Id);
        //insert conTestRec2;
        
        Lead_Disposition_Last_Event_Status__c custom = new Lead_Disposition_Last_Event_Status__c(name='Test',StageName__c='Closed Won', Last_Event__c=2);
        insert custom;
    }
    
    @IsTest
    public static void handleOppUpdateInsertTest()
    {
        Id dealerAccRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
        Account acc = new Account(Name='Test Account12322',RecordTypeId=dealerAccRecTypeId,
                                         DealerCode_CD__c='1234'
                                        );
        insert acc;
        
         Account pro = new Account(name ='abc' ,  recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider').getRecordTypeId()) ;
        insert pro; 
            
        Opportunity OppRec = new Opportunity(Name='YashLead1234',StageName='In Conversation',PreferredDealerAccount_TXT__c=acc.id, Email__c='abc@test.com', ZipCode_TXT__c='12345',MSRP_AMT__c=200,Quote_AMT__c=500,
                                PreferredDealerNumber_NUM__c='1234', External_ID__c='12345',CloseDate=system.today() , First_Name_TXT__c='Test opp19', Last_Name_TXT__c ='Test opp LAst9', LeadProvider_ID__c=pro.id,
                                Options_TXT__c='<option><optionname>Sport</optionname><manufacturercode>p394</manufacturercode><stock>100</stock><weighting>65</weighting><price>19500</price></option><option><optionname>Sport</optionname><manufacturercode>p394</manufacturercode><stock>100</stock><weighting>65</weighting><price type="invoice" currency="USD" source="Kelley Blue Book">19500</price><price type="appraisal" currency="USD" delta="percentage" relativeto="invoice" source="KBB"/><price type="msrp" currency="USD" delta="relative" relativeto="invoice" source="KBB">200</price><price type="quote" currency="USD" delta="absolute">19000</price><price type="offer" currency="USD" delta="relative" relativeto="invoice" source="KBB">200</price><price type="call" currency="USD" delta="percentage" relativeto="msrp">2</price><price type="asking" currency="USD" delta="percentage" relativeto="msrp">2</price></option>'
                                );
                                
        Test.startTest();
        insert OppRec;
        OppRec.StageName='Closed Won';
        OppRec.CloseDate=system.today();
        update OppRec;
        /*
        string json = '[{"optionname": "Sport","manufacturercode": "p394","stock": "100","weighting": "65"},{"optionname": "Sport","manufacturercode": "p394","stock": "100","weighting": "65"}]';
        System.JSONParser parser = System.JSON.createParser(json);
        OptionsJSON2Apex.parse(json);
        */
        Test.stopTest();
        
    }    
    
    @IsTest
    public static void JsonTest() {
       
        UserRole r = new UserRole(DeveloperName = 'HELMS_Standard', Name = 'HELMS_Standard');
        insert r;      
       Profile profile_2 = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
            User admin = new User( 
            Email = 'Test1239username@gmail.com',
            ProfileId = profile_2.Id, 
            UserRoleId = r.Id,
            UserName = 'Test391nameAdminass@gmail.com', 
            Alias = 'Test',
            TimeZoneSidKey = 'America/New_York',
            EmailEncodingKey = 'ISO-8859-1',
            LocaleSidKey = 'en_US', 
            LanguageLocaleKey = 'en_US',
            PortalRole = 'Manager',
            FirstName = 'AdminFirstname',
            LastName = 'AdminLastname'
        );
        insert admin;
        User user;
        Account acc;
        Contact con;
        Account pro;
      System.runAs(admin){
        Id p = [select id from profile where name='HELMS Partner Community'].id;

        Id dealerAccRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
         acc = new Account(Name='Test Account123',RecordTypeId=dealerAccRecTypeId,
                                         DealerCode_CD__c='515722'
                                        );
        insert acc;
        
        Id conRecTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
        con = new Contact(FirstName='YashLead1234',LastName='Record1234',Email='yash1234@testing.com',Title='Mr',
                                        AccountId=acc.Id, RecordTypeId=conRecTypeId );
        insert con;
                
        pro = new Account(name ='Acura Dealer Created' ,  recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider').getRecordTypeId()) ;
        insert pro; 
        
        user = new User(alias = 'mamavv', email='test123@noemail.com',
        emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
        localesidkey='en_US', profileid = p, country='United States',IsActive =true,
        ContactId = con.Id,
        timezonesidkey='America/Los_Angeles', username='testermamathalaa@noemail.com');

        insert user;
        }
        system.runAs(user) {
        // statements to be executed by this test user.
        pro = new Account(name ='abc' ,  recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider').getRecordTypeId()) ;
        insert pro; 
            Opportunity oppRec = new Opportunity(Name='YashLead1234',StageName='In Conversation',PreferredDealerAccount_TXT__c=acc.id, Email__c='yash1234@testing.com', ZipCode_TXT__c='12345',MSRP_AMT__c=200,Quote_AMT__c=500,
                                    PreferredDealerNumber_NUM__c='515722', External_ID__c='12345',CloseDate=system.today() ,First_Name_TXT__c='Test opp1', Last_Name_TXT__c ='Test opp LAst', 
                                  LeadProvider_ID__c=pro.id,  Options_TXT__c='<option><optionname>Sport</optionname><manufacturercode>p394</manufacturercode><stock>100</stock><weighting>65</weighting><price type="invoice" currency="USD" source="Kelley Blue Book">19500</price><price type="appraisal" currency="USD" delta="percentage" relativeto="invoice" source="KBB"/><price type="msrp" currency="USD" delta="relative" relativeto="invoice" source="KBB">200</price><price type="quote" currency="USD" delta="absolute">19000</price><price type="offer" currency="USD" delta="relative" relativeto="invoice" source="KBB">200</price><price type="call" currency="USD" delta="percentage" relativeto="msrp">2</price><price type="asking" currency="USD" delta="percentage" relativeto="msrp">2</price></option>'
                                    );
            Opportunity oppRec2 = new Opportunity(Name='YashLead1234',StageName='In Conversation',PreferredDealerAccount_TXT__c=acc.id, Email__c='yash1234@testing.com', ZipCode_TXT__c='12345',MSRP_AMT__c=200,Quote_AMT__c=500,
                                    PreferredDealerNumber_NUM__c='515722', External_ID__c='12345',CloseDate=system.today() ,Division_CD__c='A', SubDiv_TXT__c='Honda', First_Name_TXT__c='Test opp12', Last_Name_TXT__c ='Test opp LAst2', 
                                    RecordTypeId=Schema.SObjectType.opportunity.getRecordTypeInfosByDeveloperName().get('Honda').getRecordTypeId(),
                                    LeadProvider_ID__c=pro.id, Options_TXT__c='<option><optionname>Sport</optionname><manufacturercode>p394</manufacturercode><stock>100</stock><weighting>65</weighting><price type="invoice" currency="USD" source="Kelley Blue Book">19500</price><price type="appraisal" currency="USD" delta="percentage" relativeto="invoice" source="KBB"/><price type="msrp" currency="USD" delta="relative" relativeto="invoice" source="KBB">200</price><price type="quote" currency="USD" delta="absolute">19000</price><price type="offer" currency="USD" delta="relative" relativeto="invoice" source="KBB">200</price><price type="call" currency="USD" delta="percentage" relativeto="msrp">2</price><price type="asking" currency="USD" delta="percentage" relativeto="msrp">2</price></option>'
                                    );
            Opportunity oppRec3 = new Opportunity(Name='YashLead1234',StageName='In Conversation',PreferredDealerAccount_TXT__c=acc.id, Email__c='yash1234@testing.com', ZipCode_TXT__c='12345',MSRP_AMT__c=200,Quote_AMT__c=500,
                                    PreferredDealerNumber_NUM__c='515722', External_ID__c='12345',CloseDate=system.today() , Division_CD__c='B', SubDiv_TXT__c='Acura', First_Name_TXT__c='Test opp13', Last_Name_TXT__c ='Test opp LAst3', 
                                    RecordTypeId=Schema.SObjectType.opportunity.getRecordTypeInfosByDeveloperName().get('Acura').getRecordTypeId(),
                                   LeadProvider_ID__c=pro.id,  Options_TXT__c='<option><optionname>Sport</optionname><manufacturercode>p394</manufacturercode><stock>100</stock><weighting>65</weighting><price type="invoice" currency="USD" source="Kelley Blue Book">19500</price><price type="appraisal" currency="USD" delta="percentage" relativeto="invoice" source="KBB"/><price type="msrp" currency="USD" delta="relative" relativeto="invoice" source="KBB">200</price><price type="quote" currency="USD" delta="absolute">19000</price><price type="offer" currency="USD" delta="relative" relativeto="invoice" source="KBB">200</price><price type="call" currency="USD" delta="percentage" relativeto="msrp">2</price><price type="asking" currency="USD" delta="percentage" relativeto="msrp">2</price></option>'
                                    );
            Opportunity oppRec7 = new Opportunity(Name='YashLead1234',StageName='In Conversation',PreferredDealerAccount_TXT__c=acc.id, Email__c='yash1234@testing.com', ZipCode_TXT__c='12345',MSRP_AMT__c=200,Quote_AMT__c=500,
                                    PreferredDealerNumber_NUM__c='515722', External_ID__c='12345',CloseDate=system.today() , Division_CD__c='P', SubDiv_TXT__c='Engine', First_Name_TXT__c='Test opp14', Last_Name_TXT__c ='Test opp LAst4', 
                                    RecordTypeId=Schema.SObjectType.opportunity.getRecordTypeInfosByDeveloperName().get('Engine').getRecordTypeId(),
                                    LeadProvider_ID__c=pro.id, Options_TXT__c='<option><optionname>Sport</optionname><manufacturercode>p394</manufacturercode><stock>100</stock><weighting>65</weighting><price type="invoice" currency="USD" source="Kelley Blue Book">19500</price><price type="appraisal" currency="USD" delta="percentage" relativeto="invoice" source="KBB"/><price type="msrp" currency="USD" delta="relative" relativeto="invoice" source="KBB">200</price><price type="quote" currency="USD" delta="absolute">19000</price><price type="offer" currency="USD" delta="relative" relativeto="invoice" source="KBB">200</price><price type="call" currency="USD" delta="percentage" relativeto="msrp">2</price><price type="asking" currency="USD" delta="percentage" relativeto="msrp">2</price></option>'
                                    );
            Opportunity oppRec4 = new Opportunity(Name='YashLead1234',StageName='In Conversation',PreferredDealerAccount_TXT__c=acc.id, Email__c='yash1234@testing.com', ZipCode_TXT__c='12345',MSRP_AMT__c=200,Quote_AMT__c=500,
                                    PreferredDealerNumber_NUM__c='515722', External_ID__c='12345',CloseDate=system.today() , Division_CD__c='M', SubDiv_TXT__c='Motorcycle', First_Name_TXT__c='Test opp15', Last_Name_TXT__c ='Test opp LAst5', 
                                    RecordTypeId=Schema.SObjectType.opportunity.getRecordTypeInfosByDeveloperName().get('Power_Sports').getRecordTypeId(),
                                    LeadProvider_ID__c=pro.id, Options_TXT__c='<option><optionname>Sport</optionname><manufacturercode>p394</manufacturercode><stock>100</stock><weighting>65</weighting><price type="invoice" currency="USD" source="Kelley Blue Book">19500</price><price type="appraisal" currency="USD" delta="percentage" relativeto="invoice" source="KBB"/><price type="msrp" currency="USD" delta="relative" relativeto="invoice" source="KBB">200</price><price type="quote" currency="USD" delta="absolute">19000</price><price type="offer" currency="USD" delta="relative" relativeto="invoice" source="KBB">200</price><price type="call" currency="USD" delta="percentage" relativeto="msrp">2</price><price type="asking" currency="USD" delta="percentage" relativeto="msrp">2</price></option>'
                                    );
            Opportunity oppRec5 = new Opportunity(Name='YashLead1234',StageName='In Conversation',PreferredDealerAccount_TXT__c=acc.id, Email__c='yash1234@testing.com', ZipCode_TXT__c='12345',MSRP_AMT__c=200,Quote_AMT__c=500,
                                    PreferredDealerNumber_NUM__c='515722', External_ID__c='12345',CloseDate=system.today() , Division_CD__c='P', SubDiv_TXT__c='PowerEquipment', First_Name_TXT__c='Test opp16', Last_Name_TXT__c ='Test opp LAst6', 
                                    RecordTypeId=Schema.SObjectType.opportunity.getRecordTypeInfosByDeveloperName().get('Power_Equipment').getRecordTypeId(),
                                    LeadProvider_ID__c=pro.id, Options_TXT__c='<option><optionname>Sport</optionname><manufacturercode>p394</manufacturercode><stock>100</stock><weighting>65</weighting><price type="invoice" currency="USD" source="Kelley Blue Book">19500</price><price type="appraisal" currency="USD" delta="percentage" relativeto="invoice" source="KBB"/><price type="msrp" currency="USD" delta="relative" relativeto="invoice" source="KBB">200</price><price type="quote" currency="USD" delta="absolute">19000</price><price type="offer" currency="USD" delta="relative" relativeto="invoice" source="KBB">200</price><price type="call" currency="USD" delta="percentage" relativeto="msrp">2</price><price type="asking" currency="USD" delta="percentage" relativeto="msrp">2</price></option>'
                                    );
            Opportunity oppRec6 = new Opportunity(Name='YashLead1234',StageName='In Conversation',PreferredDealerAccount_TXT__c=acc.id, Email__c='yash1234@testing.com', ZipCode_TXT__c='12345',MSRP_AMT__c=200,Quote_AMT__c=500,
                                    PreferredDealerNumber_NUM__c='515722', External_ID__c='12345',CloseDate=system.today() , Division_CD__c='B', SubDiv_TXT__c='Acura', First_Name_TXT__c='Test opp17', Last_Name_TXT__c ='Test opp LAst7',
                                   LeadProvider_ID__c=pro.id,  RecordTypeId=Schema.SObjectType.opportunity.getRecordTypeInfosByDeveloperName().get('Acura').getRecordTypeId(), Total_Quote_AMT__c=100
                                     );
            Test.startTest();
            List<Opportunity> opplist = new List<Opportunity>();
            opplist.add(oppRec);
            opplist.add(oppRec2);
            opplist.add(oppRec3);
            //opplist.add(OppRec4);
            //opplist.add(OppRec5);
            //opplist.add(OppRec6);
            //opplist.add(OppRec7);
            insert opplist;
           
            OppRec.StageName='Closed Won';
            OppRec.CloseDate=system.today();
            update oppRec;

        }
    }
@IsTest
    public static void JsonTest1() {
       
        UserRole r = new UserRole(DeveloperName = 'HELMS_Standard', Name = 'HELMS_Standard');
        insert r;      
       Profile profile_2 = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
            User admin = new User( 
            Email = 'Test1239username@gmail.com',
            ProfileId = profile_2.Id, 
            UserRoleId = r.Id,
            UserName = 'Test391nameAdminass@gmail.com', 
            Alias = 'Test',
            TimeZoneSidKey = 'America/New_York',
            EmailEncodingKey = 'ISO-8859-1',
            LocaleSidKey = 'en_US', 
            LanguageLocaleKey = 'en_US',
            PortalRole = 'Manager',
            FirstName = 'AdminFirstname',
            LastName = 'AdminLastname'
        );
        insert admin;
        User user;
        Account acc;
        Contact con;
        Account pro;
      System.runAs(admin){
        Id p = [select id from profile where name='HELMS Partner Community'].id;

        Id dealerAccRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
         acc = new Account(Name='Test Account123',RecordTypeId=dealerAccRecTypeId,
                                         DealerCode_CD__c='515722'
                                        );
        insert acc;
        
        Id conRecTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
        con = new Contact(FirstName='YashLead1234',LastName='Record1234',Email='yash1234@testing.com',Title='Mr',
                                        AccountId=acc.Id, RecordTypeId=conRecTypeId );
        insert con;
                
        pro = new Account(name ='Honda Dealer Created' ,  recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider').getRecordTypeId()) ;
        //insert pro; 
        
        user = new User(alias = 'mamavv', email='test123@noemail.com',
        emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
        localesidkey='en_US', profileid = p, country='United States',IsActive =true,
        ContactId = con.Id,
        timezonesidkey='America/Los_Angeles', username='testermamathalaa@noemail.com');

        insert user;
        }
        system.runAs(user) {
        // statements to be executed by this test user.
        pro = new Account(name ='Honda Dealer Created' ,  recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider').getRecordTypeId()) ;
        insert pro;
        Account pro1 = new Account(name ='Acura Dealer Created' ,  recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider').getRecordTypeId()) ;
        insert pro1;
            Account pro2 = new Account(name ='Engine Dealer Created' ,  recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider').getRecordTypeId()) ;
        insert pro2;
            Account pro3 = new Account(name ='Motorcycle Dealer Created' ,  recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider').getRecordTypeId()) ;
        insert pro3;
            Account pro4 = new Account(name ='werEquipment Dealer Created' ,  recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider').getRecordTypeId()) ;
        insert pro4;
            Account pro5 = new Account(name ='Marine Dealer Created' ,  recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider').getRecordTypeId()) ;
        insert pro5;
            Test.startTest();
            Opportunity OppRec21 = new Opportunity(Name='YashLead1234',StageName='In Conversation',PreferredDealerAccount_TXT__c=acc.id, Email__c='yash1234@testing.com', ZipCode_TXT__c='12345',MSRP_AMT__c=200,Quote_AMT__c=500,
                                    PreferredDealerNumber_NUM__c='515722', External_ID__c='12345',CloseDate=system.today() ,Division_CD__c='A', SubDiv_TXT__c='Honda', First_Name_TXT__c='Test opp12', Last_Name_TXT__c ='Test opp LAst2', 
                                    RecordTypeId=Schema.SObjectType.opportunity.getRecordTypeInfosByDeveloperName().get('Honda').getRecordTypeId(),
                                    LeadProvider_ID__c=pro.id, Options_TXT__c='<option><optionname>Sport</optionname><manufacturercode>p394</manufacturercode><stock>100</stock><weighting>65</weighting><price type="invoice" currency="USD" source="Kelley Blue Book">19500</price><price type="appraisal" currency="USD" delta="percentage" relativeto="invoice" source="KBB"/><price type="msrp" currency="USD" delta="relative" relativeto="invoice" source="KBB">200</price><price type="quote" currency="USD" delta="absolute">19000</price><price type="offer" currency="USD" delta="relative" relativeto="invoice" source="KBB">200</price><price type="call" currency="USD" delta="percentage" relativeto="msrp">2</price><price type="asking" currency="USD" delta="percentage" relativeto="msrp">2</price></option>'
                                    );
            insert OppRec21;
            OppRec21.LeadProvider_ID__c = null;
            update OppRec21;
            OppRec21.LeadProvider_ID__c = null;
            OppRec21.SubDiv_TXT__c='Acura';
            OppRec21.Division_CD__c= 'B';
            OppRec21.RecordTypeId = Schema.SObjectType.opportunity.getRecordTypeInfosByDeveloperName().get('Acura').getRecordTypeId();
            //update OppRec21;
            OppRec21.LeadProvider_ID__c = null;
            OppRec21.SubDiv_TXT__c='Engine';
            OppRec21.Division_CD__c= 'P';
            OppRec21.RecordTypeId = Schema.SObjectType.opportunity.getRecordTypeInfosByDeveloperName().get('Engine').getRecordTypeId();
            /*update OppRec21;
            OppRec21.LeadProvider_ID__c = null;
            OppRec21.SubDiv_TXT__c='Motorcycle';
            OppRec21.Division_CD__c= 'M';
            OppRec21.RecordTypeId = Schema.SObjectType.opportunity.getRecordTypeInfosByDeveloperName().get('Power_Sports').getRecordTypeId();
            //update OppRec21;
            OppRec21.LeadProvider_ID__c = null;
            OppRec21.SubDiv_TXT__c='PowerEquipment';
            OppRec21.Division_CD__c= 'P';
            OppRec21.RecordTypeId = Schema.SObjectType.opportunity.getRecordTypeInfosByDeveloperName().get('Power_Equipment').getRecordTypeId();
            update OppRec21;
            OppRec21.LeadProvider_ID__c = null;
            OppRec21.SubDiv_TXT__c='Marine';
            OppRec21.Division_CD__c= 'P';
            OppRec21.RecordTypeId = Schema.SObjectType.opportunity.getRecordTypeInfosByDeveloperName().get('Marine').getRecordTypeId();
            update OppRec21;*/
        }
    } 
    @IsTest
    public static void JsonTest2() {
       
        UserRole r = new UserRole(DeveloperName = 'HELMS_Standard', Name = 'HELMS_Standard');
        insert r;      
       Profile profile_2 = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
            User admin = new User( 
            Email = 'Test1239username@gmail.com',
            ProfileId = profile_2.Id, 
            UserRoleId = r.Id,
            UserName = 'Test391nameAdminass@gmail.com', 
            Alias = 'Test',
            TimeZoneSidKey = 'America/New_York',
            EmailEncodingKey = 'ISO-8859-1',
            LocaleSidKey = 'en_US', 
            LanguageLocaleKey = 'en_US',
            PortalRole = 'Manager',
            FirstName = 'AdminFirstname',
            LastName = 'AdminLastname'
        );
        insert admin;
        User user;
        Account acc;
        Contact con;
        Account pro;
      System.runAs(admin){
        Id p = [select id from profile where name='HELMS Partner Community'].id;

        Id dealerAccRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
         acc = new Account(Name='Test Account123',RecordTypeId=dealerAccRecTypeId,
                                         DealerCode_CD__c='515722'
                                        );
        insert acc;
        
        Id conRecTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
        con = new Contact(FirstName='YashLead1234',LastName='Record1234',Email='yash1234@testing.com',Title='Mr',
                                        AccountId=acc.Id, RecordTypeId=conRecTypeId );
        insert con;
                
        pro = new Account(name ='Honda Dealer Created' ,  recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider').getRecordTypeId()) ;
        //insert pro; 
        
        user = new User(alias = 'mamavv', email='test123@noemail.com',
        emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
        localesidkey='en_US', profileid = p, country='United States',IsActive =true,
        ContactId = con.Id,
        timezonesidkey='America/Los_Angeles', username='testermamathalaa@noemail.com');

        insert user;
        }
        system.runAs(user) {
        // statements to be executed by this test user.
        pro = new Account(name ='Honda Dealer Created' ,  recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider').getRecordTypeId()) ;
        insert pro;
        Account pro1 = new Account(name ='Acura Dealer Created' ,  recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider').getRecordTypeId()) ;
        //insert pro1;
            Account pro2 = new Account(name ='Engine Dealer Created' ,  recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider').getRecordTypeId()) ;
        //insert pro2;
            Account pro3 = new Account(name ='Motorcycle Dealer Created' ,  recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider').getRecordTypeId()) ;
        insert pro3;
            Account pro4 = new Account(name ='werEquipment Dealer Created' ,  recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider').getRecordTypeId()) ;
        insert pro4;
            Account pro5 = new Account(name ='Marine Dealer Created' ,  recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider').getRecordTypeId()) ;
        insert pro5;
            Account pro6 = new Account(name ='PowerEquipment Dealer Created' ,  recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider').getRecordTypeId()) ;
        insert pro6;
            Test.startTest();
            Opportunity OppRec21 = new Opportunity(Name='YashLead1234',StageName='In Conversation',PreferredDealerAccount_TXT__c=acc.id, Email__c='yash1234@testing.com', ZipCode_TXT__c='12345',MSRP_AMT__c=200,Quote_AMT__c=500,
                                    PreferredDealerNumber_NUM__c='515722', External_ID__c='12345',CloseDate=system.today() ,Division_CD__c='A', SubDiv_TXT__c='Honda', First_Name_TXT__c='Test opp12', Last_Name_TXT__c ='Test opp LAst2', 
                                    RecordTypeId=Schema.SObjectType.opportunity.getRecordTypeInfosByDeveloperName().get('Honda').getRecordTypeId(),
                                    LeadProvider_ID__c=pro.id, Options_TXT__c='<option><optionname>Sport</optionname><manufacturercode>p394</manufacturercode><stock>100</stock><weighting>65</weighting><price type="invoice" currency="USD" source="Kelley Blue Book">19500</price><price type="appraisal" currency="USD" delta="percentage" relativeto="invoice" source="KBB"/><price type="msrp" currency="USD" delta="relative" relativeto="invoice" source="KBB">200</price><price type="quote" currency="USD" delta="absolute">19000</price><price type="offer" currency="USD" delta="relative" relativeto="invoice" source="KBB">200</price><price type="call" currency="USD" delta="percentage" relativeto="msrp">2</price><price type="asking" currency="USD" delta="percentage" relativeto="msrp">2</price></option>'
                                    );
            //insert OppRec21;
            //OppRec21.LeadProvider_ID__c = null;
            //update OppRec21;
            /*OppRec21.LeadProvider_ID__c = null;
            OppRec21.SubDiv_TXT__c='Acura';
            OppRec21.Division_CD__c= 'B';
            OppRec21.RecordTypeId = Schema.SObjectType.opportunity.getRecordTypeInfosByDeveloperName().get('Acura').getRecordTypeId();
            update OppRec21;
            OppRec21.LeadProvider_ID__c = null;
            OppRec21.SubDiv_TXT__c='Engine';
            OppRec21.Division_CD__c= 'P';
            OppRec21.RecordTypeId = Schema.SObjectType.opportunity.getRecordTypeInfosByDeveloperName().get('Engine').getRecordTypeId();
            update OppRec21;*/
            OppRec21.LeadProvider_ID__c = null;
            OppRec21.SubDiv_TXT__c='Motorcycle';
            OppRec21.Division_CD__c= 'M';
            OppRec21.RecordTypeId = Schema.SObjectType.opportunity.getRecordTypeInfosByDeveloperName().get('Power_Sports').getRecordTypeId();
            insert OppRec21;
            OppRec21.LeadProvider_ID__c = null;
            OppRec21.SubDiv_TXT__c='PowerEquipment';
            OppRec21.Division_CD__c= 'P';
            OppRec21.RecordTypeId = Schema.SObjectType.opportunity.getRecordTypeInfosByDeveloperName().get('Power_Equipment').getRecordTypeId();
            update OppRec21;
            OppRec21.LeadProvider_ID__c = null;
            OppRec21.SubDiv_TXT__c='Marine';
            OppRec21.Division_CD__c= 'P';
            OppRec21.RecordTypeId = Schema.SObjectType.opportunity.getRecordTypeInfosByDeveloperName().get('Marine').getRecordTypeId();
           // update OppRec21;
        }
    } 
   @IsTest
    public static void handleOppUpdateInsertTest1()
    {
        Id dealerAccRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
        Account acc = new Account(Name='Test Account12322',RecordTypeId=dealerAccRecTypeId,
                                         DealerCode_CD__c='1234'
                                        );
        insert acc;
        
         Account pro = new Account(name ='abc' ,  recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider').getRecordTypeId()) ;
        insert pro; 
        Lead newLead = new Lead(lastName='Test last',Email='Testing@testing.com',Lead_Group_ID__c='12345');
        insert newLead;
        Opportunity OppRec = new Opportunity(Name='YashLead1234',StageName='In Conversation',PreferredDealerAccount_TXT__c=acc.id, Email__c='abc@test.com', ZipCode_TXT__c='12345',MSRP_AMT__c=200,Quote_AMT__c=500,
                                PreferredDealerNumber_NUM__c='1234',Lead_Group_ID__c='12345', External_ID__c='12345',CloseDate=system.today() , First_Name_TXT__c='Test opp19', Last_Name_TXT__c ='Test opp LAst9', LeadProvider_ID__c=pro.id,
                                Options_TXT__c='<option><optionname>Sport</optionname><manufacturercode>p394</manufacturercode><stock>100</stock><weighting>65</weighting><price>19500</price></option><option><optionname>Sport</optionname><manufacturercode>p394</manufacturercode><stock>100</stock><weighting>65</weighting><price type="invoice" currency="USD" source="Kelley Blue Book">19500</price><price type="appraisal" currency="USD" delta="percentage" relativeto="invoice" source="KBB"/><price type="msrp" currency="USD" delta="relative" relativeto="invoice" source="KBB">200</price><price type="quote" currency="USD" delta="absolute">19000</price><price type="offer" currency="USD" delta="relative" relativeto="invoice" source="KBB">200</price><price type="call" currency="USD" delta="percentage" relativeto="msrp">2</price><price type="asking" currency="USD" delta="percentage" relativeto="msrp">2</price></option>'
                                );
                                
        Test.startTest();
        insert OppRec;
        OppRec.StageName='Closed Won';
        OppRec.CloseDate=system.today();
        update OppRec;
        OppRec.StageName='Closed Inactive';
        OppRec.CloseDate=system.today();
        update OppRec;
        Test.stopTest();
        
    } 
@IsTest
    public static void handleOppUpdateInsertTest2()
    {
        Id dealerAccRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
        Account acc = new Account(Name='Test Account12322',RecordTypeId=dealerAccRecTypeId,
                                         DealerCode_CD__c='1234',Routable_FLG__c=true,HondaDigitalSolutions_FLG__c=true
                                        );
        insert acc;
        
         Account pro = new Account(name ='abc' , HondaDigitalSolutions_FLG__c=true,Routable_FLG__c=true, recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Vendor').getRecordTypeId()) ;
        insert pro; 
        Lead newLead = new Lead(lastName='Test last',Email='Testing@testing.com',Lead_Group_ID__c='12345');
        insert newLead;
        Dealer_Division__c dDivision = new Dealer_Division__c(First_Name_TXT__c='test', 
                                                                  InternetCertified_FLG__c=true,
                                                                  Dealer_ID__c=acc.Id,
                                                                  SubDiv_TXT__c ='Honda',
                                                                  isActive_FLG__c=true);
        insert dDivision;
        CRM_System__c crmSystem = new CRM_System__c(Name='Test crm',Vendor_ID__c=pro.Id,ISActive_FLG__c=true);
        insert crmSystem;
        Dealer_Participation__c dParticip = new Dealer_Participation__c(LeadReceivingStartDate_DT__c=System.NOW()-12,
                                                                           //ISActive_FLG__c=true,
                                                                           DealerAccount_ID__c=acc.Id,
                                                                           Dealer_Subdivision__c=dDivision.Id,
                                                                        CRM_System__c=crmSystem.Id);
        insert dParticip;
        Opportunity OppRec = new Opportunity(Name='YashLead1234',StageName='In Conversation',PreferredDealerAccount_TXT__c=acc.id, Email__c='abc@test.com', ZipCode_TXT__c='12345',MSRP_AMT__c=200,Quote_AMT__c=500,
                                PreferredDealerNumber_NUM__c='1234',Lead_Group_ID__c='12345', External_ID__c='12345',CloseDate=system.today() , First_Name_TXT__c='Test opp19', SubDiv_TXT__c='Honda',Last_Name_TXT__c ='Test opp LAst9', LeadProvider_ID__c=pro.id,
                                recordtypeid = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Honda').getRecordTypeId(),Routable_FLG__c=false,             
                                Options_TXT__c='<option><optionname>Sport</optionname><manufacturercode>p394</manufacturercode><stock>100</stock><weighting>65</weighting><price>19500</price></option><option><optionname>Sport</optionname><manufacturercode>p394</manufacturercode><stock>100</stock><weighting>65</weighting><price type="invoice" currency="USD" source="Kelley Blue Book">19500</price><price type="appraisal" currency="USD" delta="percentage" relativeto="invoice" source="KBB"/><price type="msrp" currency="USD" delta="relative" relativeto="invoice" source="KBB">200</price><price type="quote" currency="USD" delta="absolute">19000</price><price type="offer" currency="USD" delta="relative" relativeto="invoice" source="KBB">200</price><price type="call" currency="USD" delta="percentage" relativeto="msrp">2</price><price type="asking" currency="USD" delta="percentage" relativeto="msrp">2</price></option>'
                                );
                                
        Test.startTest();
        insert OppRec;
        Test.stopTest();
        
    }  
    @IsTest
    public static void handleOppUpdateInsertTest3()
    {
        Id dealerAccRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
        Account acc = new Account(Name='Test Account12322',RecordTypeId=dealerAccRecTypeId,
                                         DealerCode_CD__c='1234'
                                        );
        insert acc;
        
         Account pro = new Account(name ='Acura Dealer Created' ,  recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider').getRecordTypeId()) ;
        insert pro; 
            
        Opportunity OppRec = new Opportunity(Name='YashLead1234',StageName='In Conversation',PreferredDealerAccount_TXT__c=acc.id, Email__c='abc@test.com', ZipCode_TXT__c='12345',MSRP_AMT__c=200,Quote_AMT__c=500,
                                PreferredDealerNumber_NUM__c='1234', External_ID__c='12345',CloseDate=system.today() , First_Name_TXT__c='Test opp19', Last_Name_TXT__c ='Test opp LAst9', LeadProvider_ID__c=pro.id,
                                Options_TXT__c='<option><optionname>Sport</optionname><manufacturercode>p394</manufacturercode><stock>100</stock><weighting>65</weighting><price>19500</price></option><option><optionname>Sport</optionname><manufacturercode>p394</manufacturercode><stock>100</stock><weighting>65</weighting><price type="invoice" currency="USD" source="Kelley Blue Book">19500</price><price type="appraisal" currency="USD" delta="percentage" relativeto="invoice" source="KBB"/><price type="msrp" currency="USD" delta="relative" relativeto="invoice" source="KBB">200</price><price type="quote" currency="USD" delta="absolute">19000</price><price type="offer" currency="USD" delta="relative" relativeto="invoice" source="KBB">200</price><price type="call" currency="USD" delta="percentage" relativeto="msrp">2</price><price type="asking" currency="USD" delta="percentage" relativeto="msrp">2</price></option>'
                                );
                                
        Test.startTest();
        insert OppRec;
        OppRec.StageName='Closed Won';
        OppRec.CloseDate=system.today();
        update OppRec;
        /*
        string json = '[{"optionname": "Sport","manufacturercode": "p394","stock": "100","weighting": "65"},{"optionname": "Sport","manufacturercode": "p394","stock": "100","weighting": "65"}]';
        System.JSONParser parser = System.JSON.createParser(json);
        OptionsJSON2Apex.parse(json);
        */
        Test.stopTest();
        
    }
    @isTest
    public static void findDuplicateOpportunityTest(){
        Id dealerAccRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
        Account acc = new Account(Name='Test AccountDupOpp',RecordTypeId=dealerAccRecTypeId,
                                         DealerCode_CD__c='1234'
                                        );
        insert acc;
          Account pro = new Account(name ='Acura Dealer Created' ,  recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider').getRecordTypeId()) ;
        insert pro; 
            
        Opportunity OppRec = new Opportunity(Name='TestDupOPP',StageName='In Conversation',PreferredDealerAccount_TXT__c=acc.id, Email__c='abc@test.com', ZipCode_TXT__c='12345',Lead_Group_ID__c='00Q7c00000DOOrrrrr',Duplicate_Similar__c=false,
                                PreferredDealerNumber_NUM__c='1234', External_ID__c='12345',CloseDate=system.today() , First_Name_TXT__c='Test opp1', Last_Name_TXT__c ='Test opp Last1', LeadProvider_ID__c=pro.id);
          insert OppRec;                      
        Test.startTest();
        Opportunity oppRec2=new Opportunity(Name='TestDupOPP',StageName='In Conversation',PreferredDealerAccount_TXT__c=acc.id, Email__c='abc@test.com', ZipCode_TXT__c='12345',Lead_Group_ID__c='00Q7c00000DOOrrrrr',Duplicate_Similar__c=true,
                                PreferredDealerNumber_NUM__c='1234', External_ID__c='12345',CloseDate=system.today() , First_Name_TXT__c='Test opp1', Last_Name_TXT__c ='Test opp Last1', LeadProvider_ID__c=pro.id);
        
        
       insert  OppRec2;
        HELMSupdateOppHandler handler=new HELMSupdateOppHandler();
        list<Opportunity> opplst=new list<opportunity>();
        opplst.add(OppRec2);
      //  handler.findDuplicateOpportunity(opplst);
      }
   
}