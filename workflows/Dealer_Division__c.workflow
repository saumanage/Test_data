<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Lead_Enrollment_Date</fullName>
        <description>This is to update Lead Enrollment date as current date when Lead Enrollment Flag checked true.</description>
        <field>Lead_Enrollment_Date__c</field>
        <formula>TODAY()</formula>
        <name>Lead Enrollment Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ToUpdateLeadEnrollementDate</fullName>
        <field>Lead_Enrollment_Date__c</field>
        <name>ToUpdateLeadEnrollementDate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>ToUpdateLeadEnrollementDate</fullName>
        <actions>
            <name>Lead_Enrollment_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>$Setup.BypassAutomations__c.BypassWorkflowRule__c =False &amp;&amp; InternetCertified_FLG__c =True</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ToUpdateLeadEnrollementDateToBlank</fullName>
        <actions>
            <name>ToUpdateLeadEnrollementDate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>when ever Lead Enrollment Flag is unchecked then Lead Enrollment date is blank</description>
        <formula>$Setup.BypassAutomations__c.BypassWorkflowRule__c =False &amp;&amp; InternetCertified_FLG__c =False</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
