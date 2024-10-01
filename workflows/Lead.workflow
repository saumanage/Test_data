<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Send_Email_alert_to_Lead_creation_latest</fullName>
        <description>Send Email alert to Lead creation latest</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <senderAddress>yourhonda@ebizmail.honda.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>HELMS_Automated/WebToLeadEmailAlertTemplate</template>
    </alerts>
    <fieldUpdates>
        <fullName>Auto_populating_Preferred_Dealer_Number</fullName>
        <description>Auto populating Preferred Dealer Number</description>
        <field>PreferredDealerNumber_NUM__c</field>
        <formula>PreferredDealerAccount_ID__r.DealerCode_CD__c</formula>
        <name>Auto populating Preferred Dealer Number</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Dealer_Status_Reason_To_Blank</fullName>
        <field>StatusReason_TXT__c</field>
        <name>Dealer Status Reason To Blank</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_LeadStatus</fullName>
        <field>Status</field>
        <literalValue>Closed - Not Converted</literalValue>
        <name>Update Lead Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Lead_Status</fullName>
        <field>Status</field>
        <literalValue>Closed - Not Converted</literalValue>
        <name>Update Lead Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Status_Reason_to_Blank</fullName>
        <field>StatusReason_TXT__c</field>
        <name>Update Status Reason to Blank</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>set_ifFirstName_to_true</fullName>
        <field>IsFirstName_FLG__c</field>
        <literalValue>1</literalValue>
        <name>set ifFirstName to true</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>set_isFirstName_to_false</fullName>
        <field>IsFirstName_FLG__c</field>
        <literalValue>0</literalValue>
        <name>set isFirstName to false</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Auto populating Preferred Dealer Number for Lead object</fullName>
        <actions>
            <name>Auto_populating_Preferred_Dealer_Number</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Auto populating Preferred Dealer Number for Lead object</description>
        <formula>ISBLANK(PreferredDealerNumber_NUM__c) &amp;&amp;    NOT( ISBLANK(PreferredDealerAccount_ID__c)) &amp;&amp; $Setup.BypassAutomations__c.BypassWorkflowRule__c =false</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Duplicate Merged</fullName>
        <actions>
            <name>Update_Lead_Status</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Will run when Duplicate Merged is selected on the Status Reason field</description>
        <formula>ISPICKVAL(StatusReason_TXT__c , &apos;Duplicate Merged&apos;) &amp;&amp; $Setup.BypassAutomations__c.BypassWorkflowRule__c = false</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Name Error</fullName>
        <actions>
            <name>Update_LeadStatus</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Will run when Name Error is selected on the Status Reason field</description>
        <formula>ISPICKVAL(StatusReason_TXT__c , &apos;Name Error&apos;) &amp;&amp; $Setup.BypassAutomations__c.BypassWorkflowRule__c = false</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Name blank</fullName>
        <actions>
            <name>set_isFirstName_to_false</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>(ISBLANK(FirstName) || ISBLANK( LastName )) &amp;&amp; $Setup.BypassAutomations__c.BypassWorkflowRule__c = false</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Name not blank</fullName>
        <actions>
            <name>set_ifFirstName_to_true</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>NOT(ISBLANK( FirstName ))  &amp;&amp;   NOT(ISBLANK( LastName) )  &amp;&amp; $Setup.BypassAutomations__c.BypassWorkflowRule__c = false</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Lead Provider Error to Blank</fullName>
        <actions>
            <name>Update_Status_Reason_to_Blank</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>AND( $Setup.BypassAutomations__c.BypassWorkflowRule__c =false, NOT(ISPICKVAL( StatusReason_TXT__c , &apos;Waiting for the routing window to start&apos;)), NOT( ISBLANK(LeadProvider_ID__c)),  NOT( ISBLANK(PreferredDealerAccount_ID__c) ), ISPICKVAL( PRIORVALUE(StatusReason_TXT__c) , &apos;Lead Provider error&apos;) || ISPICKVAL( PRIORVALUE(StatusReason_TXT__c) , &apos;Unable to assign Dealer&apos;) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Preferred Dealer Error to Blank</fullName>
        <actions>
            <name>Dealer_Status_Reason_To_Blank</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>AND( $Setup.BypassAutomations__c.BypassWorkflowRule__c =false,    NOT(ISNULL(PreferredDealerAccount_ID__c)) ||  NOT(ISNULL(PreferredDealerNumber_NUM__c)),   ISPICKVAL( PRIORVALUE(StatusReason_TXT__c)  , &apos;Unable to assign Dealer&apos;)  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>WebToLeadAlert</fullName>
        <actions>
            <name>Send_Email_alert_to_Lead_creation_latest</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>Send email to Lead Creation</description>
        <formula>LeadProvider_ID__r.WebtoLeadAllowed_FLG__c = true &amp;&amp; $Setup.BypassAutomations__c.BypassWorkflowRule__c =false</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
