/**
 * The HELMSLeadEnrichment class is a schedulable class that runs every day at specified intervals.
 * It queries the Lead object for new records created today that have not been enriched and schedules the HELMSLeadEnrichmentRetryBatch class to process them.
 * @author Lee
 * @version 1.0
 * @since 2024-03-14
 */
global class HELMSLeadEnrichment implements Schedulable {
    global void execute(SchedulableContext SC) {
        String q = 'SELECT Name, FirstName, LastName, ContactKey_TXT__c, PostalCode FROM Lead WHERE Status = \'New\' AND CreatedDate = TODAY AND Enrichment_Receive_Date_Time__c = null';
        List<sObject> leads = Database.query(q);
        
        // Execute batch if query returned records.
        if (!leads.isEmpty()) {
            Id batchId = Database.executeBatch(new HELMSLeadEnrichmentRetryBatch(q, true), 1);
        }

        // Schedule the next job in 15 minutes.
        /*Datetime sysTime = System.now().addMinutes(15);
        String cronExp = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
        
        // But do not schedule the next job if we are running a test.
        if (!Test.isRunningTest()) {
            System.schedule('HELMSLeadEnrichment15 '+sysTime.month() + '/' + sysTime.day() + '/' + sysTime.year() + ' at ' +  sysTime.hour() + ':' + (String.valueOf(sysTime.minute()).length() == 1 ? '0' + String.valueOf(sysTime.minute()) : String.valueOf(sysTime.minute())), cronExp, new HELMSLeadEnrichment());
        }*/
    }
}