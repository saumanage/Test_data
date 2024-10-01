@isTest
public class HELMS_OpportunityCreationLeadBatchTest {
    @isTest static void exc(){
      string Label;
       List<HELMS_LeadConversionFieldsToOpportunity__mdt>  accrec = new List<HELMS_LeadConversionFieldsToOpportunity__mdt>();
        HELMS_LeadConversionFieldsToOpportunity__mdt a1 = new HELMS_LeadConversionFieldsToOpportunity__mdt();
        a1.LeadFieldAPIName__c='ModelTrim';
        accrec.add(a1);
       Test.startTest();
     //   insert a1;
        HELMS_OpportunityCreationLeadBatch  mybatch = new HELMS_OpportunityCreationLeadBatch();
        Database.executeBatch(mybatch);
        Test.stopTest(); 
    }
}