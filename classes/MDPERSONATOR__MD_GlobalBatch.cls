/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class MD_GlobalBatch implements Database.AllowsCallouts, Database.Batchable<SObject> {
    global String destQuery;
    global Boolean disableAddress;
    global Boolean disableEmail;
    global Boolean disableName;
    global Boolean disablePhone;
    global Boolean processAll;
    global String query;
    global Boolean updateContact;
    global MD_GlobalBatch(String q, Boolean updateContact, Boolean processAll) {

    }
    global MD_GlobalBatch(String q, String dest, Boolean updateContact, Boolean processAll) {

    }
    global void execute(Database.BatchableContext bc, List<SObject> scope) {

    }
    global void finish(Database.BatchableContext bc) {

    }
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return null;
    }
}
