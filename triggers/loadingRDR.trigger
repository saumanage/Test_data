trigger loadingRDR on RDR_Sales__c (before insert,after insert) {
	Set<String> vinNumber = new Set<String>();
    for(RDR_Sales__c rdrRec : trigger.new){
        if(rdrRec.Status_Code_CD__c == '03' && rdrRec.Auto_VIN_Status_Code__c == 'RR2' && (rdrRec.XPROD_DIV_CD__c == 'A' || rdrRec.XPROD_DIV_CD__c == 'B') ){
            vinNumber.add(rdrRec.Vin_TXT__c);
        }
    }
    System.debug('vinNumber : '+vinNumber);
    Map<String ,List<Id>> mapExistingRDR = new Map<String ,List<Id>>();
    Map<String ,List<RDR_Sales__c>> mapExistingRDRNew = new Map<String ,List<RDR_Sales__c>>();
    for(RDR_Sales__c existsingRDRRec : [SELECT Id, Dealer_Number_NUM__c, Vin_TXT__c FROM RDR_Sales__c WHERE IsToDelete__c = false AND Vin_TXT__c IN : vinNumber]){
        if(mapExistingRDR.containsKey(existsingRDRRec.Vin_TXT__c)){
           mapExistingRDR.get(existsingRDRRec.Vin_TXT__c).add(existsingRDRRec.Id);
           mapExistingRDRNew.get(existsingRDRRec.Vin_TXT__c).add(existsingRDRRec);
        }else{
            mapExistingRDR.put(existsingRDRRec.Vin_TXT__c,new List<Id>{existsingRDRRec.Id});
            mapExistingRDRNew.put(existsingRDRRec.Vin_TXT__c,new List<RDR_Sales__c>{existsingRDRRec});
        }
    }
    //System.debug('mapExistingRDR : '+mapExistingRDR);
   // System.debug('mapExistingRDRNew : '+mapExistingRDRNew);
   // system.debug('mapExistingRDRNew Count : '+mapExistingRDRNew.size());
    
    List<RDR_Sales__c> rdrToUpdate = new List<RDR_Sales__c>();
    List<RDR_Sales__c> rdrToInsert = new List<RDR_Sales__c>();
    if(trigger.isBefore){
          Set<Id> rdrExRecId = new Set<Id>();
    	for(RDR_Sales__c rdrRec : trigger.new){
            if(mapExistingRDR.size() > 0 && mapExistingRDR.containsKey(rdrRec.Vin_TXT__c) && mapExistingRDR.get(rdrRec.Vin_TXT__c) != null){
                rdrRec.IsToDelete__c = true;
                List<Id> rdrRecId = new List<Id>();
                rdrRecId = mapExistingRDR.get(rdrRec.Vin_TXT__c);
                List<RDR_Sales__c> rdrRecIdNew = new List<RDR_Sales__c>();
				rdrRecIdNew = mapExistingRDRNew.get(rdrRec.Vin_TXT__c);
                for(RDR_Sales__c rdrRecTemp : rdrRecIdNew){
                   // System.debug('ID : '+rdrRecTemp.Id);
                   // System.debug('ID : '+rdrRecTemp.Dealer_Number_NUM__c);
                    if(rdrExRecId.size() == 0){
                        if(rdrRecTemp.Dealer_Number_NUM__c != rdrRec.Dealer_Number_NUM__c){
                            RDR_Sales__c rdrRecToUpdate = new RDR_Sales__c(Id=rdrRecTemp.Id,New_Dealer_Number_From_Buy_Sell__c=rdrRec.Dealer_Number_NUM__c);
                        	rdrToUpdate.add(rdrRecToUpdate);
                           	rdrExRecId.add(rdrRecTemp.Id);
                        }
                    }else if(!rdrExRecId.contains(rdrRecTemp.Id)){
                        if(rdrRecTemp.Dealer_Number_NUM__c != rdrRec.Dealer_Number_NUM__c){
                        	RDR_Sales__c rdrRecToUpdate = new RDR_Sales__c(Id=rdrRecTemp.Id,New_Dealer_Number_From_Buy_Sell__c=rdrRec.Dealer_Number_NUM__c);
                        	rdrToUpdate.add(rdrRecToUpdate);
                        	rdrExRecId.add(rdrRecTemp.Id);
                        }
                    }
                }
                /*for(Id rdrListId : rdrRecId){
                       if(rdrExRecId.size() == 0){
					   		RDR_Sales__c rdrRecToUpdate = new RDR_Sales__c(Id=rdrListId,Dealer_Number_NUM__c=rdrRec.New_Dealer_Number_From_Buy_Sell__c);
                        	rdrToUpdate.add(rdrRecToUpdate);
                           	rdrExRecId.add(rdrListId);
                    }else if(!rdrExRecId.contains(rdrListId)){
                        	RDR_Sales__c rdrRecToUpdate = new RDR_Sales__c(Id=rdrListId,Dealer_Number_NUM__c=rdrRec.New_Dealer_Number_From_Buy_Sell__c);
                        	rdrToUpdate.add(rdrRecToUpdate);
                        	rdrExRecId.add(rdrListId);
                    }
                }*/
            }else{
                rdrToInsert.add(rdrRec);
            }  
        }    
    }
    
    //System.debug('rdrToInsert : '+rdrToInsert);
    //System.debug('rdrToUpdate : '+rdrToUpdate);
    if(rdrToUpdate.size() > 0){
        try{
            update rdrToUpdate;
             //System.debug('UpdatedRDR : '+rdrToUpdate);
        }catch(Exception e){
            //System.debug('e : '+e.getMessage());
        }
    }
    Set<Id> rdrRecToDel = new Set<Id>();
    if(trigger.isAfter){
       // System.debug('Inside After');
        for(RDR_Sales__c rdrRec : trigger.new){
            if(rdrRec.IsToDelete__c){
                rdrRecToDel.add(rdrRec.Id);
            }
        }
    }
    //System.debug('rdrRecToDel : '+rdrRecToDel);
    if(rdrRecToDel.size() > 0){
        loadingRDRHelper.deleteRDRRecords(rdrRecToDel);
    }
    
    if(trigger.isInsert && trigger.isBefore){
        RDRSalesTriggerHandler inst= new RDRSalesTriggerHandler();
        inst.rdrsalemodel(trigger.new);
    }
}