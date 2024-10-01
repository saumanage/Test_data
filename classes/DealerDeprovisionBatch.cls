/*----------------------------------------------------------------------------------------------------------------------------------------------------
Class Name : DealerDeprovisionBatch 
Test Class Name : DealerDeprovisionBatchTest
Last Modified Version Owner : Saikiran Siddipeta
Comments : Code is used to deactivate the HELMS Patner community Users ,when criteria doesnt match ,like Dealer_Deprovision__c's 
'iNg_'+newDealer.Dealer_Number__c+'_'+newDealer.LogonId__c matches to the User's FederationIdentifier then it will skip the matched users and deactivate the remaining users. (AMSLM-5009)
-------------------------------------------------------------------------------------------------------------------------------------------------------
*/
global class DealerDeprovisionBatch implements Database.Batchable<sObject>,Database.stateful,Schedulable {
    Integer count;
    Set<string> uniqueName = new set<string>();
    List<User> lstUsers = new List<User>();
    Set<Id> setIDs=new Set<Id>();
    
    // Start Method
    global Database.QueryLocator start(Database.BatchableContext bC) {          
                   String query = 'select Id,Name,firstname,lastname,username,IsActive,DealerNumber_NUM__c,ProfileId,ContactId,Application_Name__c,FederationIdentifier    from User where Profile.Name =\'HELMS Partner Community\' and Application_Name__c  != \'Manage Orders\''+(Test.isRunningTest()?' LIMIT 100':'');
     //   system.debug(' Inside start method $$ '+query);
        return Database.getQueryLocator(query); 
    }

   // Execute method
    global void execute(Database.BatchableContext bC, List<user> patnerUssers) {
      //  system.debug(' Inside execute method $$ ');             
        List<Dealer_Deprovision__c> listd= new List<Dealer_Deprovision__c>();
        List<Dealer_Deprovision__c> newList= new List<Dealer_Deprovision__c>();
        
       //here we are filtering the Stating records which are created today and IsProcessed equals to false
                  // limit updated as part of AMSLM-991     
                   listd=[Select id,Name,LogonId__c,FirstName__c,LastName__c,Dealer_Number__c,Application_Name__c,IsProcessed__c,Processed_Time__c from Dealer_Deprovision__c where createdDate=today and IsProcessed__c=False LIMIT 8000];
        count=listd.size();
   //     system.debug(' count :: '+count);
        if(listd.size()>0){
            
        
        for(Dealer_Deprovision__c newDealer: listd){
            if(!setIDs.contains(newDealer.Id)){  
        //      System.debug(' set ids inside if : ');
          //  string newUniqueName = newDealer.Dealer_Number__c+newDealer.FirstName__c+newDealer.LastName__c;
          //  example   FederationIdentifier = iNg_251012_HELMSDEALERSALES
            string newUniqueName = 'iNg_'+newDealer.Dealer_Number__c+'_'+newDealer.LogonId__c;
                           
      //      system.debug('newUniqueName : '+newUniqueName);
            newDealer.IsProcessed__c=true;
            newDealer.Processed_Time__c= system.now();
            newList.add(newDealer);
            uniqueName.add(newUniqueName);  
            
            }else{
                setIDs.add(newDealer.Id); 
            }
        //    System.debug(' set ids after if : '+setIDs);
           
        }
            if(newList.size()>0){
                 update newList;
            }
           
       //     system.debug('uniqueName : dealer '+uniqueName);
            
    }
               
     //here we are comparing with dealer number,first name ,last name and then we are making the users active and inactive.
      //     system.debug('patnerUssers : '+patnerUssers);
      //     system.debug('patnerUssers  count: '+patnerUssers.size());
        for(user newuser :patnerUssers){            
           // string newUniqueUserName = newuser.DealerNumber_NUM__c+newuser.firstname+newuser.lastname;
             //  example    FederationIdentifier = iNg_251012_HELMSDEALERSALES
                string newUniqueUserName = newuser.FederationIdentifier;
                
       //     system.debug('newUniqueUserName userr: '+newUniqueUserName);
                    if(uniqueName.size()>0){           
            if(uniqueName.contains(newUniqueUserName) ){
                if(newuser.IsActive == false){
            // newuser.IsActive = true;
                lstUsers.add(newuser);
           //  system.Debug( 'newuser :: '+lstUsers);  
                }
            }           
            else{
          
            // need to comment the below line to Deactivate all the users who are in active state which are not present in the custom object                
            newuser.IsActive = false;
            lstUsers.add(newuser);  
                
            }           
        }
            }        
     //     system.debug('lstUsers : '+lstUsers);
     //     system.debug('lstUsers count: '+lstUsers.size());
    }

    // Finish Method

    global void finish(Database.BatchableContext BC) {

    //    system.debug(' count value :: '+count);
    //    system.debug(' newlistofdealerdeprovisioning:: '+lstUsers);
        //here we are using second batch because to avoid any type issue ,if we get the bulk records.
          DeprovisonSecondBatch b = new DeprovisonSecondBatch(lstUsers);
          //Database.executeBatch(b, 200);
          Database.executeBatch(b, 100);
        //if no records found we are sending the email notification
        if(count==0 || count==null){
     //       system.debug(' in finish method :: ');
            OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'yourhonda@ebizmail.honda.com'];    
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            if ( owea.size() > 0 ) {
           message.setOrgWideEmailAddressId(owea.get(0).Id);
           }
            //for testing purpose we can use our email ids
            //saikiran.siddipeta@wipro.com ','saikiran_siddipeta@na.honda.com','Helms@na.honda.com 
          String[] toAddresses = new String[] {HELMSConstants.emailNotification}; 
            message.setToAddresses(toAddresses);    
            message.setSubject('noreply@salesforce.com');
            String body='Hi Team,<br/>No Dealer user records received today. Either the file is empty or no file was sent out today.<br/><br/>Thanks<br/>Honda team </br>';
            message.setHtmlBody(body);

         Messaging.SingleEmailMessage[] messages =new List<Messaging.SingleEmailMessage> {message};
         Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
           if (results[0].success) {
      //      System.debug('The email was sent successfully.');
              } else {
      //      System.debug('The email failed to send: '+ results[0].errors[0].message);
                }           
        }
    }
       public void execute(SchedulableContext sc){
        DealerDeprovisionBatch cs = new DealerDeprovisionBatch();
        Id JobID=Database.executeBatch(cs);
    }
    
        
          

}