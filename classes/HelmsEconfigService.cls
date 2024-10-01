public class HelmsEconfigService {
    @Future(callout=true)
    public static void econfigAPI(set<id> leadIDset){
        try{
            list<lead> leadlist= new list<lead>([select id,Division_CD__c,SubDiv_TXT__c,Model_ID__c,Fuel_Type_Code__c from lead where id IN:leadIdset]);
            List<lead> updateLeadList = new list<lead>();
            string clientDomain=System.Label.EconfigClientDomain;
            string bearerToken=System.Label.EconfigBearerToken;
            string DPauthorization=System.Label.EconfigWlAuthorization;
            string environment='';
            if(clientDomain.contains('dev')){
                environment='dev';
            }
            else if(clientDomain.contains('stage')){
                environment='stage';
            }
            else{
                environment='prod';
            }
            for (lead l: leadlist){
                
                string subdivision= l.SubDiv_TXT__c;
                string division=l.Division_CD__c;
                string modelId=l.Model_ID__c;
                
                string requestBody='{"mit":{"@mit_version_date":"2019-03-10","@mit_version_number":"1","client_info":{"@application_id":"helms.honda.com","@echo_input":"false","@server_ip":"test","@session_id":"test","@domain":"'+clientDomain+'","@environment":"'+environment+'"},"input_parameters":{"required":{"source_cd":"'+subdivision+'","site_cd":"'+subdivision+'","category_cd":"CONFIG","division":{"@version_num":"0","#text":"'+division+'"},"models":{"model":{"@id":"'+modelId+'"}}},"optional":{"attributes":{"attribute":[{"@attribute_type_name":"FUEL_TYP_CD"}]}}},"private":{"template_info":{"@class":"Model","@filename":"Model-GetModelCompleteDetails-MIT.xml","@xsd":"Model-GetModelCompleteDetails-MIT.xsd","@method":"GetModelCompleteDetails"},"stored_procedure":{"@name":"ecnetsp_Model_GetModelCompleteDetails"}}}}';
                Http http = new Http();
                HttpRequest request = new HttpRequest();
                
                request.setEndpoint('callout:HELMSEnconfigAPI');
                request.setHeader('Authorization',bearerToken);
                
                request.setHeader('ClientDomain',clientDomain);
                request.setHeader('hondaHeaderType.messageId','82eee037-784e-47aa-9b1a-00be9cc5e5f4');
                request.setHeader('hondaHeaderType.siteId','00e0e97f0fb543208a918fc946dea334');
                request.setHeader('hondaHeaderType.collectedTimestamp','2012-01-01T14:02:41.548-05:00');
                request.setHeader('accept','application/json');
                request.setHeader('X-Honda-wl-authorization',DPauthorization);
                request.setHeader('Content-Type','application/json');
                request.setMethod('POST');
                request.setBody(requestBody);
                HttpResponse response = http.send(request);
                if(response.getBody() != null && response.getStatusCode() == 200){
                    String responseJson = response.getBody();
                    // Parse the JSON string into a Map
                    Map<String, Object> jsonResponse = (Map<String, Object>) JSON.deserializeUntyped(responseJson);
                    
                    // Access the 'mot' object from the JSON response
                    Map<String, Object> motObject = (Map<String, Object>) jsonResponse.get('mot');
                    
                    // Access the 'db_results' object from the 'mot' object
                    Map<String, Object> dbResultsObject = (Map<String, Object>) motObject.get('db_results');
                    
                    // Access the 'attributes' object from the 'db_results' object
                    Map<String, Object> attributesObject = (Map<String, Object>) dbResultsObject.get('attributes');
                    
                    // Access the 'attribute' object from the 'attributes' object
                    Map<String, Object> attributeObject = (Map<String, Object>) attributesObject.get('attribute');
                    
                    // Access the value of the "@name" key from the 'attribute' object
                    String fuelTypeCode = (String) attributeObject.get('@name');
                    
                    //System.debug('fuelTypeCode--'+fuelTypeCode); // Output: fuelTypeCode
                    //system.debug('::::response::::::'+response.getBody());
                    //system.debug('::::getStatusCode::::::'+response.getStatusCode());
                    if(fuelTypeCode=='E'){
                        l.Fuel_Type_Code__c='E';
                        updateLeadList.add(l);
                    }
                    else if(fuelTypeCode=='H'){
                        l.Fuel_Type_Code__c='H';
                        updateLeadList.add(l);
                    }
                    else if(fuelTypeCode=='N'){
                        l.Fuel_Type_Code__c='N';
                        updateLeadList.add(l);
                    }
                    else if(fuelTypeCode=='B'){
                        l.Fuel_Type_Code__c='B';
                        updateLeadList.add(l);
                    }
                    else{
                        l.Fuel_Type_Code__c='G';
                        updateLeadList.add(l);
                    }
                    
                }
                else{
                    Logs__c  log =new Logs__c (name='HelmsEconfigService',Trigger_or_Class_Name__c='HelmsEconfigService', Error_Message__c =response.getBody(), Error_Line_Number__c =response.getStatusCode() );
                    insert log;
                    
                }
                
            }
            if(updateLeadList.size()>0){
                update updateLeadList;
            }
            
        }catch(exception ex){
            Logs__c  l =new Logs__c (name='HelmsEconfigService',Trigger_or_Class_Name__c='HelmsEconfigService', Error_Message__c =ex.getMessage(), Error_Line_Number__c =Integer.valueOf(string.valueof(ex.getLineNumber() )) );
            insert l;
        }
        
        
        
    }
}