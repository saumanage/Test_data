trigger RDRSalesDealerNumberTrigger on RDR_Sales__c (before update) {
    //use for bypass trigger when require 
    BypassAutomations__c pb = BypassAutomations__c.getInstance(UserInfo.getUserId());
    if(pb.BypassTrigger__c == false){ 
        //stopping recursive trigger    
        if(trigger.isUpdate && trigger.isBefore && StopRecursive.firstRun){
            //set of vin number
            Set<string> vinSet= new Set<string>();
            //set of external id 
            Set<string> externalidSet= new Set<string>();
            Map<string,string> divStMap = new Map<string,string>();
            //query on custom metadata
            for(HELMS_UN_WIND__mdt mdt:[SELECT Status_Code_MDT__c,Division__c from HELMS_UN_WIND__mdt]){
                if(mdt.Division__c=='A' || mdt.Division__c=='B')
                    divStMap.put(mdt.Division__c,mdt.Status_Code_MDT__c);
            }
            
            //prepare set of value to filter the query
            for(RDR_Sales__c rdrRec : trigger.new){            
                if(rdrRec.Status_Code_CD__c ==  divStMap.get(rdrRec.XPROD_DIV_CD__c) && rdrRec.XPROD_DIV_CD__c!=null && divStMap.keyset().contains(rdrRec.XPROD_DIV_CD__c) ==true && rdrRec.Auto_VIN_Status_Code__c == 'RM1' && rdrRec.Vin_TXT__c!=null){
                    vinSet.add(rdrRec.Vin_TXT__c);
                    externalidSet.add(rdrRec.External_Id__c);
                }
            }
            //matchback list
            List<Matchback__c> matchbckList= new List<Matchback__c>();
            //opportunity list
            List<Opportunity> oppList= new List<Opportunity>();
            //set of opportunity id
            Set<id> oppidSet= new Set<id>();
            //fetch rdr sales records 
            List<RDR_Sales__c> oldList=[Select Id,Name,Dealer_Number_NUM__c,Sales_Date_DT__c,Vin_TXT__c,(Select id,RDR_Sales__c,Opportunity__c From Matchback__r) from RDR_Sales__c where Vin_TXT__c in :vinSet and External_Id__c in :externalidSet and Vin_TXT__c!=null and External_Id__c!=null];
            
            for(RDR_Sales__c rdr: oldList){
                matchbckList.addall(rdr.Matchback__r); 
                for(Matchback__c mtch: rdr.Matchback__r){
                    oppidSet.add(mtch.Opportunity__c);
                }
            }
            //query on opportunity 
            for(Opportunity opp: [Select id,Sale_Confirmation__c,Matchback_Date__c From Opportunity where id in :oppidSet]){
                if(opp.Sale_Confirmation__c = true || opp.Matchback_Date__c !=null){
                    opp.Sale_Confirmation__c = false;
                    opp.Matchback_Date__c = null;
                    oppList.add(opp);
                }
            }
            //rdr id set 
            Set<id> rdrsales= new Set<id>();
            //deleting exiting matchback records and unwind opportunity
            if(matchbckList.size()>0){
                Database.DeleteResult[] drList= Database.delete(matchbckList, false);
                
                for(Integer i = 0; i < drList.size(); i++){
                    Database.DeleteResult dr = drList[i];
                    if (dr.isSuccess()) {
                        // Operation was successful, so get the ID of the record that was processed
                        rdrsales.add(matchbckList[i].RDR_Sales__c);
                    }   
                }
                for(RDR_Sales__c rdr: trigger.new){
                    if(rdrsales.contains(rdr.id)){
                        rdr.isProcessed__c = true;
                        rdr.isUnwind__c = true;
                    }
                }
            }
            
            StopRecursive.isExecuting=false;
            //update opportunity
            if(oppList.size()>0){
                database.update(oppList,false);
            }
            
            StopRecursive.firstRun=false;
            
        }
        //if(rdrSalesToAddNewDealerNumber.size() > 0){
            //System.debug('rdrSalesToAddNewDealerNumber : '+rdrSalesToAddNewDealerNumber);
            //RDRSalesDealerNumberHandler.processRDRDealerNumber(rdrSalesToAddNewDealerNumber);
        //}
    }
}