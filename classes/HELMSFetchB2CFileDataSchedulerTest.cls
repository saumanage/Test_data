@istest
Public class HELMSFetchB2CFileDataSchedulerTest{
    public static testMethod void testschedule() {
        Test.StartTest();
        HELMSFetchB2CFileDataScheduler testsche = new HELMSFetchB2CFileDataScheduler();
        String sch = '0 0 23 * * ?';
        system.schedule('Test status Check', sch, testsche );
        Test.setMock(HttpCalloutMock.class, new HELMSHttpCalloutMockImpl());
        Test.stopTest();
    }
}