<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>SendNewLeadProviderNotfcationToECRM</fullName>
        <ccEmails>campaign_management@ahm.honda.com,ahm_ecrm_group@ahm.honda.com</ccEmails>
        <description>SendNewLeadProviderNotfcationToECRM</description>
        <protected>false</protected>
        <senderAddress>helms@ahm.honda.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>HELMS_Automated/New_Provider</template>
    </alerts>
    <fieldUpdates>
        <fullName>Account_Launchbox_Field_Update</fullName>
        <field>Launchbox_ID__c</field>
        <formula>DealerCode_CD__c</formula>
        <name>Account_Launchbox_Field_Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Provider_RT_Is_Active_flag_is_true</fullName>
        <description>Provider Account record (rt = Provider), set the IsActive flag as true per default.</description>
        <field>IsActive_CD__c</field>
        <literalValue>1</literalValue>
        <name>Provider RT- Is Active flag is true</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Updating_ISACTIVE_Flag_is_False</fullName>
        <description>Updating ISACTIVE Flag is False</description>
        <field>IsActive_CD__c</field>
        <literalValue>0</literalValue>
        <name>Updating ISACTIVE Flag is False</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Account_Launchbox_Field_Update</fullName>
        <actions>
            <name>Account_Launchbox_Field_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>AND($Setup.BypassAutomations__c.BypassWorkflowRule__c = false , NOT( ISBLANK( DealerCode_CD__c ) ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Provider RT - Is Active is False</fullName>
        <actions>
            <name>Updating_ISACTIVE_Flag_is_False</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Account record (rt = Provider) and Provider is equal to Inactive  then ISAcctive flag is false</description>
        <formula>AND(RecordType.DeveloperName = &apos;Provider&apos;, ProviderStatus_TXT__c =&apos;Inactive&apos;, NOT(ISNULL(ProviderStatus_TXT__c)) ,$Setup.BypassAutomations__c.BypassWorkflowRule__c = false)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Provider RT - Is Active is True</fullName>
        <actions>
            <name>Provider_RT_Is_Active_flag_is_true</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Account record (rt = Provider) and Provider is not equal to Inactive  then ISAcctive flag is true</description>
        <formula>AND( NOT($Setup.BypassAutomations__c.BypassWorkflowRule__c), RecordType.DeveloperName =&apos;Provider&apos;, NOT(ProviderStatus_TXT__c =&apos;Inactive&apos;), NOT(ISNULL(ProviderStatus_TXT__c )) )</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
