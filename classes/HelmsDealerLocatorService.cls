//This class is used to assign a dealer to a lead based on the address if a lead comes without a dealer number
global class HelmsDealerLocatorService {
    global static boolean dealerLocatorFlag = false;
    global static boolean isUpdatedSalesToService = false;
    global static boolean isUpdatedSalesOnly = false;
    
    public static void updateSalesOnly(Set<Id> listId){
        List<Lead> listToUpdateSalesOnly = new List<Lead>();
        for(Lead leadRec : [Select Id, Name, Dealer_Assignment_Type__c, Is_Location_Enrichment_Done__c, PreferredDealerNumber_NUM__c, SalesRelatedDealerNumber__c, ServiceRelatedDealerNumber__c FROM Lead WHERE Id IN : listId]){
            leadRec.PreferredDealerNumber_NUM__c = leadRec.SalesRelatedDealerNumber__c;
            leadRec.Is_Location_Enrichment_Done__c = true;
            leadRec.Dealer_Assignment_Type__c = 'Sales';
            listToUpdateSalesOnly.add(leadRec); 
        }
        if(listToUpdateSalesOnly.size() > 0 && HelmsDealerLocatorService.isUpdatedSalesOnly == false){
            //System.debug('Just Before Update');
            HelmsDealerLocatorService.isUpdatedSalesOnly = true;
            update listToUpdateSalesOnly;
            //System.debug('listToUpdateSalesToService : '+listToUpdateSalesOnly);
        }
    }
    
    
    public static void updateSalesToService(Set<Id> listId){
        //System.debug('Inside Sales to Service'); 
        List<Lead> listToUpdateSalesToService = new List<Lead>();
        for(Lead leadRec : [Select Id, Name, Dealer_Assignment_Type__c, Is_Location_Enrichment_Done__c, PreferredDealerNumber_NUM__c, SalesRelatedDealerNumber__c, ServiceRelatedDealerNumber__c FROM Lead WHERE Id IN : listId]){
            if( (leadRec.PreferredDealerNumber_NUM__c  != leadRec.ServiceRelatedDealerNumber__c) && (leadRec.SalesRelatedDealerNumber__c  != leadRec.ServiceRelatedDealerNumber__c) ){
            	leadRec.PreferredDealerNumber_NUM__c = leadRec.ServiceRelatedDealerNumber__c;
                leadRec.Is_Location_Enrichment_Done__c = true;
                leadRec.Dealer_Assignment_Type__c = 'Service';
            	listToUpdateSalesToService.add(leadRec);    
            }
        }
        //System.debug('After For Loop. Inside Sales to Service');
        //System.debug('listToUpdateSalesToService : '+listToUpdateSalesToService);
        //System.debug('HELMSleadEnrichmentIntegrationupdate.flag : '+HelmsDealerLocatorService.isUpdatedSalesToService);
        if(listToUpdateSalesToService.size() > 0 && HelmsDealerLocatorService.isUpdatedSalesToService == false){
            //System.debug('Just Before Update');
            HelmsDealerLocatorService.isUpdatedSalesToService = true;
            update listToUpdateSalesToService;
            //System.debug('listToUpdateSalesToService : '+listToUpdateSalesToService);
        }
    }
    
    public static Map<Id,String> checkDistance(Set<Id> listId){
        //System.debug('Inside Check Distance Fun. '+listId);
        Map<Id,String> isReceivedDealer = new Map<Id,String>();
        Map<String,Integer> ppoi = new Map<String,Integer>();
        List<Lead> leadlist = new List<Lead>([Select id,ServiceRelatedDealerNumber__c,SalesRelatedDealerNumber__c from lead where ID IN :listId]);
        List<string> dlrnumlist = new List<string>();
        Set<string> accDistset = new Set<string>();
        Map<id,Account> leadsalesdealerMap = new Map<id,Account>();
        for(lead l: leadlist){
            if(l.ServiceRelatedDealerNumber__c!=null || l.ServiceRelatedDealerNumber__c!='')
                dlrnumlist.add(l.ServiceRelatedDealerNumber__c);
            if(l.SalesRelatedDealerNumber__c!=null || l.SalesRelatedDealerNumber__c!='')
                accDistset.add(l.SalesRelatedDealerNumber__c);      
        }
        List<Account> salesaccounts= new List<Account>([Select id,DealerCode_CD__c,ShippingLatitude,ShippingLongitude from Account where recordtype.developername='Dealer' And DealerCode_CD__c IN:accDistset]);
        Map<string,string> salesnumAccountMap =  new Map<string,string>();
        for(Account a: salesaccounts){
            salesnumAccountMap.put(a.DealerCode_CD__c,a.ShippingLatitude+','+a.ShippingLongitude);
        }
        Set<Account> accset =new Set<Account>([Select id from Account where recordtype.developername='Dealer' And DealerCode_CD__c IN:dlrnumlist]);
        Map<string,Boolean> leadenrollmentmap = new Map<string,Boolean>();
        
        Set<Dealer_Division__c> dlrdivset=new Set<Dealer_Division__c>([select id,Dealer_ID__r.DealerCode_CD__c,SubDiv_TXT__c,InternetCertified_FLG__c from Dealer_Division__c where Dealer_ID__c IN: accset and isActive_FLG__c=true]);
        for (Dealer_Division__c ddivrec :dlrdivset){
            leadenrollmentmap.put(ddivrec.Dealer_ID__r.DealerCode_CD__c+''+ddivrec.SubDiv_TXT__c,ddivrec.InternetCertified_FLG__c);
        }
        for(Lead_Enrichment_Callout__mdt m :[select id,poi_radius__c, Division__c from Lead_Enrichment_Callout__mdt])
        {
        	ppoi.put(m.Division__c , Integer.valueof(m.poi_radius__c));
        }
        if(listId.size() > 0){
            for(Lead leadrec : [SELECT Id, Division_CD__c,SubDiv_TXT__c, PreferredDealerNumber_NUM__c, PreferredDealerAccount_ID__c, PreferredDealerAccount_ID__r.ShippingLatitude, PreferredDealerAccount_ID__r.ShippingLongitude,  SalesRelatedDealerNumber__c, ServiceRelatedDealerNumber__c,Longitude, Latitude FROM Lead WHERE Id IN : listId]){
                //System.debug('Sales Dealer Number : '+leadrec.SalesRelatedDealerNumber__c);
                //System.debug('Service Dealer Number : '+leadrec.ServiceRelatedDealerNumber__c);
                String DealerSelected = 'Location';
                Integer configuredDistance = 0;
                if(ppoi.size() > 0 && ppoi.containskey(leadrec.Division_CD__c)){
                    configuredDistance = ppoi.get(leadrec.Division_CD__c);
                }
                //if(leadrec.PreferredDealerNumber_NUM__c == leadrec.SalesRelatedDealerNumber__c){
                    Location loc1 = Location.newInstance(leadrec.Latitude,leadrec.Longitude);
                /*
                    string lat=salesnumAccountMap.get(leadrec.SalesRelatedDealerNumber__c).substringbetween('latStart','latEnd');
                    string lon=salesnumAccountMap.get(leadrec.SalesRelatedDealerNumber__c).substringbetween('longtStart','longEnd');
                    double latitude= Double.parseDouble(lat);
                    double longitude= Double.parseDouble(lon);
                    Location loc2 = Location.newInstance(latitude,longitude);
                 */
                    string[] latlong =salesnumAccountMap.get(leadrec.SalesRelatedDealerNumber__c).split(',');
                    double latitude= Double.valueof(latlong[0]);
                    double longitude= Double.valueof(latlong[1]);
                    Location loc2 = Location.newInstance(latitude,longitude);
                    //Location loc2 = Location.newInstance((salesnumAccountMap.get(leadrec.SalesRelatedDealerNumber__c)).ShippingLatitude,(salesnumAccountMap.get(leadrec.ServiceRelatedDealerNumber__c).ShippingLatitudeShippingLongitude));
                    //System.debug('loc1 : '+loc1);
                    //System.debug('loc2 : '+loc2);
                    //System.debug('configuredDistance : '+configuredDistance);
                    Double dist = Location.getDistance(loc1, loc2, 'mi');
                    //System.debug('Sales Dealer Distance : '+dist);    
                    
                    if(dist <= configuredDistance){
                        DealerSelected = 'Sales';
                    }else{
                        //System.debug('Service Dealer Number : '+leadrec.ServiceRelatedDealerNumber__c);
                        if(leadrec.ServiceRelatedDealerNumber__c != null &&  leadenrollmentmap.containskey(leadrec.ServiceRelatedDealerNumber__c+''+leadrec.SubDiv_TXT__c) && leadenrollmentmap.get(leadrec.ServiceRelatedDealerNumber__c+''+leadrec.SubDiv_TXT__c)){
                            Boolean isService = HelmsDealerLocatorService.checkServiceDistance(configuredDistance,leadrec.Latitude, leadrec.Longitude, leadrec.ServiceRelatedDealerNumber__c);
                            if(isService){
                            	DealerSelected = 'Service';    
                            }	
                        }
                    }
                //}
                isReceivedDealer.put(leadrec.Id,DealerSelected);
            }
        } 
        return isReceivedDealer;
    }
    
    public static boolean checkServiceDistance(Integer configueddistanceval, Decimal latitude,Decimal longitude, String serviceDealerNumber){
        //System.debug('Inside Service Distance :'+serviceDealerNumber);
        boolean isWithinAllowedRadius = false;
        //True - Service Dealer is within the Configured Distance
        //System.debug('SQL is : '+'SELECT Id,DealerCode_CD__c,ShippingLatitude,ShippingLongitude FROM Account WHERE DealerCode_CD__c = :'+ serviceDealerNumber+'');
        Account accRec = [SELECT Id,DealerCode_CD__c,ShippingLatitude,ShippingLongitude FROM Account WHERE DealerCode_CD__c = : serviceDealerNumber];
        Location loc1 = Location.newInstance(accRec.ShippingLatitude,accRec.ShippingLongitude);
        Location loc2 = Location.newInstance(latitude,longitude);
        Double serviceDist = Location.getDistance(loc1, loc2, 'mi');
        //System.debug('serviceDist : '+serviceDist);
        if(serviceDist <= configueddistanceval ){
            isWithinAllowedRadius = true;
        }
        return isWithinAllowedRadius;
    }
    
    
    @future(callout=true)
    //Set<Id> leadIdSet
    public static void dealerLocatorService(Set<Id> leadIdSet){
        try{
            Map<String,String> ppoi = new Map<String,String>();
            for(Lead_Enrichment_Callout__mdt m :[select id,poi_radius__c, Division__c from Lead_Enrichment_Callout__mdt])
            {
                ppoi.put(m.Division__c , String.valueOf(Integer.valueof(m.poi_radius__c)));
            }
            List<Lead> leadListToUpdate = new List<Lead>();
            Set<Id> leadIdToUpdate = new Set<Id>();
            //List<Lead> leadList = [SELECT Id,Name,Is_Location_Enrichment_Done__c,Dealer_Assignment_Type__c,PreferredDealerAccount_ID__c,PreferredDealerNumber_NUM__c,postalCode,State,Division_CD__c FROM Lead WHERE Id IN : leadIdSet ];
            List<Lead> leadList = [SELECT Id,Name,Is_Location_Enrichment_Done__c,Dealer_Assignment_Type__c,PreferredDealerAccount_ID__c,PreferredDealerNumber_NUM__c,postalCode,State,City,Division_CD__c,Fuel_Type_Code__c FROM Lead WHERE Id IN : leadIdSet ];
            for(Lead leadrec : leadList){
                String apiHeaderParam = '';
                //String apiHeaderAppId = 'helms.honda.com';
                String apiHeaderAppId = 'bodyshops.honda.com';
                apiHeaderParam += '?AppId='+apiHeaderAppId;
                String apiHeaderState = '';
                String apiHeaderCity = '';
                String apiHeaderZipCode = '';
                String apiHeaderPOIType = '';
                String apiHeaderSearchRadius = '';
                String apiHeaderSearchPoiId = '';
                if(leadrec.State != null && leadrec.State != ''){
                    apiHeaderState = leadrec.State;
                }
                apiHeaderParam += '&State='+apiHeaderState;
                if(leadrec.postalCode != null && leadrec.postalCode != ''){
                    apiHeaderZipCode = leadrec.postalCode;
                }
                apiHeaderParam += '&ZipCode='+apiHeaderZipCode;
                if(leadrec.Division_CD__c != null && leadrec.Division_CD__c != ''){
                    apiHeaderPOIType = leadrec.Division_CD__c;
                }
                apiHeaderParam += '&POIType='+apiHeaderPOIType;
                if(ppoi.size() > 0 && ppoi.containsKey(leadrec.Division_CD__c)){
                    apiHeaderSearchRadius = ppoi.get(leadrec.Division_CD__c);
                }
                apiHeaderParam += '&SearchRadius='+apiHeaderSearchRadius;
                if(leadrec.PreferredDealerNumber_NUM__c != null && leadrec.PreferredDealerNumber_NUM__c != ''){
                    //apiHeaderSearchPoiId = leadrec.PreferredDealerNumber_NUM__c;
                    apiHeaderSearchPoiId = '';
                }
                
                //for bev - Bijay-07/28/2023 filter modified for GM
                if(leadrec.Fuel_Type_Code__c=='E'){
                    apiHeaderParam += '&NumberOfPOIs=1&Filters=01%26GM&ShowAllAttributes=False&ShowAllProperties=False&ShowAllDepartments=False&Output=json';
                }
                else{
                    apiHeaderParam += '&NumberOfPOIs=1&Filters=01&ShowAllAttributes=False&ShowAllProperties=False&ShowAllDepartments=False&Output=json';
                }
                
                //apiHeaderParam += '&NumberOfPOIs=1&Filters=01&ShowAllAttributes=False&ShowAllProperties=False&ShowAllDepartments=False&Output=json';
                apiHeaderParam += '&POIId='+apiHeaderSearchPoiId;
                if(leadrec.City != null && leadrec.City != ''){
                    apiHeaderCity = leadrec.City;
                }
                apiHeaderParam += '&City='+apiHeaderCity;
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
                String jsonResponse = '';
                if(res.getBody() != null && res.getStatusCode() == 200){
                    //System.debug('Inside response');
                    //jsonResponse = res.getBody();
                    JSONParser parser = JSON.createParser(res.getBody());
                    //System.debug('parser : '+parser);
                    while (parser.nextToken() != null) {
                        if(parser.getCurrentName() == 'POIId' && parser.getText() != '' && parser.getText() !='POIId'){
                            //System.debug('POIID : '+parser.getText());
                            if(leadIdToUpdate.size() == 0){
                                leadIdToUpdate.add(leadrec.Id);
                            	leadrec.PreferredDealerNumber_NUM__c = parser.getText();
                                leadrec.Dealer_Assignment_Type__c = 'Proximity';
                                leadrec.Is_Location_Enrichment_Done__c = true;
                            	leadListToUpdate.add(leadrec);    
                            }
                            else if(!leadIdToUpdate.contains(leadrec.Id)){
                                leadIdToUpdate.add(leadrec.Id);
                            	leadrec.PreferredDealerNumber_NUM__c = parser.getText();
                                leadrec.Dealer_Assignment_Type__c = 'Proximity';
                                leadrec.Is_Location_Enrichment_Done__c = true;
                            	leadListToUpdate.add(leadrec);    
                            }
                            break;
                        }   
                    }
                }
            }
            if(leadListToUpdate.size() > 0){
                update leadListToUpdate;
            }
        }Catch(Exception ex){
        	//System.debug('Exception at line : '+ ex.getLineNumber());
            //System.debug('Exception Message : '+ ex.getMessage());
        }
    }
}