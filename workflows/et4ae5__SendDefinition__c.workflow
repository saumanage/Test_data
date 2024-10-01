<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>et4ae5__EmailSendStatus</fullName>
        <description>Send Email Notification of Completed Send</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>et4ae5__ExactTarget/et4ae5__ETSendDone</template>
    </alerts>
    <alerts>
        <fullName>et4ae5__SendFailed</fullName>
        <description>Send Email Notification of Failed Send</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>et4ae5__ExactTarget/et4ae5__ETSendDone</template>
    </alerts>
    <fieldUpdates>
        <fullName>et4ae5__DelayedSend</fullName>
        <field>et4ae5__TriggerDelayedSend__c</field>
        <literalValue>1</literalValue>
        <name>DelayedSend</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>et4ae5__FailBackupWorkflow</fullName>
        <field>et4ae5__SendStatus__c</field>
        <literalValue>Failed</literalValue>
        <name>FailBackupWorkflow</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>true</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>et4ae5__FailBackupWorkflowM</fullName>
        <field>et4ae5__Messages__c</field>
        <formula>$Label.et4ae5__errorNoRes</formula>
        <name>FailBackupWorkflowM</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>true</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>et4ae5__PopulateBackupWorkflow</fullName>
        <field>et4ae5__BackupWorkflow__c</field>
        <formula>IF(ISBLANK(et4ae5__Scheduled_Date_Time__c), now()+(1/96), IF(now()&gt;et4ae5__Scheduled_Date_Time__c,now()+(1/96),et4ae5__Scheduled_Date_Time__c+(1/96)))</formula>
        <name>PopulateBackupWorkflow</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>et4ae5__SendClassFrom</fullName>
        <field>et4ae5__FromEmail__c</field>
        <formula>et4ae5__FromAddress__c</formula>
        <name>SendClassFrom</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>true</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>et4ae5__SendComplete</fullName>
        <field>et4ae5__SendStatus__c</field>
        <literalValue>Completed</literalValue>
        <name>SendComplete</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>et4ae5__SendStatusDateTime</fullName>
        <field>et4ae5__Status_Date_Time__c</field>
        <formula>now()</formula>
        <name>SendStatusDateTime</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>et4ae5__SetConversationId</fullName>
        <field>et4ae5__ConversationId__c</field>
        <formula>$Organization.Id+Id</formula>
        <name>SetConversationId</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>et4ae5__TrackingAsOfSD</fullName>
        <field>et4ae5__Tracking_As_Of__c</field>
        <formula>LastModifiedDate</formula>
        <name>TrackingAsOfSD</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>true</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>et4ae5__UnpopulateBackupWorkflow</fullName>
        <field>et4ae5__BackupWorkflow__c</field>
        <name>UnpopulateBackupWorkflow</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>BackupWorkflow</fullName>
        <active>false</active>
        <criteriaItems>
            <field>et4ae5__SendDefinition__c.et4ae5__BackupWorkflow__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>et4ae5__UnpopulateBackupWorkflow</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>et4ae5__SendDefinition__c.et4ae5__BackupWorkflow__c</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>ScheduledSend</fullName>
        <active>false</active>
        <criteriaItems>
            <field>et4ae5__SendDefinition__c.et4ae5__Scheduled_Date_Time__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>et4ae5__DelayedSend</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>et4ae5__SendDefinition__c.et4ae5__Scheduled_Date_Time__c</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>et4ae5__FailBackupWorkflow</fullName>
        <active>false</active>
        <description>This workflow rule is now deprecated. Please deactivate this workflow rule.</description>
        <formula>ISBLANK(&apos;DEPRECATED&apos;)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>et4ae5__PopulateBackupWorkflow</fullName>
        <active>false</active>
        <description>This workflow rule is now deprecated. Please deactivate this workflow rule.</description>
        <formula>ISBLANK(&apos;DEPRECATED&apos;)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>et4ae5__SendClassFrom</fullName>
        <active>false</active>
        <description>This workflow rule is now deprecated. Please deactivate this workflow rule.</description>
        <formula>ISBLANK(&apos;DEPRECATED&apos;)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>et4ae5__SendComplete</fullName>
        <active>false</active>
        <description>This workflow rule is now deprecated. Please deactivate this workflow rule.</description>
        <formula>ISBLANK(&apos;DEPRECATED&apos;)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>et4ae5__SendFailed</fullName>
        <active>false</active>
        <description>This workflow rule is now deprecated. Please deactivate this workflow rule.</description>
        <formula>ISBLANK(&apos;DEPRECATED&apos;)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>et4ae5__SendStatusDateTime</fullName>
        <active>false</active>
        <description>This workflow rule is now deprecated. Please deactivate this workflow rule.</description>
        <formula>ISBLANK(&apos;DEPRECATED&apos;)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>et4ae5__SetConversationId</fullName>
        <active>false</active>
        <description>This workflow rule is now deprecated. Please deactivate this workflow rule.</description>
        <formula>ISBLANK(&apos;DEPRECATED&apos;)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>et4ae5__TrackingAsOfSD</fullName>
        <active>false</active>
        <description>This workflow rule is now deprecated. Please deactivate this workflow rule.</description>
        <formula>ISBLANK(&apos;DEPRECATED&apos;)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
