/****************************************************************************************************************
Name: 			B2B_TaxHelper
Purpose: 		This class is to provide Tax from Vertex API.
Date: 			28/01/2021
Created By: 	Soumya Sahoo
Test ClassName: B2B_TaxHelperTest, B2B_VertexTaxCalculationCalloutMock(Mock Class)
******************************************************************************************************************
MODIFICATIONS – 	Date 		|	Dev Name		|	Method		|	User Story
******************************************************************************************************************
22/05/2022	|	Soumya Sahoo	|				|	Error handling changes- JIRA- 8617
******************************************************************************************************************/
public class B2B_TaxHelper {
    @AuraEnabled
    public static String getTaxRatesAndAmountsFromVertex(Order__x orderDetails,List<B2B_VertexTaxCalculationIntegration.OrderItemWrapper> orderItemDetails,String shippingCharge,String installationCharges,String reestockingfee){
     	Map<String,String> dealerAddress = New Map<String,String>();
        Map<String,String> customerAddress = New Map<String,String>();
        List<Account__x> accountDetails=new List<Account__x>();
        String dealerCode;
        String dealerId;

       	if(!Test.isRunningTest())
            accountDetails=[select id,externalid,ShippingStreet__c,ShippingState__c,ShippingCity__c,ShippingPostalCode__c,PoIId_c__c from Account__x where id=:orderDetails.AccountId__c Limit 1];
        else {
            Account__x accdetails=new Account__x();
            accdetails.ShippingStreet__c=B2B_IntegrationConstants.TESTDATA_SHIPPING_STREET;
        	accdetails.ShippingCity__c=B2B_IntegrationConstants.TESTDATA_SHIPPING_CITY;
			accdetails.ShippingState__c= B2B_IntegrationConstants.TESTDATA_SHIPPING_STATE;           
        	accdetails.ShippingPostalCode__c=B2B_IntegrationConstants.TESTDATA_SHIPPING_POSTALCODE;
            accountDetails.add(accdetails);
        }
        
        if(accountDetails.size()>0)
        {
            dealerAddress.put(B2B_IntegrationConstants.STREETADDRESS,accountDetails[0].ShippingStreet__c);
        	dealerAddress.put(B2B_IntegrationConstants.CITY,accountDetails[0].ShippingCity__c);
        	dealerAddress.put(B2B_IntegrationConstants.STATE,accountDetails[0].ShippingState__c);
        	dealerAddress.put(B2B_IntegrationConstants.POSTALCODE,accountDetails[0].ShippingPostalCode__c);
            dealerCode= accountDetails[0].PoIId_c__c;
            dealerId=accountDetails[0].externalid;
        }
        customerAddress.put(B2B_IntegrationConstants.STREETADDRESS,orderDetails.ShippingStreet__c);
        customerAddress.put(B2B_IntegrationConstants.CITY,orderDetails.ShippingCity__c);
        customerAddress.put(B2B_IntegrationConstants.STATE,orderDetails.ShippingState__c);
        customerAddress.put(B2B_IntegrationConstants.POSTALCODE,orderDetails.ShippingPostalCode__c);
        
        
        B2B_VertexTaxCalculationIntegration.ResponseDataWrapper responseData = B2B_VertexTaxCalculationIntegration.calculateTaxQuotation(dealerAddress,customerAddress,orderItemDetails,dealerCode,orderDetails,shippingCharge,installationCharges,reestockingfee,dealerId);
        return JSON.serialize(responseData);
    }

}