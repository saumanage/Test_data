/*-----------------------------------------------------------------------------------------------------------------------------------------
Class Name : HelmsActiveAdminUsersFileOverMail 
Test Class Name : HelmsActiveAdminUsersFileOverMailTest
Owner : Talapalle Vinay
Comments : Generate List of HELMS Active Admin Users in CSV file and sending over email 
-------------------------------------------------------------------------------------------------------------------------------------------
*/
global class HelmsActiveAdminUsersFileOverMail implements Schedulable {
   	global void execute(schedulablecontext sc){
        report();
    }
   global void report() {
        boolean sendmail=true;
       // Querying the list of active admin user records
       List<User> userList = [SELECT Id, Name, Profile.Name, Email, LastLoginDate
                              FROM User
                              WHERE IsActive = true AND Profile.Name = 'System Administrator'];
       if (!userList.isEmpty()) {
           // Generate CSV data
           String csvData = generateCSV(userList);
           // Sending the email with attached CSV file
            Messaging.SingleEmailMessage fromEmail=new Messaging.SingleEmailMessage();
        	OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'yourhonda@ebizmail.honda.com'];    
        	Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        	if ( owea.size() > 0 ) {
        	message.setOrgWideEmailAddressId(owea.get(0).Id);
        	}
           message.setSubject('Active HELMS Admin Users');
           String recipient = System.Label.HELMS_Active_Admin_Users_Recipients;
           List<string> toAddresses=recipient.split(',');
           message.setToAddresses(toAddresses);
           Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
           attachment.setFileName('User_Data_Report.csv');
           attachment.setBody(Blob.valueOf(csvData));
           Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
           message.setHtmlBody('<p>Hi Team,</p><p>Please find the attached file for HELMS Active Admin Users.</p><p>Thanks,<br/>Honda LMS</p>');
           message.setFileAttachments(new Messaging.EmailFileAttachment[]{attachment});
           Messaging.SingleEmailMessage[] messages =new List<Messaging.SingleEmailMessage> {message};
                if(sendmail = true){
                    Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);  
                }
       }
   }
   private String generateCSV(List<User> userList) {
       // Header row
       String csvData = 'ID,Name,Profile,Email,Last Login Date\n';
       // Populate data in rows
       for(User userRec : userList) {
           csvData += userRec.Id + ',';
           csvData += userRec.Name.replace(',', '') + ',';
           csvData += userRec.Profile.Name.replace(',', '') + ',';
           csvData += userRec.Email.replace(',', '') + ',';
           csvData += String.valueOf(userRec.LastLoginDate) + '\n';
       }
       return csvData;
   }
}