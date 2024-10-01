@isTest
private class HELMSAdditionalDataScoringServiceTest2 {
    
    @isTest static void POSTCalloutTest(){
       Test.startTest();
       	
       Test.setMock(HttpCalloutMock.class, new HELMSAdditionalDataMock2());
       Lead l = new Lead();
        
       l.FirstName = 'Francisco';
       l.LastName = 'Ramos';
       l.Email = 'terihonda@outlook.com';
       l.Phone = '(707) 570-8801';
       l.Country = 'US';
       l.State = 'MD';
       l.City = 'Waldorf';
       l.Status = 'New';
       l.Division_CD__c = 'A';
       l.SubDiv_TXT__c = 'Honda';
       l.Make_TXT__c = 'Honda';
       l.Model_TXT__c = 'Civic Type R';
       l.Year_YR__c = '2020';
       insert l;
       Set<id> leadIds = new Set<Id>();
       List<Lead> tlsBefore = [SELECT ID, Is_ECRM_Update_Done__c, FirstName FROM Lead];
       leadIds.add(tlsBefore[0].Id);
       HELMSAdditionalDataScoringService.GetAdditionaldata(leadIds);
        Test.stopTest();
        
        List<Lead> tlsAfter = [SELECT ID, Is_ECRM_Update_Done__c FROM Lead];
        lIST<Logs__c> error = [SELECT ID , 	Error_Message__c FROM Logs__c];
        //if(!error.isEmpty())
        //System.debug(error[0].Error_Message__c);
	        
       //System.assertEquals(tlsAfter[0].Is_ECRM_Update_Done__c, true);
    }
    
    @isTest static void POSTCalloutTest2(){
        Test.startTest();
       	
       Test.setMock(HttpCalloutMock.class, new HELMSAdditionalDataMock2());
       Lead l = new Lead();
        
       l.FirstName = 'Francisco';
       l.LastName = 'Ramos';
       l.Email = 'terihonda@outlook.com';
       l.Phone = '(707) 570-8801';
       l.Country = 'US';
       l.State = 'MD';
       l.City = 'Waldorf';
       l.Status = 'New';
       l.Division_CD__c = 'A';
       l.SubDiv_TXT__c = 'Honda';
       l.Make_TXT__c = 'Honda';
       l.Model_TXT__c = 'Civic Type R';
       l.Year_YR__c = '2020';
       l.Is_HELMS_Contact_Key__c = true;
       insert l;
        
       Set<id> leadIds = new Set<Id>();
       List<Lead> tlsBefore = [SELECT ID, Is_ECRM_Update_Done__c, FirstName FROM Lead];
       leadIds.add(tlsBefore[0].Id);
       HELMSAdditionalDataScoringService.GetAdditionaldata(leadIds);
        Test.stopTest();
        
        List<Lead> tlsAfter = [SELECT ID, Is_ECRM_Update_Done__c FROM Lead];
        lIST<Logs__c> error = [SELECT ID , 	Error_Message__c FROM Logs__c];
        //if(!error.isEmpty())
        //System.debug(error[0].Error_Message__c);
    }

}