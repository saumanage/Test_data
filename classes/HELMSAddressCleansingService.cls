/*
Class Name : HELMSAddressCleansingService 
Test Class Name : HELMSAddressCleansingServiceTest
Mock request test class Name:HELMSAddressCleansingMockTest
Last Modified Version Owner : Bijay Kumar Sahoo
Comments : Code to update the timezone of the account based on the address

*/
public class HELMSAddressCleansingService implements Database.Batchable<sObject>,Database.AllowsCallouts,Schedulable {
    public Database.QueryLocator start(Database.BatchableContext bc){
        string query='Select id,Realtime_TimeZone_Offset__c,ShippingStreet,ShippingCity,ShippingState,ShippingPostalCode,ShippingCountry from account where RecordType.DeveloperName =\'Dealer\'';
        //string query='Select id,Realtime_TimeZone_Offset__c,ShippingStreet,ShippingCity,ShippingState,ShippingPostalCode,ShippingCountry from account where id =\'0017c00000n3jSPAAY\'';
        return Database.getQueryLocator(query); 
     }
    
    public void execute(Database.BatchableContext bc, List<Account> scope){

        try{
            List<Account> accttoupdate= new list<Account>();
            //Loops through each account and generates the request body to do callout
            for (Account acct: scope){
                String apiHeaderParam = '';
                String apiHeaderAppId = 'eShopping.services.honda.com';
                apiHeaderParam += '?AppId='+apiHeaderAppId;
                String apiHeaderLine1 = '';
                String apiHeaderLine2 = '';
                String apiHeaderCity = '';
                String apiHeaderState = '';
                String apiHeaderCountry = '';
                String apiHeaderZipCode = '';
                //apiHeaderParam='?appId=eShopping.services.honda.com&Line1=34711+Moraviannn+Drive1&Line2=APARTMENT+208&City=Sterling+Heights&State=MI&Zip=48312&Province=&Country=&case=mixed&email=none@gmail.com&homephone=3107833712&cellphone=3107833912';
                if(acct.ShippingStreet!=null){
                    apiHeaderLine1=acct.ShippingStreet;
                }
                apiHeaderParam += '&Line1='+apiHeaderLine1;
                apiHeaderParam += '&Line2='+apiHeaderLine2;
                if(acct.ShippingCity!=null){
                    apiHeaderCity=acct.ShippingCity;
                }
                apiHeaderParam += '&City='+apiHeaderCity;
                if(acct.ShippingState!=null){
                    apiHeaderState=acct.ShippingState;
                }
                apiHeaderParam += '&State='+apiHeaderState;
                if(acct.ShippingPostalCode!=null){
                    apiHeaderZipCode=acct.ShippingPostalCode;
                }
                apiHeaderParam += '&Zip='+apiHeaderZipCode;
                if(acct.ShippingCountry!=null){
                    apiHeaderCountry=acct.ShippingCountry;
                }
                apiHeaderParam += '&Province=&Country='+apiHeaderCountry;
                

                HttpRequest req = new HttpRequest();
                req.setHeader('Accept', 'application/xml');
                req.setHeader('Content-Type','application/xml;charset=UTF-8');
                string uniqueuid ='123456789';
                //string uniqueuid =HELMSleadEnrichmentIntegrationupdate.getUUID();
                req.setHeader('hondaHeaderType.messageId',uniqueuid);
                //req.setHeader('hondaHeaderType.siteId',System.Label.siteid);
                string sitee='honda.com';
                req.setHeader('hondaHeaderType.siteId',sitee);
                string bid='cust1@somecompany.com';
                req.setHeader('hondaHeaderType.businessId',bid);
                apiHeaderParam=apiHeaderParam.replace(' ','+');
                apiHeaderParam=apiHeaderParam.replace('#','+');
                //system.debug('apiheaderparam----->'+apiHeaderParam);
                //apiHeaderParam='?appId=eShopping.services.honda.com&Line1=34711+Moraviannn+Drive1&Line2=APARTMENT+208&City=Sterling+Heights&State=MI&Zip=48312&Province=&Country=&case=mixed&email=none@gmail.com&homephone=3107833712&cellphone=3107833912';
                //apiHeaderParam='?appId=eShopping.services.honda.com&Line1=Moravian+Drive&Line2=&City=DuBois&State=PA&Zip=15801&Province=&Country=United+States';
                req.setEndpoint('callout:HELMS_Address_Cleansing_Service'+apiHeaderParam);
                //req.setEndpoint('callout:HELMS_Address_Cleansing_Service'+apiHeaderParam);
                //system.debug('Endpoint----->'+'callout:HELMS_Address_Cleansing_Service'+apiHeaderParam);
                req.setTimeout(120000);
                req.setMethod('GET');
                Http http = new Http();
                HTTPResponse res = http.send(req);
                //System.debug('Response----'+res.getBody());
                //System.debug('Status----'+res.getStatusCode());
                String xmlResponse = '';
                string tz='';
                string tzname='';
                string timezone;
                integer inttimezone;
                string timezoneoffset='';
                if(res.getBody() != null && res.getStatusCode() == 200){
                    xmlResponse=res.getBody();
                    if(xmlResponse.contains('<TimeZoneOffSet>') && xmlResponse.contains('</TimeZoneOffSet>')){
                        tz=xmlResponse.substringBetween('<TimeZoneOffSet>','</TimeZoneOffSet>');
                    }
                    if(xmlResponse.contains('<TimeZoneName>')&& xmlResponse.contains('</TimeZoneName>')){
                        tzname=xmlResponse.substringBetween('<TimeZoneName>','</TimeZoneName>');
                    }
                    if (tz!=''){
                     timezone=tz.substring(0,3);
                        //system.debug('Trimmed timezone:'+timezone);
                        inttimezone=integer.valueOf(timezone);
                        //system.debug('Integer timezone:'+inttimezone);
                        timezoneoffset=string.valueOf(inttimezone);
                        timezoneoffset=tzname+' ('+timezoneoffset+')';
                         
                    }
                    
                    //system.debug('xml response-'+xmlResponse);
                    //system.debug('Timezone Offset-'+tz);
                    
                    
                }
                if(timezoneoffset!='' && acct.Realtime_TimeZone_Offset__c!=timezoneoffset){
                    acct.Realtime_TimeZone_Offset__c=timezoneoffset;
                    accttoupdate.add(acct); 
                }
                
            }
            if(accttoupdate.size()>0){
                update accttoupdate;
            }
            
            
        }
        Catch(Exception ex){
        	//System.debug('Exception at line : '+ ex.getLineNumber());
            //System.debug('Exception Message : '+ ex.getMessage());
            Logs__c  l =new Logs__c (name='TimeZone Update',Trigger_or_Class_Name__c='HELMSAddressCleansingService', Error_Message__c =ex.getMessage(), Error_Line_Number__c =Integer.valueOf(string.valueof(ex.getLineNumber() )) );
            insert l;
        }
    }   //Finish method starts
        public void finish(Database.BatchableContext bc){
           
        }
        public void execute(SchedulableContext sc){
        HELMSAddressCleansingService cs = new HELMSAddressCleansingService();
        Id JobID=Database.executeBatch(cs,100);
    }
    

}