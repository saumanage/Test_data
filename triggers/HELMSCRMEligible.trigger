trigger HELMSCRMEligible on Contact (after insert,after update){
    
    BypassAutomations__c pb = BypassAutomations__c.getInstance(UserInfo.getUserId());
    if(pb.BypassTrigger__c == false){
        
        Map<ID , Boolean> mapCons = new Map<ID , Boolean> ();
        If(trigger.isAfter && trigger.isUpdate){
            Id conRecordTypeId = Schema.SObjectType.contact.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
            for(Contact con: Trigger.new){
                
                if(con.HelmsCRMEligible_FLAG__c != (Trigger.oldMap.get(con.Id).HelmsCRMEligible_FLAG__c)){
                    if(con.RecordTypeId == conRecordTypeId){               
                        mapCons.put(con.Id, con.HelmsCRMEligible_FLAG__c );
                    }
                }           
                
            }
            
            HELMSCRMEligibleHandler.updateUser(mapCons );
        }
        
        if(trigger.IsAfter){
            Map<id, Contact> conOldMap = new Map<id, Contact>();
            if(trigger.isInsert){
                HELMSCRMEligibleHandler.AssignPermissionSetToUser(trigger.New, conOldMap, trigger.isInsert, trigger.isUpdate );  
            }
            
            if(trigger.isUpdate){
                
                HELMSCRMEligibleHandler.AssignPermissionSetToUser(trigger.New, Trigger.OldMap, trigger.isInsert, trigger.isUpdate ); 
            }
        } 
        
    }
    
}