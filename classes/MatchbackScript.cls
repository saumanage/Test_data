global class MatchbackScript implements Database.Batchable<sObject>,Database.Stateful,Schedulable{

    String query;
    global Integer matchtodlr = 0;
    global Integer matchtoOthdlr = 0;
    global Integer enmatch = 0;
    global Integer enmatchto = 0;
    global Integer totalsize = 0;
    global Integer saleschecktrue = 0;
    global String extquery = '';
    
    global MatchbackScript(String qr){
        extquery = qr;
    }
    global Database.QueryLocator start(Database.BatchableContext BC) {
       
        List<string> MatchbackMdt = new List<string>();
        for(Matchback_MDT__mdt matchMdt:[SELECT Status_Code_MDT__c  from Matchback_MDT__mdt]){
            MatchbackMdt.add(matchMdt.Status_Code_MDT__c);
        }
       
        String whereCondition = '(Customer_First_Name_NUM__c!=null or Customer_Last_Name_NM__c != null) and (Dealer_Number_NUM__c != null and Sales_Date_DT__c !=null and XPROD_DIV_CD__c !=null) and (isProcessed__c = false and Status_Code_CD__c IN:MatchbackMdt) and (Email_id_TXT__c != null or Telephone_Number_NUM__c !=null or Customer_Address_ZIP_Code_TXT__c!=null)  '+ extquery;
        query = 'Select Id,Name,Dealer_Number_NUM__c,isUnwind__c,Customer_First_Name_NUM__c,Customer_Last_Name_NM__c,isProcessed__c,XPROD_DIV_CD__c,Status_Code_CD__c,Auto_VIN_Status_Code__c,Sales_Date_DT__c,Telephone_Number_NUM__c,Email_id_TXT__c,Customer_Address_TXT__c,Vin_TXT__c,Serial_Number_NUM__c,State_Code_CD__c,Customer_Street_Address_TXT__c,Customer_Address_ZIP_Code_TXT__c,Customer_City_TXT__c from RDR_Sales__c where' +whereCondition;
        
        System.debug('query : '+query);
        return Database.getQueryLocator(query);    
    }
    
    global void execute(Database.BatchableContext BC,  List<RDR_Sales__c> rdsList) {
        System.debug('rdsList : '+rdsList.size());
        totalsize = totalsize+rdsList.size();
        set<string>fname = new set<string>();
        set<string>lname = new set<string>();
        set<string>EmailS = new set<string>();
        set<string>PhoneS = new set<string>();
        set<string>zipcodes = new set<string>();
        set<string>divisionset = new set<string>();
        set<string>VinNumbers = new set<string>();
        set<string> contactKeys = new set<string>();
       
        List<Opportunity> UpdateoppBackList = new List<Opportunity>();
        List<RDR_Sales__c> unmRdrList= new List<RDR_Sales__c>();
        
        for(RDR_Sales__c rdr:rdsList){
            
            if(rdr.Customer_First_Name_NUM__c != null){
                fname.add(rdr.Customer_First_Name_NUM__c);
            }
            if(rdr.Customer_Last_Name_NM__c != null){
                lname.add(rdr.Customer_Last_Name_NM__c );
            }
            if(rdr.Email_id_TXT__c != null){
                EmailS.add(rdr.Email_id_TXT__c );
            }
            if(rdr.Telephone_Number_NUM__c != null){
                PhoneS.add(rdr.Telephone_Number_NUM__c );
            }
            if(rdr.Customer_Address_ZIP_Code_TXT__c != null){
                zipcodes.add(rdr.Customer_Address_ZIP_Code_TXT__c );
            }
            if(rdr.Vin_TXT__c != null){
                VinNumbers.add(rdr.Vin_TXT__c );
            }
            if(rdr.XPROD_DIV_CD__c != null){
                divisionset.add(rdr.XPROD_DIV_CD__c );
            }
            
        }
       
        List<Opportunity> oppBackList = [Select Name,First_Name_TXT__c,Last_Name_TXT__c,Phone__c,Email__c,ZipCode_TXT__c,Division_CD__c,Sale_Confirmation__c,Matchback_Date__c,PreferredDealerNumber_NUM__c,Address_TXT__c,Number_NM__c,Serial_Number__c,CreatedDate,ContactKey_TXT__c,State_TXT__c ,City_TXT__c ,Street_TXT__c 
                                           from Opportunity 
                           where (First_Name_TXT__c IN: fname or Last_Name_TXT__c IN: lname) and Division_CD__c IN:divisionset and (Email__c IN: EmailS or Phone__c IN: PhoneS or ZipCode_TXT__c IN: zipcodes or Number_NM__c IN:VinNumbers ) ]; 

        system.debug('oppBackList######'+oppBackList.size());
        list<Matchback__c> matchBackList = new list <Matchback__c>();
        list<Matchback__c> matchBackToList = new list <Matchback__c>();
        Map<id,list<opportunity>> mapidvsopp= new Map<id,list<opportunity>>();
        List<RDR_Sales__c> lsttoupdaterdr= new List<RDR_Sales__c>();
        List<Matchback__c> lstInsertMb = new List<Matchback__c>();

        List<Matchback_MDT__mdt > MatchbackMdt = [SELECT Id,Division__c,Status_Code_MDT__c,Subdivision__c  from Matchback_MDT__mdt];
        Map<string,string> matchbackMap = new  Map<string,string>();
        for(Matchback_MDT__mdt M:MatchbackMdt){
            matchbackMap.put(M.Division__c,M.Status_Code_MDT__c);
        }
        
        for(RDR_Sales__c objrds : rdsList){
                boolean isFlag =false;
                mapidvsopp.put(objrds.id,new list<opportunity>{});
                
            for(Opportunity opp : oppBackList){

                 if(
                
                        (
                            (
                                (objrds.Status_Code_CD__c == matchbackMap.get(opp.Division_CD__c)) && objrds.Sales_Date_DT__c != null
                            ) 
                            &&
                            (
                                (
                                    objrds.Customer_First_Name_NUM__c !=null 
                                    && objrds.Customer_First_Name_NUM__c.tolowercase() == opp.First_Name_TXT__c.tolowercase() 
                                    &&   objrds.XPROD_DIV_CD__c == opp.Division_CD__c 
                                    && objrds.XPROD_DIV_CD__c!=null 
                                    && objrds.Sales_Date_DT__c!= Null
                                )
                                ||
                                (
                                    objrds.Customer_Last_Name_NM__c!=null 
                                    && objrds.Customer_Last_Name_NM__c.tolowercase() == opp.Last_Name_TXT__c.tolowercase() 
                                    &&  objrds.XPROD_DIV_CD__c == opp.Division_CD__c 
                                    && objrds.XPROD_DIV_CD__c!=null 
                                    && objrds.Sales_Date_DT__c!= Null 
                                )
                            )
                        )
                        &&
                        (
                            (
                                opp.Phone__c!=null  
                                && opp.Phone__c == objrds.Telephone_Number_NUM__c 
                            )
                            ||
                            (
                                objrds.Customer_First_Name_NUM__c !=null 
                                && objrds.Customer_First_Name_NUM__c.tolowercase() == opp.First_Name_TXT__c.tolowercase()
                                && objrds.Customer_Last_Name_NM__c!=null 
                                && objrds.Customer_Last_Name_NM__c.tolowercase() ==  opp.Last_Name_TXT__c.tolowercase() 
                                && opp.ZipCode_TXT__c!=null 
                                && opp.ZipCode_TXT__c == objrds.Customer_Address_ZIP_Code_TXT__c
                            )
                            ||
                                (opp.Email__c!=null && opp.Email__c == objrds.Email_id_TXT__c) 
                            || 
                            (
                                opp.Street_TXT__c != null 
                                && opp.ZipCode_TXT__c != null 
                                && opp.City_TXT__c != null 
                                && opp.State_TXT__c != null 
                                && objrds.Customer_Street_Address_TXT__c == opp.Street_TXT__c 
                                && objrds.Customer_Address_ZIP_Code_TXT__c == opp.ZipCode_TXT__c 
                                && objrds.Customer_City_TXT__c == opp.City_TXT__c 
                                && objrds.State_Code_CD__c == opp.State_TXT__c
                            )
                            || 
                            (
                                (opp.Number_NM__c!=null  && opp.Number_NM__c == objrds.Vin_TXT__c )
                                ||
                                (opp.Serial_Number__c!=null && opp.Serial_Number__c == objrds.Serial_Number_NUM__c)
                            )
                        )
                    )
                    
                    {

                        System.debug('Sale_Confirmation__c#########'+opp.id);
                       
                        if(opp.PreferredDealerNumber_NUM__c == objrds.Dealer_Number_NUM__c && opp.Sale_Confirmation__c != true && objrds.isProcessed__c == false){
                           
                            Matchback__c MB = new Matchback__c();
                            MB.Opportunity__c = opp.Id;
                            MB.RDR_Sales__c = objrds.Id;
                            MB.Matchback_Date__c = objrds.Sales_Date_DT__c;
                            MB.Matchback_Status__c = 'Matched to Dealer';
                            matchBackList.add(MB);
                            
                            opp.Sale_Confirmation__c = true;
                            if(objrds.Sales_Date_DT__c!=null)
                                opp.Matchback_Date__c = objrds.Sales_Date_DT__c.addDays(1);
                                
                            UpdateoppBackList.add(opp);
                            system.debug('rdr mb  :::::::'+ mb);
                            
                            lstInsertMb.add(MB);
                        }
                        else if(opp.PreferredDealerNumber_NUM__c != objrds.Dealer_Number_NUM__c && opp.Sale_Confirmation__c != true && objrds.isProcessed__c == false){//&& objrds.isProcessed__c == false
                             Matchback__c MB = new Matchback__c();
                             MB.Opportunity__c = opp.Id;
                             MB.RDR_Sales__c = objrds.Id;
                             MB.Matchback_Date__c = objrds.Sales_Date_DT__c;
                             MB.Matchback_Status__c = 'Matched to other Dealer';
                             matchBackToList.add(MB);
                             system.debug('rdr mb to :::::::'+ mb);
                             
                             lstInsertMb.add(MB);
                        }
                  
                    }
                    else if(
            
                        (objrds.Status_Code_CD__c == matchbackMap.get(opp.Division_CD__c)) && objrds.Sales_Date_DT__c != null 
                        &&
                        (
                           (objrds.Customer_First_Name_NUM__c!=null && opp.First_Name_TXT__c!=null && objrds.Customer_First_Name_NUM__c.tolowercase() == opp.First_Name_TXT__c.tolowercase() && objrds.XPROD_DIV_CD__c == opp.Division_CD__c  ) 
                          
                           || 
                           
                           (objrds.Customer_Last_Name_NM__c!=null && opp.Last_Name_TXT__c!=null && objrds.Customer_Last_Name_NM__c.tolowercase() == opp.Last_Name_TXT__c.tolowercase() &&  objrds.XPROD_DIV_CD__c == opp.Division_CD__c )
                        
                           ||
                           
                           (objrds.Customer_First_Name_NUM__c!=null && objrds.Customer_Last_Name_NM__c!=null && opp.First_Name_TXT__c!=null  && opp.Last_Name_TXT__c!=null && objrds.Customer_First_Name_NUM__c.tolowercase() == opp.First_Name_TXT__c.tolowercase()  && objrds.Customer_Last_Name_NM__c.tolowercase() ==  opp.Last_Name_TXT__c.tolowercase() &&  opp.ZipCode_TXT__c == objrds.Customer_Address_ZIP_Code_TXT__c &&  objrds.XPROD_DIV_CD__c == opp.Division_CD__c )
                    
                        )
                        
                    )
                    {   
                        if(opp.ContactKey_TXT__c!=null && opp.Sale_Confirmation__c != true && objrds.isProcessed__c == false){
                            contactKeys.add(opp.ContactKey_TXT__c);
                            mapidvsopp.get(objrds.id).add(opp);
                            isFlag = true;
                        }
                        
                    }
                                
            }
            
            if(isFlag==true){
                unmRdrList.add(objrds);
            }
            
            objrds.isProcessed__c = true;
            lsttoupdaterdr.add(objrds);
        }
        
        system.debug('matchBackList :::'+matchBackList.size());
        system.debug('matchBackToList :::'+matchBackToList.size());
        system.debug('unmRdrList :::'+unmRdrList.size());
        
        
        List<Customer_Enrichment__c> CustomerEncrichmentList = new List<Customer_Enrichment__c>();
        if(contactKeys.size()>0){
            CustomerEncrichmentList=[Select Contact_Key__c,Customer_Account_Id__r.Contact_Key__c,Email__c ,Phone_Number__c,Street__c,Zip_Code__c,City__c,State__c from Customer_Enrichment__c where Customer_Account_Id__r.Contact_Key__c IN:contactKeys AND Customer_Account_Id__r.Contact_Key__c!= NULL];
        }
        
        if(!CustomerEncrichmentList.isEmpty() && !unmRdrList.isEmpty() ){

            for(RDR_Sales__c rdrc : unmRdrList){
                
                if(mapidvsopp.get(rdrc.id)!=null){
                    for(opportunity oppr: mapidvsopp.get(rdrc.id)){
                        for(Customer_Enrichment__c ce : CustomerEncrichmentList){
                            if(
                                (
                                    (ce.Phone_Number__c == rdrc.Telephone_Number_NUM__c && rdrc.Telephone_Number_NUM__c!=null)
                                    ||
                                    (ce.Email__c == rdrc.Email_id_TXT__c && rdrc.Email_id_TXT__c!=null)
                                    ||
                                    (rdrc.Customer_First_Name_NUM__c!=null && rdrc.Customer_Last_Name_NM__c!=null && oppr.First_Name_TXT__c!=null  && oppr.Last_Name_TXT__c!=null && rdrc.Customer_First_Name_NUM__c.tolowercase() == oppr.First_Name_TXT__c.tolowercase()  && rdrc.Customer_Last_Name_NM__c.tolowercase() ==  oppr.Last_Name_TXT__c.tolowercase() && ce.Zip_Code__c == rdrc.Customer_Address_ZIP_Code_TXT__c && rdrc.Customer_Address_ZIP_Code_TXT__c!=null)
                                    ||
                                    (
                                        ce.Street__c == rdrc.Customer_Street_Address_TXT__c && rdrc.Customer_Street_Address_TXT__c!=null
                                        && 
                                        ce.Zip_Code__c == rdrc.Customer_Address_ZIP_Code_TXT__c && rdrc.Customer_Address_ZIP_Code_TXT__c!=null
                                        && 
                                        ce.City__c == rdrc.Customer_City_TXT__c && rdrc.Customer_City_TXT__c!=null
                                        && 
                                        ce.State__c == rdrc.State_Code_CD__c && rdrc.State_Code_CD__c!=null
                                    )
                                )
                            ){
                                
                                if(oppr.ContactKey_TXT__c==ce.Contact_Key__c){
                                    
                                    Matchback__c MB = new Matchback__c();
                                    MB.Opportunity__c = oppr.id;
                                    MB.RDR_Sales__c = rdrc.Id; 
                                    MB.Matchback_Date__c = rdrc.Sales_Date_DT__c;
                                    if(oppr.PreferredDealerNumber_NUM__c==rdrc.Dealer_Number_NUM__c && rdrc.Dealer_Number_NUM__c!=null){
                                        MB.Matchback_Status__c = 'Matched to Dealer';
                                        enmatch = enmatch +1;
                                        
                                        oppr.Sale_Confirmation__c = true;
                                        if(rdrc.Sales_Date_DT__c!=null)
                                            oppr.Matchback_Date__c = rdrc.Sales_Date_DT__c.addDays(1);
                                             
                                        UpdateoppBackList.add(oppr);
                                    }
                                    if(oppr.PreferredDealerNumber_NUM__c!=rdrc.Dealer_Number_NUM__c && rdrc.Dealer_Number_NUM__c!=null){
                                        MB.Matchback_Status__c = 'Matched to Other Dealer';
                                        enmatchto = enmatchto +1;
                                    }
                                    
                                    lstInsertMb.add(MB);
                                    system.debug('en mb::::::::::'+mb);
                                    
                                    break ;
                                }
                            }
                                     
                        }
                    }
                }
            }
        }
        
        
        matchtodlr = matchtodlr+matchBackList.size();
        matchtoOthdlr = matchtoOthdlr+matchBackToList.size();
        
        if(System.Label.MatchbackDate.contains('Allow DML')==true){
            system.debug('::::lstInsertMb::::::::'+lstInsertMb);
            if(lstInsertMb.size()>0){
                insert lstInsertMb;
            }
            if(lsttoupdaterdr.size()>0){
                update lsttoupdaterdr;
            }
            if(UpdateoppBackList.size()>0){
                update UpdateoppBackList;
            }
            system.debug('sucessfully inserted matchback'+' '+lstInsertMb.size());
        }
        
        
        
    }

    global void finish(Database.BatchableContext BC) {
         
         MatchbackCount__c mt = new MatchbackCount__c();
         mt.name = System.Label.MatchbackDate+'  '+ string.valueof(system.now().time());
         mt.Match_To_Dealer__c = matchtodlr;
         mt.Match_To_Other_Dealer__c = matchtoOthdlr;
         mt.Description__c = totalsize+ ' '+' '+enmatch+' '+enmatchto+' '+ saleschecktrue;
         insert mt;
         
        
    }
    global void execute (SchedulableContext sc){
        
    }
}