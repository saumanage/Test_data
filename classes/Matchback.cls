/**
 * Apex Class Name : Matchback
 * Wrriten By : Syam
 
 */
global class Matchback implements Database.Batchable<sObject>,Database.Stateful,Schedulable{
    String query;   
    global Matchback(){}
    
     // collect the batches of records or objects to be passed to execute
    global Database.QueryLocator start(Database.BatchableContext BC) {
        String ndays = Label.N_days;
        List<string> matchbackMdt1 = new List<string>();
        List<string> unwindMdt2 = new List<string>();
        for(Matchback_MDT__mdt matchMdt:[SELECT Status_Code_MDT__c  from Matchback_MDT__mdt]){
            matchbackMdt1.add(matchMdt.Status_Code_MDT__c);
        }
        for(HELMS_UN_WIND__mdt unwindMdt:[SELECT Status_Code_MDT__c,Status_Code_MDT2__c  from HELMS_UN_WIND__mdt]){
            unwindMdt2.add(unwindMdt.Status_Code_MDT2__c);
        }
       
        String whereCondition = '(Customer_First_Name_NUM__c!=null or Customer_Last_Name_NM__c != null) and (Dealer_Number_NUM__c != null and Sales_Date_DT__c !=null and XPROD_DIV_CD__c !=null) and ((isProcessed__c = false and Status_Code_CD__c IN:matchbackMdt1) or (isUnwind__c=false and  Status_Code_CD__c IN:unwindMdt2)) and (Email_id_TXT__c != null or Telephone_Number_NUM__c !=null or Customer_Address_ZIP_Code_TXT__c!=null)  and CreatedDate = LAST_N_DAYS:'+ndays ;
        query = 'Select Id,Name,Dealer_Number_NUM__c,isUnwind__c,Customer_First_Name_NUM__c,Customer_Last_Name_NM__c,isProcessed__c,XPROD_DIV_CD__c,Status_Code_CD__c,Auto_VIN_Status_Code__c,Sales_Date_DT__c,Telephone_Number_NUM__c,Email_id_TXT__c,Customer_Address_TXT__c,Vin_TXT__c,Serial_Number_NUM__c,State_Code_CD__c,Customer_Street_Address_TXT__c,Customer_Address_ZIP_Code_TXT__c,Customer_City_TXT__c from RDR_Sales__c where' +whereCondition;

        System.debug('RDR Query: ' + query);
        
        return Database.getQueryLocator(query);    
    }
     
     // process each batch of records
    global void execute(Database.BatchableContext BC,  List<RDR_Sales__c> rdsList) {
        set<string> fname = new set<string>();
        set<string> lname = new set<string>();
        set<string> emailS = new set<string>();
        set<string> phoneS = new set<string>();
        set<string> zipcodes = new set<string>();
        set<string> serialnos = new set<string>();
        set<string> divisionset = new set<string>();
        set<string> vinNumbers = new set<string>();
        Map<String,Opportunity> opptoContactKeyMatch = new Map<String,Opportunity>();
        Map<String,Opportunity> opptoContactKeyNoMatch = new Map<String,Opportunity>();
        set<Opportunity> updateoppBackList = new set<Opportunity>();
        set<RDR_Sales__c> rdrset = new set<RDR_Sales__c>();
        List<Matchback__c> matchbackDeletelist = new List<Matchback__c>();
        List<Id> molist = new List<Id>();
        
        //prepare some unique set of value to filter query       
        for(RDR_Sales__c rdr:rdsList){
            
            if(rdr.Customer_First_Name_NUM__c != null){
                fname.add(rdr.Customer_First_Name_NUM__c);
            }
            if(rdr.Customer_Last_Name_NM__c != null){
                lname.add(rdr.Customer_Last_Name_NM__c );
            }
            if(rdr.Email_id_TXT__c != null){
                emailS.add(rdr.Email_id_TXT__c );
            }
            if(rdr.Telephone_Number_NUM__c != null){
                phoneS.add(rdr.Telephone_Number_NUM__c );
            }
            if(rdr.Customer_Address_ZIP_Code_TXT__c != null){
                zipcodes.add(rdr.Customer_Address_ZIP_Code_TXT__c );
            }
            if(rdr.Serial_Number_NUM__c != null){
                serialnos.add(rdr.Serial_Number_NUM__c );
            }
            if(rdr.Vin_TXT__c != null){
                vinNumbers.add(rdr.Vin_TXT__c );
            }
            if(rdr.XPROD_DIV_CD__c != null){
                divisionset.add(rdr.XPROD_DIV_CD__c );
            }
            
        }
        //fetch opportunity records 
        List<Opportunity> oppBackList = [Select Name,First_Name_TXT__c,Last_Name_TXT__c,Phone__c,Email__c,ZipCode_TXT__c,Division_CD__c,Sale_Confirmation__c,Matchback_Date__c,PreferredDealerNumber_NUM__c,Address_TXT__c,Number_NM__c,Serial_Number__c,CreatedDate,ContactKey_TXT__c,State_TXT__c ,City_TXT__c ,Street_TXT__c 
                                           from Opportunity 
                                           where (First_Name_TXT__c IN: fname or Last_Name_TXT__c IN: lname) and Division_CD__c IN:divisionset and (Email__c IN: emailS or Phone__c IN: phoneS or ZipCode_TXT__c IN: zipcodes or (Number_NM__c IN:vinNumbers or Serial_Number__c IN:serialnos)) ]; 
       
        System.debug('Opportunity Query: ' + oppBackList);
        
        list<Matchback__c> matchBackList = new list <Matchback__c>();
        //query on custom meta data 
        List<Matchback_MDT__mdt > matchbackMdt = [SELECT Id,Division__c,Status_Code_MDT__c,Subdivision__c  from Matchback_MDT__mdt];
        Map<string,string> matchbackMap = new  Map<string,string>();
        for(Matchback_MDT__mdt M: matchbackMdt){
            matchbackMap.put(M.Division__c,M.Status_Code_MDT__c);
            
        }
        List<HELMS_UN_WIND__mdt> unwindMdt = [SELECT Id,Division__c,Status_Code_MDT__c,SubDivision__c,Status_Code_MDT2__c   from HELMS_UN_WIND__mdt];
        Map<string,string> unwindMap = new  Map<string,string>();
        Map<string,string> unwindMap2 = new  Map<string,string>();
        for(HELMS_UN_WIND__mdt M: unwindMdt){
            unwindMap.put(M.Division__c,M.Status_Code_MDT__c);
            unwindMap2.put(M.Division__c,M.Status_Code_MDT2__c);
        }
        //process rdr records 
        
        for(RDR_Sales__c objrds : rdsList){
                boolean unwindFlag =false;
            for(Opportunity opp : oppBackList){
               
                if((((objrds.Status_Code_CD__c == matchbackMap.get(opp.Division_CD__c)) && objrds.Sales_Date_DT__c != null && (Date.valueOf(opp.CreatedDate.date())).daysBetween(Date.valueOf(objrds.Sales_Date_DT__c)) <= 120 ) &&
                  ((objrds.Customer_First_Name_NUM__c !=null && objrds.Customer_First_Name_NUM__c.tolowercase() == opp.First_Name_TXT__c.tolowercase() &&   objrds.XPROD_DIV_CD__c == opp.Division_CD__c && objrds.XPROD_DIV_CD__c!=null && objrds.Sales_Date_DT__c!= Null)
                  || (objrds.Customer_Last_Name_NM__c!=null && objrds.Customer_Last_Name_NM__c.tolowercase() == opp.Last_Name_TXT__c.tolowercase() &&  objrds.XPROD_DIV_CD__c == opp.Division_CD__c && objrds.XPROD_DIV_CD__c!=null && objrds.Sales_Date_DT__c!= Null )))
                    &&((opp.Phone__c!=null  && opp.Phone__c == objrds.Telephone_Number_NUM__c )
                       ||(objrds.Customer_First_Name_NUM__c !=null && objrds.Customer_First_Name_NUM__c.tolowercase() == opp.First_Name_TXT__c.tolowercase() && objrds.Customer_Last_Name_NM__c!=null && objrds.Customer_Last_Name_NM__c.tolowercase() ==  opp.Last_Name_TXT__c.tolowercase() && opp.ZipCode_TXT__c!=null && opp.ZipCode_TXT__c == objrds.Customer_Address_ZIP_Code_TXT__c)
                    ||(opp.Email__c!=null && opp.Email__c == objrds.Email_id_TXT__c) || (opp.Street_TXT__c != null && opp.ZipCode_TXT__c != null && opp.City_TXT__c != null && opp.State_TXT__c != null && objrds.Customer_Street_Address_TXT__c == opp.Street_TXT__c && objrds.Customer_Address_ZIP_Code_TXT__c == opp.ZipCode_TXT__c && objrds.Customer_City_TXT__c == opp.City_TXT__c && objrds.State_Code_CD__c == opp.State_TXT__c)
                     || ((opp.Number_NM__c!=null  && opp.Number_NM__c == objrds.Vin_TXT__c )
                     || (opp.Serial_Number__c!=null && opp.Serial_Number__c == objrds.Serial_Number_NUM__c))))
                    
                    {
                      
                       if(opp.PreferredDealerNumber_NUM__c == objrds.Dealer_Number_NUM__c && opp.Sale_Confirmation__c != true && objrds.isProcessed__c == false){
                           
                            Matchback__c mB = new Matchback__c();
                            mB.Opportunity__c = opp.Id;
                            mB.RDR_Sales__c = objrds.Id;
                            mB.Matchback_Date__c = objrds.Sales_Date_DT__c;
                            mB.Matchback_Status__c = 'Matched to Dealer';
                            matchBackList.add(mB);
                            opp.Sale_Confirmation__c = true;
                            opp.Matchback_Date__c = objrds.Sales_Date_DT__c.addDays(1);
                            updateoppBackList.add(opp);
                        }
                        else if(opp.PreferredDealerNumber_NUM__c != objrds.Dealer_Number_NUM__c && objrds.isProcessed__c == false){
                             Matchback__c mB = new Matchback__c();
                             mB.Opportunity__c = opp.Id;
                             mB.RDR_Sales__c = objrds.Id;
                             opp.Matchback_Date__c = objrds.Sales_Date_DT__c.addDays(1);
                             mB.Matchback_Date__c = objrds.Sales_Date_DT__c;
                             mB.Matchback_Status__c = 'Matched to other Dealer';
                             matchBackList.add(mB);
                             updateoppBackList.add(opp);
                       }
                        
                  
                    }
                                
                    
                else if((((objrds.Status_Code_CD__c == matchbackMap.get(opp.Division_CD__c)) && objrds.Sales_Date_DT__c != null && (Date.valueOf(opp.CreatedDate.date())).daysBetween(Date.valueOf(objrds.Sales_Date_DT__c)) <= 120 ) &&
                  ((objrds.Customer_First_Name_NUM__c !=null && objrds.Customer_First_Name_NUM__c.tolowercase() == opp.First_Name_TXT__c.tolowercase() &&   objrds.XPROD_DIV_CD__c == opp.Division_CD__c && objrds.XPROD_DIV_CD__c!=null && objrds.Sales_Date_DT__c!= Null)
                   || (objrds.Customer_Last_Name_NM__c!=null && objrds.Customer_Last_Name_NM__c.tolowercase() == opp.Last_Name_TXT__c.tolowercase() &&  objrds.XPROD_DIV_CD__c == opp.Division_CD__c && objrds.XPROD_DIV_CD__c!=null && objrds.Sales_Date_DT__c!= Null )
                   ||(objrds.Customer_First_Name_NUM__c !=null && objrds.Customer_First_Name_NUM__c.tolowercase() == opp.First_Name_TXT__c.tolowercase() && objrds.Customer_Last_Name_NM__c !=null && objrds.Customer_Last_Name_NM__c.tolowercase() ==  opp.Last_Name_TXT__c.tolowercase() && objrds.Customer_Address_ZIP_Code_TXT__c !=null && objrds.XPROD_DIV_CD__c == opp.Division_CD__c && objrds.XPROD_DIV_CD__c!=null && objrds.Sales_Date_DT__c!= Null))
                    && (opp.PreferredDealerNumber_NUM__c == objrds.Dealer_Number_NUM__c && opp.Sale_Confirmation__c != true && objrds.isProcessed__c == false)))
                {

                  opptoContactKeyMatch.put(opp.ContactKey_TXT__c,opp);
                }


                else if((((objrds.Status_Code_CD__c == matchbackMap.get(opp.Division_CD__c)) && objrds.Sales_Date_DT__c != null && (Date.valueOf(opp.CreatedDate.date())).daysBetween(Date.valueOf(objrds.Sales_Date_DT__c)) <= 120 ) &&
                  ((objrds.Customer_First_Name_NUM__c !=null && objrds.Customer_First_Name_NUM__c.tolowercase().contains(opp.First_Name_TXT__c.tolowercase()) &&   objrds.XPROD_DIV_CD__c == opp.Division_CD__c && objrds.XPROD_DIV_CD__c!=null && objrds.Sales_Date_DT__c!= Null)
                   || (objrds.Customer_Last_Name_NM__c!=null && objrds.Customer_Last_Name_NM__c.tolowercase().contains(opp.Last_Name_TXT__c.tolowercase()) &&  objrds.XPROD_DIV_CD__c == opp.Division_CD__c && objrds.XPROD_DIV_CD__c!=null && objrds.Sales_Date_DT__c!= Null )
                    ||(objrds.Customer_First_Name_NUM__c !=null && objrds.Customer_First_Name_NUM__c.tolowercase() == opp.First_Name_TXT__c.tolowercase() && objrds.Customer_Last_Name_NM__c!=null && objrds.Customer_Last_Name_NM__c.tolowercase() ==  opp.Last_Name_TXT__c.tolowercase() && opp.ZipCode_TXT__c!=null && opp.ZipCode_TXT__c == objrds.Customer_Address_ZIP_Code_TXT__c &&  objrds.XPROD_DIV_CD__c == opp.Division_CD__c && objrds.XPROD_DIV_CD__c!=null && objrds.Sales_Date_DT__c!= Null))
                    && (opp.PreferredDealerNumber_NUM__c != objrds.Dealer_Number_NUM__c &&  objrds.isProcessed__c == false)))
                {
                 
                  if(opp.ContactKey_TXT__c!=null)
                    opptoContactKeyNoMatch.put(opp.ContactKey_TXT__c,opp);
                }

                       
               // else if(objrds.Status_Code_CD__c =='02') 
                else if(((( (  (objrds.Status_Code_CD__c == unwindMap.get(opp.Division_CD__c) && objrds.Auto_VIN_Status_Code__c == 'RM1') || (objrds.Status_Code_CD__c == unwindMap2.get(opp.Division_CD__c)) )  &&  objrds.Sales_Date_DT__c != null   &&(Date.valueOf(opp.CreatedDate.date())).daysBetween(Date.valueOf(objrds.Sales_Date_DT__c)) <= 120 ) &&
                  ((objrds.Customer_First_Name_NUM__c !=null && objrds.Customer_First_Name_NUM__c.tolowercase().contains(opp.First_Name_TXT__c.tolowercase()) &&   objrds.XPROD_DIV_CD__c == opp.Division_CD__c && objrds.XPROD_DIV_CD__c!=null && objrds.Sales_Date_DT__c!= Null)
                  || (objrds.Customer_Last_Name_NM__c!=null && objrds.Customer_Last_Name_NM__c.tolowercase().contains(opp.Last_Name_TXT__c.tolowercase()) &&  objrds.XPROD_DIV_CD__c == opp.Division_CD__c && objrds.XPROD_DIV_CD__c!=null && objrds.Sales_Date_DT__c!= Null)))
                    &&((opp.Phone__c!=null  && opp.Phone__c == objrds.Telephone_Number_NUM__c )
                       ||(objrds.Customer_First_Name_NUM__c !=null && objrds.Customer_First_Name_NUM__c.tolowercase() == opp.First_Name_TXT__c.tolowercase() && objrds.Customer_Last_Name_NM__c!=null && objrds.Customer_Last_Name_NM__c.tolowercase() ==  opp.Last_Name_TXT__c.tolowercase() && opp.ZipCode_TXT__c!=null && opp.ZipCode_TXT__c == objrds.Customer_Address_ZIP_Code_TXT__c)
                    ||(opp.Email__c!=null && opp.Email__c == objrds.Email_id_TXT__c) || (opp.Street_TXT__c != null && opp.ZipCode_TXT__c != null && opp.City_TXT__c != null && opp.State_TXT__c != null && objrds.Customer_Street_Address_TXT__c == opp.Street_TXT__c && objrds.Customer_Address_ZIP_Code_TXT__c == opp.ZipCode_TXT__c && objrds.Customer_City_TXT__c == opp.City_TXT__c && objrds.State_Code_CD__c == opp.State_TXT__c)
                     || ((opp.Number_NM__c!=null  && opp.Number_NM__c == objrds.Vin_TXT__c )
                     || (opp.Serial_Number__c!=null && opp.Serial_Number__c == objrds.Serial_Number_NUM__c)))))
                  

                    {

                        if(opp.PreferredDealerNumber_NUM__c == objrds.Dealer_Number_NUM__c && objrds.isUnwind__c == false && objrds.isProcessed__c == true){
                           opp.Sale_Confirmation__c = false;
                           opp.Matchback_Date__c = null;
                          
                        }
                        molist.add(opp.id);
                        unwindFlag = true;
                      
                    }
                    
                
            }
            objrds.isUnwind__c = unwindFlag;
            objrds.isProcessed__c = true;
            rdrset.add(objrds);
                   
        }
        
        List<Customer_Enrichment__c> customerEncrichmentList = new List<Customer_Enrichment__c>();
        List<Customer_Enrichment__c> customerEncrichmentList1 = new List<Customer_Enrichment__c>();
        if(!opptoContactKeyMatch.isEmpty()){

            customerEncrichmentList=[Select Contact_Key__c,Customer_Account_Id__r.Contact_Key__c,Email__c ,Phone_Number__c,Street__c,Zip_Code__c,City__c,State__c from Customer_Enrichment__c where Customer_Account_Id__r.Contact_Key__c IN:opptoContactKeyMatch.keySet() AND Customer_Account_Id__r.Contact_Key__c!= NULL];

        }
        if(!customerEncrichmentList.isEmpty() ){

            for(RDR_Sales__c rdrforContactKeys : rdsList){
                for(Opportunity oppForEnrich :opptoContactKeyMatch.values()){

                    for(Customer_Enrichment__c ce : customerEncrichmentList){
                       if(((ce.Phone_Number__c!=null  && ce.Phone_Number__c == rdrforContactKeys.Telephone_Number_NUM__c )
                        ||(ce.Email__c!=null && ce.Email__c == rdrforContactKeys.Email_id_TXT__c)||(ce.Zip_Code__c != null && ce.Zip_Code__c == rdrforContactKeys.Customer_Address_ZIP_Code_TXT__c && rdrforContactKeys.Customer_Last_Name_NM__c != Null && rdrforContactKeys.Customer_First_Name_NUM__c != Null )||(ce.Street__c !=null && ce.Zip_Code__c != null && ce.City__c !=null && ce.State__c != null  &&  ce.Street__c == rdrforContactKeys.Customer_Street_Address_TXT__c && ce.Zip_Code__c == rdrforContactKeys.Customer_Address_ZIP_Code_TXT__c && ce.City__c == rdrforContactKeys.Customer_City_TXT__c && ce.State__c == rdrforContactKeys.State_Code_CD__c ))){
                            if(oppForEnrich.Id == opptoContactKeyMatch.get(ce.Customer_Account_Id__r.Contact_Key__c).Id){

                                Matchback__c mB = new Matchback__c();
                                mB.Opportunity__c = oppForEnrich.Id;
                                mB.RDR_Sales__c = rdrforContactKeys.Id; 
                                mB.Matchback_Date__c = rdrforContactKeys.Sales_Date_DT__c;
                                mB.Matchback_Status__c = 'Matched to Dealer';
                                matchBackList.add(mB);
                                opptoContactKeyMatch.get(ce.Customer_Account_Id__r.Contact_Key__c).Sale_Confirmation__c = true;
                                opptoContactKeyMatch.get(ce.Customer_Account_Id__r.Contact_Key__c).Matchback_Date__c = rdrforContactKeys.Sales_Date_DT__c.addDays(1);
                                updateoppBackList.add(opptoContactKeyMatch.get(ce.Customer_Account_Id__r.Contact_Key__c));
                                break;
                            }
                        }
                                 
                    }    
                }
            }
        }
        if(!opptoContactKeyNoMatch.isEmpty()){
            customerEncrichmentList1=[Select Customer_Account_Id__r.Contact_Key__c ,Email__c ,Phone_Number__c,Zip_Code__c,Street__c,City__c,State__c from Customer_Enrichment__c where Customer_Account_Id__r.Contact_Key__c IN:opptoContactKeyNoMatch.keySet() AND Customer_Account_Id__r.Contact_Key__c!= NULL];
        }
        if(!customerEncrichmentList1.isEmpty()){
            for(RDR_Sales__c rdrforContactKeys : rdsList){
                for(Opportunity oppForEnrichNoMtach :opptoContactKeyNoMatch.values()){
                    for(Customer_Enrichment__c ce : customerEncrichmentList1){
                       if((ce.Phone_Number__c!=null  && ce.Phone_Number__c == rdrforContactKeys.Telephone_Number_NUM__c)
                        ||(ce.Email__c!=null && ce.Email__c == rdrforContactKeys.Email_id_TXT__c)||(ce.Zip_Code__c != null  && ce.Zip_Code__c == rdrforContactKeys.Customer_Address_ZIP_Code_TXT__c && rdrforContactKeys.Customer_Last_Name_NM__c != Null && rdrforContactKeys.Customer_First_Name_NUM__c != Null )||(ce.Street__c !=null && ce.Zip_Code__c != null && ce.City__c !=null && ce.State__c != null  &&  ce.Street__c == rdrforContactKeys.Customer_Street_Address_TXT__c && ce.Zip_Code__c == rdrforContactKeys.Customer_Address_ZIP_Code_TXT__c && ce.City__c == rdrforContactKeys.Customer_City_TXT__c && ce.State__c == rdrforContactKeys.State_Code_CD__c )){
                            if(oppForEnrichNoMtach.Id == opptoContactKeyNoMatch.get(ce.Customer_Account_Id__r.Contact_Key__c).Id){
                               
                                Matchback__c mB = new Matchback__c();
                                mB.Opportunity__c = oppForEnrichNoMtach.Id;
                                mB.RDR_Sales__c = rdrforContactKeys.Id;
                                mB.Matchback_Date__c = rdrforContactKeys.Sales_Date_DT__c;
                                mB.Matchback_Status__c = 'Matched to Other Dealer';
                                matchBackList.add(mB);

                                break;
                            }
                        }
                    }
                             
                }    
            }
        }
        
        //query on matchback records
        if(!molist.isEmpty()){
           matchbackDeletelist = [select id from Matchback__c where Opportunity__c IN:molist];
        }
        //delete exiting matchback records
        if(!matchbackDeletelist.isEmpty()){
          database.delete(matchbackDeletelist,false);
        } 
        //insert matchback records
        if(!matchBackList.isEmpty()){
          insert matchBackList;
        }
        
        
        //insert rdr records
        if(!rdrset.isEmpty()){
   
          List<RDR_Sales__c> rdrlist = new List<RDR_Sales__c>(rdrset);
          update rdrlist;
        }
        
        List<Logs__c> insetLog= new List<Logs__c>();
        if(!updateoppBackList.isEmpty()){
            list<opportunity>updateoppBackList1 = new list<opportunity>(updateoppBackList);
            Database.SaveResult[] results = Database.update(updateoppBackList1, false);
              
                // Iterate SaveResult array
                for (Database.SaveResult result : results) {
                    if (result.isSuccess()) {
                        
                        //Opportunity autoOpp = new Opportunity(id=result.getId());
                        //oppids.add(result.getId());
                    }
                    else {
                        //Error ecountered              
                        for(Database.Error error : result.getErrors()) {
                            //Handle error
                            Logs__c logRecord = new Logs__c(Name='Batch or Lead Trigger Lead to Opp ** ',Trigger_or_Class_Name__c='Matchback **',Error_Message__c = error.getMessage() + '' +error.getFields(),Error_Line_Number__c = 0);
                            insetLog.add(logRecord);

                        }
                    }
          
                }
        }
        //insert error log records 
        if(insetLog.size()>0){
            insert insetLog;
        }
    }
    
    // execute any post-processing operations
    global void finish(Database.BatchableContext BC) {
        Logs__c l = new Logs__c(name = 'MatchBackLogic' , Trigger_or_Class_Name__c = 'Matchback',Error_Line_Number__c = 0);
        insert l;
        
    }
    //schedule batch job
    global void execute (SchedulableContext sc){
         Matchback scheduleMatchback = new Matchback();
         Id batchId = Database.executeBatch(scheduleMatchback, Integer.valueOf(Label.Matchback_Batch_Size));
    }
}