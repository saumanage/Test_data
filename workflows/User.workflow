<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_User_Deactivation_Date</fullName>
        <field>Deactivated_Date__c</field>
        <formula>TODAY()</formula>
        <name>Update User Deactivation Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Update Deactivation Date</fullName>
        <actions>
            <name>Update_User_Deactivation_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>update the user deactivation date</description>
        <formula>AND( $Setup.BypassAutomations__c.BypassWorkflowRule__c=FALSE, (IsActive =false))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
