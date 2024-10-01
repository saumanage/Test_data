/*
Test Class Name : HELMSAddressCleansingServiceTest
Class Name : HELMSAddressCleansingService 
Mock request test class Name:HELMSAddressCleansingMockTest
Last Modified Version Owner : Bijay Kumar Sahoo
Comments : Code to pass a mock response to the test class

*/
@isTest
public class HELMSAddressCleansingMockTest implements HttpCalloutMock{
    //create a mock response
    public HTTPResponse respond(HTTPRequest request) {
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/xml');
        response.setStatusCode(200);
        string respBody='<?xml version="1.0"?><eCRMCleanConsumerContactInfo xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" Error="false" xsi:noNamespaceSchemaLocation="eCRMCleanConsumerContactInfo.xsd"><ConsumerInfoRequest Id="1" Process="Addresses"><Addresses><Address Type=""><Line1>1605 N Monroe St</Line1><Line2 /><City>Monroe</City><State>MI</State><Zip>481624248</Zip><Province /><Country>U.S. Virgin Islands</Country></Address></Addresses></ConsumerInfoRequest><ConsumerInfoResponse Id="1"><Addresses><Address Status="GOOD" Type=""><Line1>1605 N Monroe St </Line1><Line2 /><City>Monroe</City><State>MI</State><Zip>48162-4248</Zip><Province /><Country>US</Country><TimeZoneName>Eastern Standard Time</TimeZoneName><TimeZoneOffSet>-04:00:00</TimeZoneOffSet><StatusDetails><StatusDetail Type="Address Status"><Code>AS01</Code><Description>Address Fully Verified - The address is valid and deliverable according to official postal agencies.</Description></StatusDetail></StatusDetails></Address></Addresses></ConsumerInfoResponse></eCRMCleanConsumerContactInfo>';
        response.setBody(respBody);
        response.setStatusCode(200);
        return response; 
    }
}