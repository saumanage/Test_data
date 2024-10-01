/****************************************************************************************************************
Name: 			B2B_IntegrationConstants
Purpose: 		This class is to provide Tax from Vertex API.
Date: 			28/01/2021
Created By: 	Soumya Sahoo
******************************************************************************************************************
MODIFICATIONS – 	Date 		|	Dev Name		|	Method		|	User Story
******************************************************************************************************************
22/05/2022	|	Soumya Sahoo	|				|	Error handling changes- JIRA- 8617
******************************************************************************************************************/
public class B2B_IntegrationConstants {
	public static final STRING STATE = 'mainDivision';
 	public static final STRING POSTALCODE= 'postalCode';
    public static final STRING COUNTRY= 'country';
    public static final STRING COUNTRY_VALUE = 'US';
    public static final STRING CITY = 'city';
    public static final STRING ERROR_MESSAGE_STATUS_CODE_500 = 'Dynamic backend host not specified';
    public static final STRING ERROR_RESPONSE_CODE = '500';
    public static final INTEGER DEFAULT_VALUE=0;
    public static final STRING SOME_JOB='Some Job';
    public static final STRING TAX_ERROR_MESSAGE_CHECKOUT='Tax calculation error';
    public static final STRING TAX_ERROR_MESSAGE_DESCRIPTION='B2BTaxSample';
    public static final STRING TAXES='Taxes';
    public static final STRING QUOTATION='quotation';
    public static final STRING TAX_XML_URL='urn:vertexinc:o-series:tps:9:0';
    public static final STRING BlankVariable='';
    public static final STRING NULLVARIABLE=Null;
    public static final STRING STREETADDRESS='streetAddress';
    public static final STRING LINENUMBER='Line Number';
    public static final STRING RESPONSE='Response';
    public static final STRING RESPONSESTATUS='ResponseStatus';
    public static final STRING DESCRIPTION='Description';
    public static final STRING SUCCESS='success';
    public static final STRING TOTALCHARGES='TotalCharges';
    public static final STRING CODE='Code';
    public static final STRING MESSAGE='Message';
    public static final STRING AMOUNT='Amount';
    public static final STRING errormessage='errorMessage';
    public static final INTEGER STATUSCODE=200;
    public static final STRING ERROR_CORRECT_ADDRESS='Please Provide Correct Addresses.';
    public static final STRING TESTDATA_SHIPPING_STREET='4340 W Dublin Granville Rd';
    public static final STRING TESTDATA_SHIPPING_CITY='Dublin';
    public static final STRING TESTDATA_SHIPPING_STATE='OH';
    public static final STRING TESTDATA_SHIPPING_POSTALCODE='90815-4678';
    public static final BOOLEAN	FALSE_VALUE=FALSE;
    public static final BOOLEAN	TRUE_VALUE=TRUE;
    public static final DECIMAL	ZERO_VALUE=0.0;
    public static final STRING BAD_RESPONSE_MESSAGE='Bad Request from API';
    //Added below 3 line to for error handling constand values
    public static final STRING ERROR_TYPE='Integration';
    public static final STRING INTEGRATION_SEVERITY='Critical';
    public static final STRING INTEGRATION_ERROR_TYPE='	http api callout';
    
    
    // added by Rajrishi
    public static final STRING SYSTEM_CANCELED = 'SYSTEM CANCELED';
    public static final STRING UNAVAILABLE_REFUND = 'Unavailable Refund';
    public static final STRING PAYMENT_SUCCESS = 'Success';
    public static final STRING TRANSACTION_REFUND_NAME = 'Payment Refund Transaction';
    public static final STRING PAYMENT_FAILURE = 'Failure';
    public static final STRING BT_REFUND = '/transaction/refund';
    public static final STRING BT_TRAN_SEARCH = '/transaction/search';
    public static final STRING BRAINTREE_RECONCILIATION ='Braintree Reconciliation'; //added by suresh 
    public static final STRING BT_VOID = '/transaction/void'; //added by suresh for payment settlement
    
}