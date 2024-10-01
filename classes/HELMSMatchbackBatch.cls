global class HELMSMatchbackBatch implements Database.Batchable<sObject>, Database.Stateful {
	
        global Database.QueryLocator start(Database.BatchableContext BC) { 
        Helms_Matchback_Exract__mdt matchbackqry = Helms_Matchback_Exract__mdt.getInstance('Helms_Matchback_Extract');
    	String query = 'SELECT Id, Name, Dealer_Number_NUM__c, Customer_First_Name_NUM__c, Customer_Last_Name_NM__c, isProcessed__c, XPROD_DIV_CD__c, Telephone_Number_NUM__c,Customer_Home_Phone_Number__c,Primary_Driver_Home_Phone_Number__c,Primary_Driver_Phone_Number__c,Customer_Cellphone_Number__c,Primary_Driver_Cellphone_Number__c, Email_id_TXT__c,Primary_Driver_Email__c, Serial_Number_NUM__c,Vin_TXT__c, Sales_Date_DT__c,Customer_Street_Address_TXT__c,Customer_Address_ZIP_Code_TXT__c,Customer_City_TXT__c,State_Code_CD__c,Updated_by_New_MB__c FROM RDR_Sales__c where Updated_by_New_MB__c=false';
           if(matchbackqry.Start_Date__c!=null){
                query = query+' and CreatedDate>='+matchbackqry.Start_Date__c;
            }
            if(matchbackqry.End_Date__c!=null){
                query = query+' and CreatedDate<='+matchbackqry.End_Date__c;
            }
            //query = query + ' LIMIT 5';
            system.debug('query:'+query);
        return Database.getQueryLocator(query);    
    } 

    global void execute(Database.BatchableContext BC, List<RDR_Sales__c> rdrList) {
        set<String> firstName = new set<String>();
        set<String> lastName = new set<String>();
        set<String> email = new set<String>();
        set<String> phone = new set<String>();
        set<String> dealerNo = new set<String>();
        set<String> division = new set<String>();
        set<string> zipcodes = new set<string>();
        set<string> serialnos = new set<string>();
        set<string> vinNumbers = new set<string>();
        Set<Id> processedOpportunityIds = new Set<Id>(); 
        set<Opportunity> updateoppList = new set<Opportunity>();
        set<RDR_Sales__c> rdrset = new set<RDR_Sales__c>();
             
        for (RDR_Sales__c rdr : rdrList) {
            if (rdr.Customer_First_Name_NUM__c != null) {
                firstName.add(rdr.Customer_First_Name_NUM__c);
            }
            if (rdr.Customer_Last_Name_NM__c != null) {
                lastName.add(rdr.Customer_Last_Name_NM__c);
            }
            if (rdr.Email_id_TXT__c != null) {
                email.add(rdr.Email_id_TXT__c);
            }
            if (rdr.Primary_Driver_Email__c != null) {
                email.add(rdr.Primary_Driver_Email__c);
            }
            if (rdr.Telephone_Number_NUM__c != null) {
                phone.add(rdr.Telephone_Number_NUM__c);
            }
            if (rdr.Customer_Home_Phone_Number__c!= null) {
                phone.add(rdr.Customer_Home_Phone_Number__c);
            }
            if (rdr.Primary_Driver_Home_Phone_Number__c!= null) {
                phone.add(rdr.Primary_Driver_Home_Phone_Number__c);
            }
            if (rdr.Primary_Driver_Phone_Number__c!= null) {
                phone.add(rdr.Primary_Driver_Phone_Number__c);
            }
            if (rdr.Customer_Cellphone_Number__c!= null) {
                phone.add(rdr.Customer_Cellphone_Number__c);
            }
            if (rdr.Primary_Driver_Cellphone_Number__c!= null) {
                phone.add(rdr.Primary_Driver_Cellphone_Number__c);
            }
            if (rdr.Dealer_Number_NUM__c != null) {
                dealerNo.add(rdr.Dealer_Number_NUM__c);
            }
            if (rdr.XPROD_DIV_CD__c != null) {
                division.add(rdr.XPROD_DIV_CD__c);
            }
            if(rdr.Customer_Address_ZIP_Code_TXT__c != null){
                zipcodes.add(rdr.Customer_Address_ZIP_Code_TXT__c );
            }
            /*if(rdr.Serial_Number_NUM__c != null){
                serialnos.add(rdr.Serial_Number_NUM__c );
            }
            if(rdr.Vin_TXT__c != null){
                vinNumbers.add(rdr.Vin_TXT__c );
            }*/
        }

        Helms_Matchback_Exract__mdt matchbackqry = Helms_Matchback_Exract__mdt.getInstance('Helms_Matchback_Extract');
        
        Datetime startDate;
        if(matchbackqry.Start_Date__c!=null){
           startDate = Date.valueOf(matchbackqry.Start_Date__c).addDays(-120);
        }
        
        List<Opportunity> oppBackList = new List<Opportunity>();
        
        if(matchbackqry.Start_Date__c!=null && matchbackqry.End_Date__c!=null){
             oppBackList = [SELECT Id, Name, First_Name_TXT__c, Last_Name_TXT__c, Phone__c, Email__c, ZipCode_TXT__c, Division_CD__c, Sale_Confirmation__c, Matchback_Date__c, PreferredDealerNumber_NUM__c, Address_TXT__c, Number_NM__c, Serial_Number__c, CreatedDate, ContactKey_TXT__c, State_TXT__c, City_TXT__c, Street_TXT__c, ValidEmail_FLG__c, Updated_by_New_MB__c
                                  FROM Opportunity
                                  WHERE ((Email__c IN :email AND Division_CD__c IN :division)
                                         OR ((First_Name_TXT__c IN :firstName OR Last_Name_TXT__c IN :lastName) 
                                             AND Division_CD__c IN :division 
                                             AND (Phone__c IN :phone OR ZipCode_TXT__c IN :zipcodes)))
                                  AND Updated_by_New_MB__c != TRUE AND CreatedDate>= :startDate AND CreatedDate<= :Date.valueOf(matchbackqry.End_Date__c)];

        }
        else{
             oppBackList = [SELECT Id, Name, First_Name_TXT__c, Last_Name_TXT__c, Phone__c, Email__c, ZipCode_TXT__c, Division_CD__c, Sale_Confirmation__c, Matchback_Date__c, PreferredDealerNumber_NUM__c, Address_TXT__c, Number_NM__c, Serial_Number__c, CreatedDate, ContactKey_TXT__c, State_TXT__c, City_TXT__c, Street_TXT__c, ValidEmail_FLG__c, Updated_by_New_MB__c
                                  FROM Opportunity
                                  WHERE ((Email__c IN :email AND Division_CD__c IN :division)
                                         OR ((First_Name_TXT__c IN :firstName OR Last_Name_TXT__c IN :lastName) 
                                             AND Division_CD__c IN :division 
                                             AND (Phone__c IN :phone OR ZipCode_TXT__c IN :zipcodes)))
                                  AND Updated_by_New_MB__c != TRUE];
        }
        
        List<Matchback_New__c> matchBackList = new List<Matchback_New__c>();
        
        for (RDR_Sales__c objrds : rdrList) {
            for (Opportunity opp : oppBackList) {
                if(
				(opp.ValidEmail_FLG__c != False && opp.Email__c != null && (objrds.Email_id_TXT__c == opp.Email__c || objrds.Primary_Driver_Email__c == opp.Email__c) && objrds.XPROD_DIV_CD__c == opp.Division_CD__c)
	||
	(
	((objrds.Customer_First_Name_NUM__c != null && objrds.Customer_First_Name_NUM__c.tolowercase() == opp.First_Name_TXT__c.tolowercase()) || (objrds.Customer_Last_Name_NM__c != null && objrds.Customer_Last_Name_NM__c.tolowercase() == opp.Last_Name_TXT__c.tolowercase())) 
	&& 
	objrds.XPROD_DIV_CD__c == opp.Division_CD__c	
	&& 
	(
	(opp.Phone__c != null  && opp.Phone__c.length() >= 10 && (objrds.Telephone_Number_NUM__c == opp.Phone__c || objrds.Customer_Home_Phone_Number__c == opp.Phone__c || objrds.Primary_Driver_Home_Phone_Number__c == opp.Phone__c || objrds.Primary_Driver_Phone_Number__c == opp.Phone__c || objrds.Customer_Cellphone_Number__c == opp.Phone__c || objrds.Primary_Driver_Cellphone_Number__c == opp.Phone__c)) 
	||  
	(opp.Street_TXT__c != null && opp.ZipCode_TXT__c != null && objrds.Customer_Street_Address_TXT__c == opp.Street_TXT__c && objrds.Customer_Address_ZIP_Code_TXT__c == opp.ZipCode_TXT__c)
	)
 )                
) 
                {     
                    if (opp.PreferredDealerNumber_NUM__c == objrds.Dealer_Number_NUM__c && opp.Updated_by_New_MB__c != true && objrds.Updated_by_New_MB__c != true && !processedOpportunityIds.contains(opp.Id)) { 
                        Matchback_New__c mB = new Matchback_New__c();
                        mB.Opportunity__c = opp.Id;
                        mB.RDR_Sales__c = objrds.Id;
                        mB.Matchback_Date__c = objrds.Sales_Date_DT__c;
                        mB.Matchback_Status__c = 'Matched to Dealer';
                        matchBackList.add(mB);
                        processedOpportunityIds.add(opp.Id); 
                        opp.Updated_by_New_MB__c = true;
                        //opp.Sale_Confirmation__c = true;
                        opp.Matchback_Date__c = objrds.Sales_Date_DT__c;
                        updateoppList.add(opp);
                    }     
                    else if (opp.PreferredDealerNumber_NUM__c != objrds.Dealer_Number_NUM__c && objrds.Updated_by_New_MB__c != true && !processedOpportunityIds.contains(opp.Id)) { 
                        Matchback_New__c mB = new Matchback_New__c();
                        mB.Opportunity__c = opp.Id;
                        mB.RDR_Sales__c = objrds.Id;
                        opp.Matchback_Date__c = objrds.Sales_Date_DT__c;
                        mB.Matchback_Date__c = objrds.Sales_Date_DT__c;
                        mB.Matchback_Status__c = 'Matched to other Dealer';
                        matchBackList.add(mB);
                        processedOpportunityIds.add(opp.Id); 
                        updateoppList.add(opp);
                    } 
                } 
            }
            objrds.Updated_by_New_MB__c = true;
            rdrset.add(objrds);    
        }
               
        if (!matchBackList.isEmpty()) {
            insert matchBackList;
        }
        
        if (!rdrset.isEmpty()) {
            List<RDR_Sales__c> rdrlist1 = new List<RDR_Sales__c>(rdrset);
            update rdrlist1;
        }

        if (!updateoppList.isEmpty()) {
            List<Opportunity> updateoppList1 = new List<Opportunity>(updateoppList);
            Database.SaveResult[] results = Database.update(updateoppList1, false);
        }
    }
    
    global void finish(Database.BatchableContext BC) {
        System.debug('Batch is Processed Successfully');
    }
}