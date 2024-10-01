trigger ModelGroupUploadTrigger on Product_Model_Master__c (after insert) {
	BypassAutomations__c pb = BypassAutomations__c.getInstance(UserInfo.getUserId());
    if(pb.BypassTrigger__c == false){
     	ModelGroupUploadHandler modelgrpuploadhandler = new ModelGroupUploadHandler();
        if(trigger.isInsert && trigger.isAfter){
            modelgrpuploadhandler.addProductModelCustomObject(trigger.new);
        }
    }
}