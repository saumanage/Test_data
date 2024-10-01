global with sharing class HELMSErrorLogEmailScheduler implements Schedulable {
    
    global void execute(SchedulableContext sc){
    
            map<string,integer> mapcountype= new map<string,integer>();
            mapcountype.put('Unsuccessful log-in attempts from SSO',0);
            mapcountype.put('Lead insertion failures',0);
            mapcountype.put('Lead routing failure',0);
            mapcountype.put('Lead enrichment call failures',0);
            List<lead> ledLst = new List<lead>();
            List<String> emailids= new List<String>();
            
            integer totalcount=0;
            integer failurecount=0;
            decimal percentage;
            
            Threshold_Limit__mdt thLimit = Threshold_Limit__mdt.getInstance('Threshold');
            //System.debug('----->'+thLimit);
        if(System.Label.Threshold_Email_ID.contains(';'))
        emailids.addall(System.Label.Threshold_Email_ID.split(';'));
        else if(!System.Label.Threshold_Email_ID.contains(';') && System.Label.Threshold_Email_ID!=null)
            emailids.add(System.Label.Threshold_Email_ID);
            
            
            datetime ndate= datetime.now().addhours(-1);
            //system.debug('ndate-------------'+ndate);
            
            List<Logs__c> logList= [SELECT Id,type__c,createddate from Logs__c where (type__c= 'Unsuccessful log-in attempts from SSO' or type__c= 'Lead insertion failures' or type__c= 'Lead routing failure' or type__c= 'Lead enrichment call failures' ) and createddate>=:ndate WITH SECURITY_ENFORCED ]; 
            //system.debug('logList-------------'+logList);
           
            for(Logs__c lg : logList){
                if(lg.type__c== 'Unsuccessful log-in attempts from SSO')
                    mapcountype.put('Unsuccessful log-in attempts from SSO',mapcountype.get('Unsuccessful log-in attempts from SSO')+1);
                if(lg.type__c== 'Lead insertion failures')
                     mapcountype.put('Lead insertion failures',mapcountype.get('Lead insertion failures')+1);
                if(lg.type__c== 'Lead routing failure')
                     mapcountype.put('Lead routing failure',mapcountype.get('Lead routing failure')+1);
                if(lg.type__c== 'Lead enrichment call failures')
                     mapcountype.put('Lead enrichment call failures',mapcountype.get('Lead enrichment call failures')+1);
            }
            
            //system.debug('Unsuccessful   -------------'+mapcountype.get('Unsuccessful log-in attempts from SSO'));
            
            if(mapcountype.get('Unsuccessful log-in attempts from SSO')>thLimit.Log_in_Attempts__c){
                
                Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                message.toAddresses = emailids;
                message.optOutPolicy = 'FILTER';
                message.subject = 'Threshold limit is exceeded for Unsuccessful log-in attempts from SSO';
                message.setHtmlBody('<p>Hi Team,</p></br></br><p>Please find below error details:</p><p>Timestamp: '+system.now()+'</p></br><p>Number of log-in attempts Failed: '+mapcountype.get('Unsuccessful log-in attempts from SSO')+'</p></br></br><p>Thanks</p>');
                Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
                Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
                //system.debug('results   -------------'+results);
               
            }
        
            ledLst=[SELECT id,createddate from lead where createddate >=:ndate WITH SECURITY_ENFORCED];
            //system.debug('ledLst   -------------'+ledLst.size());
            
            if(mapcountype.get('Lead insertion failures')>0){
                
                failurecount = mapcountype.get('Lead insertion failures');
                totalcount = failurecount + ledLst.size();
                percentage = 0;
                
                if(totalcount>0 && failurecount>0 )
                    percentage=(decimal)failurecount/totalcount*100;
                
                //system.debug('percentage *********** '+percentage);
                
                if(percentage>thLimit.Lead_Insertion__c){
                
                    Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                    message.toAddresses = emailids;
                    message.optOutPolicy = 'FILTER';
                    message.subject = 'Threshold limit is exceeded for Lead insertion';
                    message.setHtmlBody('<p>Hi Team,</p></br></br><p>Please find below error details:</p><p>Timestamp: '+system.now()+'</p></br><p>No of Records Success: '+ledLst.size()+'</p></br><p>No of Records Failed: '+failurecount+'</p></br></br><p>Thanks</p>');
                    Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
                    Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
                    
                    //system.debug('results Lead insertion*********** '+results);
                }
            
             }
        

            List<opportunity> oppSucessLst=[SELECT id,createddate from opportunity where (Routing_Status__c='Sent to Dealer' or Routing_Status__c='Success' or Routing_Status__c='Ready') and createddate >=:ndate WITH SECURITY_ENFORCED];
            List<opportunity> oppFailureLst=[SELECT id,createddate from opportunity where Routing_Status__c='Failure' and createddate >=:ndate WITH SECURITY_ENFORCED];
            
            //system.debug('OppSucessLst *********** '+OppSucessLst.size());
            //system.debug('OppFailureLst *********** '+OppFailureLst.size());
            
            failurecount = oppFailureLst.size();
            if(mapcountype.get('Lead routing failure')>0 || failurecount>0){
                    failurecount = failurecount +mapcountype.get('Lead routing failure');
                    totalcount = failurecount + oppSucessLst.size();
                    percentage = 0;
                    
                if(totalcount>0 && failurecount>0 ){
                    percentage=(decimal)failurecount/totalcount*100;
                //system.debug('percentage *********** '+percentage);
                
                if(percentage>thLimit.Lead_Routing__c){
                
                    Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                    message.toAddresses = emailids;
                    message.optOutPolicy = 'FILTER';
                    message.subject = 'The Threshold limit is exceeded for Lead routing';
                    message.setHtmlBody('<p>Hi Team,</p></br></br><p>Please find below error details:</p><p>Timestamp: '+system.now()+'</p></br><p>No of Records Success: '+OppSucessLst.size()+'</p></br><p>No of Records Failed: '+failurecount+'</p></br></br><p>Thanks</p>');
                    Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
                    Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
                }
           }
            }
           
            List<lead> enrihLedLst=[SELECT id,createddate from lead where StatusReason_TXT__c='Lead Enrichment call error' and createddate >=:ndate WITH SECURITY_ENFORCED ];
            failurecount = enrihLedLst.size();
            //system.debug('enrihLedLst.size() *********** '+enrihLedLst.size());
            
        if(mapcountype.get('Lead enrichment call failures')>0 || failurecount >0){
                failurecount = failurecount + mapcountype.get('Lead enrichment call failures');
                totalcount = failurecount + ledLst.size();
                percentage = 0;
            if(totalcount>0 && failurecount>0 ){
                    percentage=(decimal)failurecount/totalcount*100;
                //system.debug('percentage *********** '+percentage);
                
                if(percentage>thLimit.Lead_Enrichment__c){
                
                    Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                    message.toAddresses = emailids;
                    message.optOutPolicy = 'FILTER';
                    message.subject = 'Threshold limit is exceeded for Lead enrichment call';
                    message.setHtmlBody('<p>Hi Team,</p></br></br><p>Please find below error details:</p><p>Timestamp: '+system.now()+'</p></br><p>No of Records Success: '+ledLst.size()+'</p></br><p>No of Records Failed: '+failurecount+'</p></br></br><p>Thanks</p>');
                    Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
                    Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
                }
            }
            
            }
    }        
   
    }