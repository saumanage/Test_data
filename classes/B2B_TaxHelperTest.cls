/****************************************************************************************************************
Name: 			B2B_TaxHelperTest
Purpose: 		This class is to provide Tax from Vertex API.
Date: 			28/01/2021
Created By: 	Radhey Shyam Gupta
******************************************************************************************************************
MODIFICATIONS – 	Date 		|	Dev Name		|	Method		|	User Story
******************************************************************************************************************
22/05/2022	|	Soumya Sahoo	|				|	Error handling changes- JIRA- 8617
******************************************************************************************************************/
@isTest
public class B2B_TaxHelperTest {
    @isTest
    public static void unitTest(){
        String ordTestData='{"Cart_Shipping_Street_c__c":"47 W 13th St","Cart_Shipping_City_c__c":"New York","Cart_Shipping_State_c__c":"NY","Cart_Shipping_Postal_Code_c__c":"10011"}';
        Order__x objOrder = new Order__x();
        objOrder= (Order__x ) JSON.deserialize(ordTestData, Order__x .class);
        B2B_VertexTaxCalculationIntegration.OrderItemWrapper ordwr=new B2B_VertexTaxCalculationIntegration.OrderItemWrapper();
		ordwr.quantity=2;
		ordwr.unitPrice=1.44;
        List<B2B_VertexTaxCalculationIntegration.OrderItemWrapper> item=new List<B2B_VertexTaxCalculationIntegration.OrderItemWrapper>();
    	item.add(ordwr);
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new B2B_VertexTaxCalculationCalloutMock());
        B2B_TaxHelper.getTaxRatesAndAmountsFromVertex(objOrder,item,'2','3','4');
        Test.stopTest();
    }

}