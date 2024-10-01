trigger HELMSOptionTrigger on Options__c (after insert, after delete, after undelete, after update) {  
    
    
    BypassAutomations__c pb = BypassAutomations__c.getInstance(UserInfo.getUserId());
    if(pb.BypassTrigger__c == false){
        
        List<Options__c> optionsList;
        
        if (Trigger.isDelete){
            optionsList = Trigger.old;
        }else{
            optionsList = Trigger.new; 
        }
        if (optionsList != null && optionsList.isEmpty() == false) {
            //Opportunity Ids
            Set<Id> opportunityIds = new Set<Id>();
            for (Options__c option : optionsList) {
                IF(option.Opportunity_ID__c!=NULL){
                    opportunityIds.add(option.Opportunity_ID__c);
                }
            }
            
            if(opportunityIds.size()>0){
                //Map of Opportunities
                Map<Id, Opportunity> opportunities = new Map<Id, Opportunity>([SELECT Id, Total_MSRP_AMT__c,MSRP_AMT__c FROM Opportunity WHERE Id IN :opportunityIds]);
                //Rollup_Amount__c
                Map<Id, double> oppAmounts = new Map<Id, double>();
                AggregateResult[] results = [SELECT Opportunity_ID__c, SUM(PriceMSRP_AMT__c) RollupAmount FROM Options__c WHERE Opportunity_ID__c IN :opportunityIds GROUP BY Opportunity_ID__c];
                //System.debug('results'+results);
                for (AggregateResult result : results) {
                    Id opportunityId = (Id) result.get('Opportunity_ID__c');
                    double rollupAmount = (double) result.get('RollupAmount');
                    oppAmounts.put(opportunityId, rollupAmount);
                    system.debug('oppAmounts'+oppAmounts);
                }
                //Map Amounts for Update
                List<Opportunity> oppsToUpdate = new List<Opportunity>();
                for(Id opportunityId : opportunities.keySet()) {
                    Opportunity opp = opportunities.get(opportunityId);
                    double rollupAmount = 0;
                    if (oppAmounts.containsKey(opportunityId)) {
                        rollupAmount = oppAmounts.get(opportunityId);
                        system.debug('rollupAmount'+rollupAmount);
                    }
                    if (rollupAmount!=null && rollupAmount != opp.Total_MSRP_AMT__c) {
                        if(opp.MSRP_AMT__c != null){
                            opp.Total_MSRP_AMT__c = rollupAmount + opp.MSRP_AMT__c;
                            system.debug('opp.Total_MSRP_AMT__c'+opp.Total_MSRP_AMT__c);
                        }else{
                            opp.Total_MSRP_AMT__c = rollupAmount;
                            system.debug('opp.Total_MSRP_AMT__c'+opp.Total_MSRP_AMT__c);
                        }
                        oppsToUpdate.add(opp);
                    }
                }
                //Update Opportunities
                if (oppsToUpdate.isEmpty() == false) {
                    update oppsToUpdate;
                }
            }
        }
    }
}