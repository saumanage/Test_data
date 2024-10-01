@isTest
public class ResponseTimeCorrectionBatchTestClass {
    @isTest static void monday(){
        account acc=new account(Timezone__c='-7',MonOpenHour__c='0000',MonCloseHour__c='2400',TueOpenHour__c='0000',
        TueCloseHour__c='2400',WedOpenHour__c='0000',WedCloseHour__c='2400',ThuOpenHour__c='0000',ThuCloseHour__c='2400',
        FriOpenHour__c='0000',FriCloseHour__c='2400',SatOpenHour__c='0000',SatCloseHour__c='2400',SunOpenHour__c='0000',
        SunCloseHour__c='2400');
        acc.Name = 'Test Account';
        insert acc;
        opportunity opp= new opportunity(Stagename='In Conversation',PreferredDealerAccount_TXT__c=acc.id,Name='SLA test class', 
         LeadProvider_ID__c=acc.id, Email__c='call.bijay1@gmail.com', ZipCode_TXT__c='12345',Routing_Status__c='Success', 
        First_Name_TXT__c='SLA test', Last_Name_TXT__c='class',Opportunity_SF_ID__c='123456789');
        opp.CloseDate= system.Today();
        opp.createddate=system.now()-20;
        insert opp;
        Routing_Dealer_CRM_Disposition__c rdc= new Routing_Dealer_CRM_Disposition__c(HELMS_Opportunity_External_Key__c='123456789');
        rdc.Response_Time__c=system.now()+20;
        insert rdc;
        Test.startTest();
        string query='Select Id,Opportunity_SF_ID__c,Routing_Status__c,CreatedDate,name,Service_Level_Agreement_TXT__c,SubDiv_TXT__c , PreferredDealerAccount_TXT__r.Account_Timezone__c,PreferredDealerAccount_TXT__r.MonOpenHour__c,PreferredDealerAccount_TXT__r.MonCloseHour__c,PreferredDealerAccount_TXT__r.TueOpenHour__c,PreferredDealerAccount_TXT__r.TueCloseHour__c,PreferredDealerAccount_TXT__r.WedOpenHour__c,PreferredDealerAccount_TXT__r.WedCloseHour__c,PreferredDealerAccount_TXT__r.ThuOpenHour__c,PreferredDealerAccount_TXT__r.ThuCloseHour__c,PreferredDealerAccount_TXT__r.FriOpenHour__c,PreferredDealerAccount_TXT__r.FriCloseHour__c,PreferredDealerAccount_TXT__r.SatOpenHour__c,PreferredDealerAccount_TXT__r.SatCloseHour__c,PreferredDealerAccount_TXT__r.SunOpenHour__c,PreferredDealerAccount_TXT__r.SunCloseHour__c,Business_Hours_Elasped__c,Routing_Success_Date_Time__c from Opportunity';
        query += ' Where (StageName != \'Acknowledged\' AND StageName != \'Assigned to Dealer\')   and Routing_Status__c=\'Success\' and Response_Date_Time__c=null and createddate>=2022-03-03T00:05:30.000+0000  ' ;
        ResponseTimeCorrectionBatch cs = new ResponseTimeCorrectionBatch(query);
        Id jobID=Database.executeBatch(cs);
        Test.stopTest();
        
    }
    @isTest static void level1(){
        account acc=new account(Timezone__c='-7',MonOpenHour__c='0000',MonCloseHour__c='2400',TueOpenHour__c='0000',
        TueCloseHour__c='2400',WedOpenHour__c='0000',WedCloseHour__c='2400',ThuOpenHour__c='0000',ThuCloseHour__c='2400',
        FriOpenHour__c='0000',FriCloseHour__c='2400',SatOpenHour__c='0000',SatCloseHour__c='2400',SunOpenHour__c='0000',
        SunCloseHour__c='2400');
        acc.Name = 'Test Account';
        insert acc;
        opportunity opp= new opportunity(Stagename='In Conversation',PreferredDealerAccount_TXT__c=acc.id,Name='SLA test class', 
         LeadProvider_ID__c=acc.id, Email__c='call.bijay1@gmail.com', ZipCode_TXT__c='12345',Routing_Status__c='Success', 
        First_Name_TXT__c='SLA test', Last_Name_TXT__c='class',Business_Hours_Elasped__c=49);
        opp.CloseDate= system.Today();
        insert opp;
        Test.startTest();
        string query='Select Id,Opportunity_SF_ID__c,Routing_Status__c,CreatedDate,name,Service_Level_Agreement_TXT__c,SubDiv_TXT__c , PreferredDealerAccount_TXT__r.Account_Timezone__c,PreferredDealerAccount_TXT__r.MonOpenHour__c,PreferredDealerAccount_TXT__r.MonCloseHour__c,PreferredDealerAccount_TXT__r.TueOpenHour__c,PreferredDealerAccount_TXT__r.TueCloseHour__c,PreferredDealerAccount_TXT__r.WedOpenHour__c,PreferredDealerAccount_TXT__r.WedCloseHour__c,PreferredDealerAccount_TXT__r.ThuOpenHour__c,PreferredDealerAccount_TXT__r.ThuCloseHour__c,PreferredDealerAccount_TXT__r.FriOpenHour__c,PreferredDealerAccount_TXT__r.FriCloseHour__c,PreferredDealerAccount_TXT__r.SatOpenHour__c,PreferredDealerAccount_TXT__r.SatCloseHour__c,PreferredDealerAccount_TXT__r.SunOpenHour__c,PreferredDealerAccount_TXT__r.SunCloseHour__c,Business_Hours_Elasped__c,Routing_Success_Date_Time__c from Opportunity';
        query += ' Where (StageName != \'Acknowledged\' AND StageName != \'Assigned to Dealer\')   and Routing_Status__c=\'Success\' and Response_Date_Time__c=null and createddate>=2022-03-03T00:05:30.000+0000  ' ;
        ResponseTimeCorrectionBatch cs = new ResponseTimeCorrectionBatch(query);
        Id jobid= Database.executeBatch(cs,1);
        Test.stopTest();
        
    }
    @isTest static void level2(){
        account acc=new account(Timezone__c='-7',MonOpenHour__c='0000',MonCloseHour__c='2400',TueOpenHour__c='0000',
        TueCloseHour__c='2400',WedOpenHour__c='0000',WedCloseHour__c='2400',ThuOpenHour__c='0000',ThuCloseHour__c='2400',
        FriOpenHour__c='0000',FriCloseHour__c='2400',SatOpenHour__c='0000',SatCloseHour__c='2400',SunOpenHour__c='0000',
        SunCloseHour__c='2400');
        acc.Name = 'Test Account';
        insert acc;
        opportunity opp= new opportunity(Stagename='In Conversation',PreferredDealerAccount_TXT__c=acc.id,Name='SLA test class', 
         LeadProvider_ID__c=acc.id, Email__c='call.bijay1@gmail.com', ZipCode_TXT__c='12345',Routing_Status__c='Success', 
        First_Name_TXT__c='SLA test', Last_Name_TXT__c='class',Business_Hours_Elasped__c=73);
        opp.CloseDate= system.Today();
        insert opp;
        Test.startTest();
        string query='Select Id,Opportunity_SF_ID__c,Routing_Status__c,CreatedDate,name,Service_Level_Agreement_TXT__c,SubDiv_TXT__c , PreferredDealerAccount_TXT__r.Account_Timezone__c,PreferredDealerAccount_TXT__r.MonOpenHour__c,PreferredDealerAccount_TXT__r.MonCloseHour__c,PreferredDealerAccount_TXT__r.TueOpenHour__c,PreferredDealerAccount_TXT__r.TueCloseHour__c,PreferredDealerAccount_TXT__r.WedOpenHour__c,PreferredDealerAccount_TXT__r.WedCloseHour__c,PreferredDealerAccount_TXT__r.ThuOpenHour__c,PreferredDealerAccount_TXT__r.ThuCloseHour__c,PreferredDealerAccount_TXT__r.FriOpenHour__c,PreferredDealerAccount_TXT__r.FriCloseHour__c,PreferredDealerAccount_TXT__r.SatOpenHour__c,PreferredDealerAccount_TXT__r.SatCloseHour__c,PreferredDealerAccount_TXT__r.SunOpenHour__c,PreferredDealerAccount_TXT__r.SunCloseHour__c,Business_Hours_Elasped__c,Routing_Success_Date_Time__c from Opportunity';
        query += ' Where (StageName != \'Acknowledged\' AND StageName != \'Assigned to Dealer\')   and Routing_Status__c=\'Success\' and Response_Date_Time__c=null and createddate>=2022-03-03T00:05:30.000+0000  ' ;
        ResponseTimeCorrectionBatch cs = new ResponseTimeCorrectionBatch(query);
        Id jobid= Database.executeBatch(cs,1);
        Test.stopTest();
        
    }
    @isTest static void level3(){
        account acc=new account(Timezone__c='-7',MonOpenHour__c='0000',MonCloseHour__c='2400',TueOpenHour__c='0000',
        TueCloseHour__c='2400',WedOpenHour__c='0000',WedCloseHour__c='2400',ThuOpenHour__c='0000',ThuCloseHour__c='2400',
        FriOpenHour__c='0000',FriCloseHour__c='2400',SatOpenHour__c='0000',SatCloseHour__c='2400',SunOpenHour__c='0000',
        SunCloseHour__c='2400');
        acc.Name = 'Test Account';
        insert acc;
        opportunity opp= new opportunity(Stagename='In Conversation',PreferredDealerAccount_TXT__c=acc.id,Name='SLA test class', 
         LeadProvider_ID__c=acc.id, Email__c='call.bijay1@gmail.com', ZipCode_TXT__c='12345',Routing_Status__c='Success', 
        First_Name_TXT__c='SLA test', Last_Name_TXT__c='class',Business_Hours_Elasped__c=98);
        opp.CloseDate= system.Today();
        insert opp;
        Test.startTest();
        string query='Select Id,Opportunity_SF_ID__c,Routing_Status__c,CreatedDate,name,Service_Level_Agreement_TXT__c,SubDiv_TXT__c , PreferredDealerAccount_TXT__r.Account_Timezone__c,PreferredDealerAccount_TXT__r.MonOpenHour__c,PreferredDealerAccount_TXT__r.MonCloseHour__c,PreferredDealerAccount_TXT__r.TueOpenHour__c,PreferredDealerAccount_TXT__r.TueCloseHour__c,PreferredDealerAccount_TXT__r.WedOpenHour__c,PreferredDealerAccount_TXT__r.WedCloseHour__c,PreferredDealerAccount_TXT__r.ThuOpenHour__c,PreferredDealerAccount_TXT__r.ThuCloseHour__c,PreferredDealerAccount_TXT__r.FriOpenHour__c,PreferredDealerAccount_TXT__r.FriCloseHour__c,PreferredDealerAccount_TXT__r.SatOpenHour__c,PreferredDealerAccount_TXT__r.SatCloseHour__c,PreferredDealerAccount_TXT__r.SunOpenHour__c,PreferredDealerAccount_TXT__r.SunCloseHour__c,Business_Hours_Elasped__c,Routing_Success_Date_Time__c from Opportunity';
        query += ' Where (StageName != \'Acknowledged\' AND StageName != \'Assigned to Dealer\')   and Routing_Status__c=\'Success\' and Response_Date_Time__c=null and createddate>=2022-03-03T00:05:30.000+0000  ' ;
        ResponseTimeCorrectionBatch cs = new ResponseTimeCorrectionBatch(query);
        Id jobid= Database.executeBatch(cs,1);
        Test.stopTest();
        
    }
    @isTest static void exc(){
        account acc=new account(Timezone__c='-7',MonOpenHour__c=null,MonCloseHour__c='2400',TueOpenHour__c='0000',
        TueCloseHour__c='2400',WedOpenHour__c='0000',WedCloseHour__c='2400',ThuOpenHour__c='0000',ThuCloseHour__c='2400',
        FriOpenHour__c='0000',FriCloseHour__c='2400',SatOpenHour__c='0000',SatCloseHour__c='2400',SunOpenHour__c='0000',
        SunCloseHour__c='2400');
        acc.Name = 'Test Account';
        insert acc;
        opportunity opp= new opportunity(Stagename='In Conversation',PreferredDealerAccount_TXT__c=acc.id,Name='SLA test class', 
         LeadProvider_ID__c=acc.id, Email__c='call.bijay1@gmail.com', ZipCode_TXT__c='12345',Routing_Status__c='Success', 
        First_Name_TXT__c='SLA test', Last_Name_TXT__c='class',Business_Hours_Elasped__c=98);
        opp.CloseDate= system.Today();
        
        insert opp;
        Test.startTest();
        
        string query='Select Id,Opportunity_SF_ID__c,Routing_Status__c,CreatedDate,name,Service_Level_Agreement_TXT__c,SubDiv_TXT__c , PreferredDealerAccount_TXT__r.Account_Timezone__c,PreferredDealerAccount_TXT__r.MonOpenHour__c,PreferredDealerAccount_TXT__r.MonCloseHour__c,PreferredDealerAccount_TXT__r.TueOpenHour__c,PreferredDealerAccount_TXT__r.TueCloseHour__c,PreferredDealerAccount_TXT__r.WedOpenHour__c,PreferredDealerAccount_TXT__r.WedCloseHour__c,PreferredDealerAccount_TXT__r.ThuOpenHour__c,PreferredDealerAccount_TXT__r.ThuCloseHour__c,PreferredDealerAccount_TXT__r.FriOpenHour__c,PreferredDealerAccount_TXT__r.FriCloseHour__c,PreferredDealerAccount_TXT__r.SatOpenHour__c,PreferredDealerAccount_TXT__r.SatCloseHour__c,PreferredDealerAccount_TXT__r.SunOpenHour__c,PreferredDealerAccount_TXT__r.SunCloseHour__c,Business_Hours_Elasped__c,Routing_Success_Date_Time__c from Opportunity';
        query += ' Where (StageName != \'Acknowledged\' AND StageName != \'Assigned to Dealer\')   and Routing_Status__c=\'Success\' and Response_Date_Time__c=null and createddate>=2022-03-03T00:05:30.000+0000  ' ;
        ResponseTimeCorrectionBatch cs = new ResponseTimeCorrectionBatch(query);
        Id jobid= Database.executeBatch(cs,1);
		String sch = '0 0 23 * * ?';
		system.schedule('Testing', sch, cs );
        Test.stopTest();
        
    }
   

}