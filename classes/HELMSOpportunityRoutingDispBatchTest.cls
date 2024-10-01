@isTest 
public class HELMSOpportunityRoutingDispBatchTest
{
   @isTest static void testRoutingDispositionMethod()
    {        
        Account acc = new Account();
        acc.Name = 'Test Account';
        insert acc;
        List<Opportunity> listOpp = new List<Opportunity>();
       
        Id hondaRecTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Honda Opportunity').getRecordTypeId();
        
        Opportunity oppty = new Opportunity(Name='TestLavanya1 TestGrandhi1',First_Name_TXT__c = 'TestLavanya1',Last_Name_TXT__c = 'TestGrandhi1',
        Stagename='Acknowledged',OpportunityStatus_TXT__c = 'Auto-response sent',Email__c='testLavanya@gmail.com',ZipCode_TXT__c='12345',
        Phone__c='7780190896',Updated_by_New_MB__c=false,RecordTypeId=hondaRecTypeId,Division_CD__c='A',PreferredDealerNumber_NUM__c='222276',
        CreatedDate = System.today()-5,CloseDate = System.today()+10,Service_Level_Agreement_TXT__c='Level 2');
       
        
         Opportunity oppty1 = new Opportunity(Name='TestLavanya2 TestGrandhi2',First_Name_TXT__c = 'TestLavanya2',Last_Name_TXT__c = 'TestGrandhi1',
        Stagename='Acknowledged',OpportunityStatus_TXT__c = 'Lead Opened',Email__c='testLavanya@gmail.com',ZipCode_TXT__c='12345',
        Phone__c='7780190896',Updated_by_New_MB__c=false,RecordTypeId=hondaRecTypeId,Division_CD__c='A',PreferredDealerNumber_NUM__c='222276',
        CreatedDate = System.today()-5,CloseDate = System.today()+10,Service_Level_Agreement_TXT__c='Level 2');
        
        Opportunity oppty2 = new Opportunity(Name='TestLavanya2 TestGrandhi2',First_Name_TXT__c = 'TestLavanya2',Last_Name_TXT__c = 'TestGrandhi1',
        Stagename='Acknowledged',OpportunityStatus_TXT__c = 'Auto-response sent',Email__c='testLavanya@gmail.com',ZipCode_TXT__c='12345',
        Phone__c='7780190896',Updated_by_New_MB__c=false,RecordTypeId=hondaRecTypeId,Division_CD__c='A',PreferredDealerNumber_NUM__c='222276',
        CreatedDate = System.today()-5,CloseDate = System.today()+10,Service_Level_Agreement_TXT__c='Level 2');
        
        Opportunity oppty3 = new Opportunity(Name='TestLavanya2 TestGrandhi2',First_Name_TXT__c = 'TestLavanya2',Last_Name_TXT__c = 'TestGrandhi1',
        Stagename='Acknowledged',OpportunityStatus_TXT__c = 'Auto-response sent',Email__c='testLavanya@gmail.com',ZipCode_TXT__c='12345',
        Phone__c='7780190896',Updated_by_New_MB__c=false,RecordTypeId=hondaRecTypeId,Division_CD__c='A',PreferredDealerNumber_NUM__c='222276',
        CreatedDate = System.today()-5,CloseDate = System.today()+10,Service_Level_Agreement_TXT__c='Level 2');
        
        
         listOpp.add(oppty);
        listOpp.add(oppty1);
         listOpp.add(oppty2);
         listOpp.add(oppty3);
        
        insert listOpp;
        
        for(Opportunity eachOpp:listOpp) {
            eachOpp.Opportunity_SF_ID__c = eachOpp.Id;
        }
        update listOpp;
        
        List<Task> tsk = new List<Task>();
        Task task = new Task(WhatId = Oppty.Id, Subject = 'inbound Call');
            tsk.add(task);
        insert task;
        
       Profile p = [Select Id From Profile Where Name = 'System Administrator'];
        User u = new User(firstname= 'Test',
                          lastname='User',
                          Alias='TUser',
                          email = 'test@test.com',
                          username= 'testWipro@test.com', 
                          profileId= p.id, 
                          emailencodingkey='UTF-8',
                          languagelocalekey='en_US',
                          localesidkey='en_US',
                          timezonesidkey='America/Los_Angeles');
        insert u;    
        
        System.runAs(u){
            List<Routing_Dealer_CRM_Disposition__c> listDealerDisp = new List<Routing_Dealer_CRM_Disposition__c>();
            for(integer i =0 ; i < 4 ; i++){
                Routing_Dealer_CRM_Disposition__c dealerDisp = new Routing_Dealer_CRM_Disposition__c();
                dealerDisp.HELMS_Opportunity_External_Key__c = listOpp[i].Id;
                dealerDisp.Response_Time__c = system.today();
                dealerDisp.The_Last_Event__c = String.Valueof(i+1);
                listDealerDisp.add(dealerDisp); 
            }
            
            insert listDealerDisp;
        }
        
        Test.startTest();

            string query='Select id,Name,Arrival_Time_DT_c__c,Auto_Response__c,Current_Status__c,Is_Processed_Job__c,Response_Time__c, HELMS_Opportunity_External_Key__c, OwnerId,The_Last_Event__c,CreatedDate from Routing_Dealer_CRM_Disposition__c where Is_Processed_Job__c !=true order by CreatedDate asc';
                
            HELMSOpportunityRoutingDispositionBatch  disbatch = new HELMSOpportunityRoutingDispositionBatch(query);
            Id batchId = Database.executeBatch(disbatch ,200);
            system.assertEquals('TestLavanya2 TestGrandhi2', oppty3.Name);
            
        Test.stopTest();
    }
    @IsTest
    public static void testSchedulebatch()
    {
        Test.startTest();
        
        HELMSOpportunityRoutingDispositionBatch disbatch= new HELMSOpportunityRoutingDispositionBatch();
        String sch = '0 0 5 * * ?';
        system.schedule('Test status Check', sch, disbatch);
        Test.stopTest();
    } 
}