<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Case_Owner_To_HELMS_Tier_2_Support_Queue</fullName>
        <field>OwnerId</field>
        <lookupValue>HELMS_Tier_2_Support</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Case Owner To HELMS Tier 2 Support Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case_Ownership_To_PSP_Queue</fullName>
        <field>OwnerId</field>
        <lookupValue>Powersports_Case_Queue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Case Ownership To PSP Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case_Ownership_to_Marine_Queue</fullName>
        <field>OwnerId</field>
        <lookupValue>Marine_Case_Queue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Case Ownership to Marine Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case_Ownership_to_Queue</fullName>
        <description>HELMS Tier 1 Support is Queue gets the ownership of case.</description>
        <field>OwnerId</field>
        <lookupValue>HELMS_Tier_1_Support</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Case Ownership to Queue</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Case Assignment For HELMS Tier 2 Support Queue</fullName>
        <actions>
            <name>Case_Owner_To_HELMS_Tier_2_Support_Queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>assigning case to HELMS Tier 2 Support Queue</description>
        <formula>AND (OR(ISPICKVAL(Type, &apos;CRM Switch&apos;) ,  ISPICKVAL( Origin , &apos;Email&apos;) , ISPICKVAL(Type, &apos;New CRM Vendor&apos;)),    NOT(ISPICKVAL(Type,&apos;New Dealer CRM&apos; ) ),  $Setup.BypassAutomations__c.BypassWorkflowRule__c = false)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Case Assignment Portal User</fullName>
        <actions>
            <name>Case_Ownership_to_Queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Used to assign cases to HELMS Tier 1 Support Queue</description>
        <formula>AND(NOT( Created_by_User_Division__c = &apos;P&apos;),NOT( Created_by_User_Division__c = &apos;M&apos;), NOT( ISPICKVAL( Type,&apos;New CRM Vendor&apos;))  ,NOT(ISPICKVAL( Type , &apos;CRM Switch&apos;)), NOT(ISPICKVAL( Origin , &apos;Email&apos;)),NOT( ISPICKVAL( Type ,&apos;New Dealer CRM&apos;) ) ,$Setup.BypassAutomations__c.BypassWorkflowRule__c = false)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Case Assignment for Marine Queue</fullName>
        <actions>
            <name>Case_Ownership_to_Marine_Queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>AND(Created_by_User_Division__c = &apos;P&apos;, NOT (ISPICKVAL(Type, &apos;CRM Switch&apos;)),  NOT( ISPICKVAL( Type ,&apos;New Dealer CRM&apos;) ) ,$Setup.BypassAutomations__c.BypassWorkflowRule__c = false)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Case Assignment for PSP Queue</fullName>
        <actions>
            <name>Case_Ownership_To_PSP_Queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>AND(Created_by_User_Division__c = &apos;M&apos;, NOT (ISPICKVAL(Type, &apos;CRM Switch&apos;)),NOT( ISPICKVAL( Type ,&apos;New Dealer CRM&apos;) ) , $Setup.BypassAutomations__c.BypassWorkflowRule__c = false)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
