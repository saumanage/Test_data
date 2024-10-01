@isTest
public class HELMSLeadEnrichmentRetryBatchTest {
     @IsTest
    private static void leadEnrichment2()
    {
           Test.startTest();
        HELMSJsonWrapper res =new HELMSJsonWrapper();
        HELMSJsonWrapper.Consumer_detail  rc=new HELMSJsonWrapper.Consumer_detail();
        rc.contact_key= '12356';
        rc.cid=2;  
       
        HELMSJsonWrapper.Response r=new HELMSJsonWrapper.Response();
       // r.consumer_detail= rc;
        r.msg_text='test';
        r.msg_code='test';
        res.response = r;
         res.response.consumer_detail = rc;
        RestRequest request = new RestRequest();
      
        request.httpMethod = 'PATCH';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf('{"leadId": "led.id"}');
        RestContext.request = request;
        
        Test.setMock(HttpCalloutMock.class, new LeadEnrichMockTest());
        
        
       

    set<id> s=new set<id>();
        Lead led = new Lead(FirstName='YashL',Salutation='Mr' ,LastName='Record12xc34',MiddleName='mm',Email='yxcash12345yas@testing.com',Status='Manual Validation',Suffix='Test',
                                PreferredDealerNumber_NUM__c='123456', Model_ID__c='123', Division_CD__c='P',VehicleStatus_TXT__c='New',External_ID__c='nhxcs',street='bb', city='cic', state ='stss', postalcode='12545', country='coun' );
        insert led;
        HELMSleadEnrichmentIntegrationupdate ff = new HELMSleadEnrichmentIntegrationupdate();       
        HELMSleadEnrichmentIntegrationupdate.LeadEnrichment(s ,false) ;
       
        string srand=HELMSleadEnrichmentIntegrationupdate.getRandomContactKey();
        
         JSONRequest ledjson = new JSONRequest();
            
            List<JSONRequest.Vehicle> vehList = new List<JSONRequest.Vehicle>();
            JSONRequest.Vehicle v = new JSONRequest.Vehicle();
           
            v.modelId = led.Model_ID__c;

            v.businessunit = led.Division_CD__c;
            v.vehicletypecode = 'N';
            
            vehList.add(v);
            
            List<JSONRequest.Address> addList = new List<JSONRequest.Address>();
            JSONRequest.Address add = new JSONRequest.Address();
            
            if(led.street!=null){
                add.address_line1 = led.street;
            }
            if(led.street!=null){
                add.address_line2 = led.street;
            }
            
            if(led.city!=null){
                add.city = led.city;
            }
            if(led.state!=null){
                add.state = led.state;
            }
            if(led.postalCode!=null){
                String m=led.postalCode;
                if(m.contains('-')){
                    String[] mi = m.split('-');
                   // system.debug('0-----'+Mi[0]);
                   // system.debug('1-----'+Mi[1]);
                    
                    add.zip = mi[0];
                    add.plus4 = mi[1];
                }else{
                    add.zip = led.postalCode;
                }
            }
                   
            
            if(led.country!=null){      
                add.country = led.country;
            }
            addList.add(add);
            
            JSONRequest.Name na = new JSONRequest.Name();
            if(led.Salutation!=null){   
                na.prefix=led.Salutation;
            }
            if(led.FirstName!=null){    
                na.first_name=led.FirstName;
            }
            if(led.MiddleName!=null){   
                na.middle_name=led.MiddleName;
            }
            if(led.LastName!=null){ 
                na.last_name=led.LastName;
            }
            if(led.Suffix!=null){   
                na.suffix=led.Suffix;
            
            }
            JSONRequest.Customer cus = new JSONRequest.Customer();
            cus.name= na;
            cus.address = addList;
            cus.email= led.email;
            cus.home_phone=led.Phone;
            cus.cell_phone=led.MobilePhone;

            
            JSONRequest.Location loc = new JSONRequest.Location();
            
            if(led.PreferredDealerNumber_NUM__c!=null){
                loc.poi_id= led.PreferredDealerNumber_NUM__c;
            }
            loc.poi_radius='15';
              
            ledjson.leadId=led.External_ID__c;
            ledjson.customer=cus;
            ledjson.location=loc;
            ledjson.vehicle=vehList;
            ledjson.source=System.Label.source;
          
          string query1= 'select id,Name,FirstName,LastName from Lead WHERE id=\''+led.id+'\'';
          Boolean isupdate;
    HELMSLeadEnrichmentRetryBatch hbe=new HELMSLeadEnrichmentRetryBatch(query1,false);    
    Id jobid= Database.executeBatch(hbe,1);   
    
         Test.stopTest();
        
    }
   @IsTest
    private static void leadEnrichment1()
    {
        Test.startTest();
        HELMSJsonWrapper res =new HELMSJsonWrapper();
        Id dealerAccRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        Account accTestRec = new Account(FirstName='Test',LastName='Account123',RecordTypeId=dealerAccRecTypeId,DealerCode_CD__c='123456',Contact_Key__c='E150363308'
                                        );
        insert accTestRec;
        Account accTestRec1 = new Account(FirstName='Hello',LastName='World',RecordTypeId=dealerAccRecTypeId,DealerCode_CD__c='12456',Contact_Key__c='E1503308'
                                        );
        insert accTestRec1;
        
      
        HELMSJsonWrapper.Consumer_detail  rc=new HELMSJsonWrapper.Consumer_detail();
        rc.contact_key= 'E1503308';
        rc.cid=2;  
        
       
        HELMSJsonWrapper.Response r=new HELMSJsonWrapper.Response();
       // r.consumer_detail= rc;
        r.msg_text='test';
        r.msg_code='test';
        res.response = r;
         res.response.consumer_detail = rc;
        RestRequest request = new RestRequest();
      
        request.httpMethod = 'PATCH';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf('{"leadId": "led.id"}');
        RestContext.request = request;
        
        Test.setMock(HttpCalloutMock.class, new LeadEnrichMockTest());
        
        
        
        set<id> s=new set<id>();
        Lead led = new Lead(FirstName='YashL',Salutation='Mr' ,LastName='Record12xc34',MiddleName='mm',Email='yxcash12345yas@testing.com',Status='Manual Validation',Suffix='Test',
                                PreferredDealerNumber_NUM__c='123456', Model_ID__c='123', Division_CD__c='P',VehicleStatus_TXT__c='New',External_ID__c='nhxcs',street='bb', city='cic', state ='stss', postalcode='12365', country='coun' );
        insert led;
          String RecTypeId= [select Id from RecordType where (Name='Person Account') and (SobjectType='Account')].Id;
        Account Accnt = new Account(FirstName='YashL',LastName='Record12xc34',
          RecordTypeID=RecTypeId,
          Contact_Key__c='E1503308');
            insert Accnt;
        
        HELMSleadEnrichmentIntegrationupdate ff = new HELMSleadEnrichmentIntegrationupdate();       
        HELMSleadEnrichmentIntegrationupdate.LeadEnrichment(s, false) ;
       
        string srand=HELMSleadEnrichmentIntegrationupdate.getRandomContactKey();
        
         JSONRequest ledjson = new JSONRequest();
            
            List<JSONRequest.Vehicle> vehList = new List<JSONRequest.Vehicle>();
            JSONRequest.Vehicle v = new JSONRequest.Vehicle();
           
            v.modelId = led.Model_ID__c;

            v.businessunit = led.Division_CD__c;
            v.vehicletypecode = 'N';
            
            vehList.add(v);
            
            List<JSONRequest.Address> addList = new List<JSONRequest.Address>();
            JSONRequest.Address add = new JSONRequest.Address();
            
            if(led.street!=null){
                add.address_line1 = led.street;
            }
            if(led.street!=null){
                add.address_line2 = led.street;
            }
            
            if(led.city!=null){
                add.city = led.city;
            }
            if(led.state!=null){
                add.state = led.state;
            }
            if(led.postalCode!=null){
                String m=led.postalCode;
                if(m.contains('-')){
                    String[] mi = m.split('-');
                  //  system.debug('0-----'+Mi[0]);
                  //  system.debug('1-----'+Mi[1]);
                    
                    add.zip = mi[0];
                    add.plus4 = mi[1];
                }else{
                    add.zip = led.postalCode;
                }
            }
                   
            
            if(led.country!=null){      
                add.country = led.country;
            }
            addList.add(add);
            
            JSONRequest.Name na = new JSONRequest.Name();
            if(led.Salutation!=null){   
                na.prefix=led.Salutation;
            }
            if(led.FirstName!=null){    
                na.first_name=led.FirstName;
            }
            if(led.MiddleName!=null){   
                na.middle_name=led.MiddleName;
            }
            if(led.LastName!=null){ 
                na.last_name=led.LastName;
            }
            if(led.Suffix!=null){   
                na.suffix=led.Suffix;
            
            }
            JSONRequest.Customer cus = new JSONRequest.Customer();
            cus.name= na;
            cus.address = addList;
            cus.email= led.email;
            cus.home_phone=led.Phone;
            cus.cell_phone=led.MobilePhone;

            
            JSONRequest.Location loc = new JSONRequest.Location();
            
            if(led.PreferredDealerNumber_NUM__c!=null){
                loc.poi_id= led.PreferredDealerNumber_NUM__c;
            }
            loc.poi_radius='15';
              
            ledjson.leadId=led.External_ID__c;
            ledjson.customer=cus;
            ledjson.location=loc;
            ledjson.vehicle=vehList;
            ledjson.source=System.Label.source;
        
              string query1= 'select id,Name,FirstName,LastName from Lead WHERE id=\''+led.id+'\'';
               Boolean isupdate;
    HELMSLeadEnrichmentRetryBatch hbe=new HELMSLeadEnrichmentRetryBatch(query1,false);    
            
        Test.stopTest();
        
    }
    
    @IsTest
    private static void leadEnrichment3()
    {
        Test.startTest();
        HELMSJsonWrapper res =new HELMSJsonWrapper();
        Id dealerAccRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        Account accTestRec = new Account(FirstName='Test',LastName='Account123',RecordTypeId=dealerAccRecTypeId,DealerCode_CD__c='123456',Contact_Key__c='E2503308'
                                        );
        insert accTestRec;
        Account accTestRec1 = new Account(FirstName='Hello',LastName='World',RecordTypeId=dealerAccRecTypeId,DealerCode_CD__c='12456',Contact_Key__c='E1503308'
                                        );
        insert accTestRec1;
        HELMSJsonWrapper.Consumer_detail  rc=new HELMSJsonWrapper.Consumer_detail();
        rc.contact_key= 'E1503308';
        rc.cid=2;  
       
        HELMSJsonWrapper.Response r=new HELMSJsonWrapper.Response();
       // r.consumer_detail= rc;
        r.msg_text='test';
        
        r.msg_code='test';
        res.response = r;
         res.response.consumer_detail = rc;
        RestRequest request = new RestRequest();
      
        request.httpMethod = 'PATCH';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf('{"leadId": "led.id"}');
        RestContext.request = request;
        
        Test.setMock(HttpCalloutMock.class, new LeadEnrichMock2Test());
       
        set<id> s=new set<id>();
        Lead led = new Lead(FirstName='test',Salutation='Mr' ,LastName='Record12xc34',MiddleName='test',Email='',Status='Manual Validation',Suffix='Test',
                                PreferredDealerNumber_NUM__c='123456', Model_ID__c='123', Division_CD__c='P',VehicleStatus_TXT__c='New',External_ID__c='nhxcs',street='', city='', state ='', postalcode='12345', country='', Phone='1234567890', MobilePhone='12345' );
        insert led;
        HELMSleadEnrichmentIntegrationupdate ff = new HELMSleadEnrichmentIntegrationupdate();       
        HELMSleadEnrichmentIntegrationupdate.LeadEnrichment(s, true) ;
       
        string srand=HELMSleadEnrichmentIntegrationupdate.getRandomContactKey();
        
         JSONRequest ledjson = new JSONRequest();
            
            List<JSONRequest.Vehicle> vehList = new List<JSONRequest.Vehicle>();
            JSONRequest.Vehicle v = new JSONRequest.Vehicle();
           
            v.modelId = led.Model_ID__c;

            v.businessunit = led.Division_CD__c;
            v.vehicletypecode = 'N';
            
            vehList.add(v);
            
            List<JSONRequest.Address> addList = new List<JSONRequest.Address>();
            JSONRequest.Address add = new JSONRequest.Address();
            
            if(led.street!=null){
                add.address_line1 = led.street;
            }
            if(led.street!=null){
                add.address_line2 = led.street;
            }
            
            if(led.city!=null){
                add.city = led.city;
            }
            if(led.state!=null){
                add.state = led.state;
            }
            if(led.postalCode!=null){
                String m=led.postalCode;
                if(m.contains('-')){
                    String[] mi = m.split('-');
                   // system.debug('0-----'+Mi[0]);
                  //  system.debug('1-----'+Mi[1]);
                    
                    add.zip = mi[0];
                    add.plus4 = mi[1];
                }else{
                    add.zip = led.postalCode;
                }
            }
                   
            
            if(led.country!=null){      
                add.country = led.country;
            }
            addList.add(add);
            
            JSONRequest.Name na = new JSONRequest.Name();
            if(led.Salutation!=null){   
                na.prefix=led.Salutation;
            }
            if(led.FirstName!=null){    
                na.first_name=led.FirstName;
            }
            if(led.MiddleName!=null){   
                na.middle_name=led.MiddleName;
            }
            if(led.LastName!=null){ 
                na.last_name=led.LastName;
            }
            if(led.Suffix!=null){   
                na.suffix=led.Suffix;
            
            }
            JSONRequest.Customer cus = new JSONRequest.Customer();
            cus.name= na;
            cus.address = addList;
            cus.email= led.email;
            cus.home_phone=led.Phone;
            cus.cell_phone=led.MobilePhone;

            
            JSONRequest.Location loc = new JSONRequest.Location();
            
            if(led.PreferredDealerNumber_NUM__c!=null){
                loc.poi_id= led.PreferredDealerNumber_NUM__c;
            }
            loc.poi_radius='15';
              
            ledjson.leadId=led.External_ID__c;
            ledjson.customer=cus;
            ledjson.location=loc;
            ledjson.vehicle=vehList;
            ledjson.source=System.Label.source;
            string query2= 'select id,Name,FirstName,LastName from Lead WHERE id=\''+led.id+'\'';

             Boolean isupdate;
             HELMSLeadEnrichmentRetryBatch hbe=new HELMSLeadEnrichmentRetryBatch(query2,False);    
  
    Id jobid= Database.executeBatch(hbe,1);    
            
            
    HELMSLeadEnrichmentRetryBatch hbe22=new HELMSLeadEnrichmentRetryBatch();   
    HELMSLeadEnrichmentRetryBatch.getUUID();
        Test.stopTest();
        
    }  
      @IsTest
    private static void leadEnrichment4()
    {
        Test.startTest();
        HELMSJsonWrapper res =new HELMSJsonWrapper();
        HELMSJsonWrapper.Consumer_detail  rc=new HELMSJsonWrapper.Consumer_detail();
        rc.contact_key= 'E150363308';
        rc.cid=2;
        Id dealerAccRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        Account accTestRec = new Account(FirstName='Test',LastName='Account123',RecordTypeId=dealerAccRecTypeId,DealerCode_CD__c='123456',Contact_Key__c=null
                                        );
        insert accTestRec;
        Account accTestRec1 = new Account(FirstName='Hello',LastName='World',RecordTypeId=dealerAccRecTypeId,DealerCode_CD__c='12456',Contact_Key__c='E1503308'
                                        );
        insert accTestRec1;
          
       
        HELMSJsonWrapper.Response r=new HELMSJsonWrapper.Response();
        r.consumer_detail= rc;
        r.msg_text='test';
        r.msg_code='test';
        res.response = r;
         res.response.consumer_detail = rc;
        RestRequest request = new RestRequest();
      
        request.httpMethod = 'PATCH';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf('{"leadId": "led.id"}');
        RestContext.request = request;
        
        Test.setMock(HttpCalloutMock.class, new LeadEnrichMock2Test());        
        
        set<id> s=new set<id>();
        Lead led = new Lead(FirstName='test',Salutation='Mr' ,LastName='Record12xc34',MiddleName='tes',Email='',Status='Manual Validation',Suffix='Test',
                                PreferredDealerNumber_NUM__c='123456', Model_ID__c='123', Division_CD__c='A',VehicleStatus_TXT__c='New',External_ID__c='nhxcs',street='', city='', state ='', postalcode='', country='' );
        insert led;
        HELMSleadEnrichmentIntegrationupdate ff = new HELMSleadEnrichmentIntegrationupdate();       
        HELMSleadEnrichmentIntegrationupdate.LeadEnrichment(s, true) ;
       
        string srand=HELMSleadEnrichmentIntegrationupdate.getRandomContactKey();
        
         JSONRequest ledjson = new JSONRequest();
            
            List<JSONRequest.Vehicle> vehList = new List<JSONRequest.Vehicle>();
            JSONRequest.Vehicle v = new JSONRequest.Vehicle();
           
            v.modelId = led.Model_ID__c;

            v.businessunit = led.Division_CD__c;
            v.vehicletypecode = 'N';
            
            vehList.add(v);
            
            List<JSONRequest.Address> addList = new List<JSONRequest.Address>();
            JSONRequest.Address add = new JSONRequest.Address();
            
            if(led.street!=null){
                add.address_line1 = led.street;
            }
            if(led.street!=null){
                add.address_line2 = led.street;
            }
            
            if(led.city!=null){
                add.city = led.city;
            }
            if(led.state!=null){
                add.state = led.state;
            }
            if(led.postalCode!=null){
                String m=led.postalCode;
                if(m.contains('-')){
                    String[] mi = m.split('-');
                  //  system.debug('0-----'+Mi[0]);
                  //  system.debug('1-----'+Mi[1]);
                    
                    add.zip = mi[0];
                    add.plus4 = mi[1];
                }else{
                    add.zip = led.postalCode;
                }
            }
                   
            
            if(led.country!=null){      
                add.country = led.country;
            }
            addList.add(add);
            
            JSONRequest.Name na = new JSONRequest.Name();
            if(led.Salutation!=null){   
                na.prefix=led.Salutation;
            }
            if(led.FirstName!=null){    
                na.first_name=led.FirstName;
            }
            if(led.MiddleName!=null){   
                na.middle_name=led.MiddleName;
            }
            if(led.LastName!=null){ 
                na.last_name=led.LastName;
            }
            if(led.Suffix!=null){   
                na.suffix=led.Suffix;
            
            }
            JSONRequest.Customer cus = new JSONRequest.Customer();
            cus.name= na;
            cus.address = addList;
            cus.email= led.email;
            cus.home_phone=led.Phone;
            cus.cell_phone=led.MobilePhone;

            
            JSONRequest.Location loc = new JSONRequest.Location();
            
            if(led.PreferredDealerNumber_NUM__c!=null){
                loc.poi_id= led.PreferredDealerNumber_NUM__c;
            }
            loc.poi_radius='15';
              
            ledjson.leadId=led.External_ID__c;
            ledjson.customer=cus;
            ledjson.location=loc;
            ledjson.vehicle=vehList;
            ledjson.source=System.Label.source;
            
              string query2= 'select id,Name,FirstName,LastName from Lead WHERE id=\''+led.id+'\'';
               Boolean isupdate;
    HELMSLeadEnrichmentRetryBatch hbe=new HELMSLeadEnrichmentRetryBatch(query2,true);    
  
    Id jobid= Database.executeBatch(hbe,1);   
        Test.stopTest();
        
    }
     @isTest static void testScheduler () {
      
        String cronExpr = '0 0 * * * ? ';
        String jobRunningTime = '2022-02-08 00:00:00';

        Test.startTest();
         
        HELMSJsonWrapper res =new HELMSJsonWrapper();
        HELMSJsonWrapper.Consumer_detail  rc=new HELMSJsonWrapper.Consumer_detail();
        rc.contact_key= 'E150363308';
        rc.cid=2;
        Id dealerAccRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        Account accTestRec = new Account(FirstName='Test',LastName='Account123',RecordTypeId=dealerAccRecTypeId,DealerCode_CD__c='123456',Contact_Key__c=null
                                        );
        insert accTestRec;
        Account accTestRec1 = new Account(FirstName='Hello',LastName='World',RecordTypeId=dealerAccRecTypeId,DealerCode_CD__c='12456',Contact_Key__c='E1503308'
                                        );
        insert accTestRec1;
          
       
        HELMSJsonWrapper.Response r=new HELMSJsonWrapper.Response();
        r.consumer_detail= rc;
        r.msg_text='test';
        r.msg_code='test';
        res.response = r;
         res.response.consumer_detail = rc;
        RestRequest request = new RestRequest();
      
        request.httpMethod = 'PATCH';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf('{"leadId": "led.id"}');
        RestContext.request = request;
        
        Test.setMock(HttpCalloutMock.class, new LeadEnrichMock2Test());
        
        
        set<id> s=new set<id>();
        Lead led = new Lead(FirstName='',Salutation='Mr' ,LastName='Record12xc34',MiddleName='',Email='',Status='Manual Validation',Suffix='Test',
                                PreferredDealerNumber_NUM__c='123456', Model_ID__c='123', Division_CD__c='P',VehicleStatus_TXT__c='New',External_ID__c='nhxcs',street='', city='', state ='', postalcode='', country='' );
        insert led;
        HELMSleadEnrichmentIntegrationupdate ff = new HELMSleadEnrichmentIntegrationupdate();       
        HELMSleadEnrichmentIntegrationupdate.LeadEnrichment(s, true) ;
       
        string srand=HELMSleadEnrichmentIntegrationupdate.getRandomContactKey();
        
         JSONRequest ledjson = new JSONRequest();
            
            List<JSONRequest.Vehicle> vehList = new List<JSONRequest.Vehicle>();
            JSONRequest.Vehicle v = new JSONRequest.Vehicle();
           
            v.modelId = led.Model_ID__c;

            v.businessunit = led.Division_CD__c;
            v.vehicletypecode = 'N';
            
            vehList.add(v);
            
            List<JSONRequest.Address> addList = new List<JSONRequest.Address>();
            JSONRequest.Address add = new JSONRequest.Address();
            
            if(led.street!=null){
                add.address_line1 = led.street;
            }
            if(led.street!=null){
                add.address_line2 = led.street;
            }
            
            if(led.city!=null){
                add.city = led.city;
            }
            if(led.state!=null){
                add.state = led.state;
            }
            if(led.postalCode!=null){
                String m=led.postalCode;
                if(m.contains('-')){
                    String[] mi = m.split('-');
                  //  system.debug('0-----'+Mi[0]);
                  //  system.debug('1-----'+Mi[1]);
                    
                    add.zip = mi[0];
                    add.plus4 = mi[1];
                }else{
                    add.zip = led.postalCode;
                }
            }
                   
            
            if(led.country!=null){      
                add.country = led.country;
            }
            addList.add(add);
            
            JSONRequest.Name na = new JSONRequest.Name();
            if(led.Salutation!=null){   
                na.prefix=led.Salutation;
            }
            if(led.FirstName!=null){    
                na.first_name=led.FirstName;
            }
            if(led.MiddleName!=null){   
                na.middle_name=led.MiddleName;
            }
            if(led.LastName!=null){ 
                na.last_name=led.LastName;
            }
            if(led.Suffix!=null){   
                na.suffix=led.Suffix;
            
            }
            JSONRequest.Customer cus = new JSONRequest.Customer();
            cus.name= na;
            cus.address = addList;
            cus.email= led.email;
            cus.home_phone=led.Phone;
            cus.cell_phone=led.MobilePhone;

            
            JSONRequest.Location loc = new JSONRequest.Location();
            
            if(led.PreferredDealerNumber_NUM__c!=null){
                loc.poi_id= led.PreferredDealerNumber_NUM__c;
            }
            loc.poi_radius='15';
              
            ledjson.leadId=led.External_ID__c;
            ledjson.customer=cus;
            ledjson.location=loc;
            ledjson.vehicle=vehList;
            ledjson.source=System.Label.source;
          //  system.debug('mamatha-------------'+led.id);
        // Schedule the test job
         string query2= 'select id,Name,FirstName,LastName from Lead WHERE id=\''+led.id+'\'';
         Boolean isupdate;
        String jobId = System.schedule('myJobTestJobName', cronExpr, new HELMSLeadEnrichmentRetryBatch(query2,true));
        Test.stopTest();
    }

}