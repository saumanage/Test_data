@isTest
private class HelmsActiveAdminUsersFileOverMailTest {
	@isTest
    static void testHelmsActiveAdminUsersFileOverMail(){
        Profile prof = [Select Id from Profile where Name='System Administrator' Limit 1];
        User user1 = new User(
        FirstName = 'Test',
        LastName = 'User',
        Email = 'testuser@example.com',
        Username = 'activeadmin@helmsuser.com',
        Alias = 'tuser',
        ProfileId = prof.Id,
        EmailEncodingKey = 'UTF-8',
        LanguageLocaleKey = 'en_US',
        LocaleSidKey = 'en_US',
        TimeZoneSidKey = 'America/Los_Angeles'
        );
        
        Test.startTest();
        insert user1;
        Test.stopTest();
        HelmsActiveAdminUsersFileOverMail adminUsers = new HelmsActiveAdminUsersFileOverMail();
        adminUsers.report();
    }
}