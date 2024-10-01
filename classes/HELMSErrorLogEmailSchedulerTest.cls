@IsTest(IsParallel=true) 
Public class HELMSErrorLogEmailSchedulerTest{
   
    public static testMethod void testschedule() {
        Test.StartTest();
       
        
        list<logs__c> lgList= new list<logs__c>();
        logs__c lg1= new logs__c();
        lg1.Name = 'Unsuccessful log-in attempts from SSO';
        lg1.Type__c = 'Unsuccessful log-in attempts from SSO';
        lgList.add(lg1);
        
        logs__c lg2= new logs__c();
        lg2.Name = 'Unsuccessful log-in attempts from SSO';
        lg2.Type__c = 'Unsuccessful log-in attempts from SSO';
        lgList.add(lg2);
       
        logs__c lg3= new logs__c();
        lg3.Name = 'Lead insertion failures';
        lg3.Type__c = 'Lead insertion failures';
        lgList.add(lg3);
        
        logs__c lg4= new logs__c();
        lg4.Name = 'Lead insertion failures';
        lg4.Type__c = 'Lead insertion failures';
        lgList.add(lg4);
        
        logs__c lg5= new logs__c();
        lg5.Name = 'Lead enrichment call failures';
        lg5.Type__c = 'Lead enrichment call failures';
        lgList.add(lg5);
        
        logs__c lg6= new logs__c();
        lg6.Name = 'Lead enrichment call failures';
        lg6.Type__c = 'Lead enrichment call failures';
        lgList.add(lg6);
        
        logs__c lg7= new logs__c();
        lg7.Name = 'Lead routing failure';
        lg7.Type__c = 'Lead routing failure';
        lgList.add(lg7);
        
        logs__c lg8= new logs__c();
        lg8.Name = 'Lead routing failure';
        lg8.Type__c = 'Lead routing failure';
        lgList.add(lg8);
        
        insert lgList;
        
        HELMSErrorLogEmailScheduler testsche = new HELMSErrorLogEmailScheduler();
        
        String sch = '0 0 23 * * ?';
        system.schedule('Test status Check', sch, testsche );
        
        
        
        
        
        Test.stopTest();
    }
}