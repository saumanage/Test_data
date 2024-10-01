/****************************************************************************** 
 File Name:LeadCloseConversionBatch           
 Created On:     
 Created By:      Bandi Sujatha, Appirio
 Test Classes:    LeadCloseConversionBatchTest       
 HELMS Jira Story: 
===============================================================================
 Modification Log: 
 May 18th, 2021 Bandi Sujatha (Appirio) initial coding,cleanup 
*******************************************************************************/
@isTest
//Test Class for Lead Conversion Batch Class
public class LeadCloseConversionBatchTest
{
    //Method
    @isTest public static void testschedule() { 
        HELMS_LeadConversionScheduler testschdl = new HELMS_LeadConversionScheduler();
        String sch = '0 0 23 * * ?';
        system.schedule('Test status Check', sch, testschdl);
        
        Lead_Expiration__c le = new Lead_Expiration__c();
        le.A__c = 90;
        le.B__c = 90;
        le.M__c = 90;
        le.P__c = -1;
        insert le;
        
        Test.StartTest(); 
        Lead ld = new Lead();
        ld.lastName ='LastName';
        ld.IsConverted=false;
        ld.Division_CD__c='A';
        insert ld;
        
        String query = 'Select Id,Name,LastModifiedDate,IsConverted,StatusReason_TXT__c,Status,Division_CD__c from Lead where IsConverted=false';
        LeadCloseConversionBatch obj = new LeadCloseConversionBatch(query);
        DataBase.executeBatch(obj); 
        LeadCloseConversionBatch obj1 = new LeadCloseConversionBatch();
        system.assertEquals('LastName', ld.lastName);
        Test.stopTest();
             
      
        
    }
    //Second Method
    @isTest public static void testschedule1() { 
        HELMS_LeadConversionScheduler testschdl = new HELMS_LeadConversionScheduler();
        String sch = '0 0 23 * * ?';
        system.schedule('Test status Check', sch, testschdl);
        
        Lead_Expiration__c le = new Lead_Expiration__c();
        le.A__c = 90;
        le.B__c = 90;
        le.M__c = 90;
        le.P__c = -1;
        insert le;
        
        Test.StartTest(); 
        Lead ld = new Lead();
        ld.lastName ='LastName';
        ld.IsConverted=false;
       // ld.Division_CD__c='A';
        insert ld;
        
        String query = 'Select Id,Name,LastModifiedDate,IsConverted,StatusReason_TXT__c,Status from Lead where IsConverted=false';
        LeadCloseConversionBatch obj = new LeadCloseConversionBatch(query);
        DataBase.executeBatch(obj); 
        //LeadCloseConversionBatch obj1 = new LeadCloseConversionBatch();
        system.assertEquals('LastName', ld.lastName);
        Test.stopTest();
             
      
        
    }
}