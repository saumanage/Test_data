@isTest
private class HELMSBUSINESSHOURSCALCULATIONTEST {
    @isTest static void monday(){
        account acc=new account(Timezone__c='-7',MonOpenHour__c='0000',MonCloseHour__c='2400',TueOpenHour__c='0000',
        TueCloseHour__c='2400',WedOpenHour__c='0000',WedCloseHour__c='2400',ThuOpenHour__c='0000',ThuCloseHour__c='2400',
        FriOpenHour__c='0000',FriCloseHour__c='2400',SatOpenHour__c='0000',SatCloseHour__c='2400',SunOpenHour__c='0000',
        SunCloseHour__c='2400');
        acc.Name = 'Test Account';
        insert acc;
        opportunity opp= new opportunity(Stagename='Assigned to Dealer',PreferredDealerAccount_TXT__c=acc.id,Name='SLA test class', 
         LeadProvider_ID__c=acc.id, Email__c='call.bijay1@gmail.com', ZipCode_TXT__c='12345', 
        First_Name_TXT__c='SLA test', Last_Name_TXT__c='class');
        opp.CloseDate= system.Today();
        opp.createddate=system.now()-20;
        insert opp;
        Test.startTest();
        HELMSBUSINESSHOURSCALCULATION ba= new HELMSBUSINESSHOURSCALCULATION();
        Id jobid= Database.executeBatch(ba,1);
        Test.stopTest();
        string level= [select id,Service_Level_Agreement_TXT__c from opportunity where id=:opp.id].Service_Level_Agreement_TXT__c;
        //system.assertEquals('Level 3', level);
    }
    @isTest static void level1(){
        account acc=new account(Timezone__c='-7',MonOpenHour__c='0000',MonCloseHour__c='2400',TueOpenHour__c='0000',
        TueCloseHour__c='2400',WedOpenHour__c='0000',WedCloseHour__c='2400',ThuOpenHour__c='0000',ThuCloseHour__c='2400',
        FriOpenHour__c='0000',FriCloseHour__c='2400',SatOpenHour__c='0000',SatCloseHour__c='2400',SunOpenHour__c='0000',
        SunCloseHour__c='2400');
        acc.Name = 'Test Account';
        insert acc;
        opportunity opp= new opportunity(Stagename='Assigned to Dealer',PreferredDealerAccount_TXT__c=acc.id,Name='SLA test class', 
         LeadProvider_ID__c=acc.id, Email__c='call.bijay1@gmail.com', ZipCode_TXT__c='12345', 
        First_Name_TXT__c='SLA test', Last_Name_TXT__c='class',Business_Hours_Elasped__c=49);
        opp.CloseDate= system.Today();
        opp.createddate=system.now()-2.5;
        insert opp;
        Test.startTest();
        HELMSBUSINESSHOURSCALCULATION ba= new HELMSBUSINESSHOURSCALCULATION();
        Id jobid= Database.executeBatch(ba,1);
        Test.stopTest();
        string level= [select id,Service_Level_Agreement_TXT__c from opportunity where id=:opp.id].Service_Level_Agreement_TXT__c;
        //system.assertEquals('Level 1', level);
        
    }
    @isTest static void level2(){
        account acc=new account(Timezone__c='-7',MonOpenHour__c='0000',MonCloseHour__c='2400',TueOpenHour__c='0000',
        TueCloseHour__c='2400',WedOpenHour__c='0000',WedCloseHour__c='2400',ThuOpenHour__c='0000',ThuCloseHour__c='2400',
        FriOpenHour__c='0000',FriCloseHour__c='2400',SatOpenHour__c='0000',SatCloseHour__c='2400',SunOpenHour__c='0000',
        SunCloseHour__c='2400');
        acc.Name = 'Test Account';
        insert acc;
        opportunity opp= new opportunity(Stagename='Assigned to Dealer',PreferredDealerAccount_TXT__c=acc.id,Name='SLA test class', 
         LeadProvider_ID__c=acc.id, Email__c='call.bijay1@gmail.com', ZipCode_TXT__c='12345', 
        First_Name_TXT__c='SLA test', Last_Name_TXT__c='class',Business_Hours_Elasped__c=73);
        opp.CloseDate= system.Today();
        opp.createddate=system.now()-3.5;
        insert opp;
        Test.startTest();
        HELMSBUSINESSHOURSCALCULATION ba= new HELMSBUSINESSHOURSCALCULATION();
        Id jobid= Database.executeBatch(ba,1);
        Test.stopTest();
        string level= [select id,Service_Level_Agreement_TXT__c from opportunity where id=:opp.id].Service_Level_Agreement_TXT__c;
        //system.assertEquals('Level 2', level);
        
    }
    @isTest static void level3(){
        account acc=new account(Timezone__c='-7',MonOpenHour__c='0000',MonCloseHour__c='2400',TueOpenHour__c='0000',
        TueCloseHour__c='2400',WedOpenHour__c='0000',WedCloseHour__c='2400',ThuOpenHour__c='0000',ThuCloseHour__c='2400',
        FriOpenHour__c='0000',FriCloseHour__c='2400',SatOpenHour__c='0000',SatCloseHour__c='2400',SunOpenHour__c='0000',
        SunCloseHour__c='2400');
        acc.Name = 'Test Account';
        insert acc;
        opportunity opp= new opportunity(Stagename='Assigned to Dealer',PreferredDealerAccount_TXT__c=acc.id,Name='SLA test class', 
         LeadProvider_ID__c=acc.id, Email__c='call.bijay1@gmail.com', ZipCode_TXT__c='12345', 
        First_Name_TXT__c='SLA test', Last_Name_TXT__c='class',Business_Hours_Elasped__c=98);
        opp.CloseDate= system.Today();
        opp.createddate=system.now()-20;
        insert opp;
        Test.startTest();
        HELMSBUSINESSHOURSCALCULATION ba= new HELMSBUSINESSHOURSCALCULATION();
        Id jobid= Database.executeBatch(ba,1);
        Test.stopTest();
        string level= [select id,Service_Level_Agreement_TXT__c from opportunity where id=:opp.id].Service_Level_Agreement_TXT__c;
        //system.assertEquals('Level 3', level);
        
    }
    @isTest static void exc(){
        account acc=new account(Timezone__c='-7',MonOpenHour__c=null,MonCloseHour__c='2400',TueOpenHour__c='0000',
        TueCloseHour__c='2400',WedOpenHour__c='0000',WedCloseHour__c='2400',ThuOpenHour__c='0000',ThuCloseHour__c='2400',
        FriOpenHour__c='0000',FriCloseHour__c='2400',SatOpenHour__c='0000',SatCloseHour__c='2400',SunOpenHour__c='0000',
        SunCloseHour__c='2400');
        acc.Name = 'Test Account';
        insert acc;
        opportunity opp= new opportunity(Stagename='Assigned to Dealer',PreferredDealerAccount_TXT__c=acc.id,Name='SLA test class', 
         LeadProvider_ID__c=acc.id, Email__c='call.bijay1@gmail.com', ZipCode_TXT__c='12345', 
        First_Name_TXT__c='SLA test', Last_Name_TXT__c='class',Business_Hours_Elasped__c=98);
        opp.CloseDate= system.Today();
        opp.createddate=system.now()-20;
        insert opp;
        Test.startTest();
        
        HELMSBUSINESSHOURSCALCULATION ba= new HELMSBUSINESSHOURSCALCULATION();
        Id jobid= Database.executeBatch(ba,1);
		String sch = '0 0 23 * * ?';
		system.schedule('Testing', sch, ba );
        Test.stopTest();
    }
   

}