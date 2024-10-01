/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class MD_ExpressEntry {
    global String cancelURL {
        get;
        set;
    }
    global String city {
        get;
        set;
    }
    global String ctrySubdivision {
        get;
        set;
    }
    global String deliveryAddress {
        get;
        set;
    }
    global String disableEE {
        get;
        set;
    }
    global Boolean isSaved {
        get;
        set;
    }
    global String mapSelect {
        get;
        set;
    }
    global String numSelect {
        get;
        set;
    }
    global String objectID {
        get;
        set;
    }
    global String objectPrefix {
        get;
        set;
    }
    global String recordWhat;
    global String retURL {
        get;
        set;
    }
    global String rType {
        get;
        set;
    }
    global String state {
        get;
        set;
    }
    global String zip {
        get;
        set;
    }
    global MD_ExpressEntry() {

    }
    global MD_ExpressEntry(ApexPages.StandardController controller) {

    }
    webService static void consumeCredits() {

    }
    global static String doParseTokenResponseWS(System.HttpResponse res) {
        return null;
    }
    global void fetchStored() {

    }
    global String getEEMinLookup() {
        return null;
    }
    global String getEEToggleCase() {
        return null;
    }
    @AuraEnabled
    webService static String getExpressToken() {
        return null;
    }
    @AuraEnabled
    global static String getResponse(String request) {
        return null;
    }
    @AuraEnabled
    global static String getResponseFromLightning(String searchString) {
        return null;
    }
    global String getSavedEECountry() {
        return null;
    }
    webService static void globalConsumeCredits() {

    }
    global System.PageReference redirect() {
        return null;
    }
    global void refreshToken() {

    }
    global System.PageReference save() {
        return null;
    }
    global void setSavedEECountry(String savedEECountry) {

    }
    @AuraEnabled
    global static String updateRecord(Id recordId, String fieldMap) {
        return null;
    }
    global void updateRecord() {

    }
}
