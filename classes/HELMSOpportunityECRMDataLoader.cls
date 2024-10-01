global with sharing class HELMSOpportunityECRMDataLoader {
   
//Method Start
    public static void loadOpportunityECRMData(Set<id> oppIds){
        try{
            //List<Opportunity> updatedOps = new List<Opportunity>();
            Map<Id,Opportunity> OppswithECRMMap = new Map<id,Opportunity>();
            string SoapXMLBody = '';
            String ContactKey = '';
            Opportunity nOpp = new Opportunity();
            List<Opportunity> listOpps = [Select id, Account.Id From Opportunity where ID IN :oppIds];
            Id currentAcc = listOpps[0].Account.id;
            List<Customer_Enrichment__c> currentCe = [SELECT ID FROM Customer_Enrichment__c where Customer_Account_Id__c = :currentAcc];
            boolean doCE = true;
            if(!currentCe.isEmpty()){
                doCE = false;
            }
            List<Customer_Enrichment__c> newCes = new List<Customer_Enrichment__c>();
            Id custAccountId = null;
            System.debug(oppIds.size());
            Integer count = 0;
            for(Opportunity op : [Select id, Name, Account.Contact_Key__c, Account.Id, StageName, OpportunityStatus_TXT__c, ContactKey_TXT__c From Opportunity where ID IN :oppIds ORDER BY CreatedDate desc]){
                count++;
                nOpp.id = op.Id;
                ContactKey = op.Account.Contact_Key__c;
                custAccountId = op.Account.Id;
                SoapXMLBody = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:head="http://www.honda.com/header" xmlns:con="http://ConsumerProfileMsg"><soapenv:Header><head:hondaMsgHeader><head:messageId>?</head:messageId><head:siteId>?</head:siteId><head:businessId>?</head:businessId><head:collectedTimestamp>?</head:collectedTimestamp></head:hondaMsgHeader></soapenv:Header><soapenv:Body><con:CRMDataReq><con:ContactKey>'+ContactKey+'</con:ContactKey><con:SourceSystem>HELMS</con:SourceSystem></con:CRMDataReq></soapenv:Body></soapenv:Envelope>';
                Http http = new Http(); 
                HttpRequest req = new HttpRequest();
                req.setHeader('Accept', 'application/xml');
                req.setHeader('Content-Type','application/xml;charset=UTF-8');
                req.setMethod('POST');
                req.setEndpoint('callout:Ecrm_Cred_for_Scoring');
                req.setBody(SoapXMLBody);
                req.setTimeout(120000);
                
                String response = '';
                DOM.Document doc=new DOM.Document();
                HttpResponse res = new http().send(req); 
                if (res.getStatusCode() == 200 ) {  
                    response = res.getBody(); 
                    doc.load(response);
                    nOpp.Enrichment_XML_Payload__c = String.valueOf(response);
                    DOM.XmlNode rootNode=doc.getRootElement();
                    DOM.XmlNode body= rootNode.getChildElement('Body', 'http://schemas.xmlsoap.org/soap/envelope/');
                    Dom.XMLNode CRMDataResp = body.getChildElement('CRMDataResp','http://ConsumerProfileMsg');
                    list<string> stlist= new list<string>();     
                    if(CRMDataResp != null){
                        for(Dom.XMLNode crmdata : CRMDataResp.getChildren()) {  
                            for(Dom.XmlNode alldata : crmdata.getchildelements()) {
                                if(alldata.getname()=='Demographics'){
                                    for(Dom.XmlNode demog : alldata.getchildelements()) {
                                        if(demog.getName() == 'Age'  ){
                                            nOpp.DMGR_Age__c = decimal.valueof(demog.getText());
                                        }else if(demog.getName() == 'Children'){
                                            nOpp.DMGR_Children__c = demog.getText();
                                            nOpp.ENR_CI_Children_in_Household__c = demog.getText();
                                        }else if(demog.getName() == 'MaritalStatus'  ){
                                            nOpp.DMGR_Marital_Status__c = demog.getText();
                                        }/*else if(demog.getName() == 'Income'  ){
                                            nOpp.DMGR_Income__c = decimal.valueof(demog.getText());
                                        }*/else if(demog.getName() == 'USTravel'  ){
                                            if(demog.getText() == '1'){
                                                nOpp.DMGR_US_Travel__c = true;
                                            }
                                        }else if(demog.getName() == 'Football'  ){
                                            if(demog.getText() == '1'){
                                                nOpp.DMGR_Football__c = true;	
                                            }
                                            
                                        }else if(demog.getName() == 'Baseball'  ){
                                            if(demog.getText() == '1'){
                                                nOpp.DMGR_Baseball__c = true;
                                            }
                                        }else if(demog.getName() == 'Basketball' ){
                                            if(demog.getText() == '1'){
                                                nOpp.DMGR_Basketball__c = true;
                                            }
                                        }else if(demog.getName() == 'Hockey' ){
                                            if(demog.getText() == '1'){
                                                nOpp.DMGR_Hockey__c = true;
                                            }                                  
                                        }else if(demog.getName() == 'Golf' ){
                                            if(demog.getText() == '1'){
                                                nOpp.DMGR_Golf__c = true;
                                            }
                                        }else if(demog.getName() == 'Skiing' ){
                                            if(demog.getText() == '1'){
                                                nOpp.DMGR_Skiing__c = true;
                                            }
                                        }else if(demog.getName() == 'Photography' ){
                                            if(demog.getText() == '1'){
                                                nOpp.DMGR_Photography__c = true;
                                            }
                                        }else if(demog.getName() == 'HomeOwnerRenter' ){
                                                nOpp.DMGR_Home_Owner_or_Renter__c = demog.getText();
                                        }
                                        else if(demog.getName() == 'HHLDIncomeEstHigherRanges' ){
                                            nOpp.DMGR_Income_Estate_HHLD_Higher_Ranges__c = demog.getText();
                                            nOpp.DMGR_Income__c = demog.getText();
                                        }
                                        else if(demog.getName() == 'GreenLiving' ){
                                            if(demog.getText() == '1'){
                                                nOpp.DMGR_Green_Living__c = true;
                                            }
                                        }else if(demog.getName() == 'EnvironmentalIssues' ){
                                            if(demog.getText() == '1'){
                                                nOpp.DMGR_Environmental_Issues__c = true;
                                            }
                                        }else if(demog.getName() == 'Outdoors' ){
                                            System.debug('Outdoors');
                                            if(demog.getText() == '1'){
                                                nOpp.DMGR_Outdoors__c = true;
                                            }
                                        }else if(demog.getName() == 'HouseholdSize'){
                                           //System.debug('HouseholdSize');
                                            nOpp.DMGR_Household_Size__c = Integer.valueof(demog.getText());
                                        }else if(demog.getName() == 'OccupationDetailed'  ){
                                            nOpp.DMGR_Occupation_Detailed__c = demog.getText();
                                        }else if(demog.getName() == 'Education'  ){
                                            System.debug('Education');
                                            nOpp.DMGR_Education_Level__c = demog.getText();
                                        }else if(demog.getName() == 'Occupation'  ){
                                            System.debug('Occupation');
                                            nOpp.DMGR_Occupation__c = demog.getText();
                                        }else if(demog.getName() == 'VehicleKnownOwnedNumber'  ){
                                            if(Integer.valueOf(demog.getText()) > 0){
                                                nOpp.DMGR_Vehicle_Known_Owned__c = true;
                                            }
                                        }
                                    }
                                }
                                else if(alldata.getName() == 'Enrichment'){
                                    Map<String, List<String>> vinToCar = new Map<String, List<String>>();
                                    for(Dom.XmlNode enrich : alldata.getchildelements()){
                                        if(enrich.getName() == 'CustomerInsights'){
                                            for(Dom.XmlNode custIn : enrich.getchildelements()){
                                                if(custIn.getName() == 'PurchaseScore'){
                                                    for(Dom.XmlNode pScore : custIn.getchildelements()){
                                                        if(pScore.getName() == 'AcuraScore' && pScore.getText() != null){
                                                            nOpp.ENR_Likeliness_to_Buy_Acura__c = pScore.getText();
                                                            nOpp.ENR_CI_Likely_to_Buy_Acura__c = pScore.getText();
                                                        }
                                                        else if(pScore.getName() == 'HondaScore' && pScore.getText() != null){
                                                            nOpp.ENR_Likeliness_to_Buy_Honda__c = pScore.getText();
                                                            nOpp.ENR_CI_Likely_to_Buy_Honda__c = pScore.getText();
                                                        }
                                                        else if(pScore.getName() == 'PSPScore'){
                                                            Integer averageScore = 0;
                                                            for(DOM.XmlNode pspscore : pScore.getchildelements()){
                                                                
                                                                if(pspscore.getName() ==  'Trail' && pspscore.getText() != null){
                                                                    averageScore += Integer.valueOf(pspscore.getText());
                                                                }
                                                                else if(pspscore.getName() == 'Competition' && pspscore.getText() != null){
                                                                    averageScore += Integer.valueOf(pspscore.getText());
                                                                }
                                                                else if(pspscore.getName() == 'Adventure' && pspscore.getText() != null){
                                                                    averageScore += Integer.valueOf(pspscore.getText());
                                                                }
                                                                else if(pspscore.getName() == 'DualSport' && pspscore.getText() != null){
                                                                    averageScore += Integer.valueOf(pspscore.getText());
                                                                }
                                                            }
                                                            if(averageScore != 0){
                                                                averageScore = averageScore/4;
                                                                nOpp.ENR_Likeliness_to_Buy_PSP__c = String.valueOf(averageScore);
                                                                nOpp.ENR_CI_Likely_to_Buy_PSP__c = String.valueOf(averageScore);
                                                            }
                                                        }
                                                    }
                                                }
                                                else if(custIn.getName() == 'EventsAttended' && custIn.getText() != null){
                                                    nOpp.ENR_CI_Event_Attendance__c = custIn.getText() + ' Honda Events Attended in the Past 5 years.';
                                                }
                                            }
                                        }
                                        else if(enrich.getName() == 'OwnershipHistory'){
                                            Map<String, List<Integer>> makeToNumber = new Map<String, List<Integer>>();
                                            makeToNumber.put('Honda', new List<Integer>{0,0});
                                            makeToNumber.put('Acura', new List<Integer>{0,0});
                                            String currentOwn = 'Current Vehicles:' + '\n';
                                            String formerOwn = 'Former Vehicles:' + '\n';
                                            String listSalesDealNo = '';
                                            String listServiceDealNo = '';
                                            String preferedDealerNo = '';
                                            String mostRecentPurchase = '';
                                            Integer formerCount = 0;
                                            Integer currentCount = 0;
                                            Integer hCount = 0;
                                            Integer aCount = 0;
                                            //System.debug('In Ownership hiSTORY');
                                            Boolean ownerType = false;
                                            for(Dom.XmlNode ownHist : enrich.getchildelements()){
                                                if(ownHist.getName() == 'OwnershipProduct'){
                                                    String VIN = '';
                                                    String PurchaseDate = '';
                                                    String Year = '';
                                                    String Make = '';
                                                    String ModelMarketingName = '';
                                                    String DisposedOn = '';
                                                    String SalesDealerNumber = '';
                                                    String ServiceDealerNumber = '';
                                                    for(Dom.XmlNode prod : ownHist.getchildelements()){
                                                        if(prod.getName() == 'VIN'){
                                                            VIN = prod.getText();
                                                        }
                                                        else if(prod.getName() == 'CurrentOwner'){
                                                            if(prod.getText() =='N'){
                                                                ownerType = false;
                                                                formerCount++;
                                                            }
                                                            else if(prod.getText() == 'Y'){
                                                                ownerType = true;
                                                                currentCount++;
                                                            }
                                                        }
                                                        else if(prod.getName() == 'PurchaseDate'){
                                                            PurchaseDate = prod.getText();
                                                            if(mostRecentPurchase == ''){
                                                                mostRecentPurchase = prod.getText();
                                                            }
                                                        }
                                                        else if(prod.getName() == 'Year'){
                                                            Year = prod.getText();
                                                        }
                                                        else if(prod.getName() == 'Make'){
                                                            Make = prod.getText();
                                                            if(Make == 'Honda')hCount++;
                                                            else if(Make == 'Acura')aCount++;
                                                            if(ownerType){
                                                                makeToNumber.get(Make)[0]++;
                                                            }else{
                                                                makeToNumber.get(Make)[1]++;
                                                            }
                                                            //Will the make for a Powersport and Power Equipment vehicle just say Powersport or Power Equipment
                                                        }
                                                        else if(prod.getName() == 'ModelMarketingName'){
                                                            ModelMarketingName = prod.getText();
                                                        }
                                                        else if(prod.getName() == 'DisposedOn'){
                                                            DisposedOn = prod.getText();
                                                        }
                                                        else if(prod.getName() == 'SalesDealerNo'){
                                                                SalesDealerNumber = prod.getText(); 
                                                        }
                                                        else if(prod.getName() == 'VINAssignedServiceDealerNo'){
                                                                ServiceDealerNumber = prod.getText();
                                                        }
                                                    }
                                                    if(ownerType != null){
                                                        if(ownerType){
                                                            currentOwn = currentOwn + String.valueOf(currentCount) + '#: '
                                                                + Year + ' ' +  Make + ' ' +ModelMarketingName + '\n';
                                                        }
                                                        else{
                                                            formerOwn = formerOwn + String.valueOf(formerCount) + '#: '
                                                                + Year + ' ' +  Make + ' ' + ModelMarketingName +
                                                                ', Acquistion Date: ' + PurchaseDate + ', Disposed on ' +
                                                                DisposedOn + ', VIN: ' + VIN + '\n';
                                                        }
                                                    }
                                                    listSalesDealNo = listSalesDealNo + SalesDealerNumber + ',';
                                                    listServiceDealNo = listServiceDealNo + ServiceDealerNumber + ',';
                                                    //Date pd = date.valueOf(String.valueOf(PurchaseDate));
                                                    //date mpd = date.valueOf(String.valueOf(mostRecentPurchase));
                                                    if(PurchaseDate > mostRecentPurchase){
                                                           mostRecentPurchase = PurchaseDate;
                                                           if(SalesDealerNumber != ''){
                                                               preferedDealerNo = SalesDealerNumber;
                                                           }
                                                           else if(ServiceDealerNumber != ''){
                                                               preferedDealerNo = ServiceDealerNumber;
                                                           }
                                                    }
                                                    
                                                    vinToCar.put(VIN, new List<String>{Year, Make, ModelMarketingName});
                                                }
                                            }
                                            nOpp.ENR_Acura_Vehicles_Owned__c = aCount;
                                            nOpp.ENR_Honda_Vehicles_Owned__c = hCount;
                                            //still need these two fields le.ENR_Power_Sports_Vehicles_Owned__c le.ENR_Power_Equipment_Vehicles_Owned__c
                                            nOpp.ENR_CI_Ownership_Details__c = currentOwn + '\n' + formerOwn;
                                            if(currentCount > 0){
                                                nOpp.ENR_Ownership_Type__c = 'Current Owner';
                                            }
                                            else if(currentCount == 0 && formerCount > 0){
                                                nOpp.ENR_Ownership_Type__c = 'Former Owner';
                                            }
                                            String ownership = '';
                                            if(makeToNumber.get('Honda')[0] != 0 && makeToNumber.get('Honda')[1] == 0){
                                                ownership = ownership + 'Customer has ' + makeToNumber.get('Honda')[0] + ' current Honda vehicles. ' + '\n';
                                            }else if(makeToNumber.get('Honda')[0] == 0 && makeToNumber.get('Honda')[1] != 0){
                                                ownership = ownership + 'Customer has ' + makeToNumber.get('Honda')[1] + ' former Honda vehicles. '  + '\n'; 
                                            }else if(makeToNumber.get('Honda')[0] != 0 && makeToNumber.get('Honda')[1] != 0){
                                                ownership = ownership + 'Customer has ' + makeToNumber.get('Honda')[0] + ' current and ' + makeToNumber.get('Honda')[1] + ' former Honda vehicles.' + '\n';
                                            }
                                            if(makeToNumber.get('Acura')[0] != 0 && makeToNumber.get('Acura')[1] == 0){
                                                ownership = ownership + 'Customer has ' + makeToNumber.get('Acura')[0] + ' current Acura vehicles. ' + '\n';
                                            }else if(makeToNumber.get('Acura')[0] == 0 && makeToNumber.get('Acura')[1] != 0){
                                                ownership = ownership + 'Customer has ' + makeToNumber.get('Acura')[1] + ' former Acura vehicles. '  + '\n'; 
                                            }else if(makeToNumber.get('Acura')[0] != 0 && makeToNumber.get('Acura')[1] != 0){
                                                ownership = ownership + 'Customer has ' + makeToNumber.get('Acura')[0] + ' current vehicles and ' + makeToNumber.get('Acura')[1] + ' former Acura vehicles.' + '\n';
                                            }
                                            nOpp.ENR_CI_Ownership__c = ownership;
                                            nOpp.SalesRelatedDealerNumber__c = listSalesDealNo;
                                            nOpp.ServiceRelatedDealerNumber__c = listServiceDealNo;
                                            /*if(doPDealer){
                                                nOpp.PreferredDealerNumber_NUM__c = preferedDealerNo;
                                            }*/
                                        }
                                        else if(enrich.getName() == 'ServiceHistoryLast5Years'){
                                            String service = '';
                                            Double totalCustomerPayed = 0;
                                            Double totalWarrantyPayed = 0;
                                            Integer prodCount = 0;
                                            for(DOM.XmlNode servHist : enrich.getchildelements()){
                                                if(servHist.getName() == 'ServicedProduct'){
                                                    String Year = '';
                                                    String Make = '';
                                                    String ModelMarketingName = '';
                                                    Double customerPayed = 0;
                                                    Double warrantyPayed = 0;
                                                    Integer warrantyCount = 0;
                                                    Integer customerCount = 0;
                                                    prodCount++;
                                                    for(DOM.XmlNode prod : servHist.getchildelements()){
                                                        if(prod.getName() == 'Year'){
                                                            Year = prod.getText();
                                                        }
                                                        else if(prod.getName() == 'Make'){
                                                            Make = prod.getText();
                                                        }
                                                        else if(prod.getName() == 'ModelMarketingName'){
                                                            ModelMarketingName = prod.getText();
                                                        }
                                                        else if(prod.getName() == 'RepairOrders'){
                                                            //System.debug('RepairOrders');
                                                            for(DOM.XmlNode rOrders : prod.getchildelements()){
                                                                if(rOrders.getName() == 'RepairOrder'){
                                                                    Double holdAmount = 0;
                                                                    //System.debug('RepairOrder');
                                                                    for(DOM.XmlNode rOrder : rOrders.getchildelements()){
                                                                        
                                                                        if(rOrder.getName() == 'RepairOrderAmount'){
                                                                            holdAmount = Double.valueOf(rOrder.getText());
                                                                            //System.debug(holdAmount);
                                                                        }
                                                                        else if(rOrder.getName() == 'ServicePayType'){
                                                                            if(rOrder.getText() == 'WARRANTY'){
                                                                                warrantyCount++;
                                                                                warrantyPayed += holdAmount;
                                                                                //System.debug(warrantyPayed);
                                                                                //System.debug(holdAmount);
                                                                            }
                                                                            else if(rOrder.getText() == 'CUSTOMER PAY'){
                                                                                customerCount++;
                                                                                customerPayed += holdAmount;
                                                                                //System.debug(customerPayed);
                                                                                //System.debug(holdAmount);
                                                                            }
                                                                        }
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    }
                                                    service = service + String.valueOf(prodCount) + '#: ' + Year + ' ' + Make + ' ' + ModelMarketingName + ' : ' +  
                                                        String.valueOf(customerCount) + ' Customer paid service items with an out of pocket expense $' +
                                                        String.valueOf(customerPayed) + '. ' + String.valueOf(warrantyCount) + ' total Honda paid service items: ' +
                                                        String.valueOf(warrantyCount) + '  Warranty paid items.' + '\n' + '\n';
                                                    totalCustomerPayed += customerPayed;
                                                    totalWarrantyPayed += warrantyPayed;
                                                }
                                            }
                                            nOpp.ENR_CI_Service_History__c = service;
                                            nOpp.ENR_Total_Spent_on_Service_by_Customer__c = totalCustomerPayed;
                                            nOpp.ENR_Total_Spent_on_Service_by_Warranty__c = totalWarrantyPayed; 
                                        }
                                        else if(enrich.getName() == 'CustomerExtendedWarrantyInsights'){
                                            //nOpp.ENR_Extended_Warranty_Contract__c = true;
                                            String warranty = '';
                                            Integer prodCount = 0;
                                            for(Dom.XmlNode cewi : enrich.getchildelements()){
                                                if(cewi.getName() == 'Product'){
                                                    prodCount++;
                                                    String Year = '';
                                                    String Make = '';
                                                    String ModelMarketingName = '';
                                                    String VIN = '';
                                                    String expDate = '';
                                                    String expMiles = '';
                                                    for(Dom.XmlNode prod : cewi.getchildelements()){
                                                        if(prod.getName() == 'VIN'){
                                                            if(!vinToCar.isEmpty() && vinToCar.get(prod.getText()) != null){
                                                                Year = vinToCar.get(prod.getText())[0];
                                                                Make = vinToCar.get(prod.getText())[1];
                                                                ModelMarketingName = vinToCar.get(prod.getText())[2];
                                                            }
                                                        }
                                                        else if(prod.getName() == 'ExpiryDate'){
                                                            expDate = prod.getText();
                                                        }
                                                        else if(prod.getName() == 'ExpiryMiles'){
                                                            expMiles = prod.getText();
                                                        }
                                                    }
                                                    warranty = warranty + String.valueOf(prodCount) + '#: ' + Year + ' ' + Make + ' ' + ModelMarketingName 
                                                        + ' Expires on ' + expDate + ' or ' + expMiles + ' Miles' + '\n';
                                                }
                                            }
                                            if(warranty != ''){
                                                nOpp.ENR_Extended_Warranty_Contract__c = true; 
                                            }
                                            nOpp.ENR_CI_Extended_Warranty__c = warranty;
                                        } 
                                    }
                                }
                                else if(alldata.getName() == 'Matchback'){
                                    System.debug('MBack');
                                    if(doCE){
                                        for(Dom.XmlNode mBack : alldata.getchildelements()){
                                            if(mBack.getName() == 'Email'){
                                                for(DOM.XmlNode email : mBack.getchildelements()){
                                                    if(email.getName() == 'CustomerEmail'){
                                                        Customer_Enrichment__c nCE = new Customer_Enrichment__c();
                                                        nCE.Email__c = email.getText();
                                                        nCE.AK_Customer_Enrichment__c = email.getText() + custAccountId;
                                                        nCE.Customer_Account_Id__c = custAccountId;
                                                        nCE.RecordTypeId = Schema.SObjectType.Customer_Enrichment__c.getRecordTypeInfosByDeveloperName()
                                                            .get('Email').getRecordTypeId();
                                                        System.debug(nCE);
                                                        newCes.add(nCE);
                                                    }
                                                }
                                            }
                                            else if(mBack.getName() == 'Phone'){
                                                //Integer phoneCounter = 0;
                                                //List<String> phones = new List<String>();
                                                for(DOM.XmlNode phone : mBack.getchildelements()){
                                                    if(phone.getName() == 'CustomerPhone'){
                                                        //phoneCounter++;
                                                        //phones.add(phone.getText());
                                                        Customer_Enrichment__c nCE = new Customer_Enrichment__c();
                                                        nCE.Phone_Number__c = phone.getText();
                                                        nCE.AK_Customer_Enrichment__c = phone.getText() + custAccountId;
                                                        nCE.Customer_Account_Id__c = custAccountId;
                                                        nCE.RecordTypeId = Schema.SObjectType.Customer_Enrichment__c.getRecordTypeInfosByDeveloperName()
                                                            .get('Phone').getRecordTypeId();
                                                        System.debug(nCE);
                                                        newCes.add(nCE);
                                                    }
                                                }
                                            }
                                            else if(mBack.getName() == 'Address'){
                                                List<String> custAdds = new List<String>();
                                                for(DOM.XmlNode address : mBack.getchildelements()){
                                                    if(address.getName() == 'CustAddress'){
                                                        //String custA = '';
                                                        String partAk = '';
                                                        Customer_Enrichment__c nCE = new Customer_Enrichment__c();
                                                        for(Dom.XmlNode cAddress : address.getchildelements()){
                                                            if(cAddress.getName() == 'CustomerAddress'){
                                                                nCE.Street__c = cAddress.getText();
                                                            }
                                                            if(cAddress.getName() == 'City'){
                                                                nCE.City__c = cAddress.getText();
                                                            }
                                                            if(cAddress.getName() == 'State'){
                                                                nCE.State__c = cAddress.getText();
                                                            }
                                                            if(cAddress.getName() == 'Zipcode'){
                                                                nCE.Zip_Code__c = cAddress.getText();
                                                                partAk = cAddress.getText();
                                                            }
                                                        }
                                                        //nCE.Address__c = custA;
                                                        nCE.AK_Customer_Enrichment__c = partAk + custAccountId;
                                                        nCE.Customer_Account_Id__c = custAccountId;
                                                        nCE.RecordTypeId = Schema.SObjectType.Customer_Enrichment__c.getRecordTypeInfosByDeveloperName()
                                                            .get('Address').getRecordTypeId();
                                                        System.debug(nCE);
                                                        newCes.add(nCE);
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }//end of all data loop
                        }//end of first loop of crm data
                    }//end of crm dataresp if statement
                    //updatedOps.add(nOpp);
                    //System.debug(updatedOps);
                    System.debug(nOpp);
                    if(!OppswithECRMMap.containsKey(nOpp.id)){
                        OppswithECRMMap.put(nOpp.Id, nOpp);
                    }
                    
                }
            }
            System.debug(OppswithECRMMap.size() + ' ' + count);
            
            if(!OppswithECRMMap.isEmpty()){
                //OppswithECRMMap.putAll(updatedOps);
                //System.debug(OppswithECRMMap.size());
                update OppswithECRMMap.values();
                //Database.update(updatedOps, false);
            }
            if(!newCes.isEmpty()){
                Database.insert(newCes, false);
            }
        }
        catch(Exception e){
            Logs__c  l =new Logs__c (name='ECRM Opportunity Data Load',Trigger_or_Class_Name__c='HELMSOpportunityECRMDataLoader', Error_Message__c =e.getMessage(), Error_Line_Number__c =Integer.valueOf(string.valueof(e.getLineNumber() )) );
           	insert l;
        }
    }
}