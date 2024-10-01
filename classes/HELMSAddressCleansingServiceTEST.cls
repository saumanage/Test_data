@isTest
private class HELMSAddressCleansingServiceTEST {
    @isTest static void monday(){
        
        account acc=new account(Timezone__c='-7',MonOpenHour__c='0000',MonCloseHour__c='2400',TueOpenHour__c='0000',
        TueCloseHour__c='2400',WedOpenHour__c='0000',WedCloseHour__c='2400',ThuOpenHour__c='0000',ThuCloseHour__c='2400',
        FriOpenHour__c='0000',FriCloseHour__c='2400',SatOpenHour__c='0000',SatCloseHour__c='2400',SunOpenHour__c='0000',
        SunCloseHour__c='2400',ShippingStreet='1813 Ensley Avenue',ShippingCity='Birmingham',ShippingState='AL',ShippingPostalCode='35218',
                               ShippingCountry='US');
        acc.Name = 'Test Account';
        insert acc;
        Test.setMock(HttpCalloutMock.class, new HelmsAddressCleansingMockTest());
        Test.startTest();
        HELMSAddressCleansingService ba= new HELMSAddressCleansingService();
        Database.executeBatch(ba,1);
        Test.stopTest();
        string timezone= [select id,Realtime_TimeZone_Offset__c from account where id=:acc.id].Realtime_TimeZone_Offset__c;
        system.assertEquals('Eastern Standard Time (-4)', timezone);
    }
}