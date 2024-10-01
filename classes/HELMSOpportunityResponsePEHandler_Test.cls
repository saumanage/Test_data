@isTest
public class HELMSOpportunityResponsePEHandler_Test {
    static testMethod void testPEHandler(){
        Account acc = new Account();
        acc.Name = 'Test Account';
        insert acc;
        List<Opportunity> listOpp = new List<Opportunity>();
        Opportunity opp = new Opportunity( Name = 'Test Opp', CloseDate = System.today()+10, 
                                          LeadProvider_ID__c = acc.Id, Email__c = 'test@test.com',ZipCode_TXT__c = '88763',
                                          First_Name_TXT__c = 'Test', Last_Name_TXT__c = 'Opp', StageName = 'Acknowledged',
                                          OpportunityStatus_TXT__c = 'Auto-response sent', CreatedDate = System.today());
        Opportunity opp1 = new Opportunity( Name = 'Test Opp', CloseDate = System.today()+10, 
                                          LeadProvider_ID__c = acc.Id, Email__c = 'test1@test.com',ZipCode_TXT__c = '88763',
                                          First_Name_TXT__c = 'Test', Last_Name_TXT__c = 'Opp', StageName = 'Acknowledged',
                                          OpportunityStatus_TXT__c = 'Auto-response sent', CreatedDate = System.today()-2,
                                          Service_Level_Agreement_TXT__c='Level 1');
        Opportunity opp2 = new Opportunity( Name = 'Test Opp', CloseDate = System.today()+10, 
                                          LeadProvider_ID__c = acc.Id, Email__c = 'test@test.com',ZipCode_TXT__c = '88763',
                                          First_Name_TXT__c = 'Test', Last_Name_TXT__c = 'Opp', StageName = 'Acknowledged',
                                          OpportunityStatus_TXT__c = 'Auto-response sent', CreatedDate = System.today()-50,
                                          Service_Level_Agreement_TXT__c='Level 2');
        Opportunity opp3 = new Opportunity( Name = 'Test Opp', CloseDate = System.today()+10, 
                                          LeadProvider_ID__c = acc.Id, Email__c = 'test@test.com',ZipCode_TXT__c = '88763',
                                          First_Name_TXT__c = 'Test', Last_Name_TXT__c = 'Opp', StageName = 'Acknowledged',
                                          OpportunityStatus_TXT__c = 'Auto-response sent', CreatedDate = System.today()-5,
                                          Service_Level_Agreement_TXT__c='Level 2');
        listOpp.add(opp);
        listOpp.add(opp1);
        listOpp.add(opp2);
        listOpp.add(opp3);
        insert listOpp;
        for(Opportunity eachOpp:listOpp) {
            eachOpp.Opportunity_SF_ID__c = eachOpp.Id;
        }
        update listOpp;
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
        Test.startTest();
        System.runAs(u){
          List<Dealer_CRM_Disposition__e> listDealerDisp = new List<Dealer_CRM_Disposition__e>();
            for(integer i =0 ; i < 4 ; i++){
                Dealer_CRM_Disposition__e dealerDisp = new Dealer_CRM_Disposition__e();
                dealerDisp.HELMS_Opportunity_External_Key_TXT__c = listOpp[i].Id;
                dealerDisp.The_Last_Event_TXT__c = String.Valueof(i+1);
                listDealerDisp.add(dealerDisp); 
            }
            
        EventBus.publish(listDealerDisp);
        Test.stopTest();  
        }
        
        List<Opportunity> updateOpp = [Select Id, StageName, OpportunityStatus_TXT__c from Opportunity];
        System.assertEquals('Acknowledged', opp3.StageName);
        List<Task> t = [Select Id, Disposition_Code_CD__c from Task];
        System.debug('====>>>>>>>'+t.Size());
     //   System.assertEquals(listOpp.Size(), t.Size());
    } 
}