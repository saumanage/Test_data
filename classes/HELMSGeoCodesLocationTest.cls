@isTest
public class HELMSGeoCodesLocationTest {
    public static testMethod void testGeoLocation() {
        Set<Id> setId = new Set<ID>();
        Opportunity opp1 = new Opportunity(Name='John Miller',StageName='Sales Order', CloseDate=Date.today(), First_Name_TXT__c='John', Last_Name_TXT__c='Miller',City_TXT__c='Bronx',State_TXT__c='New York',ZipCode_TXT__c='10451',Division_CD__c ='P',SubDiv_TXT__c='PowerEquipment');
        insert opp1;
        setId.add(opp1.id);
        Test.setMock(HttpCalloutMock.class, new HELMSGeoLocationMockTest());  
		Test.startTest();
        HELMSGeoCodesLocationAPI.getGeocodes(setId);
        Test.stopTest();
    }

}