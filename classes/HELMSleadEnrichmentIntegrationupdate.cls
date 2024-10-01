global class HELMSleadEnrichmentIntegrationupdate{
    global static boolean flag =false;
  @future (callout=true)
   public static void LeadEnrichment(set<id> listids, Boolean isUpdate) {
       List<Logs__c > logList= new List<Logs__c >();
       
   Map<Id, String> encodeIdMap = new Map<Id, String>();
    try{
        String contactkey;
         //Construct HTTP request and response
         //Http request method,Endpoint and setBody
         HttpRequest req = new HttpRequest();
         
         req.setHeader('Accept', 'application/json');
         req.setHeader('Content-Type','application/json;charset=UTF-8');
         string uniqueuid = HELMSleadEnrichmentIntegrationupdate.getUUID();
             
         req.setHeader('hondaHeaderType.messageId',uniqueuid);
         req.setHeader('hondaHeaderType.siteId',System.Label.siteid);
         req.setHeader('hondaHeaderType.businessId',System.Label.businessId);
         String endpoint = System.Label.EndpointURL;
         req.setMethod('POST');
         //Bug-4131
         req.setEndpoint('callout:eCRM_Credentials'); 
         //end - Bug-4131
         req.setTimeout(120000);
        List<Lead> ledlist=[select id,ownerid, Name,Model_ID__c,Division_CD__c,ContactKey_TXT__c,FirstName,Number_NM__c,VehicleStatus_TXT__c,External_ID__c,Email, LastName, Suffix, Salutation, MiddleName, Phone, MobilePhone,PreferredDealerNumber_NUM__c, City, PostalCode, Street,State, Country,CustomerAccount_ID__c, Lead_SF_ID__c, ValidAddress_FLG__c, ValidEmail_FLG__c, ValidMobile_FLG__c, ValidPhoneNum_FLG__c, IsDealerized__c, Is_HELMS_Contact_Key__c  from Lead where id IN: listids and IsConverted=false ORDER BY PreferredDealerNumber_NUM__c];
        Map<Id, string> resList = new Map<Id, string>();
        Map<String,String> ppoi = new Map<String,String>();
        for(Lead_Enrichment_Callout__mdt m :[select id,poi_radius__c, Division__c from Lead_Enrichment_Callout__mdt])
        {
            ppoi.put(m.Division__c , String.valueOf(Integer.valueof(m.poi_radius__c)));
        }
        //System.debug('isUpdate : '+isUpdate);
        for(Lead led :ledlist ){
            JSONRequest ledjson = new JSONRequest();
            
            List<JSONRequest.Vehicle> vehList = new List<JSONRequest.Vehicle>();
            JSONRequest.Vehicle v = new JSONRequest.Vehicle();
            if(led.Model_ID__c!=null){
                v.modelId = led.Model_ID__c;
            }
            if(led.Division_CD__c!=null){
                v.businessunit = led.Division_CD__c;
            }
            //v.vehicletypecode = 'N';
            If(led.VehicleStatus_TXT__c!=null){
                String s=led.VehicleStatus_TXT__c;
                //system.debug('-----'+s.LEFT(1));
                v.vehicletypecode = s.LEFT(1);
            }
            
            vehList.add(v);
            
            List<JSONRequest.Address> addList = new List<JSONRequest.Address>();
            JSONRequest.Address add = new JSONRequest.Address();
            
            	       /* GLavanya-start-code was updated as a part of AMSLM-662*/
            if(led.street!=null){
                //add.address_line1 = led.street;
                add.address_line1 = (led.street.replaceAll('[^a-zA-Z0-9\\s+]', ''));
            }
            
            if(led.city!=null){
                //add.city = led.city;
                add.city = (led.city.replaceAll('[^a-zA-Z0-9\\s+]', ''));
            }
            if(led.state!=null){
                //add.state = led.state;
                add.state = (led.state.replaceAll('[^a-zA-Z\\s+]', ''));
            }
            if(led.postalCode!=null){
              /*  String M=led.postalCode;
                if(M.contains('-')){
                    String[] Mi = M.split('-');
                    //system.debug('0-----'+Mi[0]);
                    //system.debug('1-----'+Mi[1]);
                    
                    add.zip = Mi[0];
                    add.plus4 = Mi[1];
                }else{
                    add.zip = led.postalCode;
                }*/
                 add.zip = (led.postalCode.replaceAll('[^0-9\\s+]', ''));
            }
                   
            
            if(led.country!=null){      
                //add.country = led.country;
                add.country = (led.country.replaceAll('[^a-zA-Z0-9\\s+]', ''));
            }
            
            	       /* GLavanya-End -code was updated as a part of AMSLM-662*/
            
            addList.add(add);
            
            JSONRequest.Name na = new JSONRequest.Name();
            if(led.Salutation!=null){   
                na.prefix=led.Salutation;
            }
            
            	       /* GLavanya-start-code was updated as a part of AMSLM-643*/
            
            if(led.FirstName!=null){    
               // na.first_name=led.FirstName;
                na.first_name = (led.FirstName.replaceAll('[^a-zA-Z0-9\\s+]', ''));
            }
            if(led.MiddleName!=null){   
                //na.middle_name=led.MiddleName;
                na.middle_name = (led.MiddleName.replaceAll('[^a-zA-Z0-9\\s+]', ''));
            }
            if(led.LastName!=null){ 
                //na.last_name=led.LastName;
                na.last_name = (led.LastName.replaceAll('[^a-zA-Z0-9\\s+]', ''));
            }
            
            	       /* GLavanya-End -code was updated as a part of AMSLM-643*/
            if(led.Suffix!=null){   
                na.suffix=led.Suffix;
            
            } 
            JSONRequest.Customer cus = new JSONRequest.Customer();
            cus.name= na;
            cus.address = addList;
            cus.email= led.email;
            
            /* Code Written by Gouse */
            if(led.Phone != null) {
                cus.home_phone = (led.Phone.replaceAll('[^a-zA-Z0-9\\s+]', '')).deleteWhitespace();
            }
             if(led.MobilePhone != null) {
                 cus.cell_phone=(led.MobilePhone.replaceAll('[^a-zA-Z0-9\\s+]', '')).deleteWhitespace();
            }
            /* Code written by Gouse */
            
           // cus.home_phone=led.Phone;
           // cus.cell_phone=led.MobilePhone;

            
            JSONRequest.Location loc = new JSONRequest.Location();
            
            if(led.PreferredDealerNumber_NUM__c!=null){
                loc.poi_id= led.PreferredDealerNumber_NUM__c;
            }
            //loc.poi_radius='15';
            if(ppoi.Containskey(led.Division_CD__c)){
            
              loc.poi_radius=  ppoi.get(led.Division_CD__c);
            }   
            
            /* ModelCode attribute */
            if(led.Division_CD__c == 'A' || led.Division_CD__c == 'B' || led.Division_CD__c == 'M'){
            	loc.ModelCode = '01';   
            }else{
            loc.ModelCode = 'LM';
            }
            /* ModelCode attribute */
            
            loc.NumberOfPOIs ='1';
             
            ledjson.leadId=led.External_ID__c;
            ledjson.customer=cus;
            ledjson.location=loc;
            ledjson.vehicle=vehList;
            ledjson.source=System.Label.source;
            
            /* Lead Enrichment Updation */
            ledjson.ValidMobilePhone=led.ValidMobile_FLG__c;
            ledjson.ValidAddress=led.ValidAddress_FLG__c;
            ledjson.ValidPhone=led.ValidPhoneNum_FLG__c;
            ledjson.ValidEmail=led.ValidEmail_FLG__c;
            ledjson.IsDealerized =led.IsDealerized__c;
            ledjson.PESynchronous=false;
            if(isUpdate){
                ledjson.ContactKey=led.ContactKey_TXT__c;
            }
            /* Lead Enrichment Updation */
            
            
            //LMS-1733
            //HPS - 468 - Sending the Lead SF ID to Enrichment
            /*if(led.Lead_SF_ID__c==null){
                String encodeIdMapVal = RecordIdEncryptionUtil.encryptRecordId(led.id);
                encodeIdMap.put(led.id,encodeIdMapVal);
            }*/
           // System.debug('led.Lead_SF_ID__c : '+led.Lead_SF_ID__c);
            /*if(isUpdate){
                ledjson.LeadSFId= led.Lead_SF_ID__c; //After encoding the Lead Id, we are passing this value
            }else{
                ledjson.LeadSFId= encodeIdMap.get(led.id); //After encoding the Lead Id, we are passing this value    
            ledjson.LeadSFId= encodeIdMap.get(led.id); //After encoding the Lead Id, we are passing this value
                ledjson.LeadSFId= encodeIdMap.get(led.id); //After encoding the Lead Id, we are passing this value    
            }*/
            ledjson.LeadSFId= led.Lead_SF_ID__c;
            //HPS - 468 - Sending the Lead SF ID to Enrichment
            
             String JsonString=JSON.serialize(ledjson);
             System.debug('JsonString 1 : '+JsonString);
             req.setBody(JsonString);
             //Http response method 
             Http http = new Http();
             HTTPResponse res = http.send(req);
             
            // System.debug('Response----'+res.getBody());
             //No need to execute the below section during the Lead Update, due to already exists Contact Key. Put extra condition !isUpdate
            if(res.getBody()!=null && !isUpdate && led.ContactKey_TXT__c == null && res.getStatusCode() == 200){
                 //System.debug('Inside 2 *');
                 HELMSJsonWrapper Jsondatawrapper = (HELMSJsonWrapper)JSON.deserialize(res.getBody(),HELMSJsonWrapper.class);
              
                if(Jsondatawrapper.response!=null){ 
                    //System.debug('leadid----'+Jsondatawrapper.response.leadId);
                    if(Jsondatawrapper.response.consumer_detail!=null){
                    //System.debug('Contact-key-------'+Jsondatawrapper.response.consumer_detail.contact_key);
                                      
                    resList.put(led.id, Jsondatawrapper.response.consumer_detail.contact_key ); 
                    }
                }
            }
            if(res.getStatusCode() != 200){
                Logs__c  l =new Logs__c (name='Integration callout failure',Trigger_or_Class_Name__c='HELMSleadEnrichmentIntegrationupdate', Error_Message__c =res.getBody(), Error_Line_Number__c =res.getStatusCode() );
                logList.add(l); 
            }
            
        }   
        if(!isUpdate){
            //System.debug('Inside !Update 1');
            //List<Account> perAccList = [select id,Contact_Key__c from Account where IsPersonAccount =true and Contact_Key__c IN : resList.values() FOR UPDATE];
            //AMSLM-925
            List<Account> perAccList = [select id,Contact_Key__c from Account where IsPersonAccount =true and Contact_Key__c IN : resList.values()];
            //System.debug('perAccList : '+perAccList);
            List<Account> perAccListNew = new List<Account>();
			Set<String> contactKeySet = new Set<String>();
            if(perAccList.size() > 0){
            	for(Account a : perAccList){
                    //System.debug(a.Id);
                    //System.debug(a.Contact_Key__c);
                    if(contactKeySet.isEmpty()){
                        contactKeySet.add(a.Contact_Key__c);
                        perAccListNew.add(a);
                    }
                    else if(!contactKeySet.contains(a.Contact_Key__c)){
                        contactKeySet.add(a.Contact_Key__c);
                        perAccListNew.add(a);
                    }    
                }   
            }
            set<Lead> updateLead = new set<Lead>();
            List<Account> accList = new List<Account>();
            
            List<New_Contact_Key__e> publishEvents = new List<New_Contact_Key__e>();
        	Set<Id> uniqueLeadIdSet = new Set<Id>();
            for(Lead led :ledlist ){
                if(perAccListNew.size()>0){
                    //System.debug('Inside ! Update 2');
                    for(Account acc:perAccListNew){
                    if(resList.get(led.id)!=null && resList.get(led.id) == acc.Contact_Key__c ){
                        led.CustomerAccount_ID__c = acc.id;
                        led.ContactKey_TXT__c = acc.Contact_Key__c;
                        if(encodeIdMap.size() > 0 && encodeIdMap.containskey(led.id) && !isUpdate){
                            led.Lead_SF_ID__c = encodeIdMap.get(led.id);
                        }
                        if(uniqueLeadIdSet.isempty()){
                            uniqueLeadIdSet.add(led.Id);
                        updateLead.add(led);
                        }else if(!uniqueLeadIdSet.contains(led.Id)){
                            uniqueLeadIdSet.add(led.Id);
                            updateLead.add(led);
                        }
                        
                       
                    }
                        else{
                        //System.debug('Inside ! Update 3');
                        Account a=new Account();
                    
                        if(led.Salutation!=null){   
                            a.Salutation=led.Salutation;
                        }
                        if(led.FirstName!=null){    
                            a.FirstName=led.FirstName;
                        }
                        if(led.MiddleName!=null){   
                            a.MiddleName=led.MiddleName;
                        }
                        if(led.LastName!=null){ 
                            a.LastName=led.LastName;
                        }
                        if(led.Suffix!=null){   
                            a.suffix=led.Suffix;
                        
                        }
                        if(led.ownerid!=null){   
                            a.ownerid=led.ownerid;
                        
                        }
                        String rno = '';
                        if(resList.size() > 0 && resList.containskey(led.id)){
                            rno = resList.get(led.id);
                            led.Is_HELMS_Contact_Key__c = false;
                        }else{
                            rno = 'H'+getRandomContactKey();
                            led.Is_HELMS_Contact_Key__c = true;
                        }
                        
                        //led.Is_HELMS_Contact_Key__c = true;
                            a.Contact_Key__c= rno;
                            resList.put(led.id, rno ); 
                                                                  
                            New_Contact_Key__e eve = new New_Contact_Key__e();
                            eve.ContactKey__c = rno;
                            
                            if(led.email!=null){ eve.Email__c = led.email;
                            }else{      eve.Email__c = ''; 
                            }
                            
                            if(led.FirstName!=null){     eve.FirstName__c = led.FirstName;
                            }else{ eve.FirstName__c = ''; } 
                            
                            if(led.LastName!=null){     eve.LastName__c = led.LastName;
                            }
                            
                            if(led.MiddleName!=null){     eve.MiddleName__c =led.MiddleName;
                            }else{ eve.MiddleName__c = ''; } 
                            
                            if(led.MobilePhone!=null){     eve.Mobile__c =led.MobilePhone;
                            }else{  eve.Mobile__c =''; }
                            
                            if(led.Phone!=null){     eve.Phone__c =led.Phone;
                            }else{  eve.Phone__c ='';   }
                            
                            if(led.Street!=null){     eve.Street__c =led.Street;
                            }//else{  eve.Street__c ='';  }
                            
                            if(led.city!=null){     eve.City__c = led.city;
                            }//else{  eve.City__c ='';    }
                            
                            if(led.State!=null){     eve.State__c =led.State;
                            }//else{  eve.State__c ='';   }
                            
                            if(led.postalCode!=null){     eve.PostalCode__c =led.postalCode;
                            }//else{  eve.PostalCode__c ='';  }
                            
                            if(led.Number_NM__c!=null){     eve.VIN__c =led.Number_NM__c;
                            }else{  eve.VIN__c =''; }    
                            publishEvents.add(eve); 
                        a.PersonEmail=led.email;
                        a.RecordTypeId = Schema.SObjectType.account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
                        accList.add(a);
                    }
                }
            }else{
                Account a=new Account();
                    
                    if(led.Salutation!=null){   
                        a.Salutation=led.Salutation;
                    }
                    if(led.FirstName!=null){    
                        a.FirstName=led.FirstName;
                    }
                    if(led.MiddleName!=null){   
                        a.MiddleName=led.MiddleName;
                    }
                    if(led.LastName!=null){ 
                        a.LastName=led.LastName;
                    }
                    if(led.Suffix!=null){   
                        a.suffix=led.Suffix;
                    
                    }
                    if(led.ownerid!=null){   
                        a.ownerid=led.ownerid;                    
                    }
                    
                       String rno = '';
                        if(resList.size() > 0 && resList.containskey(led.id)){
                            rno = resList.get(led.id);
                            led.Is_HELMS_Contact_Key__c = false;
                        }else{
                            rno = 'H'+getRandomContactKey();
                    	led.Is_HELMS_Contact_Key__c = true;
                        }
                        
                        //led.Is_HELMS_Contact_Key__c = true;
                        a.Contact_Key__c= rno;
                        resList.put(led.id, rno );
                        New_Contact_Key__e eve = new New_Contact_Key__e();
                        eve.ContactKey__c = rno;
                        if(led.email!=null){ eve.Email__c = led.email;
                            }else{      eve.Email__c = ''; 
                            }
                            
                            if(led.FirstName!=null){     eve.FirstName__c = led.FirstName;
                            }else{ eve.FirstName__c = ''; } 
                            
                            if(led.LastName!=null){     eve.LastName__c = led.LastName;
                            }
                            
                            if(led.MiddleName!=null){     eve.MiddleName__c =led.MiddleName;
                            }else{ eve.MiddleName__c = ''; } 
                            
                            if(led.MobilePhone!=null){     eve.Mobile__c =led.MobilePhone;
                            }else{  eve.Mobile__c =''; }
                            
                            if(led.Phone!=null){     eve.Phone__c =led.Phone;
                            }else{  eve.Phone__c ='';   }
                            
                            if(led.Street!=null){     eve.Street__c =led.Street;
                            }//else{  eve.Street__c ='';  }
                            
                            if(led.city!=null){     eve.City__c = led.city;
                            }//else{  eve.City__c ='';    }
                            
                            if(led.State!=null){     eve.State__c =led.State;
                            }//else{  eve.State__c ='';   }
                            
                            if(led.postalCode!=null){     eve.PostalCode__c =led.postalCode;
                            }else{  /*eve.PostalCode__c ='';*/  }
                            
                            if(led.Number_NM__c!=null){     eve.VIN__c =led.Number_NM__c;
                            }else{  eve.VIN__c =''; } 
                       // System.debug('eve New : '+eve);
                        publishEvents.add(eve); 
                            
                            
                   
                    a.PersonEmail=led.email;
                    a.RecordTypeId = Schema.SObjectType.account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
                    accList.add(a);
            }
        }
           
            
        //System.debug('accList : '+accList);
        if(accList.size()>0){ 
            insert accList;
        }
        for(Lead led :ledlist ){
            for(Account a:accList){
                    if(resList.get(led.id) == a.Contact_Key__c ){
                    led.CustomerAccount_ID__c = a.id;
                    led.ContactKey_TXT__c = a.Contact_Key__c;
                        if(encodeIdMap.size() > 0 && encodeIdMap.containskey(led.id)  && !isUpdate){
                        led.Lead_SF_ID__c = encodeIdMap.get(led.id);
                    }
                        led.Sent_for_Enrichment_Date_Time__c=system.now();
                        if(uniqueLeadIdSet.isempty()){
                            uniqueLeadIdSet.add(led.Id);
                    updateLead.add(led);
                        }else if(!uniqueLeadIdSet.contains(led.Id)){
                            uniqueLeadIdSet.add(led.Id);
                            updateLead.add(led);
                        }
                    flag =true;
                }
            }
        }
        List<Lead> updateLeadList = new List<Lead>();
        if(updateLead.size()>0){
            updateLeadList.addall(updateLead);
            update updateLeadList;
                if(publishEvents.size()>0){
                    EventBus.publish(publishEvents);
                   // System.debug('--publish contactket event---');
                }
        }
            if(logList.size()>0)
                insert logList;
        
        }
        
     
        
    }Catch(Exception ex){
        System.debug('Exception at line : '+ ex.getLineNumber());
        //System.debug('Exception Message : '+ ex.getMessage());
        
        Logs__c  l =new Logs__c (name='Lead enrichment call failures',type__c='Lead enrichment call failures',Trigger_or_Class_Name__c='HELMSleadEnrichmentIntegrationupdate', Error_Message__c =ex.getMessage(), Error_Line_Number__c =Integer.valueOf(string.valueof(ex.getLineNumber() )) );
       insert l;
    }       
    
   }
      
   public static String getUUID()
    {
        Blob b = Crypto.GenerateAESKey(128);
        String h = EncodingUtil.ConvertTohex(b);
        String guid = h.SubString(0,8)+ '-' + h.SubString(8,12) + '-' + h.SubString(12,16) + '-' + h.SubString(16,20) + '-' + h.substring(20);
        //system.debug(guid);
        return guid;
    }
    public static String getRandomContactKey()
    {
        Integer len = 9;
        String str = string.valueof(Math.abs(Crypto.getRandomLong()));
        String randomNumber = str.substring(0, len);
        //system.debug('Random Number-' + randomNumber);
        String rno = 'H'+randomNumber;
        List<Account> perAccList = [select id,Contact_Key__c from Account where IsPersonAccount =true and Contact_Key__c=:rno ];
        if(perAccList.size()>0){
            HELMSleadEnrichmentIntegrationupdate.getRandomContactKey();
        }
        
        return randomNumber;
    }
}