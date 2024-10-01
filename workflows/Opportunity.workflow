<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Email_alert_for_opptys_not_routed</fullName>
        <ccEmails>HELMS@ahm.honda.com</ccEmails>
        <description>Email alert for opptys not routed</description>
        <protected>false</protected>
        <recipients>
            <recipient>HELMS_Core_Team</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>HELMS_Automated/Opportunity_Routing_Status_Blank_template</template>
    </alerts>
    <alerts>
        <fullName>SendSurvey</fullName>
        <description>SendSurvey</description>
        <protected>false</protected>
        <recipients>
            <field>Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>helms@ahm.honda.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>unfiled$public/SendWonSurvey</template>
    </alerts>
    <fieldUpdates>
        <fullName>Business_Hours_Reset</fullName>
        <description>Set the business hours to zero to reset the SLA calculation clock</description>
        <field>Business_Hours_Elasped__c</field>
        <formula>0</formula>
        <name>Business Hours Reset</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_SLA_Status</fullName>
        <description>Change SLA Level to NO escalation whenever routing status gets to success</description>
        <field>Service_Level_Agreement_TXT__c</field>
        <literalValue>No Escalation</literalValue>
        <name>Change SLA Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Populate_Dealer_Number</fullName>
        <description>This field update action updates the Preferred dealer number from the Preferred dealer accounts.Dealer Number</description>
        <field>PreferredDealerNumber_NUM__c</field>
        <formula>PreferredDealerAccount_TXT__r.DealerCode_CD__c</formula>
        <name>Populate Dealer Number</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Routing_Status_Success_Date_Calculation</fullName>
        <field>Routing_Success_Date_Time__c</field>
        <formula>now()</formula>
        <name>Routing Status Success Date Calculation</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_Reason_Checked</fullName>
        <field>Duplicate_Similar__c</field>
        <literalValue>1</literalValue>
        <name>Status Reason Checked</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>update_Oppty_name</fullName>
        <field>Name</field>
        <formula>First_Name_TXT__c &amp; &apos; &apos; &amp;  Last_Name_TXT__c &amp; &apos; &apos; &amp;  Product_TXT__c</formula>
        <name>update Oppty name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Check Duplicate Similar</fullName>
        <actions>
            <name>Status_Reason_Checked</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.StatusReason_TXT__c</field>
            <operation>equals</operation>
            <value>Duplicate Similar</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Email for blank routing opportunities</fullName>
        <active>false</active>
        <description>This workflow sends emails for opportunities where routing status is blank even if the opportunity is eligible for routing</description>
        <formula>Routable_FLG__c = true &amp;&amp;   TEXT(Routing_Status__c)=&apos;&apos; &amp;&amp;  $Setup.BypassAutomations__c.BypassWorkflowRule__c = false</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Email_alert_for_opptys_not_routed</name>
                <type>Alert</type>
            </actions>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Oppty workflow to populate Dealer Number</fullName>
        <actions>
            <name>Populate_Dealer_Number</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>PreferredDealerAccount_TXT__c  &lt;&gt; NULL  &amp;&amp;  (PreferredDealerNumber_NUM__c   =  NULL  ||  PreferredDealerAccount_TXT__r.DealerCode_CD__c  &lt;&gt;  PreferredDealerNumber_NUM__c ) &amp;&amp; $Setup.BypassAutomations__c.BypassWorkflowRule__c =false</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Routing Status Date and Age Calculation</fullName>
        <actions>
            <name>Business_Hours_Reset</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Change_SLA_Status</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Routing_Status_Success_Date_Calculation</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>AND(ISPICKVAL(Routing_Status__c , &apos;Success&apos;) ,$Setup.BypassAutomations__c.BypassWorkflowRule__c = false)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>update Oppty name</fullName>
        <actions>
            <name>update_Oppty_name</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>when a community dealer user updates the name or product related data, update the oppty name</description>
        <formula>$Setup.BypassAutomations__c.BypassWorkflowRule__c =false &amp;&amp; IF ( ISNEW(),AND( 		                ispickval(CreatedBy.UserType, &apos;PowerPartner&apos;), 			            OR( 						    ISCHANGED(Product_TXT__c), 						ISCHANGED( First_Name_TXT__c ), 						ischanged( Last_Name_TXT__c ) 					) 				       ),OR( 					        ISCHANGED(Product_TXT__c), 						ISCHANGED( First_Name_TXT__c ), 						ischanged( Last_Name_TXT__c ) )     )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
