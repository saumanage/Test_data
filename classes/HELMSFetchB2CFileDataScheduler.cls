global class HELMSFetchB2CFileDataScheduler implements Schedulable,Database.AllowsCallouts {
    
        global void execute(SchedulableContext sc){
                 B2CFileDataScheduler();   
        }
        
        @future(callout=true) 
        public static void B2CFileDataScheduler(){
          
                Final String VERSION_BULKJOB_WAS_MADE_WITH = 'v53.0';
                List<B2C_Error_Details__c> b2cList= new List<B2C_Error_Details__c>();
                String respBody = '';  
                  
                HttpRequest req = new HttpRequest();
                String endPointUrl = URL.getOrgDomainUrl().toExternalForm() + '/services/data/' + VERSION_BULKJOB_WAS_MADE_WITH + '/jobs/ingest';
                
                req.setEndpoint(endPointUrl);
                req.setMethod('GET');
                req.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionId());
                Http http = new Http();
                HTTPResponse response = http.send(req);
                respBody = response.getBody();
                System.debug('respBody: ++++++' + respBody);
                
                if(response.getStatusCode()==200){
                    respBody = respBody.replaceAll('"object":','"objectName":');
                    bulkjobjsonwrapper bulkjob = (bulkjobjsonwrapper) System.JSON.deserialize(respBody, bulkjobjsonwrapper.class); 
                 
                
                    for(cls_records cls: bulkjob.records){
                      //System.debug('respBody: ++1++++' + cls.createdDate.date());
                      //System.debug('respBody: ++2++++' + date.today());
                      //System.debug('respBody: ++3++++' + cls.objectName);
    
                       if(cls.createdDate.date()==date.today()){
                       
                            if(cls.objectName=='Zip_Ranking__c' || cls.objectName=='City_State_Ranking__c' || cls.objectName=='RDR_Sales__c' || cls.objectName=='Dealer_Participation__c' || cls.objectName=='Dealer_Division__c' || cls.objectName=='Matchback__c' || cls.objectName=='CRM_System__c' || cls.objectName=='Account'){
                            
                                HttpRequest reqst = new HttpRequest();
                                String endPoint = URL.getOrgDomainUrl().toExternalForm() + '/services/data/' + VERSION_BULKJOB_WAS_MADE_WITH + '/jobs/query/'+cls.id;
                                
                                reqst.setEndpoint(endPoint);
                                reqst.setMethod('GET');
                                reqst.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionId());
                                Http https = new Http();
                                HTTPResponse respons = https.send(reqst);
                                respBody = respons.getBody();
                                System.debug('respBody: today++++++' + respBody);
                                
                                if(respons.getStatusCode()==200){
                                    respBody = respBody.replaceAll('"object":','"objectName":');
                                    jsonwraperclass jsnw = (jsonwraperclass) System.JSON.deserialize(respBody, jsonwraperclass.class);
            
                                    B2C_Error_Details__c b2cr= new B2C_Error_Details__c();
                                    b2cr.name = jsnw.id;
                                    
                                    if(jsnw.state=='JobComplete' || jsnw.state=='Closed')
                                        b2cr.Status__c = 'Success';
                                    else if(jsnw.state=='Open')
                                        b2cr.Status__c = 'In Progress';
                                    else
                                        b2cr.Status__c = 'Failure';
                                        
                                    b2cr.DateTime__c = jsnw.createdDate;
                                    
                                    if(jsnw.objectName=='Zip_Ranking__c')
                                        b2cr.Type__c = 'ZIP Code Rankings';
                                    else if(jsnw.objectName=='City_State_Ranking__c')
                                        b2cr.Type__c = 'City State Rankings';
                                    else if(jsnw.objectName=='RDR_Sales__c')
                                        b2cr.Type__c = 'RDR Sales';
                                    else if(jsnw.objectName=='Dealer_Participation__c')
                                        b2cr.Type__c = 'Dealer Participation';
                                    else if(jsnw.objectName=='Dealer_Division__c')
                                        b2cr.Type__c = 'Dealers Subdivisions';
                                    else if(jsnw.objectName=='Matchback__c')
                                        b2cr.Type__c = 'Matchback'; 
                                    else if(jsnw.objectName=='CRM_System__c')
                                        b2cr.Type__c = 'CRM System'; 
                                    else if(jsnw.objectName=='Account')
                                        b2cr.Type__c = 'Dealers';   
                                        
                                    b2cr.No_of_records_processed__c = string.valueof(jsnw.numberRecordsProcessed);
                                    //b2cr.No_of_Records_Failed__c = string.valueof(jsnw.numberRecordsFailed);
            
                                    if(b2cr.Type__c!=null)
                                        b2cList.add(b2cr);
                                    
                                }
                       
                            }
                         }
                    }
                }
                
                if(b2cList.size()>0)
                    insert b2cList;
                  
            }
            
            public class jsonwraperclass{
                    public String id;   //7504x00000GMxdQAAT
                    public String operation;    //upsert
                    public String objectName;   //Zip_Ranking__c
                    public datetime createdDate;  //2022-05-18T14:30:02.000+0000
                    public datetime systemModstamp;   //2022-05-18T14:30:54.000+0000
                    public String state;    //JobComplete
                    public String externalIdFieldName;  //Launchbox_ID__c
                    public Integer numberRecordsProcessed;  //83138
                    public Integer numberRecordsFailed; //0
                    public Integer totalProcessingTime; //146481
                    public Integer apiActiveProcessingTime; //125447
                    public Integer apexProcessingTime;  //138528
        
            
          }
            
          public class bulkjobjsonwrapper{
                public boolean done;                
                public cls_records[] records;
          }  
              
          public class cls_records {
                public String id;   //7504x00000GMOwHAAX
                public datetime createdDate;  //2022-05-14T13:32:21.000+0000
                public String state;    //Open
                public String objectName;   //Zip_Ranking__c

          }
          
           

 }