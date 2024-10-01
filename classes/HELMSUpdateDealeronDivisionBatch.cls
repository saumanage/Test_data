global class HELMSUpdateDealeronDivisionBatch implements Database.Batchable<sObject> {
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator('SELECT id,DealerSubdivision_CD__c, Dealer_ID__c from Dealer_Division__c where Dealer_ID__c=\'\' and DealerSubdivision_CD__c!=\'\'');
    }
    
    public void execute(Database.BatchableContext c, List<sObject> scope)
    {
        List<Dealer_Division__c> divnList= new List<Dealer_Division__c>();
        Set<string> dldvsnSet= new Set<string>();
        Map<string,id> delrMap = new Map<string,id>();
        try{
        for(SObject record : scope){
            Dealer_Division__c dvsn = (Dealer_Division__c) record;
            if(!String.Isblank(dvsn.DealerSubdivision_CD__c)){
                dldvsnSet.add(dvsn.DealerSubdivision_CD__c.Left(6));
            }
        }
        for(Account acc:[select id,DealerCode_CD__c,name from Account where DealerCode_CD__c in :dldvsnSet and DealerCode_CD__c!='']){
            delrMap.put(acc.DealerCode_CD__c,acc.id);
         }
         for(SObject sc: scope){
             Dealer_Division__c divsn = (Dealer_Division__c) sc;
             if(!String.Isblank(divsn.DealerSubdivision_CD__c) && delrMap!=null){
                if(delrMap.get(divsn.DealerSubdivision_CD__c.Left(6))!=null){
                   divsn.Dealer_ID__c= delrMap.get(divsn.DealerSubdivision_CD__c.Left(6));
                   divnList.add(divsn);
                }
            }
         }
       
        if(divnList.size()>0){
               //system.debug('divnList++'+divnList);
            update divnList;
        }
        }Catch(exception e){
            //system.debug('Exception Caught:'+e.getmessage());
        }
    } 
    
    global void finish(Database.BatchableContext bc) {
        // execute any post-processing operations like sending email
    }
}