/*----------------------------------------------------------------------------------------------------------------------------------------------------
Class Name : HELMSLeadDailyReportNotification 
Test Class Name : HELMSLeadDailyReportNotificationTest
Last Modified Version Owner : Grandhi Lavanya
Comments : Code to sending an automated yesterday's report for Leads count and opportunity count per day - AMSLM-892 
-------------------------------------------------------------------------------------------------------------------------------------------------------
*/
public with sharing class HELMSLeadDailyReportNotification implements schedulable {
      public void execute(schedulablecontext sc){
        report();
    }
     public void report(){
           try{
        boolean sendmail=true;
               
        string prebody='';
        decimal q1= ([Select COUNT() from lead where CreatedDate = yesterday  WITH SECURITY_ENFORCED]) ;  
        decimal q3= ([select COUNT() from Lead where CreatedDate = yesterday and IsConverted = true and LastModifiedBy.Name not in ('Automated Process', 'Scheduler User','MC Connect-PROD') WITH SECURITY_ENFORCED]) ;
        decimal q2 = ([select COUNT() from Lead where CreatedDate = yesterday and IsConverted = true and LastModifiedBy.Name  in ('Automated Process', 'Scheduler User','MC Connect-PROD') WITH SECURITY_ENFORCED]) ;
      	decimal q4 = ([Select count() From Lead WHERE CreatedDate = yesterday and IsConverted = false  WITH SECURITY_ENFORCED]);
        decimal q5 = ([Select count() From Lead WHERE CreatedDate = yesterday and Status not in ('Closed - Not Converted','Manual Validation') and StatusReason_TXT__c not in ('Invalid email and phone','Duplicate Similar') and  IsConverted = false WITH SECURITY_ENFORCED]);
        decimal q6 = ([select Count() from Lead where CreatedDate = yesterday and IsConverted = true  WITH SECURITY_ENFORCED]);
        decimal q7 = ([select count() from Lead where CreatedDate = yesterday and IsConverted = true  and ConvertedOpportunity.Routing_Status__c = 'Success' WITH SECURITY_ENFORCED]);
        decimal q8 = ([select count() from Lead where CreatedDate = yesterday and IsConverted = true  and (PreferredDealerAccount_ID__r.DealerCRMVendor_TXT__c = '' OR  PreferredDealerAccount_ID__r.DealerCRMVendor_TXT__c like '%HELMS%') WITH SECURITY_ENFORCED]);
        decimal q9 = ([select count() from Lead where CreatedDate = yesterday and IsConverted = true  and ConvertedOpportunity.Routing_Status__c = 'Failure' WITH SECURITY_ENFORCED]);       
        decimal q10 = ([select count() from RDR_Sales__c where CreatedDate = yesterday  WITH SECURITY_ENFORCED]);
        decimal q11 = ([select count() from Matchback__c where CreatedDate = yesterday WITH SECURITY_ENFORCED]);
        decimal q12 = ([select count() from Lead where CreatedDate = yesterday and IsConverted = true and ConvertedOpportunityId != null and ConvertedOpportunity.Conversion_Time_in_Minute__c not in ('A - Less Than 1 minute', 'B - 1 to 5 minutes','C - 5 to 15 minutes') WITH SECURITY_ENFORCED]);
     	decimal q13 = ([select count() from Lead where CreatedDate = yesterday and IsConverted = true and ConvertedOpportunityId != null and ConvertedOpportunity.Conversion_Time_in_Minute__c in ('A - Less Than 1 minute', 'B - 1 to 5 minutes', 'C - 5 to 15 minutes') WITH SECURITY_ENFORCED]);
        decimal q14= ([Select COUNT() from Lead where  CreatedDate = yesterday and IsConverted = true and ConvertedOpportunityId != null and ConvertedOpportunity.Conversion_Time_in_Minute__c='A - Less Than 1 minute' WITH SECURITY_ENFORCED]);
        decimal q15= ([Select COUNT() from Lead where  CreatedDate = yesterday and IsConverted = true and ConvertedOpportunityId != null and ConvertedOpportunity.Conversion_Time_in_Minute__c='B - 1 to 5 minutes' WITH SECURITY_ENFORCED]);
        decimal q16= ([Select COUNT() from Lead where  CreatedDate = yesterday and IsConverted = true and ConvertedOpportunityId != null and ConvertedOpportunity.Conversion_Time_in_Minute__c='C - 5 to 15 minutes' WITH SECURITY_ENFORCED]);
        decimal q17= ([Select COUNT() from Lead where  CreatedDate = yesterday and IsConverted = true and ConvertedOpportunityId != null and ConvertedOpportunity.Conversion_Time_in_Minute__c='D - 15 to 30 minutes' WITH SECURITY_ENFORCED]);
        decimal q18= ([Select COUNT() from Lead where  CreatedDate = yesterday and IsConverted = true and ConvertedOpportunityId != null and ConvertedOpportunity.Conversion_Time_in_Minute__c= 'E - 30 minutes to 2 hours' WITH SECURITY_ENFORCED]); 
        decimal q19= ([Select COUNT() from Lead where  CreatedDate = yesterday and IsConverted = true and ConvertedOpportunityId != null and ConvertedOpportunity.Conversion_Time_in_Minute__c= 'F - 2 to 24 hours' WITH SECURITY_ENFORCED]);
        decimal q20= ([Select COUNT() from Lead where  CreatedDate = yesterday and IsConverted = true and ConvertedOpportunityId != null and ConvertedOpportunity.Conversion_Time_in_Minute__c='G - 24 to 48 hours' WITH SECURITY_ENFORCED]);
        decimal q21= ([Select COUNT() from Lead where  CreatedDate = yesterday and IsConverted = true and ConvertedOpportunityId != null and ConvertedOpportunity.Conversion_Time_in_Minute__c='H - More than 48 hours' WITH SECURITY_ENFORCED]);  
		decimal q22= (q4/q1*100).setscale(1); // notconvertedleadscount
        decimal q23= (q6/q1*100).setscale(1); //convertedleadsconvert
        decimal q24 = (q14/q6*100).setscale(1); //A - Less Than 1 minute
        decimal q25 = (q15/q6*100).setscale(1); //B - 1 to 5 minutes
        decimal q26 = (q16/q6*100).setscale(1); //C - 5 to 15 minutes
        decimal q27 = (q17/q6*100).setscale(1); //D - 15 to 30 minutes
        decimal q28 = (q18/q6*100).setscale(1); //E - 30 minutes to 2 hours
        decimal q29 = (q19/q6*100).setscale(1); //F - 2 to 24 hours
        decimal q30 = (q20/q6*100).setscale(1); //G - 24 to 48 hours
        decimal q31 = (q21/q6*100).setscale(1); //H - More than 48 hours
		decimal leadsrejerr = Integer.valueOf(system.label.Leads_Rejected_Errored);
		decimal leadstoapi = Integer.valueOf(system.label.Incoming_Leads_to_API_Integration);
		decimal q32 = ([select COUNT() from Lead where createdDate= Yesterday and CreatedBy.Name in('MC Connect-PROD') WITH SECURITY_ENFORCED]) ;
		decimal q33 = leadstoapi+q32+leadsrejerr; // total incoming leads
        decimal q34 = leadsrejerr; // totalerror leads
        decimal q35 = leadstoapi; // accpeted leads from api
        decimal q36 = q34+q9+q5; // total lost leads daily
         
        Date dt=system.today().addDays(-1);
        string dte = dt.format();
        //system.debug('dte---->'+dte);
		
      //  List<Logs__C> Logs = [select Trigger_or_Class_Name__c from Logs__c where CreatedDate = yesterday WITH SECURITY_ENFORCED];   
        if(!Test.isRunningTest())
        messaging.SingleEmailMessage mail=new Messaging.SingleEmailMessage();
        OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'yourhonda@ebizmail.honda.com' WITH SECURITY_ENFORCED];    
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        if ( owea.size() > 0 ) {
        message.setOrgWideEmailAddressId(owea.get(0).Id);
        }
         string extrabody='';
         string extrabody1= '';
        message.setSubject('HELMS Daily Leads Report - '+dte+'.');
        string recipient=Label.System_Health_Alerts;     //'call.bijay1@gmail.com,bijay.sahoo1@wipro.com'; Emails can be added comma separated
       // string recipient='grandhi.lavanya@wipro.com, kongara.satwalekar@wipro.com, saikiran.siddipeta@wipro.com';
        List<string> toAddresses=recipient.split(',');
        message.setToAddresses(toAddresses); 
            
		String body=prebody;
        body = body+'<b>Hi Team,<br/></b>'+'<br/><b>HELMS Lead'+'&#39;'+'s report for yesterday-'+dte+'.<b><br/><br/>';
		
		body=body+'<br/><html><style>table, th, td {border:1px solid Black; border-collapse:collapse;}</style><body><table><style>th:nth-child(odd) {background-color: #2E5984;color: #FFFFFF; border-collapse: collapse;}th:nth-child(even) {background-color: #2E5984;color: #FFFFFF;</Style><tr><th bgcolor="#D5D6EA">Stats</th><th bgcolor="#D5D6EA">Count</th></tr><tr><td><b>Total Incoming Leads</b></td><td><b>'+q33+'</b></td></tr><tr><td>Incoming Leads to API (Integration)-PST</td><td>'+q35+'</td></tr><tr><td>Incoming Leads via Interaction Studio</td><td>'+q32+'</td></tr><tr><td><font color="Red">Leads Rejected/Errored </td><td><font color="Red">'+q34+'<tr><td><b>Leads Created in SF</b></td><td>'+q1+'</td></tr><tr><td>Leads Converted to Opportunities (Automatic)</td><td>'+q2+'</td></tr><tr><td>Leads Converted to Opportunities (Manual Validation/Release)</td><td>'+q3+'</td></tr><tr><td>Leads not Converted (Valid Reasons)</td><td>'+q4+'</td></tr><tr><td style="color:#ff0000">Leads not Converted (Error Reasons)</td><td><font color="Red">'+q5+'</td></tr><tr><td><b>Opportunities Created  in SF<b></td><td>'+q6+'</td></tr><tr><td>Opportunities Routed to Dealers</td><td>'+q7+'</td></tr><tr><td>Opportunities with HELMS CRM</td><td>'+q8+'</td></tr><tr><td><font color="Red">Opportunities Failed to Route</font></td><td><font color="Red">'+q9+'</td></tr></tr><tr><td><font color="Red">Daily Lost Leads</b></td><td><font color="Red">'+q36+'</td></tr><tr><td>RDR Created in SF</td><td>'+q10+'</td></tr><tr><td>Matchback Created in SF</td><td>'+q11+'</td></tr><tr><td>Less converted Less than 15 minutes</td><td>'+q13+'</td></tr><tr><td>Leads converted more than 15 minutes</td><td>'+q12+'</td></table></br></body></html>';
         
        extrabody = +'<b>Lead'+'&#39;'+'s'+'Daily Data Analysis Report-('+dte+').</b><br/><br/>'+'<html><style>table, th,td {border:1px solid Black; border-collapse: collapse;}</style><body><table><style>th:nth-child(odd){background-color: #2E5984;color: #FFFFFF;}th:nth-child(even) {background-color: #2E5984;color: #FFFFFF;</Style><tr><th bgcolor="#D5D6EA">Converted ↑</th><th bgcolor="#D5D6EA">Conversion Time in Minute ↑</th><th bgcolor="#D5D6EA">Date-'+dte+'</th><th bgcolor="#D5D6EA">%-'+dte+'</th></tr><tr><td colspan="2" bgcolor="#ecf2f8">TotalLeads</td><td colspan="2">'+q1+'</td></tr><tr><td bgcolor="#ffff4d">FALSE</td><td>Not Converted Leads</td><td>'+q4+'</td><td>'+q22+'%</td></tr><tr><td colspan="2" bgcolor="#ecf2f8">Converted Leads Count</td><td>'+q6+'</td><td>'+q23+'%</td></tr><tr><td bgcolor="#ffff4d">TRUE</td><td>A- Less Than 1 minute</td><td>'+q14+'</td><td>'+q24+'%</td></tr><tr><td></td><td>B - 1 to 5 minutes</td><td>'+q15+'</td><td>'+q25+'%</td></tr><tr><td></td><td>C - 5 to 15 minutes</td><td>'+q16+'</td><td>'+q26+'%</td></tr><tr><td></td><td>D - 15 to 30 minutes</td><td>'+q17+'</td><td>'+q27+'%</td></tr><tr><td></td><td>E - 30 to 2 hours</td><td>'+q18+'</td><td>'+q28+'%</td></tr><tr><td></td><td>F - 2 to 24 hours</td><td>'+q19+'</td><td>'+q29+'%</td></tr><tr><td></td><td>G - 24 to 48 hours</td><td>'+q20+'</td><td>'+q30+'%</td></tr><tr><td></td><td>H - More than 48 hours</td><td>'+q21+'</td><td>'+q31+'%</td></tr></table></br></body></html>';
		  
        extrabody1 =+'<b>SFDC Logs Report-'+dte+'.</b><br/><br/>'+'<html><style>table, th, td {border:1px solid Black; border-collapse:collapse;}</style><body><table><style>th:nth-child(odd) {background-color: #2E5984;color: #FFFFFF;}th:nth-child(even) {background-color: #2E5984;color: #FFFFFF;</Style><tr><th bgcolor="#D5D6EA">TriggerName/ClassName</th><th bgcolor="#D5D6EA">Record Count</th>'; 
		   
        for(AggregateResult log : [select Trigger_or_Class_Name__c, count(id) rec from Logs__c where CreatedDate = yesterday GROUP BY Trigger_or_Class_Name__c ORDER BY Trigger_or_Class_Name__c]){
        extrabody1=extrabody1 +'<tr><td>'+log.get('Trigger_or_Class_Name__c')+'<br/>'+'</td><td>'+log.get('rec')+'<br/>'+'</td></tr>';
       }
               
		body= body+'<br/>'+extrabody+'<tr><td>'+extrabody1+'</table></br></br></body></html>'+'</br><P style="color:red"><b>NOTE:<br/>1.Integration data will be incorrect on weekends.<br/>2.The Leads rejected are because those are either test leads or invalid data.</b></P><br/>Thanks,</br>HONDA LMS';
        message.setHtmlBody(body);
        Messaging.SingleEmailMessage[] messages =new List<Messaging.SingleEmailMessage> {message};
        if(sendmail = true){
            Messaging.SendEmailResult[] results = Messaging.sendEmail(messages); 
         //   system.debug('email sent successfully');  
        }else{
         //   system.debug('email not sent');
        }
	}catch(Exception ex){
           Logs__c  l =new Logs__c (name='HELMSLeadDailyReportNotification',Trigger_or_Class_Name__c='HELMSLeadDailyReportNotification', Error_Message__c =ex.getMessage(), Error_Line_Number__c =Integer.valueOf(string.valueof(ex.getLineNumber() )) );
            insert l;
         //   system.debug('exceptionmsg'+ex.getMessage());
           }        
         }
}