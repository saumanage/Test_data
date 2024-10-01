/**********************************************************************
Name: B2B_GetOrderExt
Purpose: Apex class is created to show external order details from HDM org in dealer console.
Created Date :  30/07/2021, 3:01 PM
Created By : Vikrant Upneja
Last Modified By :	RajRishi Kaushik ,  18/07/2022, 11:19 AM
Salesforce API Version : 55.0
*************************************************************/

public with sharing class B2B_GetOrderExt {
    @TestVisible private static List<Order__x> mockedOrder = new List<Order__x>();
    @AuraEnabled
    public static List<Order__x> OrderInfo(boolean pageurl,boolean pageurldirectship){
        String userid = UserInfo.getUserId();
        String contactid;
        String dealercode;       
        
        List<User> usrLst = new List<user>();
        if(!String.isEmpty(userid)){           
            usrLst = [SELECT ContactId from User WHERE Id=:userid];
            contactid=usrLst.get(0).ContactId;
        }
        if(!String.isEmpty(contactid)){
            List<Contact> dealercodelst = new List<Contact>();
            dealercodelst= [SELECT Account.DealerCode_CD__c FROM Contact WHERE Id=:contactid];
            dealercode=dealercodelst.get(0).Account.DealerCode_CD__c;
        }
        
        List<Order__x> orderlist = new List<Order__x>();
        
        //R2B changes for HDMP-10201 : added OrderReferenceNumber__c in Query
        if(!String.isEmpty(dealercode)){                
            if(pageurl == true && pageurldirectship == false){    //Modified by Divya for EVSE_Phase2_Sprint1 HDMP-24335           
                orderlist = (!mockedOrder.isEmpty()) ? mockedOrder : [SELECT Id, OrderReferenceNumber__c, OrderNumber__c, Delivery_Types_c__c, Updated_Order_Total_c__c, Total_Return_c__c, Total_Unavailable_AMT_c__c, SHIPPING_from_cart_c__c, Name__c, Customer_Name_c__c,
                            BillingPhoneNumber__c,Phone_No_c__c, Status__c, OrderedDate__c, GrandTotalAmount__c,Email_c__c, Type__c, Product_Division_c__c, AccountId__r.IsActive_c__c,BT_Transaction_Status_c__c,AccountId__r.PoIId_c__c,BT_Transaction_Id_c__c //added by suresh for PR    
                            FROM Order__x 
                            WHERE External_account_POID_c__c=:dealercode AND OrderedDate__c != NULL AND Type__c !=:B2B_Constants.DIRECTSHIP //Modified by Divya for EVSE_Phase2_Sprint1 HDMP-24335
                            AND (Status__c='Activated' OR Status__c='Partial Ship' 
                            OR Status__c='In Progress' OR Status__c='Ready for Pickup' 
                            OR Status__c='Payment Issue' OR Status__c='Order Issue' OR (Status__c='PARTIAL RETURN' AND Delivery_Types_c__c != 'Install At Dealer' AND isOrderPickedUp_c__c = false AND SHIPPING_from_cart_c__c = 0)) order by OrderedDate__c desc];              
            }else if(pageurl == true && pageurldirectship == true){ //Added by Divya for EVSE_Phase2_Sprint1 - START HDMP-24335               
                orderlist = (!mockedOrder.isEmpty()) ? mockedOrder : [SELECT Id, OrderReferenceNumber__c, OrderNumber__c, Delivery_Types_c__c, Updated_Order_Total_c__c, Total_Return_c__c, Total_Unavailable_AMT_c__c, SHIPPING_from_cart_c__c, Name__c, Customer_Name_c__c,
                            BillingPhoneNumber__c, Status__c, OrderedDate__c, GrandTotalAmount__c,Email_c__c, Type__c, Product_Division_c__c, AccountId__r.IsActive_c__c,BT_Transaction_Status_c__c,AccountId__r.PoIId_c__c,BT_Transaction_Id_c__c //added by suresh for PR     
                            FROM Order__x 
                            WHERE Dealer_Number_c__c=:dealercode AND OrderedDate__c != NULL AND Type__c =:B2B_Constants.DIRECTSHIP
                            AND (Status__c=:B2B_Constants.ACTIVATED OR Status__c=:B2B_Constants.PARTIAL_SHIP 
                            OR Status__c=:B2B_Constants.INPROGRESS OR Status__c=:B2B_Constants.PREPARING_FOR_SHIPMENT OR Status__c=:B2B_Constants.PROCESSING_IN_WAREHOUSE
                            OR Status__c=:B2B_Constants.PAYMENT_ISSUE OR Status__c=:B2B_Constants.ORDER_ISSUE) order by OrderedDate__c desc];//Modified by Divya for EVSE_Phase2_Sprint2
            }else {    //Added by Divya for EVSE_Phase2_Sprint1 - END HDMP-24335                            
                orderlist = (!mockedOrder.isEmpty()) ? mockedOrder : [SELECT Id, OrderReferenceNumber__c, OrderNumber__c, Delivery_Types_c__c, Updated_Order_Total_c__c, Total_Return_c__c, Total_Unavailable_AMT_c__c, SHIPPING_from_cart_c__c, Name__c, Customer_Name_c__c,
                            BillingPhoneNumber__c,Phone_No_c__c, Status__c, OrderedDate__c, GrandTotalAmount__c, Email_c__c, Type__c, Product_Division_c__c, AccountId__r.IsActive_c__c,BT_Transaction_Status_c__c,AccountId__r.PoIId_c__c,BT_Transaction_Id_c__c //added by suresh for PR   
                                        FROM Order__x 
                                        WHERE External_account_POID_c__c=:dealercode AND OrderedDate__c != NULL
                            AND (Status__c='ORDER COMPLETE - PICKED UP' OR Status__c='ORDER COMPLETE - SHIPPED' OR Status__c='CUSTOMER CANCELED' 
                            OR Status__c='ORDER RETURN' OR Status__c='DEALER REJECTED' OR Status__c='SYSTEM CANCELED' OR Status__c='ORDER COMPLETE - INSTALLED'
                            OR Status__c='DEALER CANCELED' OR (Status__c='PARTIAL RETURN' AND isOrderPickedUp_c__c = true AND SHIPPING_from_cart_c__c = 0) 
                            OR (Status__c='PARTIAL RETURN' AND SHIPPING_from_cart_c__c > 0) OR (Status__c='PARTIAL RETURN' AND Delivery_Types_c__c = 'Install At Dealer')) order by OrderedDate__c desc];
                
            }
        }
        
        return orderlist;
        
    }
    //Added this method to display message in Dealer Console for CAPS-4066
    @AuraEnabled
    public static Boolean showBTTokenMsg() {
        Boolean isBTTokenActive;
        List<Account__x> dealerList = new List<Account__x>();
        String userid = UserInfo.getUserId();
        String contactid;
        String dealercode;       
        
        List<User> usrLst = new List<user>();
        if(!String.isEmpty(userid)){           
            usrLst = [SELECT ContactId from User WHERE Id=:userid];
            contactid=usrLst.get(0).ContactId;
        }
        if(!String.isEmpty(contactid)){
            List<Contact> dealercodelst = new List<Contact>();
            dealercodelst= [SELECT Account.DealerCode_CD__c FROM Contact WHERE Id=:contactid];
            dealercode=dealercodelst.get(0).Account.DealerCode_CD__c;
        }        
        if(!String.isEmpty(dealercode)){
            dealerList = [SELECT Id,IsActive_c__c FROM Account__x where PoIId_c__c =:dealercode LIMIT 1];
            if(!dealerList.isEmpty()){
                isBTTokenActive = dealerList[0].IsActive_c__c;                
            }
        }
        return isBTTokenActive;
    }

}