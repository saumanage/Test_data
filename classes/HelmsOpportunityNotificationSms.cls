/*-------------------------------------------------------------------------------------------
Story Number :LMS-1632
Class Name : HelmsOpportunityNotificationSms 
Test Class Name : HelmsOpportunityNotificationSmsTest
Last Modified Version Owner : Saikiran
Comments : HELMS-SP-SMS Opportunity Notification-PC.
--------------------------------------------------------------------------------------------*/

public with sharing class HelmsOpportunityNotificationSms {
    public static void opportunityCreation(set<id> oppIds) {
        try{
        List<Opportunity> oppList=[SELECT Id, Name,PreferredDealerAccount_TXT__c  FROM Opportunity where id IN: oppIds];
          List<Logs__c > logList= new List<Logs__c >();
            
        set<id> dlSet= new set<id>();
        String opName = '';
        if(oppList.size()>0){                   
    //      system.debug('oppList:: '+oppList);
            for(Opportunity op:oppList){
                dlSet.add(op.PreferredDealerAccount_TXT__c);  
                opName = op.name;            
            }  
            
          }
          set<id> ddSet= new set<id>();
          for(Dealer_Division__c dobj:[Select id from Dealer_Division__c where Dealer_ID__c in :dlSet]){
              ddSet.add(dobj.id);
          }
          
           List<Dealer_Notification_Preference__c> dealerList=[select Phone__c,New_Lead_SMS__c from Dealer_Notification_Preference__c where New_Lead_SMS__c=True and Phone__c!=null and Dealer_Subdivision__c in : ddSet];
            if(dealerList.size()>0 && dealerList != null){
               NotificationRequest nR=new NotificationRequest();
            list<string> newnumbers= new list<string>();
            
            if(dealerList.size()>0 && dealerList != null){
                for(Dealer_Notification_Preference__c dealerNotification:dealerList ){
                    list<string> oldnumbers = new list<string>();                  
                    oldnumbers=dealerNotification.Phone__c.split(',');
                    for(string o:oldnumbers){
                        o = '1'+o;
                        newnumbers.add(o);
                    } 
                }
                
                nR.Subscribe=true;
                nR.Resubscribe=true;
                nR.mobileNumbers=newnumbers;
      //          system.debug('newnumbers'+newnumbers);
                nR.keyword=System.Label.SMSKeyword; 
                nR.messageText='Opportunity'+ '-' +opName+ ' '+ 'has been assigned';
      //          system.debug('nr----------->>'+nr);
                nR.Override2=true;
            }
            
            
            HttpRequest req = new HttpRequest();
            
            req.setHeader('Accept', 'application/json');
            req.setHeader('Content-Type','application/json;charset=UTF-8');
            
            req.setMethod('POST');
            //sms Notification Credentails
            req.setEndpoint('callout:sms_Notification_Credentials');
          //req.setEndpoint('https://mc219s2l565j37tg6q88270hftr1.auth.marketingcloudapis.com/v2/token'); 
            req.setTimeout(120000);
            
            SMSAuthentication sf=  new SMSAuthentication();
                sf.grant_type = HELMSConstants.grant_type;
                sf.client_id = HELMSConstants.client_id;
                sf.client_secret = HELMSConstants.client_secret;
                sf.account_id = HELMSConstants.account_id;
            String jsonString=JSON.serialize(sf);
            
            req.setBody(jsonString);
            
            Http http = new Http();
            HTTPResponse res = http.send(req);
   //         system.debug(res.getBody());
            oAuthClass autorize = (oAuthClass)JSON.deserialize(res.getBody(), oAuthClass.class);
            string accesstoken = autorize.access_token; 
            
            HttpRequest req1 = new HttpRequest();            
            req1.setHeader('Accept', 'application/json');
            req1.setHeader('Content-Type','application/json;charset=UTF-8');
            //string accesstoken ='eyJhbGciOiJIUzI1NiIsImtpZCI6IjQiLCJ2ZXIiOiIxIiwidHlwIjoiSldUIn0.eyJhY2Nlc3NfdG9rZW4iOiI3ekZ0Z0NWY3Y4dXpwSTlaQlJFRW9MRTkiLCJjbGllbnRfaWQiOiJxdm5mY2tqZHM1aW9jMm8yb2gzOG5yM2QiLCJlaWQiOjcyOTM2NDcsInN0YWNrX2tleSI6IlM3IiwicGxhdGZvcm1fdmVyc2lvbiI6MiwiY2xpZW50X3R5cGUiOiJTZXJ2ZXJUb1NlcnZlciJ9._7XHNPD91a4JYbeHeBSZXJPqpzwnwyvzWAR2Y23MPuo.JVetWdbrqfFhoR7ARFI7crsn9jYm3D8S34Ycp2C3yjXSgfngTYEcmOyz-T1dABs8zfmGjpB2IEkXmnpQzwKRqtfo7cJYWiU5Cl1Jc-ICtd9r39lmMDylXGGwyLIHzMjpIU5ldRJY5HPT';
            req1.setHeader('Authorization','Bearer ' + accesstoken);
            
            req1.setMethod('POST');
            //sms Notification Second Call 
           // req1.setEndpoint('https://mc219s2l565j37tg6q88270hftr1.rest.marketingcloudapis.com/sms/v1/messageContact/NTg6Nzg6MA/send');
            req1.setEndpoint('callout:sms_Notification_Second_Call');
            req1.setTimeout(120000);
            
            String jsonString1=JSON.serialize(nR);
            
            jsonString1=JsonString1.replace('Override2', 'Override');
     //       system.debug('JsonString1------>>>>'+jsonString1);
            
            req1.setBody(JsonString1);
     //       system.debug('JsonString1'+jsonString1);
            
            Http http1 = new Http();
            HTTPResponse res1 = http1.send(req1);
   //         system.debug(res1.getBody());
                        if(res1.getStatusCode()==202){
                
                system.debug('::::response::::::'+res1.getBody());
                system.debug('::::getStatusCode::::::'+res1.getStatusCode());
                }else{
					
		     Logs__c  l2 =new Logs__c (name='Integration callout failure',Trigger_or_Class_Name__c='HelmsOpportunityNotificationSms', Error_Message__c =res1.getBody(), Error_Line_Number__c =res1.getStatusCode() );
			 logList.add(l2);
			 
            
				}
                 system.debug('::::response::::::'+res1.getBody());
                system.debug('::::getStatusCode::::::'+res1.getStatusCode());
            
        } 
       }Catch(Exception ex){                       
            Logs__c  l =new Logs__c (name=' HelmsOpportunityNotificationSms ',Trigger_or_Class_Name__c='HelmsOpportunityNotificationSms', Error_Message__c =ex.getMessage(), Error_Line_Number__c =Integer.valueOf(string.valueof(ex.getLineNumber() )) );
           insert l;
        }
     }
      public class oAuthClass {
            public string access_token {get;set;} 
      }
}