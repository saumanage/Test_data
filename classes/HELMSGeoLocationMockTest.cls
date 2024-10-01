// Mock test class to generate response body for the HELMSGeoLocationTest Class
@isTest
public class HELMSGeoLocationMockTest implements HttpCalloutMock{
	public HTTPResponse respond(HTTPRequest request) {
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        string respBody='{"POIResponse":{"appid":"bodyshops.honda.com","Error":"false","ResultCount":"0","Version":"1","POIs":null,"POIRequest":{"appid":"bodyshops.honda.com","AppId":"bodyshops.honda.com","POIId":null,"SearchWord":null,"Address":null,"ZipCode":"90503","Country":null,"Culture":null,"POIName":null,"POIIdent":null,"POIType":"A","Filters":null,"SearchRadius":null,"BoundingBox":null,"Latitude":null,"Longitude":null,"NumberOfPOIs":null,"POIGroupSize":null,"SortByPOIName":"false","SortOrderByAttribute":null,"StateOnly":"false","ShowDrivingDistance":"false","ReferenceCoordinates":null,"SearchWordOption":null,"GeocodeOnly":"true","IPAddress":null,"ConfidenceLevel":null,"ReferenceLocation":null,"RankingSource":null,"ShowAllAttributes":null,"ShowAllProperties":null,"ShowAllDepartments":null,"AttributeCdCSV":null,"PropertyCdCSV":null,"DepartmentCdCSV":null,"FirstName":null,"LastName":null,"VIN":null,"GeocodeIfNotFound":"false","ServiceDomain":null,"SearchWordType":null,"LocationName":null,"AppIdParent":null,"OutPut":"json","Input":null,"RelationshipPOIOnly":"false","RequestID":null},"GeoCodeResults":{"Latitude":"33.8396186828613","Longitude":"-118.353973388672","Locations":{"Location":[{"Type":"Postcode1","Latitude":"33.8396186828613","Longitude":"-118.353973388672","Name":"90503, CA","Address":null,"City":"Torrance","State":"CA","ZipCode":"90503","Country":"United States","Confidence":"High","MatchCode":"Good"}]}},"CacheStatus":{"FromCache":"true","WhenCached":"11/03/2022 6:33:58 AM"},"TraceId":"9fd2e4a5-a3e6-493d-9ed7-371bc38d486d&#124;10.177.9.60","DebugLog":{"LogMessage":[{"level":"INFORMATIONAL","text":"BEGIN: POIPrivateController.Get"},{"level":"INFORMATIONAL","text":"Processing Thread: 125"},{"level":"INFORMATIONAL","text":"BEGIN: POIPrivateController.Get"},{"level":"INFORMATIONAL","text":"Inputs: poiRequest - <?xml version=\"1.0\" encoding=\"utf-16\"?>\n<POIRequest xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" appid=\"bodyshops.honda.com\">\n    <POIId />\n    <SearchWord />\n    <Address />\n    <ZipCode>90503</ZipCode>\n    <Country />\n    <Culture />\n    <POIName />\n    <POIIdent />\n    <POIType>A</POIType>\n    <Filters />\n    <SearchRadius />\n    <BoundingBox />\n    <Latitude />\n    <Longitude />\n    <NumberOfPOIs />\n    <POIGroupSize />\n    <SortByPOIName>false</SortByPOIName>\n    <SortOrderByAttribute />\n    <StateOnly>false</StateOnly>\n    <ShowDrivingDistance>false</ShowDrivingDistance>\n    <ReferenceCoordinates />\n    <SearchWordOption />\n    <GeocodeOnly>true</GeocodeOnly>\n    <IPAddress />\n    <ConfidenceLevel />\n    <ReferenceLocation />\n    <RankingSource />\n    <ShowAllAttributes />\n    <ShowAllProperties />\n    <ShowAllDepartments />\n    <AttributeCdCSV />\n    <PropertyCdCSV />\n    <DepartmentCdCSV />\n    <FirstName />\n    <LastName />\n    <VIN />\n    <GeocodeIfNotFound>false</GeocodeIfNotFound>\n    <ServiceDomain />\n    <SearchWordType />\n    <LocationName />\n    <AppIdParent />\n    <OutPut>json</OutPut>\n    <Input />\n    <RelationshipPOIOnly>false</RelationshipPOIOnly>\n    <RequestID />\n</POIRequest>"},{"level":"INFORMATIONAL","text":"BEGIN: POIPrivateController.POIExecute"},{"level":"INFORMATIONAL","text":"BEGIN: POIPrivateController.SetPOIRequestDefaultValues"},{"level":"INFORMATIONAL","text":"POIRequest Object Inputs: poiRequest - <?xml version=\"1.0\" encoding=\"utf-16\"?>\n<POIRequest xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" appid=\"bodyshops.honda.com\">\n    <POIId />\n    <SearchWord />\n    <Address />\n    <ZipCode>90503</ZipCode>\n    <Country />\n    <Culture />\n    <POIName />\n    <POIIdent />\n    <POIType>A</POIType>\n    <Filters />\n    <SearchRadius />\n    <BoundingBox />\n    <Latitude />\n    <Longitude />\n    <NumberOfPOIs />\n    <POIGroupSize />\n    <SortByPOIName>false</SortByPOIName>\n    <SortOrderByAttribute />\n    <StateOnly>false</StateOnly>\n    <ShowDrivingDistance>false</ShowDrivingDistance>\n    <ReferenceCoordinates />\n    <SearchWordOption />\n    <GeocodeOnly>true</GeocodeOnly>\n    <IPAddress />\n    <ConfidenceLevel />\n    <ReferenceLocation />\n    <RankingSource />\n    <ShowAllAttributes />\n    <ShowAllProperties />\n    <ShowAllDepartments />\n    <AttributeCdCSV />\n    <PropertyCdCSV />\n    <DepartmentCdCSV />\n    <FirstName />\n    <LastName />\n    <VIN />\n    <GeocodeIfNotFound>false</GeocodeIfNotFound>\n    <ServiceDomain>staging.location.services.honda.com</ServiceDomain>\n    <SearchWordType />\n    <LocationName />\n    <AppIdParent />\n    <OutPut>json</OutPut>\n    <Input>&lt;?xml version=\"1.0\" encoding=\"utf-16\"?&gt;\n&lt;POIRequest xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" appid=\"bodyshops.honda.com\"&gt;\n    &lt;POIId /&gt;\n    &lt;SearchWord /&gt;\n    &lt;Address /&gt;\n    &lt;ZipCode&gt;90503&lt;/ZipCode&gt;\n    &lt;Country /&gt;\n    &lt;Culture /&gt;\n    &lt;POIName /&gt;\n    &lt;POIIdent /&gt;\n    &lt;POIType&gt;A&lt;/POIType&gt;\n    &lt;Filters /&gt;\n    &lt;SearchRadius /&gt;\n    &lt;BoundingBox /&gt;\n    &lt;Latitude /&gt;\n    &lt;Longitude /&gt;\n    &lt;NumberOfPOIs /&gt;\n    &lt;POIGroupSize /&gt;\n    &lt;SortByPOIName&gt;false&lt;/SortByPOIName&gt;\n    &lt;SortOrderByAttribute /&gt;\n    &lt;StateOnly&gt;false&lt;/StateOnly&gt;\n    &lt;ShowDrivingDistance&gt;false&lt;/ShowDrivingDistance&gt;\n    &lt;ReferenceCoordinates /&gt;\n    &lt;SearchWordOption /&gt;\n    &lt;GeocodeOnly&gt;true&lt;/GeocodeOnly&gt;\n    &lt;IPAddress /&gt;\n    &lt;ConfidenceLevel /&gt;\n    &lt;ReferenceLocation /&gt;\n    &lt;RankingSource /&gt;\n    &lt;ShowAllAttributes /&gt;\n    &lt;ShowAllProperties /&gt;\n    &lt;ShowAllDepartments /&gt;\n    &lt;AttributeCdCSV /&gt;\n    &lt;PropertyCdCSV /&gt;\n    &lt;DepartmentCdCSV /&gt;\n    &lt;FirstName /&gt;\n    &lt;LastName /&gt;\n    &lt;VIN /&gt;\n    &lt;GeocodeIfNotFound&gt;false&lt;/GeocodeIfNotFound&gt;\n    &lt;ServiceDomain /&gt;\n    &lt;SearchWordType /&gt;\n    &lt;LocationName /&gt;\n    &lt;AppIdParent /&gt;\n    &lt;OutPut&gt;json&lt;/OutPut&gt;\n    &lt;Input /&gt;\n    &lt;RelationshipPOIOnly&gt;false&lt;/RelationshipPOIOnly&gt;\n    &lt;RequestID /&gt;\n&lt;/POIRequest&gt;</Input>\n    <RelationshipPOIOnly>false</RelationshipPOIOnly>\n    <RequestID />\n</POIRequest>"},{"level":"PERFORMANCE","text":"Method SetPOIRequestDefaultValues took 0.6385 milliseconds (ms)"},{"level":"INFORMATIONAL","text":"END: POIPrivateController.SetPOIRequestDefaultValues"},{"level":"INFORMATIONAL","text":"BEGIN: POIPrivateController.ValidateInputs"},{"level":"PERFORMANCE","text":"Method ValidateInputs took 0.997 milliseconds (ms)"},{"level":"INFORMATIONAL","text":"END: POIPrivateController.ValidateInputs"},{"level":"INFORMATIONAL","text":"BEGIN: POIManager.GetPOIs"},{"level":"INFORMATIONAL","text":"POIRequest Object Inputs: request - <?xml version=\"1.0\" encoding=\"utf-16\"?>\n<POIRequest xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" appid=\"bodyshops.honda.com\">\n    <POIId />\n    <SearchWord />\n    <Address />\n    <ZipCode>90503</ZipCode>\n    <Country>US</Country>\n    <Culture>en-US</Culture>\n    <POIName />\n    <POIIdent />\n    <POIType>A</POIType>\n    <Filters />\n    <SearchRadius>250</SearchRadius>\n    <BoundingBox />\n    <Latitude />\n    <Longitude />\n    <NumberOfPOIs>25</NumberOfPOIs>\n    <POIGroupSize>5</POIGroupSize>\n    <SortByPOIName>false</SortByPOIName>\n    <SortOrderByAttribute />\n    <StateOnly>false</StateOnly>\n    <ShowDrivingDistance>false</ShowDrivingDistance>\n    <ReferenceCoordinates />\n    <SearchWordOption />\n    <GeocodeOnly>true</GeocodeOnly>\n    <IPAddress />\n    <ConfidenceLevel />\n    <ReferenceLocation />\n    <RankingSource />\n    <ShowAllAttributes>true</ShowAllAttributes>\n    <ShowAllProperties>true</ShowAllProperties>\n    <ShowAllDepartments>true</ShowAllDepartments>\n    <AttributeCdCSV />\n    <PropertyCdCSV />\n    <DepartmentCdCSV />\n    <FirstName />\n    <LastName />\n    <VIN />\n    <GeocodeIfNotFound>false</GeocodeIfNotFound>\n    <ServiceDomain>staging.location.services.honda.com</ServiceDomain>\n    <SearchWordType />\n    <LocationName />\n    <AppIdParent />\n    <OutPut>json</OutPut>\n    <Input>&lt;?xml version=\"1.0\" encoding=\"utf-16\"?&gt;\n&lt;POIRequest xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" appid=\"bodyshops.honda.com\"&gt;\n    &lt;POIId /&gt;\n    &lt;SearchWord /&gt;\n    &lt;Address /&gt;\n    &lt;ZipCode&gt;90503&lt;/ZipCode&gt;\n    &lt;Country /&gt;\n    &lt;Culture /&gt;\n    &lt;POIName /&gt;\n    &lt;POIIdent /&gt;\n    &lt;POIType&gt;A&lt;/POIType&gt;\n    &lt;Filters /&gt;\n    &lt;SearchRadius /&gt;\n    &lt;BoundingBox /&gt;\n    &lt;Latitude /&gt;\n    &lt;Longitude /&gt;\n    &lt;NumberOfPOIs /&gt;\n    &lt;POIGroupSize /&gt;\n    &lt;SortByPOIName&gt;false&lt;/SortByPOIName&gt;\n    &lt;SortOrderByAttribute /&gt;\n    &lt;StateOnly&gt;false&lt;/StateOnly&gt;\n    &lt;ShowDrivingDistance&gt;false&lt;/ShowDrivingDistance&gt;\n    &lt;ReferenceCoordinates /&gt;\n    &lt;SearchWordOption /&gt;\n    &lt;GeocodeOnly&gt;true&lt;/GeocodeOnly&gt;\n    &lt;IPAddress /&gt;\n    &lt;ConfidenceLevel /&gt;\n    &lt;ReferenceLocation /&gt;\n    &lt;RankingSource /&gt;\n    &lt;ShowAllAttributes /&gt;\n    &lt;ShowAllProperties /&gt;\n    &lt;ShowAllDepartments /&gt;\n    &lt;AttributeCdCSV /&gt;\n    &lt;PropertyCdCSV /&gt;\n    &lt;DepartmentCdCSV /&gt;\n    &lt;FirstName /&gt;\n    &lt;LastName /&gt;\n    &lt;VIN /&gt;\n    &lt;GeocodeIfNotFound&gt;false&lt;/GeocodeIfNotFound&gt;\n    &lt;ServiceDomain /&gt;\n    &lt;SearchWordType /&gt;\n    &lt;LocationName /&gt;\n    &lt;AppIdParent /&gt;\n    &lt;OutPut&gt;json&lt;/OutPut&gt;\n    &lt;Input /&gt;\n    &lt;RelationshipPOIOnly&gt;false&lt;/RelationshipPOIOnly&gt;\n    &lt;RequestID /&gt;\n&lt;/POIRequest&gt;</Input>\n    <RelationshipPOIOnly>false</RelationshipPOIOnly>\n    <RequestID />\n</POIRequest>"},{"level":"INFORMATIONAL","text":"BEGIN: POIManager.GetPOIByZip"},{"level":"INFORMATIONAL","text":"BEGIN: POIManager.PopulateSorting"},{"level":"INFORMATIONAL","text":"Inputs: poiSearch - POISearchByZip"},{"level":"INFORMATIONAL","text":"BEGIN: POIManager.ValidateInput"},{"level":"INFORMATIONAL","text":"Inputs: poiSearchType - POISearchByZip"},{"level":"PERFORMANCE","text":"Method ValidateInput took 0.0275 milliseconds (ms)"},{"level":"INFORMATIONAL","text":"END: POIManager.ValidateInput"},{"level":"PERFORMANCE","text":"Method PopulateSorting took 0.0688 milliseconds (ms)"},{"level":"INFORMATIONAL","text":"END: POIManager.PopulateSorting"},{"level":"PERFORMANCE","text":"Method GetPOIByZip took 32.9124 milliseconds (ms)"},{"level":"INFORMATIONAL","text":"END: POIManager.GetPOIByZip"},{"level":"INFORMATIONAL","text":"BEGIN: POIManager.CalculateDrivingDistance"},{"level":"INFORMATIONAL","text":"BEGIN: POIManager.IsDrivingDistanceExists"},{"level":"PERFORMANCE","text":"Method IsDrivingDistanceExists took 0.0033 milliseconds (ms)"},{"level":"INFORMATIONAL","text":"END: POIManager.IsDrivingDistanceExists"},{"level":"PERFORMANCE","text":"Method CalculateDrivingDistance took 0.0266 milliseconds (ms)"},{"level":"INFORMATIONAL","text":"END: POIManager.CalculateDrivingDistance"},{"level":"PERFORMANCE","text":"Method GetPOIs took 33.0734 milliseconds (ms)"},{"level":"INFORMATIONAL","text":"END: POIManager.GetPOIs"},{"level":"INFORMATIONAL","text":"BEGIN: POIPrivateController.CreateOutputResponse"},{"level":"INFORMATIONAL","text":"BEGIN: POIPrivateController.AddResponseWithPOIRequest"},{"level":"INFORMATIONAL","text":"BEGIN: POIPrivateController.AddResponseWithTraceId"},{"level":"PERFORMANCE","text":"Method AddResponseWithTraceId took 0.007 milliseconds (ms)"},{"level":"INFORMATIONAL","text":"END: POIPrivateController.AddResponseWithTraceId"},{"level":"INFORMATIONAL","text":"BEGIN: POIPrivateController.AddResponseWithAppId"},{"level":"PERFORMANCE","text":"Method AddResponseWithAppId took 0.1097 milliseconds (ms)"},{"level":"INFORMATIONAL","text":"END: POIPrivateController.AddResponseWithAppId"},{"level":"PERFORMANCE","text":"Method AddResponseWithPOIRequest took 0.2949 milliseconds (ms)"},{"level":"INFORMATIONAL","text":"END: POIPrivateController.AddResponseWithPOIRequest"},{"level":"PERFORMANCE","text":"Method CreateOutputResponse took 0.4567 milliseconds (ms)"},{"level":"INFORMATIONAL","text":"END: POIPrivateController.CreateOutputResponse"},{"level":"PERFORMANCE","text":"Method POIExecute took 35.2755 milliseconds (ms)"},{"level":"INFORMATIONAL","text":"END: POIPrivateController.POIExecute"},{"level":"PERFORMANCE","text":"Request Get took 35.4266 milliseconds (ms)"},{"level":"INFORMATIONAL","text":"END: POIPrivateController.Get"}]}}}';
        response.setBody(respBody);
        response.setStatusCode(200);
        return response; 
    }
}