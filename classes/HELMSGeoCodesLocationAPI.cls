//This class is used to calculate the Latitude and longitude of the lead based on its address
public class HELMSGeoCodesLocationAPI {
    //method to do the rest API callout
    @Future(callout=true)
    public static void getGeocodes(Set<id> opptyIds){
        try{
            List<Opportunity> updateopptylst= new List<Opportunity>();
            List<Opportunity> lstopptys= new List<Opportunity>([select id,City_TXT__c,State_TXT__c,ZipCode_TXT__c,Division_CD__c from opportunity where id IN:opptyIds FOR UPDATE]);
            for (opportunity opp: lstopptys){
                String apiHeaderParam = '';
                String apiHeaderAppId = 'bodyshops.honda.com';
                apiHeaderParam += '?AppId='+apiHeaderAppId;
                String apiHeaderState = '';
                String apiHeaderCity = '';
                String apiHeaderZipCode = '';
                String apiHeaderPOIType = '';
                String apiHeaderSearchRadius = '';
                String apiHeaderSearchPoiId = '';
                
                string lat='';
                string lon='';
                boolean docallout=false;
                if(opp.City_TXT__c != null && opp.City_TXT__c != ''){
                    apiHeaderCity = opp.City_TXT__c;
                    docallout=true;
                }
                apiHeaderParam += '&City='+apiHeaderCity;
                if(opp.State_TXT__c != null && opp.State_TXT__c != ''){
                    apiHeaderState = opp.State_TXT__c;
                    docallout=true;
                }
                apiHeaderParam += '&State='+apiHeaderState;
                if(opp.ZipCode_TXT__c != null && opp.ZipCode_TXT__c != ''){
                    apiHeaderZipCode = opp.ZipCode_TXT__c;
                    docallout=true;
                }
                apiHeaderParam += '&ZipCode='+apiHeaderZipCode;
                if(opp.Division_CD__c != null && opp.Division_CD__c != ''){
                    apiHeaderPOIType = opp.Division_CD__c;
                }
                if(docallout){
                   
                    
                    apiHeaderParam += '&POIType='+apiHeaderPOIType;
                    apiHeaderParam=apiHeaderParam.replace(' ','+');
                    apiHeaderParam += '&GeocodeOnly=True&Output=json';
                    
                    // API Sending Code
                    String contactkey;
                    HttpRequest req = new HttpRequest();
                    req.setHeader('Accept', 'application/json');
                    req.setHeader('Content-Type','application/json;charset=UTF-8');
                    string uniqueuid = HELMSleadEnrichmentIntegrationupdate.getUUID();
                    req.setHeader('hondaHeaderType.messageId',uniqueuid);
                    req.setHeader('hondaHeaderType.siteId',System.Label.siteid);
                    req.setHeader('hondaHeaderType.businessId',System.Label.businessId);
                    //req.setEndpoint('callout:Enrichment_Location_Service'+'?AppId=helms.honda.com&State=&ZipCode=90503&POIType=A&SearchRadius=250&NumberOfPOIs=1&ShowAllAttributes=False&ShowAllProperties=False&ShowAllDepartments=False&Output=json&POIId=');
                    req.setEndpoint('callout:Enrichment_Location_Service'+apiHeaderParam);
                    req.setTimeout(120000);
                    req.setMethod('GET');
                    Http http = new Http();
                    HTTPResponse res = http.send(req);
                    System.debug('Response----'+res.getBody());
                    System.debug('Status----'+res.getStatusCode());
                    if(res.getBody() != null && res.getStatusCode() == 200){
                    
                        JSONParser parser = JSON.createParser(res.getBody());
                        while (parser.nextToken() != null) {
                            if(parser.getCurrentName() == 'Latitude' && parser.getText()!=null && parser.getText()!='null' && parser.getText()!='Latitude' ){
                                //system.debug('Latitude:'+parser.getText());
                                lat=parser.getText();
                                
                            }
                            if(parser.getCurrentName() == 'Longitude' && parser.getText()!=null && parser.getText()!='null' && parser.getText()!='Longitude'){
                                //system.debug('Longitude:'+parser.getText());
                                lon=parser.getText();
                            }
                        }
                        if (lat!=null && lon!=null && lat!='null' && lon!='lon' && lat!='' && lon!=''){
                            opp.Customer_Geocodes__Latitude__s=decimal.valueof(lat);
                            opp.Customer_Geocodes__Longitude__s=decimal.valueof(lon);
                            updateopptylst.add(opp);
                        }
                    }
                } 
            }
            if(updateopptylst.size()>0)
            Database.update(updateopptylst);
            
        }catch(exception ex){
            Logs__c  l =new Logs__c (name='HELMSGeoCodesLocationAPI',Trigger_or_Class_Name__c='HELMSGeoCodesLocationAPI', Error_Message__c =ex.getMessage(), Error_Line_Number__c =Integer.valueOf(string.valueof(ex.getLineNumber() )) );
            insert l;
        }
        
    }
    
}