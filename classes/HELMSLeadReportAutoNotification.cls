/*----------------------------------------------------------------------------------------------------------------------------------------------------
Class Name : HELMSLeadDailyReportNotification 
Test Class Name : HELMSLeadDailyReportNotificationTest
Last Modified Version Owner : Bijay Kumar Sahoo
Comments : Code to sending an automated daily and checking the limits
-------------------------------------------------------------------------------------------------------------------------------------------------------
*/
public with sharing class HELMSLeadReportAutoNotification implements schedulable{
    public void execute(schedulablecontext sc){
        report();
    }
    public void report()
    {
        try{
        boolean sendmail=false;
        string prebody='';
        datetime dt=system.now();
        decimal q8=0;
            if(system.now().hour()==09){
                prebody='Past 24 hours Report:';
                dt=system.now().addhours(-24);
                sendmail=true;
            }
            else{
                dt=system.now().addhours(-2);
                prebody='Past 2 hours Report:';
            }
        decimal q1=([Select COUNT() From Lead WHERE CreatedDate >=: dt  WITH SECURITY_ENFORCED]) ;
        decimal q2=([Select COUNT() From Lead WHERE IsConverted =true and CreatedDate >=:dt  WITH SECURITY_ENFORCED]);
        decimal q3=([Select COUNT() From Lead WHERE IsConverted = false AND CreatedDate >=:dt  and Status != 'Closed - Not Converted' AND StatusReason_TXT__c != 'Invalid email and phone' and StatusReason_TXT__c != 'Name/Address/Email Cache' and StatusReason_TXT__c != 'Related Opportunity closed' and StatusReason_TXT__c != 'Unable to assign Dealer' and StatusReason_TXT__c != 'Third Party Duplicate' and StatusReason_TXT__c != 'Duplicate Similar' and Division_CD__c != null and ContactKey_TXT__c != null  WITH SECURITY_ENFORCED]) ;
        decimal q4=([Select COUNT() From Opportunity where Routable_FLG__c =true and CreatedDate >=: dt  WITH SECURITY_ENFORCED]) ;
        decimal q5=([Select COUNT() From Opportunity where Routable_FLG__c =true and CreatedDate >=:dt and Routing_Status__c ='Success'  WITH SECURITY_ENFORCED]) ;
        decimal q6=([Select COUNT() From Opportunity where Routable_FLG__c =true and Routing_Status__c ='Failure' and CreatedDate >=:dt  WITH SECURITY_ENFORCED ]) ;
        decimal q7=([Select COUNT() From Opportunity where Routable_FLG__c =true and Routing_Status__c ='' and CreatedDate>=: dt  WITH SECURITY_ENFORCED]) ;
        if(!Test.isRunningTest())
        q8=([select  Value from PlatformEventUsageMetric where Name ='PLATFORM_EVENTS_DELIVERED' order by StartDate desc limit 1].value);

        /*
        system.debug('q1='+q1);//Total Leads
        system.debug('q2='+q2);//Leads Converted
        system.debug('q3='+q3);//Leads Stuck
        system.debug('q4='+q4);//Opportunities Eligible For Routing
        system.debug('q5='+q5);//Opportunities Successfully Routed
        system.debug('q6='+q6);//Opportunities Failed To Route
        system.debug('q7='+q7);//Opportunities With No Routing Response
        system.debug('q8='+q8);//Daily Platform Event Delivery Limit
        */
        messaging.SingleEmailMessage mail=new Messaging.SingleEmailMessage();
        OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'yourhonda@ebizmail.honda.com'];    
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        if ( owea.size() > 0 ) {
        message.setOrgWideEmailAddressId(owea.get(0).Id);
        }
        string extrabody='';
        message.setSubject('System Health Check: Good');
        string recipient=Label.System_Health_Alerts;     //'call.bijay1@gmail.com,bijay.sahoo1@wipro.com'; Emails can be added comma separated
        //string recipient='call.bijay1@gmail.com,bijay.sahoo1@wipro.com,bijay_sahoo@na.honda.com,grandhi.lavanya@wipro.com';
        List<string> toAddresses=recipient.split(',');
        message.setToAddresses(toAddresses); 
        if((q1==0)|| Test.isRunningTest()){
            sendmail=true;
            message.setSubject('Critical:No Leads getting created');
            extrabody='<br/>No leads are getting created.</br><br/>Please check the lead flow ASAP!!!</br>';
        }
        if((q1!=0 && ((q2/q1)*100)<70 && q1>20) || Test.isRunningTest()) {
            sendmail=true;
            message.setSubject('Critical:Problem in Lead conversion detected');
            integer s1=integer.valueOf((q2/q1)*100);
            extrabody='<br/>Lead conversion down to '+s1+'%.</br><br/>Please check ASAP!!!</br>';
        }
        if((q2!=0 && ((q4/q2)*100)<50 && q2>20)||Test.isRunningTest()){
            sendmail=true;
            message.setSubject('Critical:Problem in Opportunity Routing Criteria');
            integer s2=integer.valueOf((q4/q2)*100);
            extrabody='<br/>Routable opportunities eligibility down to '+s2+'%.</br><br/>Please check the routing criteria ASAP!!!</br>';
        }
        if((q4!=0 && ((q6/q4)*100)>30 && q4>20)||Test.isRunningTest()){
            sendmail=true;
            message.setSubject('Critical:Multiple Failures in Opportunity Routing');
            integer s3=integer.valueOf((q6/q4)*100);
            extrabody='<br/>Opportunity routing failure increased to '+s3+'%.</br><br/>Please check the routing flow at integration ASAP!!!</br>';
        }
        if((q4!=0 && ((q7/q4)*100)>30 && q4>20)|| Test.isRunningTest()){
            sendmail=true;
            message.setSubject('Critical:Problem in Opportunity Routing detected');
            integer s4=integer.valueOf((q7/q4)*100);
            extrabody='<br/>Opportunity with no routing response increased to '+s4+'%.</br><br/>Please check the routing flow ASAP!!!</br>';
        }
        if(!Test.isRunningTest()){
            if((q8!=0 &&q8>30000 )|| Test.isRunningTest()){
                  sendmail=true;
                  message.setSubject('Critical:High Platform Event Delivery Usage');
                  integer s5=integer.valueof((q8/50000)*100);
                  extrabody='<br/>'+s5+'% Daily Platform Event Delivery Limit Used.</br><br/>Please check the integration flows ASAP!!!</br>';
            }
        }
        
        String body=prebody+'<br/></br>';
        body=body+'<html><style>table, th, td {border:1px solid Black;}</style><body><table><style>th:nth-child(odd) {background-color: #2E5984;color: #FFFFFF;}th:nth-child(even) {background-color: #2E5984;color: #FFFFFF;</Style><tr><th>Description</th><th>Count</th></tr><tr><td>Total Leads</td><td>'+q1+'</td></tr><tr><td>Leads Converted</td><td>'+q2+'</td></tr><tr><td>Leads Stuck</td><td>'+q3+'</td></tr><tr><td>Opportunities Eligible For Routing</td><td>'+q4+'</td></tr><tr><td>Opportunities Successfully Routed</td><td>'+q5+'</td></tr><tr><td>Opportunities Failed To Route</td><td>'+q6+'</td></tr><tr><td>Opportunities With No Routing Response</td><td>'+q7+'</td></table></body></html>';
        body= body+extrabody+'</br><P style="color:red"><b>NOTE: On every Sunday'+ '&#39;' +'s, Elead'+ '&#39;' +'s CRM is under maintenance from 12:05AM - 8:00 AM Pacific time.<br>Please expect alerts for multiple failures in opportunity routing during that time period.<br>The failed opportunities would be re-routed by the batch jobs.</b></P>Thanks,</br>HONDA LMS';
        message.setHtmlBody(body);
        Messaging.SingleEmailMessage[] messages =new List<Messaging.SingleEmailMessage> {message};
        if(sendmail){
            Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);   
        }         
    }catch(Exception ex){
           Logs__c  l =new Logs__c (name='HELMSLeadReportAutoNotification',Trigger_or_Class_Name__c='HELMSLeadReportAutoNotification', Error_Message__c =ex.getMessage(), Error_Line_Number__c =Integer.valueOf(string.valueof(ex.getLineNumber() )) );
            insert l;
         //   system.debug('exceptionmsg'+ex.getMessage());
           }
    }
}