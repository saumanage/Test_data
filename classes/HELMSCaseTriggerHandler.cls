public with sharing class  HELMSCaseTriggerHandler{
    
    public static void caseSharing(List<Case> caselist){
        try{
            List<CaseShare> caseSharesList = new List<CaseShare>(); 

        
            for(Case c : caselist) {
                String owner = c.ownerId;
                If(owner.startsWithIgnoreCase('00G')){
                    //system.debug('owner : '+c.OwnerId);
                    //system.debug('Cid: '+c.id);
                    CaseShare cs = new CaseShare(); 
                    cs.CaseId = c.Id; 
                    cs.UserOrGroupId = c.CreatedById; // hardcoding other user's id 
                    cs.CaseAccessLevel = 'Edit'; 
                    caseSharesList.add(cs); 
                }
            } 
        

            //system.debug(caseSharesList); 
            if(caseSharesList.size()>0){
                //system.debug('case share list : '+caseSharesList );
                
                insert caseSharesList; 
            }
    
        }Catch(Exception ex){
                //System.debug('Exception at line : '+ ex.getLineNumber());
                //System.debug('Exception Message : '+ ex.getMessage());
                
                Logs__c  l =new Logs__c (name='Lead Enrichment Response PE- Trigger Handler',Trigger_or_Class_Name__c='HELMSLeadEnrichmentResponsePEHandler', Error_Message__c =ex.getMessage(), Error_Line_Number__c =Integer.valueOf(string.valueof(ex.getLineNumber() )) );
               insert l;
        }  
    }
}