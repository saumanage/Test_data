/*----------------------------------------------------------------------------------------------------------------------------------------------------
Class Name : DeactivateFieldLinkUsersBatch 
Test Class Name : DeactivateFieldLinkUsersBatchTest
Last Modified Version Owner : Saikiran Siddipeta
Comments : Code to deactivate the Field Link Users who have not logged in for more than 60 days (AMSLM-459)
-------------------------------------------------------------------------------------------------------------------------------------------------------
*/
global class DeactivateFieldLinkUsersBatch implements Database.Batchable<sObject>,Database.stateful,Schedulable {
     Integer count;
  
              
            // Start Method
              List<User> lstUsers = new List<User>();
    
               global Database.QueryLocator start(Database.BatchableContext bC) {          
                   String query = 'select Id,Name,firstname,lastname,username,IsActive,DealerNumber_NUM__c,ProfileId,FederationIdentifier,LastLoginDate,email    from User where Profile.Name =\'HELMS Field User\' and IsActive = true and LastLoginDate < LAST_N_DAYS:60';       
               //    system.debug(' Inside start method $$ '+query);
                   return Database.getQueryLocator(query);
               }
            
              // Execute method
              
               global void execute(Database.BatchableContext bC, List<user> fieldLinkUsers) {
                   try{
                   
           //    system.debug(' Inside execute method $$ ');
           //    system.debug('fieldLinkUsers  count: '+fieldLinkUsers.size());
                       
               Map<string,string> sendmap = new map<string,string>();
                       
            for(user newuser :fieldLinkUsers){
             
                sendmap.put(newuser.Name, newuser.Email);
                
                   if(newuser.IsActive == true){                      
                   newuser.IsActive = false;
                   lstUsers.add(newuser);
                   count=lstUsers.size();
               //    system.debug(' count :: '+count);    
               //    system.Debug( 'newuser :: '+lstUsers);  
                    if(lstUsers.size()>0){			
                    //    update lstUsers;
               //   system.debug(' ddccList : '+lstUsers);
						}  
                  }
            }  
                       string prebody='';
                       OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'yourhonda@ebizmail.honda.com'];    
                       Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                       if ( owea.size() > 0 ) {
                       message.setOrgWideEmailAddressId(owea.get(0).Id);
                      }    
                        //   List<String> toAddresses = new List<String>(SendMap.values());  
						  String toAddress1 = Label.System_Health_Alerts;
                         List<string> toAddresses=toAddress1.split(','); 
                      //     System.debug('toAddresses List :'+toAddresses);                       
                           message.setToAddresses(toAddresses);                        
                       //    String ccAddress1 = Label.System_Health_Alerts;
                       //    List<string> ccAddresses=ccAddress1.split(',');    
                       //    message.setCcAddresses(ccAddresses);                       
                          message.setSubject('noreply@salesforce.com');
                       	  String body=prebody;
                       	  body = body+'<br/>Hi Team,<br/>Please find the below list of deactivated Field Link Users who have not logged in for more than 60 days.</br>';
                          body = body+'<br/>';
                          body=body+'<html><style>table, th, td {border:1px solid Black;}</style><body><table><style>th:nth-child(odd) {background-color: #2E5984;color: #FFFFFF;}th:nth-child(even) {background-color: #2E5984;color: #FFFFFF;</Style><tr><th>Name of the Users</th><th>Users Emails</th></tr>';
                          for(string str :SendMap.keySet()){
                           body = body+'<tr><td>'+str+'<br/>'+'</td><td>'+SendMap.get(str)+'<br/>'+'</td></tr>';
                        }
                        body = body+'</table></body></html>';
                        body = body+'<br/>Thanks,</br>HONDA LMS';
                        body = body+'<br/><P style="color:red"><b>NOTE: Deactivated Users can login again ,when they login through Honda Web.</b></P>'; 
                       message.setHtmlBody(body);   
                        Messaging.SingleEmailMessage[] messages =new List<Messaging.SingleEmailMessage> {message};
                        Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
                      if (results[0].success) {
                //       System.debug('The email was sent successfully.');
                         } else {
                //       System.debug('The email failed to send: '+ results[0].errors[0].message);
                           } 

                   }Catch(Exception ex){                       
            Logs__c  l =new Logs__c (name=' HelmsOpportunityNotificationSms ',Trigger_or_Class_Name__c='HelmsOpportunityNotificationSms', Error_Message__c =ex.getMessage(), Error_Line_Number__c =Integer.valueOf(string.valueof(ex.getLineNumber() )) );
          insert l;
        }
			   }

               // Finish Method
            
                      global void finish(Database.BatchableContext bC) {
                          DeactivateFieldLinkUsersSecondBatch b = new DeactivateFieldLinkUsersSecondBatch(lstUsers);
                          Database.executeBatch(b, 200);
                          
               }
    
           public void execute(SchedulableContext sc){
        DeactivateFieldLinkUsersBatch cs = new DeactivateFieldLinkUsersBatch();
        Id jobID=Database.executeBatch(cs);
    }
         
	 
                     
            }