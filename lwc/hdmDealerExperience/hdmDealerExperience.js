/*******************************************************************************
Name: hdmDealerExperience
Business Unit: <Insert business unit here>
Created Date: 7/30/2021, 12:33 PM
Developer: Vikrant Upneja
Description: LWC is created to handle UI and apex calling of dealer side for HDM org.
*******************************************************************************

MODIFICATIONS – Date | Dev Name     | Method | User Story
25/05/2022           | Faraz Ansari | handleAddDealerNote,handleGetAllDealerNotes | 8722
*******************************************************************************/

import { LightningElement,api ,wire,track } from 'lwc';
import updateExternalOrderItem from '@salesforce/apex/HDMDealerExperienceController.updateExternalOrderItem';
import updateExternalOrder from '@salesforce/apex/HDMDealerExperienceController.updateExternalOrder';
import OrderDetailshelper from '@salesforce/apex/HDMDealerExperienceController.OrderDetails';
import addDealerNotes from '@salesforce/apex/HDMDealerExperienceController.addExternalDealerNotes';
import getAllDealerNotes from '@salesforce/apex/HDMDealerExperienceController.getAllExternalDealerNotes';
import getTax from '@salesforce/apex/B2B_TaxHelper.getTaxRatesAndAmountsFromVertex';

import insertUpdateExternalOrdFullFilment from '@salesforce/apex/HDMDealerExperienceController.insertUpdateExternalOrdFullFilment';
import processHrcOrderRefund from '@salesforce/apex/B2B_HRCOrderProcess.processHrcOrderRefund'; //added for HRC modification
import createShipmentAuditTrails from '@salesforce/apex/B2B_HRCOrderProcess.createShipmentAuditTrails'; //added by  Rajrishi
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

const CORE_CHARGE = 'Core Charge'; // SP3-16544, Added by ashwin for US 16544
 

export default class HdmDealerExperience extends NavigationMixin(LightningElement) {
  
  @api recordId;

  @track isDealerInstall = false;
  @track isModalOpen = false;
  @track isShowOrderItems = false;
  @track isLoading = true;
  @track vendor; 
  @track flowLabel;
  @track isDirectShip = false;//Added by Divya for EVSE_Phase2_Sprint1
  //Changes by Divya and Tanisha for EVSE_Phase2_Sprint1 - START
  @track productName;
  @track partNumber;
  @track updatedQuantity;
  @track productMarketingName;
  @track orderItemStatus;
  @track shippedQuantity;
  @track vin;
  //Changes by Divya and Tanisha for EVSE_Phase2_Sprint1 - END

  //get the value from session to check from which page it cames.
  @track isOpenOrderPage = sessionStorage.getItem('isOpenOrders');

  //added for storing wired data
  @track objOrder;
  @track objOrderTemp;
  @track orderItems;
  @track coreChargeItems = []; // Added by Ashwin
  isCoreExist = false; //Added by ashwin for 19435
  @track wiredOrderList;
  @track lstOrderItems;
  @track errorMessage;
  @track shippingVender;
  @track trackingNumber;
  @track storedTrackingNumber;
  @track modalWidthStyle = 'max-width: 40rem;min-width: 40rem;';

  //Added for button rendering
  @track isShowInstallationButton = false;
  @track isPaymentIssueNeedAction =false; 
  @track isPaymentEmailSent = false;
  @track isShowReturnButton = false;
  @track isShowEditButton = false;
  @track isEditClicked = false;
  @track isCancelClicked = false;
  @track isPartialReturnClicked = false;
  @track isShowInProgressButton = false;
  @track isShowCancelButton = false;
  @track isShowMarkOrderShippedButton = false;
  @track isShowReadyForPickupButton = false;
  @track isShowOrderPickedUpButton = false;
  @track isShowModifyOrderButton = false;
  @track isModifyOrderClicked = false;
  @track isEntireReturnClicked = false;
  @track isLoadingForCancel = false;
  @track isShowModifyError = false;
  @track isShowShippingAddress = false;
  @track isPaymentIssue = false;
  @track isShippingError = false;
  @track isOtherSelected;
  @track isReturnError = false;
  @track isShowEditNotes = false;
  @track isInstallationReturn = false;
  @track isShowMoreInfo = false;//Changes by Divya HDMP-24337 

  @track isTaxCalculated = false;
  @track methodName;
  @track otherCarrier;
  @track isDealerAdminUser;  
  @track dealerNoteValue = '';//Added by Faraz for 8722
  @track orderExternalId = '';//Added by Faraz for 8722
  @track customerNoteValue = '';//Added by Faraz for 8722
  @track dealerNotesList = [];//Added by Faraz for 8722
  @track isDealerNotesExist = false;//Added by Faraz for 8722
  @track shippingvendor = [
    { label: 'UPS', value: 'UPS' },
    { label: 'USPS', value: 'USPS' },
    { label: 'FedEX', value: 'FedEX' },
    { label: 'Other', value: 'Other' }
  ];

  @track dealerShippingSpeed;
  @track dealerShippingSpeedOptions = [
    { label: 'Standard (7-10 Days)', value: 'Standard (7-10 Days)' },
    { label: 'Expedited (2-3 Days)', value: 'Expedited (2-3 Days)' },
    { label: 'Express (1-2 Days)', value: 'Express (1-2 Days)' }
  ];

  // variables for return
  @track defaultRestockFees = '0.00';
  @track shipRefundVal = '0.00';
  @track shipRetVal = 'YES';
  @track installReturnVal = 'YES';
  @track installFullReturnPrice = '0.00';
  @track totalRefund = '0.00';
  @track itemsReturnPrice = '0.00';
  @track returnTax;
  @track restockingFees;
  @track updatedShipRefundVal = '0.00';
  @track itemReturnTax = '0.00';
  @track installPriceWithTax = 0;
  @track isShowRestockingFees = false;
  @track shippingReturnOptions = [{ label: 'YES', value: 'YES' },{ label: 'NO', value: 'NO' }];
  @track resErrorMessage; 

  @track isActiveDealer = true;
  @track customerNotes;
  @track additionalOrderDetails;//Added by Divya HDMP-24337 
  @track orderItemId;

  @track coreChargeItems = []; // Added by Ashwin SP3 16544
  
  @track coreChargeItemsTotal = '0.00'; // added by ashwin  SP4-7818

  //showShippingCharges = true; // Saravanan LTIM Added for HDMP-19413
  updateShippingSection = false; // Saravanan LTIM Added for HDMP-19413
  @track isHpdOrder = false; //Added by Imtiyaz Ali Sprint_4 - HDMP-24620
  @track RACING_LINE_ID = ''; //Added by Imtiyaz Ali for HPD_Sprint_3 - HDMP-24620
  @track tnCAcceptedDatetime; // Start - Added by Imtiyaz|Swaroop for HPD Sprint_4 - HDMP-24620 - HDMP-25860
  @track isInsertOrderFullFilment = true; //Added by Swaroop for HPD_Sprint5
  @track orderFullFillmentEdit; //Added by Swaroop for HPD_Sprint5
  @track isHrcOrderInProgress = false; //Added by Swaroop to restrict shipment info modification for HRC

  @track hideShipChrgsForPUD = false; //Added by Swaroop to Hide Ship Charges/Refund for PickUp From Dealer orders
  @track ispaymentVoided = false; //added by suresh for Braintree Reconciliation

  @track isShowBraintreeAPIError = false; //HDMP-27596
  @track isShowBraintreeFetchError = false;//added by suresh for Braintree Reconciliation
  @track isRecursive = false; //added by Swaroop for Braintree Reconciliation
  @track spinnerflag;
  @track spinnerfirstload=false;
  connectedCallback(){             

    //getting the record id from URL
    this.recordId = this.getUrlParameter('Id');    
    this.spinnerfirstload=true;
    //checking for previous page 
    if(sessionStorage.getItem('isOpenOrders') != "undefined"){
     
      this.isOpenOrderPage = sessionStorage.getItem('isOpenOrders');      
    }

    // method to get order details from Apex class
    this.getOrderDetails();  
         
    this.handleGetAllDealerNotes();//Added by Faraz for 8722 on 25/05/2022
  }  

  //Imtiyaz - EVSE_Phase2_Sprint_1 Start
  get ShipToAddressType(){
    if(this.objOrder){
      if(this.objOrder?.Ship_To_Address_Type_c__c && this.objOrder?.Ship_To_Address_Type_c__c == 'R'){
        return 'Residential';
      }else if(this.objOrder?.Ship_To_Address_Type_c__c && this.objOrder?.Ship_To_Address_Type_c__c == 'C'){
        return 'Commercial';
      }
    }else{
      return '';
    }
  }
  //Imtiyaz - EVSE_Phase2_Sprint_1 End

  //Imtiyaz - EVSE_Phase2_Sprint_3_HDMP- Start
  @track Updated_Order_Amount_c__c = '0.00';
  @track Updated_Shipping_c__c = '0.00';
  @track Updated_Total_Tax_c__c = '0.00';
  @track Updated_Order_Total_c__c = '0.00';
  //Imtiyaz - EVSE_Phase2_Sprint_3_HDMP- End

  orderItemIdAndFulfilmentListMap = new Map();//Imtiyaz - EVSE_Phase2_Sprint_3_HDMP- Start
  orderIdAndFulfilmentListMap = new Map(); // Added by Swaroop for HPD_Sprint5
  // helper method to get order details from Apex class by record Id
  getOrderDetails() {
    this.additionalOrderDetails = [];//Modified by Divya for EVSE2 Pat Regression fix
    OrderDetailshelper({ recordId: this.recordId }).then(result => {
      if (result) {           
        
        this.isDealerAdminUser = result.isDealerAdmin;
        let order = Object.assign({}, result.lstOrders[0]); 
     

        // Start Imtiyaz Ali - added -HDMP-24620 - HPD_Sprint_4
        if(order.Product_Subdivision_c__c == 'Hrc'){
          this.RACING_LINE_ID = order.HPD_RLN_c__c != '' ? order.HPD_RLN_c__c : '';
          this.isHpdOrder = true;
          this.isDirectShip = true;
          //this.tnCAcceptedDatetime = result.tnCAcceptedDatetime; // Start - Added by Imtiyaz|Swaroop for HPD Sprint_4 - HDMP-24620 - HDMP-25860
          this.tnCAcceptedDatetime = this.formatDateTimeStamp(result.tnCAcceptedDatetime); //added by suresh for HPDtransactionTimestamp
        }
        // Start Imtiyaz Ali - added -HDMP-24620 - HPD_Sprint_4

        //added for customer notes - HDMP-10974 starts
        if(order.Order_Transactions__r) {
          let lstNotes = [];
          order.Order_Transactions__r.forEach(item => {
            if(item.Dealer_To_Customer_Note_c__c){
              let objCustNote = {};
              objCustNote.Id = item.Id;
              objCustNote.note = item.Dealer_To_Customer_Note_c__c;
              const d = new Date(item.CreatedDate__c);
              objCustNote.date = d.toLocaleString();
              lstNotes.push(objCustNote);
            }          
          });
          this.customerNotes = lstNotes;
        } 
        //added for customer notes - HDMP-10974 ends

        //Added by Swaroop for HPD_Sprint5 -- Start
        if(this.isHpdOrder){
          try{
            this.orderIdAndFulfilmentListMap = new Map();
            let additionalOrderDetail = Object.assign([], result.listHpdFulfilledOrders);
              let additionalTemp = [];
                if (additionalOrderDetail) {
                  additionalOrderDetail.forEach(item => {
                    let objadditionalDetails = {};
                    objadditionalDetails.Id = item?.Id;
                    objadditionalDetails.Shipment_Date_Time_c__c = this.formatDate(item.Shipment_Date_Time_c__c);
                    objadditionalDetails.Shipped_Partnumber_c__c = item.Shipped_Partnumber_c__c;
                    objadditionalDetails.Shipment_Carrier_c__c = item.Shipment_Carrier_c__c;
                    objadditionalDetails.Shipping_Speed_c__c = item.Shipping_Speed_c__c;
                    objadditionalDetails.Honda_Shipping_Speed_c__c = item.Honda_Shipping_Speed_c__c;
                    objadditionalDetails.Tracking_Number_c__c = item.Tracking_Number_c__c;
                    additionalTemp.push(objadditionalDetails);
                    if(this.orderIdAndFulfilmentListMap.has(item.OrderId_c__c)){
                    let ofl = this.orderIdAndFulfilmentListMap.get(item.OrderId_c__c);
                    ofl.push({...objadditionalDetails});
                    this.orderIdAndFulfilmentListMap.set(item.OrderId_c__c, ofl);
                    }else{
                    this.orderIdAndFulfilmentListMap.set(item.OrderId_c__c, [{...objadditionalDetails}]);
                    }
                  });
                  this.additionalOrderDetails = additionalTemp;
                  if (this.additionalOrderDetails.length == 0) {
                    this.additionalOrderDetails = null;
                  }
                }
          }catch (error) {
            console.error('$error: ', error);
          }
          //Added by Swaroop for HPD_Sprint5 -- End
        }else{
          //Tanisha - EVSE_Phase2_Sprint_1 Start
          try {
            this.orderItemIdAndFulfilmentListMap = new Map();
            let additionalOrderDetail = Object.assign([], result.listFulfilledOrders);
            let additionalTemp = [];
              if (additionalOrderDetail) {
                additionalOrderDetail.forEach(item => {
                  let objadditionalDetails = {};
                  objadditionalDetails.Id = item?.Id;
                  objadditionalDetails.Shipment_Date_Time_c__c = this.formatDate(item.Shipment_Date_Time_c__c);//Modified by Divya for EVSE_Phase2_Sprint3
                  objadditionalDetails.Shipped_Partnumber_c__c = item.Shipped_Partnumber_c__c;
                  if (!item.Shipped_Item_Quantity_c__c) {
                    objadditionalDetails.Shipped_Item_Quantity_c__c = 0;
                  }
                  else {
                    objadditionalDetails.Shipped_Item_Quantity_c__c = item.Shipped_Item_Quantity_c__c;
                  }
                  objadditionalDetails.Shipment_Carrier_c__c = item.Shipment_Carrier_c__c;
                  objadditionalDetails.Honda_Shipping_Speed_c__c = item.Honda_Shipping_Speed_c__c;
                  objadditionalDetails.Tracking_Number_c__c = item.Tracking_Number_c__c;
                  additionalTemp.push(objadditionalDetails);
                  if(this.orderItemIdAndFulfilmentListMap.has(item.Order_Product_c__c)){
                    let ofl = this.orderItemIdAndFulfilmentListMap.get(item.Order_Product_c__c);
                    ofl.push({...objadditionalDetails});
                    this.orderItemIdAndFulfilmentListMap.set(item.Order_Product_c__c, ofl);
                  }else{
                    this.orderItemIdAndFulfilmentListMap.set(item.Order_Product_c__c, [{...objadditionalDetails}]);
                  }
                });
                this.additionalOrderDetails = additionalTemp;
                if (this.additionalOrderDetails.length == 0) {
                  this.additionalOrderDetails = null;
                }
                console.log('$TEST__Phase2_Sprint_1: additionalOrderDetails: ', this.additionalOrderDetails);
                console.log('$TEST_: orderItemIdAndFulfilmentListMap: ',this.orderItemIdAndFulfilmentListMap);
              }
          }catch (error) {
            console.error('$error: ', error);
          }
          //Tanisha - EVSE_Phase2_Sprint_1 End
        }

        this.objOrderTemp = order;
        this.orderExternalId = order.ExternalId; //Added by Swaroop for HPD_Sprint5 
        order = this.checkRestockingFees(order); 
       // this.restockingFees = order.restockingFees;  
       // this.updRestockingFees = order.restockingFees;  
       // R2B AC changes
       if(order.Customer_Preferred_Speeds_c__c){
        if(order.Customer_Preferred_Speeds_c__c == 'Expedited (2-3 Days)'){
          this.dealerShippingSpeedOptions = [
            { label: 'Expedited (2-3 Days)', value: 'Expedited (2-3 Days)' },
            { label: 'Express (1-2 Days)', value: 'Express (1-2 Days)' }
          ];
        }else if(order.Customer_Preferred_Speeds_c__c == 'Express (1-2 Days)'){
          this.dealerShippingSpeedOptions = [           
            { label: 'Express (1-2 Days)', value: 'Express (1-2 Days)' }
          ];
        }
       }
          
       if(order.AccountId__r) {
        this.isActiveDealer = order.AccountId__r.IsActive_c__c;
       }

        order.returnWindow = order.AccountId__r &&  order.AccountId__r.Return_Window_c__c ?  order.AccountId__r.Return_Window_c__c : 30;
        if(order.AccountId__r && order.AccountId__r.Charge_Restocking_Fees_c__c && order.AccountId__r.Charge_Restocking_Fees_c__c == 'Yes'){
          this.isShowRestockingFees = true;
        }
        order.Status = (order.Status__c == 'Activated') ? 'SUBMITTED' : 
                      (order.Status__c == 'CUSTOMER CANCELED') ? 'CUSTOMER CANCELLED' : 
            (order.Status__c == 'DEALER CANCELED') ? 'DEALER CANCELLED' : (order.Status__c == 'SYSTEM CANCELED') ? 'SYSTEM CANCELLED' : order.Status__c;  //modified by suresh for Braintree Reconciliation

        let date = new Date() - new Date(order.OrderedDate__c);          
        order.orderDays = Number(date / (1000*60*60*24)).toFixed(0);   
        order.orderDays = Number(order.orderDays) - order.returnWindow;
        if(order.orderDays > 0){
          order.isShowReturnWindow = true;
        }else {
          order.isShowReturnWindow = false;
        }

        order.OrderedDate = this.formatDate(order.OrderedDate__c);  
        order.shippedDate = order.Shipped_Date_c__c ? this.formatDate(order.Shipped_Date_c__c) : '';  
        this.otherCarrier = order.Other_Carrier_c__c;
        this.shippingVender = order.Shipping_Vendors_c__c;
        this.dealerShippingSpeed = order.Dealer_Shipping_Speed_c__c;       

        if(this.shippingVender == 'Other'){
          this.isOtherSelected = true;
        }else {
          this.isOtherSelected = false;
        }
        this.trackingNumber = order.ShippingNumber_c__c;      
        this.storedTrackingNumber = order.ShippingNumber_c__c;

        if (order.SHIPPING_from_cart_c__c > 0) {
          //Tanisha - EVSE_Phase2_Sprint_1 Start
          if (order?.Type__c == 'DirectShip') {
            order.shipToStore = 'DIRECT SHIP';
            this.isDirectShip = true;//Added by Divya - EVSE_Phase2_Sprint1
          }
          else {
            this.isDirectShip = this.isHpdOrder == true? true : false; // Added by Swaroop for HPD_Sprint5
            order.shipToStore = 'SHIP TO HOME';
          }
          //Tanisha - EVSE_Phase2_Sprint_1 End
          this.isShowShippingAddress = true;
        }else{
          this.isShowShippingAddress = false;
          if(order.Delivery_Types_c__c && order.Delivery_Types_c__c == 'Install At Dealer'){
            order.shipToStore = 'DEALER INSTALL';
            this.hideShipChrgsForPUD = true; //Added by Swaroop to Hide Shipping Charges for PickUp From Dealer orders          
            if(order.Status__c == 'Activated'){
              order.Status = 'READY FOR INSTALLATION';
              this.isShowInstallationButton = true;
            }else {
              this.isShowInstallationButton = false;
            }
            
            this.isDealerInstall = true;
          }else {
            order.shipToStore ='PICKUP FROM DEALER';
            this.hideShipChrgsForPUD = true; //Added by Swaroop to Hide Shipping Charges for PickUp From Dealer orders
          }      
        }
                              
        if(order.Status__c == 'PAYMENT ISSUE'){
          this.isPaymentIssueNeedAction = true;
        }else {
          this.isPaymentIssueNeedAction = false;
        }

        if(order.Status__c == 'PAYMENT ISSUE' && order.IsPaymentReproccessing_c__c == false){
          this.isPaymentIssue = true;
        }else {
          this.isPaymentIssue = false;
        }
            
        //Added by Swaroop for HDMP-27596 -- Start///modified by suresh for Braintree Reconciliation
        if (this.methodName == null && result.isaccessTokenError == true && !this.isHpdOrder && (order.Status__c == 'Activated' || order.Status__c == 'IN PROGRESS')) {
          this.isShowBraintreeAPIError = true;
        } else if( result.isBraintreeFetchError == true &&  !this.isHpdOrder && (order.Status__c == 'Activated' || order.Status__c == 'IN PROGRESS')){
          this.isShowBraintreeFetchError = true;
        }
        else {
          //Added by Swaroop for HDMP-27596 -- End
          if ((order.Status__c == 'READY FOR PICKUP' || order.Status__c == 'PARTIAL RETURN')
            && order.shipToStore == 'PICKUP FROM DEALER' && order.isOrderPickedUp_c__c == false) {
          this.isShowOrderPickedUpButton = true;
        }else {
          this.isShowOrderPickedUpButton = false;
        }

        if(order.IsPaymentReproccessing_c__c == true){
          this.isPaymentEmailSent = true;
        }else {
          this.isPaymentEmailSent = false;
        }
        if(order.IsError_c__c == true){//added by suresh for payment settlement
          //this.methodName = '';
          this.handleSuccessToastMessage('processPayment');
        }
        
        if(order.Status__c =='Activated' && order.Delivery_Types_c__c != 'Install At Dealer'){
          this.isShowInProgressButton = true;                 
        }else {
          this.isShowInProgressButton = false;        
        }        

        if(order.Status__c == 'ORDER COMPLETE - INSTALLED'){
          order.Status = order.Status__c;
          this.isShowInstallationButton = false;
        }
        let transacStatus = order.BT_Transaction_Status_c__c.toLowerCase() ; //added by suresh for case-inSensitive 
        if (order.Status__c == 'IN PROGRESS') {
          console.log('this.isHpdOrder',this.isHpdOrder)
          if (result.isDealerAdmin == true) {
            //let transacStatus = order.BT_Transaction_Status_c__c.toLowerCase() ;
            if(this.isHpdOrder == true && transacStatus == 'settled'){
              this.isShowModifyOrderButton = true;
              this.isHrcOrderInProgress = true;
              console.log('sHpdOrder',this.isShowModifyOrderButton)
            }else if(this.isHpdOrder == true){
              this.isHrcOrderInProgress = true;
            }else if(this.isHpdOrder == false){
              this.isShowModifyOrderButton = true;
              this.isHrcOrderInProgress = false;
              console.log('NON---HpdOrder',this.isShowModifyOrderButton)
            }
          } else {
            this.isShowModifyOrderButton = false;
          }
         
          if(order.shipToStore == 'SHIP TO HOME'){
            this.isShowEditButton = true;
            this.isShowMarkOrderShippedButton = true;           
          }//Tanisha - EVSE_Phase2_Sprint_1 Start
          else if (order.shipToStore == 'DIRECT SHIP') {
            this.isShowMarkOrderShippedButton = false;
          }
          //Tanisha - EVSE_Phase2_Sprint_1 End
          else if (order.shipToStore == 'PICKUP FROM DEALER') {
            this.isShowEditButton = false;
            this.isShowReadyForPickupButton = true;
          } 
        } else {
          this.isHrcOrderInProgress = false;
          this.isShowEditButton = false;
          this.isShowModifyOrderButton = false;
          this.isShowMarkOrderShippedButton = false;
          this.isShowReadyForPickupButton = false;
        }              
        //Tanisha - EVSE_Phase2_Sprint_1 Start
        if (order.Status__c == 'PREPARING FOR SHIPMENT' || order.Status__c == 'PROCESSING IN WAREHOUSE' || order.Status__c == 'PARTIALLY SHIPPED') {
          this.isShowModifyOrderButton = false;
          this.isShowCancelButton = false;
        }
        //Tanisha - EVSE_Phase2_Sprint_1 End
        if ((order.Status__c == 'Activated' || order.Status__c == 'IN PROGRESS' || order.Status__c == 'PAYMENT ISSUE') && result.isDealerAdmin == true && this.isDealerInstall == false && this.isHpdOrder == false) {// Imtiyaz Ali - added -HDMP-24620 - HPD_Sprint_4 - this.isHpdOrder == false
          this.isShowCancelButton = true;
        } else {
          this.isShowCancelButton = false;
        }
        //modified by suresh --added transacStatus variable
        if ((order.Status == 'READY FOR INSTALLATION' || order.Status__c == 'ORDER COMPLETE - INSTALLED' || order.Status__c == 'ORDER COMPLETE - SHIPPED' || order.Status__c == 'READY FOR PICKUP' || order.Status__c == 'ORDER COMPLETE - PICKED UP'
          || order.Status__c == 'PARTIAL RETURN') && (transacStatus == 'settled' || transacStatus == 'settling' ) && result.isDealerAdmin == true) {
          this.isShowReturnButton = true;
          this.isHrcOrderInProgress = false;
        } else {
          this.isShowReturnButton = false;
        }

        if(this.methodName == 'processCancelRequest'){
          if(order.IsError_c__c == true && (order.Status__c == 'IN PROGRESS' || order.Status__c =='Activated' || order.Status__c == 'PAYMENT ISSUE')){
            this.methodName = '';
            this.handleErrorToastMessage('processCancelRequest');
          }else{
            this.methodName = '';
            this.handleSuccessToastMessage('processCancelRequest');
          }
          this.isLoadingForCancel = false;
        }

        if(this.methodName == 'handleDeltaQuantitySubmit'){
          if(order.IsError_c__c == true && (order.Status__c == 'READY FOR PICKUP' || order.Status__c == 'ORDER COMPLETE - SHIPPED' 
          || order.Status__c == 'ORDER COMPLETE - PICKED UP' || order.Status__c == 'Activated' || order.Status__c == 'ORDER COMPLETE - INSTALLED' || order.Status__c == 'PARTIAL RETURN')){
            this.methodName = '';
            this.handleErrorToastMessage('handleDeltaQuantitySubmit');
          }else {
            this.methodName = '';
            this.handleSuccessToastMessage('handleDeltaQuantitySubmit');
          }
          this.isLoadingForCancel = false;
        }

        // if the method is called from handleMarkOrderClick method this if condition will work
        if(this.methodName == 'handleMarkOrderClick'){
          if(order.IsError_c__c == true && order.Status__c == 'PAYMENT ISSUE'){
            this.methodName = '';
            this.isPaymentIssue = true;
            this.isShowEditButton = false;          
            this.handleErrorToastMessage('handleMarkOrderClick');
            } else if (order.IsError_c__c == false && (order.Status__c == 'READY FOR PICKUP' || order.Status__c == 'ORDER COMPLETE - SHIPPED' || order.Status__c=='ORDER COMPLETE - PICKED UP')) {
            this.methodName = '';
            this.isPaymentIssue = false;
            this.isShowEditButton = false;            
            this.handleSuccessToastMessage('handleMarkOrderClick');
          }
          this.isLoadingForCancel = false;
        }      
        
       /* if(this.methodName == 'modifyOrderDetails'){
          this.isLoadingForCancel = false;
          this.methodName = '';
          this.handleSuccessToastMessage('modifyOrderDetails');
        }*/

        if(order.Status__c == 'CUSTOMER CANCELED' || order.Status__c == 'DEALER CANCELED') {   
          this.isPaymentIssue = false;  
          this.isPaymentEmailSent = false;    
          this.isShowCancelButton = false;
          }

          //modified by suresh for HDMP_27480_Braintree
          if ((order.Status__c == 'Activated' || order.Status__c == 'IN PROGRESS' ) && (transacStatus == 'settling' || transacStatus == 'submitted_for_settlement' || transacStatus == 'settled') && !this.isHpdOrder && order.Delivery_Types_c__c != 'Install At Dealer') { 
            this.isShowModifyOrderButton = false;
            this.isShowCancelButton = false;
        }
          if (order.Status__c == 'SYSTEM CANCELED' && !this.isHpdOrder) { //modified by suresh for Braintree Reconciliation

            this.isShowCancelButton = false;
            let test = sessionStorage.getItem('isOpenOrders')
            if (test == 'true') {
              console.log('the test is successfull')
              this.isLoadingForCancel = false;
              this.ispaymentVoided = true;
              if(!this.isRecursive){
                this.isRecursive = true;
                this.isLoadingForCancel = true;
                this.spinnerflag=false;
                setTimeout(()=> this.getOrderDetails(),10000);
              }
            }
            else {
              this.ispaymentVoided = false;
            }

          }
          // Update by Lokesh for HDMP-29559 Payment settlement
          if (( transacStatus =='authorized' || transacStatus =='settling' || transacStatus =='settled' || transacStatus =='submitted_for_settlement' ||  transacStatus =='authorization_expired') && order.Status__c == 'Activated' && order.Delivery_Types_c__c != 'Install At Dealer' && !this.isHpdOrder) { //addded by suresh for PR
            this.isShowInProgressButton = true;
            this.isShowModifyOrderButton = true;
            this.isShowCancelButton = true;
  
          }else if(!this.isHpdOrder || order.Delivery_Types_c__c != 'Install At Dealer'){
            this.isShowInProgressButton = false;
            this.isShowModifyOrderButton = false;
            this.isShowCancelButton = false;
          }
          if(this.isHpdOrder && order.Status__c == 'Activated'){
            this.isShowInProgressButton = true;
          }
 
        }
       

        if (order.Status__c == 'PAYMENT ISSUE' && !this.isHpdOrder && order.Delivery_Types_c__c != 'Install At Dealer') { 
          this.isShowCancelButton = true;
         }


        //Added By Divya EVSE_Phase2_Sprint3_HDMP-24340 Start - Modified By Imtiyaz - EVSE_Phase2_Sprint_3_HDMP- 
        if(this.isDirectShip == true || this.isHpdOrder){ // Added by Swaroop for HPD_Sprint5
          this.Updated_Order_Amount_c__c = (order.Updated_Order_Amount_c__c - (order.Total_Unavailable_ProductAmt_c__c ? order.Total_Unavailable_ProductAmt_c__c.toFixed(2) : '0.00')).toFixed(2);
          this.Updated_Shipping_c__c = (order.Updated_Shipping_c__c - (order.Total_Unavailable_ShippingAmt_c__c ? order.Total_Unavailable_ShippingAmt_c__c.toFixed(2) : '0.00')).toFixed(2);
          this.Updated_Total_Tax_c__c = (order.Updated_Total_Tax_c__c - (order.Total_Unavailable_TaxAmt_c__c ? order.Total_Unavailable_TaxAmt_c__c.toFixed(2) : '0.00')).toFixed(2);
          //this.Updated_Total_Tax_c__c = (this.Updated_Total_Tax_c__c).toFixed(2);
          console.log('My Updated Tax ',this.Updated_Total_Tax_c__c);
          this.Updated_Order_Total_c__c = Math.abs(Number(this.Updated_Order_Amount_c__c) + Number(this.Updated_Shipping_c__c) + Number(this.Updated_Total_Tax_c__c));//Added By Divya EVSE_Phase2_Sprint3_HDMP-24340 END
          this.Updated_Order_Total_c__c = (this.Updated_Order_Total_c__c).toFixed(2); 
          //console.log('this.Updated_Order_Total_c__c ',this.Updated_Order_Total_c__c.toFixed(2));
        }else{
          // Added by Lokesh for BUG-27122
          this.Updated_Order_Amount_c__c = order.Updated_Order_Amount_c__c.toFixed(2);
          this.Updated_Shipping_c__c = order.Updated_Shipping_c__c.toFixed(2);
          this.Updated_Total_Tax_c__c = order.Updated_Total_Tax_c__c.toFixed(2);
          this.Updated_Order_Total_c__c = order.Updated_Order_Total_c__c.toFixed(2);
        }
        //Imtiyaz - EVSE_Phase2_Sprint_3_HDMP- End

        //net fields //Modified by Divya for EVSE_Phase2_Sprint3 _Start
        //order.netItems = (order.Updated_Order_Amount_c__c - order.Total_Item_Return_c__c).toFixed(2);//
        order.netItems = (this.Updated_Order_Amount_c__c - order.Total_Item_Return_c__c).toFixed(2);
        //order.netTax = (order.Updated_Total_Tax_c__c - order.Total_Tax_Return_c__c).toFixed(2);
        order.netTax = (this.Updated_Total_Tax_c__c - order.Total_Tax_Return_c__c).toFixed(2);
        //order.netTotal = (order.Updated_Order_Total_c__c - order.Total_Return_c__c).toFixed(2);
        order.netTotal = (this.Updated_Order_Total_c__c - order.Total_Return_c__c).toFixed(2);
        order.netInstall = (order.Total_Installation_Charges_c__c - order.Total_Installation_Return_c__c).toFixed(2);
        order.netShipping = Math.abs(Number(this.Updated_Shipping_c__c) - Number(order.Total_Ship_Return_c__c));
        //order.netShipping = Math.abs(Number(order.Updated_Shipping_c__c) - Number(order.Total_Ship_Return_c__c));
        order.netShipping = order.netShipping.toFixed(2);
        //Modified by Divya for EVSE_Phase2_Sprint3 _END
        //Imtiyaz - EVSE_Phase2_Sprint_3_HDMP-25942 Start
        let unavailble_shipping_amount = 0;
        //START Modified by Bruno - BUG HDMP-27151
        /*order?.Order_Products__r?.forEach(ordItm => {
         unavailble_shipping_amount += ordItm.Total_Unavailable_ShippingAmt_c__c ? ordItm.Total_Unavailable_ShippingAmt_c__c : 0;
        });*/ //END Modified by Bruno - BUG HDMP-27151
        order.netShippingAmountToRefund = Number(order.netShipping); //Modified by Bruno - BUG HDMP-27151
        order.netShippingAmountToRefund = order.netShippingAmountToRefund.toFixed(2);
        //Imtiyaz - EVSE_Phase2_Sprint_3_HDMP-25942 End

        /*if(order.netShipping == null || order.netShipping <= 0 ){

          this.showShippingCharges = false;

        } */

        // Saravanan LTIM Ended the IF conditions for HDMP-19413
        
        // updated order price
        order.Total_Installation_Charges_c__c = order.Total_Installation_Charges_c__c ? Number(order.Total_Installation_Charges_c__c).toFixed(2) : '0.00';
        order.Updated_Order_Amount_c__c = order.Updated_Order_Amount_c__c ? order.Updated_Order_Amount_c__c.toFixed(2) : '0.00';
        order.SHIPPING_from_cart_c__c = (order.SHIPPING_from_cart_c__c && order.SHIPPING_from_cart_c__c != 0) ? order.SHIPPING_from_cart_c__c.toFixed(2) : '0.00';
        order.Updated_Total_Tax_c__c = order.Updated_Total_Tax_c__c ? order.Updated_Total_Tax_c__c.toFixed(2) : '0.00';
        order.Updated_Order_Total_c__c = order.Updated_Order_Total_c__c ? order.Updated_Order_Total_c__c.toFixed(2) : '0.00';
        order.Updated_Shipping_c__c = order.Updated_Shipping_c__c ? order.Updated_Shipping_c__c.toFixed(2) : '0.00';
        
        // Saravanan LTIM Added for 19413
        if((order.Updated_Shipping_c__c != null && order.Updated_Shipping_c__c > 0)){
          this.updateShippingSection = true;
        }
        

        //for return field 
        order.Total_Return_c__c = order.Total_Return_c__c ? order.Total_Return_c__c.toFixed(2) : '0.00';
        order.Total_Item_Return_c__c = order.Total_Item_Return_c__c ? order.Total_Item_Return_c__c.toFixed(2) : '0.00';
        order.Total_Ship_Return_c__c = order.Total_Ship_Return_c__c ? order.Total_Ship_Return_c__c.toFixed(2) : '0.00';
        order.Total_Tax_Return_c__c = order.Total_Tax_Return_c__c ? order.Total_Tax_Return_c__c.toFixed(2) : '0.00';
        order.Total_Restocking_Fees_c__c = order.Total_Restocking_Fees_c__c ? order.Total_Restocking_Fees_c__c.toFixed(2) : '0.00';
        order.Total_Installation_Return_c__c = order.Total_Installation_Return_c__c ? order.Total_Installation_Return_c__c.toFixed(2) : '0.00';

        order.Total_Core_Charge_Current_Amount__c = order.Total_Core_Charge_Current_Amount__c ? order.Total_Core_Charge_Current_Amount__c.toFixed(2) : '0.00'; // Saravanan LTIM Added for 19466
        order.Total_Core_Charge_Return_Amount__c = order.Total_Core_Charge_Return_Amount__c ? order.Total_Core_Charge_Return_Amount__c.toFixed(2) : '0.00'; // Saravanan LTIM Added for 19466

        // Saravanan LTIM Added the IF conditions for HDMP-19413
        order.netCoreCharges = (order.Total_Core_Charge_Current_Amount__c - order.Total_Core_Charge_Return_Amount__c).toFixed(2); // Saravanan LTIM HDMP - 24513  version issue
        var coreTotal = 0.00; //order.Total_Core_Charge_Current_Amount__c; //Math.abs(Number(order.Total_Core_Charge_Current_Amount__c) + Number(order.Total_Core_Charge_Return_Amount__c)).toFixed(2);
        order.coreTotal = 0.00; 

        order.totalItemTax = 0;      
        let orderItemCount = 0;
        // checking for order products list should not be blank
        if(order.Order_Products__r && order.Order_Products__r.length > 0) {
          let tempOrderItems = [];          
          let index = 0;
       

          order.Order_Products__r.forEach(item => {
            let obj = Object.assign({}, item);
		  
            if(obj.Updated_Quantity_c__c == 0){
              orderItemCount += 1;
            }
		  
            // Saravanan LTIM Added the Iteration for a bug
            if(obj.Product_Type_c__c == 'Core Charge'){
              coreTotal = coreTotal  + Number((obj.Updated_Quantity_c__c * obj.ListPrice__c));
            }
            order.coreTotal = coreTotal.toFixed(2);
             // Saravanan LTIM Added the Iteration for a bug
            
             //Imtiyaz - EVSE_Phase2_Sprint_3_HDMP-24353 Start
            obj.updatedQuantityAfterUnavailableQuantity = obj.Updated_Quantity_c__c;
           
            if (obj.Unavailable_Quantity_c__c) {
                obj.updatedQuantityAfterUnavailableQuantity = obj.Updated_Quantity_c__c - obj.Unavailable_Quantity_c__c;
            }
            //Imtiyaz - EVSE_Phase2_Sprint_3_HDMP-24353 End
            //Added by sureh for Braintree Reconciliation 
            if(order.Status__c == 'SYSTEM CANCELED' && order.BT_Transaction_Status_c__c == 'Voided'){
              obj.updatedQuantityAfterUnavailableQuantity = 0;
            }//ended

            obj.tax = obj.Total_Tax_c__c / obj.Quantity__c;
            order.totalItemTax += (obj.Total_Tax_c__c / obj.Quantity__c) * obj.Updated_Quantity_c__c;
            obj.extendedPrice = '0.00';
            obj.UpdExtendedPrice = obj.ListPrice__c * obj.updatedQuantityAfterUnavailableQuantity;
            obj.UpdExtendedPrice = obj.UpdExtendedPrice ? obj.UpdExtendedPrice.toFixed(2) : '0.00';
            obj.ListPrice__c = obj.ListPrice__c ? obj.ListPrice__c.toFixed(2) : '0.00';
            obj.deltaInstallPrice = 0;
            obj.Dealer_Installation_Price_c__c = obj.Dealer_Installation_Price_c__c ? obj.Dealer_Installation_Price_c__c.toFixed(2) : '0.00';
            obj.updatedInstallPrice = 0;
            obj.tempUpdInstallPrice = '0.00';
            obj.currentInstallPrice = Math.abs(obj.Dealer_Installation_Price_c__c - (obj.Total_Return_Installation_Charge_c__c ? obj.Total_Return_Installation_Charge_c__c : 0));
            obj.currentInstallPrice = obj.currentInstallPrice ? obj.currentInstallPrice.toFixed(2) : '0.00';
            if(this.isHpdOrder){ //Added the HRC condition by Swaroop
              obj.updatedQuantity = obj.updatedQuantityAfterUnavailableQuantity;
            }else{
            obj.updatedQuantity = obj.Updated_Quantity_c__c;
            }
            obj.isError = false;
            //obj.currentQty = Math.abs(obj.Updated_Quantity_c__c - obj.Return_Quantity_c__c);
            obj.currentQty = Math.abs(obj.Updated_Quantity_c__c - (obj.Unavailable_Quantity_c__c ? obj.Unavailable_Quantity_c__c : 0) - obj.Return_Quantity_c__c);// Modified by Divya for EVSE Phase2 - HDMP-27151
            //Tanisha - EVSE_Phase2_Sprint_1 Start //EVSE_Phase2_Sprint2_Divya_START
            /*if (obj.Unavailable_Quantity_c__c) {
              obj.Updated_Quantity_c__c = obj.currentQty - obj.Unavailable_Quantity_c__c;
            }*/
            //Tanisha - EVSE_Phase2_Sprint_1 End ////EVSE_Phase2_Sprint2_Divya_END
            obj.installPrice = obj.Dealer_Installation_Price_c__c;
            obj.Total_Return_Installation_Charge_c__c = obj.Total_Return_Installation_Charge_c__c ? obj.Total_Return_Installation_Charge_c__c : 0;
            obj.returnInstallPrice = obj.Total_Return_Installation_Charge_c__c ? obj.Total_Return_Installation_Charge_c__c.toFixed(2) : '0.00';
            obj.deltaQuantity = 0;
            obj.qtyDisabled = obj.currentQty > 0 ? false : true;
            obj.installDisabled = obj.currentInstallPrice > 0 ? false : true;
            obj.errorMessage = null;    
            obj.classInstall = 'alignment installPrice' + index.toString();               
            obj.classDelta = 'alignment deltaQuantity' + index.toString();
            obj.classIndex = 'alignment updateQuantity' + index.toString();
			      obj.isCoreCharge = obj.Product_Type_c__c == CORE_CHARGE ? true : false; // SP2-16544, Added by ashwin for US 16544
            obj.isReman = obj.Product_Type_c__c == CORE_CHARGE ? true : false; //Make isReman true for core charges only (Parts will be changed in separate loop Vivek M)
            index++;
            obj.index = index;
            tempOrderItems.push(obj);
          })
          //Begin by Vivek M - Making Reman part IsReman flag to true  
          if (tempOrderItems) {
            this.orderItems = tempOrderItems.map(item => {
              let filterItem = tempOrderItems.filter(it => (it.Product2Id__c == item.Product2Id__c && it.isReman == true));
              if (filterItem.length!=0) {
                item.isReman = true;
              }
              return item;
            });
          }
          //End by Vivek M - Making Reman part IsReman flag to true
	  
		  /* , Begin by ashin for US SP2-16544 */
         if (this.orderItems) {
            var counter = 1; // Saravanan LTIM Added for HDMP-19537
            this.orderItems.forEach(itm => {
			  itm.extendedCoreCharge = 0; // Added by ashwin for 19435
			  itm.totalUpdExtendedPrice = itm.UpdExtendedPrice; // Added by ashwin for 19435 // (previous - extendedPrice) (new - totalUpdExtendedPrice)
              if (itm.Product_Type_c__c == CORE_CHARGE) {
				this.isCoreExist = true; // Added by ashwin for 19435
                this.coreChargeItems.push(itm);
              }
              // Saravanan LTIM Added for HDMP-19537
              else{
                itm.indexVal = counter;
                counter++;
              }
              // Saravanan LTIM Added for HDMP-19537
            })
          }
          /* ended by ashwin for US SP2-16544 */
		  

          // Started by ashwin for 19435
          if (this.isCoreExist) {
            this.coreChargeItems.forEach(item => {
              let part = this.orderItems.find(prt => prt.Product_SKU_c__c === item.Product_SKU_c__c && prt.isCoreCharge == false);
                part.extendedCoreCharge = item.ListPrice__c; // Saravanan LTIM Added UpdExtendedPrice
			  part.totalUpdExtendedPrice = (parseFloat(item.UpdExtendedPrice) + parseFloat(part.UpdExtendedPrice)).toFixed(2); // (previous - extendedPrice) (new - totalUpdExtendedPrice)
            })

          }

          // Ended by ashwin for 19435


          console.log('this.orderItems===> ' + JSON.stringify(this.orderItems));

		  
          this.lstOrderItems = tempOrderItems;
          this.isShowOrderItems = true;
        }else {
          console.log('else wire  : ',);
          this.orderItems = [];
          this.lstOrderItems = [];
          this.isShowOrderItems = false;
          this.isShowOrderPickedUpButton = false;
          this.isShowEditButton = false;       
          this.isShowModifyOrderButton = false;
          this.isShowMarkOrderShippedButton = false;
          this.isShowReadyForPickupButton = false;
          this.isShowCancelButton = false;
          this.isShowReturnButton = false;
        }

        if(order.Order_Products__r && order.Order_Products__r.length == orderItemCount){
          console.log('orderItemCount : ',orderItemCount);
          this.isShowOrderPickedUpButton = false;
          this.isShowEditButton = false;       
          this.isShowModifyOrderButton = false;
          this.isShowMarkOrderShippedButton = false;
          this.isShowReadyForPickupButton = false;
          this.isShowCancelButton = false;
          this.isShowReturnButton = false;
        }
        //this.flowLabel = 'Fulfill Order!';
        if(order.shipToStore == 'SHIP TO HOME'){          
          order.shippingTax = order.TAX_from_cart_c__c - order.totalItemTax;         
          order.shippingTax = order.shippingTax.toFixed(2);              
          order.totalItemTax = order.totalItemTax.toFixed(2);             
        }else if(order.shipToStore == 'DEALER INSTALL'){
          order.installTax = order.TAX_from_cart_c__c - order.totalItemTax;         
          order.installTax = order.installTax.toFixed(2);              
          order.totalItemTax = order.totalItemTax.toFixed(2);
        }else{
          order.totalItemTax = order.Updated_Total_Tax_c__c;
        }
               
        this.objOrder = order;                                                                     
        if(this.spinnerfirstload){
          this.isLoading = false;
          this.spinnerfirstload=false;
      }
        if(this.spinnerflag==true){
          this.isLoading = true;
        }else if(this.spinnerflag==false){
        this.isLoading = false;
        if(order.Status__c == 'Activated' && order.IsError_c__c){
          this.handleErrorToastMessage('partialmodifiedOrder');
        }else 
       if(order.Status__c == 'IN PROGRESS'){
          this.handleSuccessToastMessage('handleMarkOrderClick');
        }
        }
      }
              
    }).catch(error => {
      this.isLoading = false;
      console.log('Error : ',error);
    })
  }

  handleEditNotesClick(){
    this.isShowEditNotes = true;
    this.isModalOpen = true;
  }
  //Divya EVSE Changes Start HDMP-24337 
  handleMoreInfoClick(event) {
    this.isModalOpen = true;
    this.isShowMoreInfo = true;
    this.modalWidthStyle = 'max-width: 65rem;min-width: 65rem;';
    this.orderItemId = event.target.dataset.id;
    console.log('$TEST_: orderItemId: ',this.orderItemId);
    if(this.isHpdOrder){
      this.additionalOrderDetails = this.orderIdAndFulfilmentListMap.get(this.orderExternalId);
    }else{
      this.additionalOrderDetails = this.orderItemIdAndFulfilmentListMap.get(this.orderItemId);
    }
    console.log('this.orderItemId',this.orderItemId);
    this.productName = event.target.dataset.name;
    this.partNumber = event.target.dataset.sku;
    this.quantity = event.target.dataset.quantity;
    this.updatedQuantity = event.target.dataset.upquantity;
    this.shippedQuantity = event.target.dataset.shippedquantity;//Added by Divya for EVSE_Phase2_Sprint3
    this.productMarketingName = event.target.dataset.detail;
    this.orderItemStatus = event.target.dataset.status;
    this.vin = event.target.dataset.vin;
  }
  //Divya EVSE changes End HDMP-24337 

  handleEditNotesChange(event) {
    this.dealerNotes = event.detail.value;
    this.dealerNoteValue = event.detail.value;//Added by Faraz for 8722 on 25/05/2022
  }


  checkRestockingFees(order){
    if(order.AccountId__r && order.AccountId__r.Restocking_Fees_Type_c__c){
      if(order.AccountId__r.Restocking_Fees_Type_c__c == 'Flat'){
        order.restockingFees = order.AccountId__r.Restocking_Fees_c__c ? order.AccountId__r.Restocking_Fees_c__c.toFixed(2) : '0.00';
        order.isPercentage = false; 
      }else if(order.AccountId__r.Restocking_Fees_Type_c__c == 'Percentage' && order.AccountId__r.Restocking_Fees_Percentage_c__c) {
        order.restockingFees = ((order.TOTAL_from_cart_c__c/100) * order.AccountId__r.Restocking_Fees_Percentage_c__c).toFixed(2);  
        order.isPercentage = true;  
        order.percentage = order.AccountId__r.Restocking_Fees_Percentage_c__c;
      }else {
        order.restockingFees = '0.00';
      }    
    }
    console.log('order.restockingFees : ',order.restockingFees);
    return order;
  }

  modifyTax(){
    this.isTaxCalculated = false;
  }
  // --- functions for Modify Order starts--- //

  handleModifyOrderClick(){      
    console.log('Modify Order Clicked');
    if(this.isActiveDealer == false){
      this.dispatchToastMessage('Error!', 'This functionality is not available.', 'error');
      return;
    }
    this.modalWidthStyle = 'max-width: 52rem;min-width: 52rem;';   
    this.isModifyOrderClicked = true;
    this.isModalOpen = true;   
  }

  // onchange method for quantity input field
  handleItemQuantityChange(event){
    //slds-has-error
    this.errorMessage = null;
    let itemId = event.currentTarget.dataset.id;
    let index =  event.currentTarget.dataset.index;
    let className = '.updateQuantity'+index.toString();
    console.log('itemId : '+ itemId + ' index : '+ index + ' className : '+ className);
    let quantityCmp = this.template.querySelector(className);  
    let quantity = event.currentTarget.value;
    let items = this.orderItems;
    let tempItems = [];
    console.log('quantityCmp : ',quantityCmp);   
      items.forEach(data => {
        let item = Object.assign({}, data); 
      if (item.Id == itemId) {
        if (quantity) {
          if ((quantity == item.Updated_Quantity_c__c) || (this.isHpdOrder && quantity == item.updatedQuantityAfterUnavailableQuantity)) { //Added the HRC condition by Swaroop
              item.isError = false;
              item.updatedQuantity = parseInt(quantity);
              item.UpdExtendedPrice = (item.ListPrice__c * item.updatedQuantity).toFixed(2);
              item.Delta_Quantity_c__c = 0;
              item.errorMessage = null;
              quantityCmp.setCustomValidity("");
              quantityCmp.reportValidity();
          } else if (quantity >= 0 && (quantity < item.Updated_Quantity_c__c || (this.isHpdOrder && quantity < item.updatedQuantityAfterUnavailableQuantity))) { //Added the HRC condition by Swaroop
              console.log('inside if');
            if(this.isHpdOrder){ //Added the HRC condition by Swaroop
              item.Delta_Quantity_c__c = item.updatedQuantityAfterUnavailableQuantity - parseInt(quantity); 
            }else{
              item.Delta_Quantity_c__c = item.Updated_Quantity_c__c - parseInt(quantity);
            }
              item.updatedQuantity = parseInt(quantity);
              item.UpdExtendedPrice = (item.ListPrice__c * item.updatedQuantity).toFixed(2);
              item.isError = false;
              item.errorMessage = null;
              quantityCmp.setCustomValidity("");
              quantityCmp.reportValidity();
            }else {
              item.Delta_Quantity_c__c = 0;
              item.isError = true;
              quantityCmp.setCustomValidity(" ");
            item.errorMessage = "Please enter a quantity less than or equal to " + (this.isHpdOrder? item.updatedQuantityAfterUnavailableQuantity : item.Updated_Quantity_c__c); //Added the HRC condition by Swaroop
              //quantityCmp.setCustomValidity("Please enter a quantity less than or equal to " + item.Updated_Quantity_c__c);    
              quantityCmp.reportValidity();  
                          
            } 
          }else {
            item.Delta_Quantity_c__c = 0;
            item.isError = true;
          item.errorMessage = "Please enter a quantity less than or equal to " + (this.isHpdOrder? item.updatedQuantityAfterUnavailableQuantity : item.Updated_Quantity_c__c); //Added the HRC condition by Swaroop
            quantityCmp.setCustomValidity(" ");    
            quantityCmp.reportValidity();
          }        
        }          
        tempItems.push(item);
      });   
      
      console.log('tempItems : ',tempItems);
      this.orderItems = tempItems;  
  }

  // function for saving order modifications
  modifyOrderDetails(){
    this.methodName = '';
    //Added by Lokesh for bug-29252
    let customerNoteforModify
    if(this.customerNoteValue.length){
      customerNoteforModify = this.customerNoteValue
    }
   // let customerNoteforModify = this.customerNoteValue.length ? this.customerNoteValue : '';
    let updateOrderItems = [];
    let isError = false;
    let tempOrderItemList = JSON.stringify(this.orderItems);  
    let orderitemsList = this.orderItems;
    orderitemsList.forEach(item => {
      if(item.isError == true){
        isError = true;     
      } else if (item.isError == false && ((item.updatedQuantity != item.Updated_Quantity_c__c && !this.isHpdOrder) || (this.isHpdOrder && item.updatedQuantity != item.updatedQuantityAfterUnavailableQuantity) )) { //Added the HRC condition by Swaroop
        if(!this.isHpdOrder){//added for HRC modification - Rajrishi 
        item.Updated_Quantity_c__c = item.updatedQuantity;
        }
        //item.Return_Quantity_c__c += item.Delta_Quantity_c__c;
        updateOrderItems.push(item);
      }
    });
	
	/** begin by ashwin US SP2-16544 */

    this.coreChargeItems.forEach(itm => {

      const remanItem = updateOrderItems.find(obj => obj.Product_SKU_c__c === itm.Product_SKU_c__c);

      //condition to check remanItem-vairable is not null and updateOrderItems-array does not contains duplicate items
      if (remanItem && !updateOrderItems.some(cnt => cnt.Id === itm.Id)) {

        itm.updatedQuantity = remanItem.updatedQuantity;
        itm.UpdExtendedPrice = remanItem.UpdExtendedPrice;
        itm.Delta_Quantity_c__c = remanItem.Delta_Quantity_c__c;
        itm.Updated_Quantity_c__c = remanItem.Updated_Quantity_c__c;
        itm.errorMessage = null;

        updateOrderItems.push(itm);

      }
    })
	/**  ended by ashwin US SP2-16544 */


    console.log('updateOrderItems : ', JSON.stringify(updateOrderItems));
    if(isError == true){      
      this.orderItems = JSON.parse(tempOrderItemList);  
      this.errorMessage = 'Please enter valid values';
      console.log('this.orderItems : ',this.orderItems); 
      return;
    } else {     
      if(this.isHpdOrder){//added for HRC modification - Rajrishi 
        this.callHrcOrderRefund(updateOrderItems,customerNoteforModify);
      }else{
        this.updateOrderItem(updateOrderItems, 'modifyOrderDetails', 'Modify Order', customerNoteforModify);
      setTimeout(() => {
        this.methodName = 'modifyOrderDetails';
          this.spinnerflag=false;
        this.getOrderDetails();
        //refreshApex(this.wiredOrderList);           
      }, 11000);
    }            
  }
  }

  //added for HRC modification - Rajrishi 
  callHrcOrderRefund(updateOrderItems,customerNoteforModify){
    this.isLoading = true;
    this.closeModal();
    processHrcOrderRefund({lstOrderItem: updateOrderItems, customerNote:customerNoteforModify}).then(result=>{
      console.log('processHrcOrderRefund result => ', result);
      if(result){
        this.handleSuccessToastMessage('modifyOrderDetails');
        this.getOrderDetails();
        this.isLoading = false;
      }else {
        this.handleErrorToastMessage('modifyOrderDetails');
        this.isLoading = false;
      }
    }).catch(error => {
      this.isLoading = false;
      console.log('Error => ', error);
    })
  }

  handleEditClick(){
    console.log('Edit button clicked');
    this.shippingVender = null;
    this.otherCarrier = null;
    this.dealerShippingSpeed = null;
    this.trackingNumber = null;
    this.isShowModifyError = false;
    this.isInsertOrderFullFilment = true;
    this.isEditClicked = true;
    this.isModalOpen = true;    
  }

  handleShippngVendorChange(event){
    this.errorMessage = '';
    let value = event.detail.value;
    this.shippingVender = value; 
    this.otherCarrier = '';
    this.trackingNumber = '';
    if(value == 'Other'){
      this.isOtherSelected = true;
    }else {
      this.isOtherSelected = false;
    }   
  }

  handleShippingInfoChange(event){
    let other = /^[A-Za-z0-9 ]+$/;
    this.errorMessage = '';
    let name = event.currentTarget.name;
    let value = (event.detail.value).toUpperCase();     
    if(name == 'Tracking Number'){  
        this.trackingNumber = value;  
        let trackingCmp = this.template.querySelector('.trackingNumber');
        trackingCmp.setCustomValidity('');
        trackingCmp.reportValidity(); 

    }else if(name == 'Other Carrier'){
        let otherCarrierCmp = this.template.querySelector('.otherCarrier');
        if(!value){
          otherCarrierCmp.setCustomValidity("");
          otherCarrierCmp.reportValidity();
          this.otherCarrier = value;
          return;
        }
        if(other.test(value) == true){         
          this.otherCarrier = value;
          this.isShippingError = false;
          otherCarrierCmp.setCustomValidity("");
        }else {
          this.isShippingError = true;
          otherCarrierCmp.setCustomValidity("Please enter valid name");
        }
        otherCarrierCmp.reportValidity();       
      }  
  }

  handleShippingSpeedChange(event){
    this.dealerShippingSpeed = event.detail.value;
  }

  validateTrackingNumber(){
    let usps = /^\D{2}\d{9}US$|^\d{20}$|^\d{22}$/;
    let fedex = /^\d{10}$|^\d{12}$|^\d{15}$|^\d{20}$|^\d{22}$/;
    let ups = /^\b1Z[A-Z0-9]{16}\b$/;
    let tracking = /^[a-zA-Z0-9]+$/i;

    let trackingCmp = this.template.querySelector('.trackingNumber');
    let value = this.trackingNumber;
  
    trackingCmp.setCustomValidity('');
    if(this.shippingVender == 'UPS'){
      if(ups.test(value) == true){
        this.isShippingError = false;
      }else {
        this.isShippingError = true;
        trackingCmp.setCustomValidity("Please enter valid Tracking Number");
      }
    }else if(this.shippingVender == 'USPS'){
      if(usps.test(value) == true){
        this.isShippingError = false;
      }else {
        this.isShippingError = true;
        trackingCmp.setCustomValidity("Please enter valid Tracking Number");
      }
    }else if(this.shippingVender == 'FedEX'){
      if(fedex.test(value) == true){
        this.isShippingError = false;
      }else {
        this.isShippingError = true;
        trackingCmp.setCustomValidity("Please enter valid Tracking Number");
      }
    }else if(this.shippingVender == 'Other'){
      if(tracking.test(value) == true) {
        this.isShippingError = false;
      }else {
        this.isShippingError = true;
        trackingCmp.setCustomValidity("Please enter valid Tracking Number");
      } 
    }                
    trackingCmp.reportValidity();  
  }
  updateShippingInfo(){
    this.validateTrackingNumber();
    if(this.shippingVender && this.trackingNumber && this.dealerShippingSpeed){
      if(this.isShippingError != true){
        this.isLoading = true;         
        let order = this.objOrderTemp;
        // Added by Swaroop for HPD_Sprint5 -- Start
        if(this.isHpdOrder){
          let objOrdFullfilment = {};
          if (this.shippingVender != 'Other') {
            objOrdFullfilment.orderId = order.ExternalId;
            objOrdFullfilment.trackingNumber = this.trackingNumber;
            objOrdFullfilment.shipmentCarrier = this.shippingVender;
            if (this.dealerShippingSpeed) {
              objOrdFullfilment.hondaShippingSpeed = this.dealerShippingSpeed;
            }
            this.isInsertOrderFullFilment = true;
            this.insertUpdateOrderFullfilment(objOrdFullfilment,'insertShippingInfo',this.isInsertOrderFullFilment);
            this.closeModal();
          }else {
            if (this.otherCarrier){
              objOrdFullfilment.orderId = order.ExternalId;
              objOrdFullfilment.trackingNumber = this.trackingNumber;
              objOrdFullfilment.shipmentCarrier = this.otherCarrier;
              if (this.dealerShippingSpeed) {
                objOrdFullfilment.hondaShippingSpeed = this.dealerShippingSpeed;
              }
              this.isInsertOrderFullFilment = true;
              this.insertUpdateOrderFullfilment(objOrdFullfilment,'insertShippingInfo',this.isInsertOrderFullFilment);
              this.closeModal();
            } else{
              this.errorMessage = 'Please enter Other Carrier Name';
              this.isLoading = false;
            }
          }
        }
        // Added by Swaroop for HPD_Sprint5 -- End
        else{
          if (this.shippingVender != 'Other') {
            order.ShippingNumber_c__c = this.trackingNumber;
            order.Shipping_Vendors_c__c = this.shippingVender;
            if (this.dealerShippingSpeed) {
              order.Dealer_Shipping_Speed_c__c = this.dealerShippingSpeed;
            }
  
            order.Other_Carrier_c__c = '';
            this.updateorders(order, 'updateShippingInfo');
            this.closeModal();
          } else if (this.otherCarrier) {
            console.log('this.otherCarrier : ', this.otherCarrier);
            order.ShippingNumber_c__c = this.trackingNumber;
            order.Shipping_Vendors_c__c = this.shippingVender;
            if (this.dealerShippingSpeed) {
              order.Dealer_Shipping_Speed_c__c = this.dealerShippingSpeed;
            }
            order.Other_Carrier_c__c = this.otherCarrier;
            this.updateorders(order, 'updateShippingInfo');
            this.closeModal();
          } else {
            //show error
            this.errorMessage = 'Please enter Other Carrier Name';
            this.isLoading = false;
          }
        }
      } else {
        //show error
        this.errorMessage = 'Please enter correct values';
        this.isLoading = false;
      }
    } else {
      //show error
      this.errorMessage = 'Please fill the required fields';
      this.isLoading = false;
    }
    
  }

  //function for reprocessing payment for the order
  handleUpdateReprocessing(){
    console.log('Payment Reprocess button clicked');
    this.isLoading = true;
    let order = this.objOrderTemp;
    order.IsPaymentReproccessing_c__c = true; 
    this.updateorders(order, 'handleUpdateReprocessing');   
  }

  // --- functions for Partial Return starts --- //

  handlePartialReturnClick(){
    console.log('Edit button clicked');
    if(this.isActiveDealer == false){
      this.dispatchToastMessage('Error!', 'This functionality is not available.', 'error');
      return;
    }

    if(this.isDealerInstall){
      this.modalWidthStyle = 'max-width: 62rem;min-width: 75rem;';
    }else {
      this.modalWidthStyle = 'max-width: 62rem;min-width: 62rem;';
    }    
    this.isTaxCalculated = false;
    this.isPartialReturnClicked = true;
    this.shipRetVal = 'YES';
    this.restockingFees = '0.00';
    this.returnTax = '0.00';    
    this.updRestockingFees = '0.00';
    this.itemsReturnPrice = '0.00';
    this.installFullReturnPrice = '0.00';
    if(Number(this.objOrder.Updated_Shipping_c__c) > 0){
      this.shipRefundVal = '0.00';
      this.updatedShipRefundVal = '0.00';
    }else {
      this.shipRefundVal = '0.00';
      this.updatedShipRefundVal = '0.00';
    }
    this.isModalOpen = true;
  }

  restockingFeesChange(event){
    
    let resFees = event.detail.value;
    let returnCmp = this.template.querySelector('.restockingFees');
    if(/^[0-9.]+$/i.test(event.detail.value)){
      if(this.isEntireReturnClicked == false){     
        // below || Number(this.coreChargeItemsTotal) == 0)  added by ashwin in If condition for SP4-7818 || Number(this.coreChargeItemsTotal)
        if ((Number(this.itemsReturnPrice) == 0) && Number(resFees) > 0) {
          this.resErrorMessage = 'Please return any item to charge restocking fees.';
          returnCmp.setCustomValidity(" ");
          returnCmp.reportValidity();
        }
		// below || Number(resFees) <= Number(this.coreChargeItemsTotal))  added by ashwin in If condition for SP4-7818
        else if (Number(resFees) >= 0 && (Number(resFees) <= Number(this.itemsReturnPrice) )) {
          //for partial return         
          this.errorMessage = null;
          this.resErrorMessage = null;

          this.updRestockingFees = Number(resFees).toFixed(2);
          this.restockingFees = event.detail.value;  
          returnCmp.setCustomValidity("");
          returnCmp.reportValidity();
        }else {        
          this.resErrorMessage = 'Please enter a price less than or equal to the Total Item Return price.';
          returnCmp.setCustomValidity(' ');
          returnCmp.reportValidity();
        }
          
      }
          
    }else {     
      this.resErrorMessage = 'Please enter a valid price.';
      returnCmp.setCustomValidity(" ");
      returnCmp.reportValidity();
    }
    
  }

  partialShipRefundChange(event){
    let shipVal = event.detail.value;
    let shipCmp = this.template.querySelector('.shippingReturn');
    if (/^[0-9.]+$/i.test(shipVal)) {
      if (shipVal && Number(shipVal) >= 0 && Number(shipVal) <= Number(this.objOrder.netShippingAmountToRefund)) {//Imtiyaz - EVSE_Phase2_Sprint_3_HDMP-25942 Start
        this.isReturnError = false;
        this.errorMessage = null;
        this.shipRefundVal = shipVal;
        console.log('$TEST_: shipRefundVal_: ',this.shipRefundVal);
        this.updatedShipRefundVal = Number(shipVal).toFixed(2);     
        console.log('$TEST_: updatedShipRefundVal1: ',this.updatedShipRefundVal);
        shipCmp.setCustomValidity('');
        shipCmp.reportValidity();
        
      } else {
        this.isReturnError = true;
        let errorMessage = 'Please enter a price less than or equal to ' + this.objOrder.netShippingAmountToRefund;//Imtiyaz - EVSE_Phase2_Sprint_3_HDMP-25942 Start
        shipCmp.setCustomValidity(errorMessage);
        shipCmp.reportValidity();
      }
    }else {
      this.isReturnError = true;
      let errorMessage = 'Please enter a valid price';
      shipCmp.setCustomValidity(errorMessage);
      shipCmp.reportValidity();
    }
  }

  handleInstallPriceChange(event){
    this.errorMessage = null;
    let itemId = event.currentTarget.dataset.id;
    let index =  event.currentTarget.dataset.index;
    let className = '.installPrice'+index.toString();
    let installCmp = this.template.querySelector(className);  
    let installPrice = event.currentTarget.value;
    let items = this.orderItems;
    let tempItems = [];

    items.forEach(data => {
      let item = Object.assign({}, data); 
      if(item.Id == itemId){       
          if(installPrice && Number(installPrice) >= 0 && Number(installPrice) <= Number(item.currentInstallPrice)){
            console.log('inside if');
            item.deltaInstallPrice =  installPrice;         
            item.updatedInstallPrice = Number(installPrice);
            item.tempUpdInstallPrice = item.updatedInstallPrice.toFixed(2);                 
            item.isError = false;
            item.installErrorMessage = null;
            installCmp.setCustomValidity("");
            installCmp.reportValidity();
          }else {
            item.isError = true;
            item.installErrorMessage = "Please enter a price less than or equal to " + item.currentInstallPrice;
            installCmp.setCustomValidity(" ");    
            installCmp.reportValidity();    
          }        
      }
      tempItems.push(item);
    });
    console.log('tempItems : ',tempItems);
    this.orderItems = tempItems;

    this.installFullReturnPrice = 0;
    tempItems.forEach(data => {
      if(data.isError == false){
        this.installFullReturnPrice += Number(data.deltaInstallPrice);
      }
    });
    this.installFullReturnPrice = this.installFullReturnPrice > 0 ? this.installFullReturnPrice.toFixed(2) : '0.00';   
  }

  handleDeltaQuantityChange(event){ 
    this.errorMessage = null;
    let itemId = event.currentTarget.dataset.id;
    let index =  event.currentTarget.dataset.index;
    let className = '.deltaQuantity'+index.toString();  
    let quantityCmp = this.template.querySelector(className);  
    let quantity = event.currentTarget.value;
    let items = this.orderItems;
    let tempItems = [];   
    
      items.forEach(data => {
        let item = Object.assign({}, data); 
        if(item.Id == itemId){
          if(quantity){
            if(quantity == 0) {
              item.isError = false;       
              item.deltaQuantity = parseInt(quantity);
              item.updatedQuantity = item.currentQty;
              item.extendedPrice = (item.ListPrice__c * item.deltaQuantity).toFixed(2);
              item.errorMessage = null;
              quantityCmp.setCustomValidity("");
              quantityCmp.reportValidity();
            }else if(quantity > 0 && quantity <= item.currentQty){
              console.log('inside if');
              item.deltaQuantity = parseInt(quantity);         
              item.updatedQuantity = item.currentQty - parseInt(quantity);
              item.extendedPrice = (item.ListPrice__c * item.deltaQuantity).toFixed(2);              
              item.isError = false;
              item.errorMessage = null;
              quantityCmp.setCustomValidity("");
              quantityCmp.reportValidity();
            }else {
              item.isError = true;
              item.errorMessage = "Please enter a quantity less than or equal to " + item.currentQty;
              quantityCmp.setCustomValidity(" ");    
              quantityCmp.reportValidity();    
            }
          }else {
            item.isError = true;
            item.errorMessage = "Please enter a quantity less than or equal to " + item.currentQty;
            quantityCmp.setCustomValidity(" ");    
            quantityCmp.reportValidity();
          }          
        }          
        tempItems.push(item);
      });
   
      this.itemsReturnPrice = 0; 
	  this.coreChargeItemsTotal = 0; // Added by Ashwin for SP4-7818
      // update items price for partial return
      tempItems.forEach(data => {
        if(data.isError == false){
          let price = data.deltaQuantity * Number(data.ListPrice__c);
		  // If - else Added by ashwin for SP4-7818
        if(data.Product_Type_c__c != CORE_CHARGE){
          this.itemsReturnPrice += price;
        }
        else{
          this.coreChargeItemsTotal += price; //in else Added by Ashwin for SP4-7818
        }
          //let tax = Number(data.tax) * data.deltaQuantity;         
          //tempReturnTax += tax;
        }
      });

      if(this.isShowRestockingFees == true){
        if(this.objOrder.isPercentage == true){       
          this.restockingFees = ((this.itemsReturnPrice/100) * this.objOrder.percentage).toFixed(2);      
        }else if(this.itemsReturnPrice >= Number(this.objOrder.restockingFees)){
          this.restockingFees = this.objOrder.restockingFees;       
        }else {
          this.restockingFees = '0.00';
        }
        this.updRestockingFees = this.restockingFees;
        this.resErrorMessage = null;
      
        let returnCmp = this.template.querySelector('.restockingFees');
        returnCmp.setCustomValidity("");
        returnCmp.reportValidity();
      }
	  this.coreChargeItemsTotal = this.coreChargeItemsTotal.toFixed(2); // Added by ashwin for SP4-7818
      this.itemsReturnPrice = this.itemsReturnPrice.toFixed(2);
      console.log('this.itemsReturnPrice : ',this.itemsReturnPrice);
      this.orderItems = tempItems;   
  }

  calculateTaxFromVertax(event){    
    if(this.isReturnError == true || this.resErrorMessage){    
      this.errorMessage = 'Please enter valid values';
      return;
    }    
    let isError = false;
    let orderItemWrappers = [];
    this.orderItems.forEach(item => {
      if(item.isError == true){
        isError = true;     
      }else if(item.isError == false){ 
        if(item.deltaQuantity > 0) {
          orderItemWrappers.push({
            orderItemId : item.Id,
            quantity : item.deltaQuantity,
            unitPrice : Number(item.ListPrice__c),
            //Imtiyaz - EVSE_ Start
            itemTaxCode: item.Item_Tax_Code_c__c ? item.Item_Tax_Code_c__c : '',
            //Imtiyaz - EVSE_ End
            productType : item.Cart_Item_Product_Name_c__c == 'Motocompacto' ? 'Motocompacto' : ''
          });
        }       
      }
    });
      
    if(isError == true){
      this.errorMessage = 'Please enter valid values';
      return;
    }
    this.isLoading = true;
    let shipPrice = Number(this.shipRefundVal) > 0 ? this.shipRefundVal : '';
    let installPrice = Number(this.installFullReturnPrice) > 0 ? this.installFullReturnPrice : '';
    let restockFees = Number(this.restockingFees) > 0 ? this.restockingFees : '';
    if(orderItemWrappers.length > 0 || shipPrice || installPrice){
      getTax({orderDetails : this.objOrder, orderItemDetails : orderItemWrappers, shippingCharge : shipPrice,
        installationCharges : installPrice, reestockingfee : restockFees}).then(result => {
          console.log('result : ',result);
          let taxResponse = JSON.parse(result);
          if(result && taxResponse.isSuccess){                     
            this.returnTax = -1 * taxResponse.totalTaxAmount;   
            console.log('itemsReturnPrice : ',this.itemsReturnPrice);
            console.log('shipRefundVal : ',this.shipRefundVal);
            console.log('installFullReturnPrice : ',this.installFullReturnPrice);  
			     // Number(this.coreChargeItemsTotal) Added by ashwin in below calculation for SP4-7818
          if (this.returnTax > this.objOrder.netTax) {
            this.returnTax = Number(this.objOrder.netTax);
          }else if((this.returnTax < this.objOrder.netTax) && 
          (Number(this.objOrder.netItems) - Number(this.itemsReturnPrice) == 0) && 
          (Number(this.objOrder.netShipping) - Number(this.shipRefundVal) == 0)){ //Added by Swaroop/Rajrishi for HDMP-16033 Return Tax Fix
            this.returnTax = Number(this.objOrder.netTax) - Number(this.objOrder.Total_Restocking_Fee_Tax_c__c);
          }
          this.totalRefund = (this.returnTax + Number(this.itemsReturnPrice) + Number(this.shipRefundVal) + Number(this.installFullReturnPrice)) + Number(this.coreChargeItemsTotal) - Number(this.restockingFees);
            this.installPriceWithTax = Number(this.installFullReturnPrice) + Math.abs(taxResponse.installation_Charges_tax);
            
            this.installPriceWithTax = this.installPriceWithTax.toFixed(2);
            this.returnTax = this.returnTax.toFixed(2);
            this.totalRefund = this.totalRefund.toFixed(2);
            this.isTaxCalculated = true;   

			    /*Started by ashwin for SP4-7818*/
            this.restockingFees = this.restockingFees == 0 ? 0 : Number(this.restockingFees).toFixed(2);
            this.coreChargeItemsTotal = this.coreChargeItemsTotal == 0 ? 0 : Number(this.coreChargeItemsTotal).toFixed(2);
           /*Started by ashwin for SP4-7818*/
          }else {
            this.errorMessage = 'We’re sorry, an error occurred calculating the refund amount.  Please try again later.';
          }
          this.isLoading = false;
      }).catch(error => {
        this.isLoading = false;
        this.errorMessage = 'We’re sorry, an error occurred calculating the refund amount.  Please try again later.';
        console.log('Error : ',error);
      });
    }else {
      this.isLoading = false;
      this.errorMessage = 'Please return any item to calculate return summary.';
      return;
    }
    
  }
  
  handleDeltaQuantitySubmit(){
    let updateOrderItems = [];
    let isError = false;
    let tempOrderItemList = JSON.stringify(this.orderItems);  
	//Added by Lokesh for bug-29252
  let customerNoteforReturn
  console.log('1451',this.customerNoteValue.length)
  if(this.customerNoteValue.length){
    console.log('1453',this.customerNoteValue)
    customerNoteforReturn=this.customerNoteValue
  }
  console.log('1456',customerNoteforReturn)
 //let customerNoteforReturn = this.customerNoteValue.length ? this.customerNoteValue : '';
    this.orderItems.forEach(item => {
      if(item.isError == true){
        isError = true;     
      }else if(item.isError == false){       
        // if install price and item both are returning
        if(item.deltaQuantity > 0 && Number(item.deltaInstallPrice) > 0){       
          item.Delta_Quantity_c__c = item.deltaQuantity;
          item.Return_Quantity_c__c += item.Delta_Quantity_c__c;
        
          item.Delta_Installation_Price_c__c = Number(item.deltaInstallPrice); 
          item.Total_Return_Installation_Charge_c__c += Number(item.deltaInstallPrice);       
        //if items only returning 
        }else if(item.deltaQuantity > 0){          
          item.Delta_Quantity_c__c = item.deltaQuantity;
          item.Return_Quantity_c__c += item.Delta_Quantity_c__c;   
          item.Delta_Installation_Price_c__c = 0;         
        //if install price only returing 
        } else if(Number(item.deltaInstallPrice) > 0){        
          item.Delta_Installation_Price_c__c = Number(item.deltaInstallPrice);
          item.Total_Return_Installation_Charge_c__c += Number(item.deltaInstallPrice);   
          item.Delta_Quantity_c__c = 0;            
        }else {
          item.Delta_Quantity_c__c = 0;
          item.Delta_Installation_Price_c__c = 0;
        }
        //Start Added by Aditya HDMP-19422 // Saravanan Added Else Conditions for HDMP-19431
        if(item.isCoreCharge){
          // Saravanan LTIM Commented the code
          //item.Updated_Quantity_c__c = item.Quantity__c - item.Return_Quantity_c__c;
        }else{
          // Saravanan LTIM Commented the code
          //item.Updated_Quantity_c__c = item.Quantity__c - item.Return_Quantity_c__c; // 19431
        }
        //End Added by Aditya HDMP-19422
        updateOrderItems.push(item);     
      }
    });

    if(isError == true){
      this.orderItems = JSON.parse(tempOrderItemList);  
      this.errorMessage = 'Please enter valid values';
      console.log('this.orderItems : ',this.orderItems); 
      return;
    }else {
      if(this.isReturnError == true || this.resErrorMessage){
        this.orderItems = JSON.parse(tempOrderItemList);
        this.errorMessage = 'Please enter valid values';
      }else if(Number(this.totalRefund) > 0 || Number(this.installFullReturnPrice) > 0){
        updateOrderItems = updateOrderItems && updateOrderItems.length > 0 ? updateOrderItems : JSON.parse(tempOrderItemList);
        console.log('updateOrderItems inside if : ',updateOrderItems);
        console.log('this.installFullReturnPrice : ',this.installFullReturnPrice);
        this.updateOrderItem(updateOrderItems, 'handleDeltaQuantitySubmit', 'Partial Return', customerNoteforReturn);

        setTimeout(() => {
          console.log('setTimeout : ');
          this.methodName = 'handleDeltaQuantitySubmit';
          this.spinnerflag=false;
          this.getOrderDetails();
          this.isLoadingForCancel=false
          
          //refreshApex(this.wiredOrderList);           
        }, 16000);
      } else {
        this.errorMessage = 'Total refund amount is 0';
      }     
    } 
  }
  // --- functions for Partial Return ends --- //

  //function for cancelling the order
  handleCancelClick(){
    console.log('Cancel button clicked');  
    if(this.isActiveDealer == false){
      this.dispatchToastMessage('Error!', 'This functionality is not available.', 'error');
      return;
    }
    this.isCancelClicked = true;    
    this.isModalOpen = true; 
  }
  // --- functions related to payment ends--- // 
  
  //functions for changing order status by the click of button
  handleMarkOrderClick(event){
    this.isLoading = true;
    this.spinnerflag=false;

    let name = event.currentTarget.name;  

    if((name == 'Mark Order Shipped' || name == 'Mark Order Ready For Pickup') && this.isActiveDealer == false){
      this.isLoading = false;
      this.dispatchToastMessage('Error!', 'This functionality is not available.', 'error');
      return;
    }

    let order = {};
    order.Id = this.objOrderTemp.Id;
    order.Delivery_Types_c__c=this.objOrderTemp.Delivery_Types_c__c;
    order.Send_Email_To_Customer_c__c = this.isHpdOrder == true ? true : false; //Added by Swaroop for HPD-BUG-26573
    //Added by Lokesh for bug-29252
    //order.Customer_Notes_c__c = '';
   
    if (name == 'Mark Order Shipped') {
      if ((this.objOrderTemp.ShippingNumber_c__c && this.objOrderTemp.Shipping_Vendors_c__c) || (this.isHpdOrder==true && this.orderIdAndFulfilmentListMap.has(this.orderExternalId))) { //Added by Swaroop for HPD_Sprint5
        order.Status__c = 'ORDER COMPLETE - SHIPPED';
        let shippedDate = new Date();
        order.Shipped_Date_c__c = shippedDate;
        //order.Send_Email_To_Customer_c__c = true; //added by suresh for HDMP_28483
      }else {
        this.isLoading = false;
        this.isShowModifyError = true;
        this.isModalOpen = true;       
        return;
      }        

      if(name == 'Mark Order Shipped' && !this.isHpdOrder){//added by suresh for Payment settlement
        order.Send_Email_To_Customer_c__c = true;
      }


    } else if (name == 'Mark Order Ready For Pickup') {
      order.Status__c = 'READY FOR PICKUP';      
      order.Send_Email_To_Customer_c__c = true; // Added by Bruno - Issue : Ready For Pickup email not arriving.
    } else if (name == 'Mark Order Picked Up') {
      order.Send_Email_To_Customer_c__c = true;
      order.Status__c = 'ORDER COMPLETE - PICKED UP';
      order.isOrderPickedUp_c__c = true;
    }else if(name == 'Mark Order In Progress'){
      order.Status__c = 'IN PROGRESS';     
    }else if(name == 'Mark Installation Complete'){
      order.Status__c = 'ORDER COMPLETE - INSTALLED'; 
      order.Send_Email_To_Customer_c__c = true;    
    }
  
    //added by rajrishi - HDMP-27128
    if(order.Status__c == 'ORDER COMPLETE - SHIPPED' && this.isHpdOrder == true){
      this.isLoading = true;
      this.isHrcOrderInProgress = false;
      this.handleCreateShipmentAuditTrails(order);
    } else {
        if(!this.isHpdOrder && order.Delivery_Types_c__c!='Install At Dealer'){
          this.spinnerflag=true;
        }
        this.updateorders(order, 'handleMarkOrderClick');
        this.isLoading = true;
        if (order.Status__c == 'READY FOR PICKUP' || order.Status__c == 'ORDER COMPLETE - SHIPPED' || order.Status__c == 'IN PROGRESS' || order.Status__c == 'ORDER COMPLETE - PICKED UP') {
            setTimeout(() => {
                  this.isLoading = true;
                this.spinnerflag=false;
                this.methodName = 'handleMarkOrderClick';
                //refreshApex(this.wiredOrderList);
                this.getOrderDetails(); 
                      // this.isLoading = false;
              
            }, 20000);           
    
    }     
  }

  }

  handleCreateShipmentAuditTrails(order) {

    createShipmentAuditTrails({ order: order }).then(result => {
      this.isLoadingForCancel = false;
      console.log('result ===>  ', result);
      if(result){
        this.methodName = 'handleMarkOrderClick';
        this.getOrderDetails(); 
        this.isLoading = false;
       //this.handleSuccessToastMessage('handleMarkOrderClick');
      }else {
        this.isLoading = false;
        this.handleErrorToastMessage('handleMarkOrderClick');
      }
    }).catch(error => {
      this.isLoading = false;
      this.isLoadingForCancel = false;   
      this.handleErrorToastMessage('handleMarkOrderClick');
      console.log('error ===> ', error);
    });
  } 

  //--- helper functions --- //
  processCancelRequest(event){
    this.isLoading = true;
    let name = event.currentTarget.name;
    console.log('name : ',name);
    let order = this.objOrderTemp;
    order.Send_Email_To_Customer_c__c = false;
    if(name == 'Customer Cancel'){    
		order.Status__c = 'CUSTOMER CANCELED';
    }else if(name == 'Dealer Cancel'){
		order.Status__c = 'DEALER CANCELED';
    }     
		//Added by Lokesh for bug-29252
    if(this.customerNoteValue.length){
      order.Customer_Notes_c__c=this.customerNoteValue
    }
   // order.Customer_Notes_c__c = this.customerNoteValue.length ? this.customerNoteValue : '';
	  console.log('order123 : ',order);
    this.updateorders(order, 'processCancelRequest');
    this.closeModal();
 
    setTimeout(() => {
      console.log('setTimeout : ');
      this.methodName = 'processCancelRequest';
        this.spinnerflag=false;
      //refreshApex(this.wiredOrderList); 
      this.getOrderDetails();        
    }, 15000);
  
  }

  handlebackaction() {
    console.log('handlebackaction : ', this.isOpenOrderPage);
    console.log('handlebackaction : ', this.isDirectShip);
    if (this.isOpenOrderPage == 'true' && this.isDirectShip == false) {//Modified by Divya
      this[NavigationMixin.Navigate]({
        type: 'standard__webPage',
        attributes: {
          url: '/open-orders'
        }
      });

    } else if(this.isOpenOrderPage == 'true' && this.isDirectShip == true && this.isHpdOrder == true) { // Added by Swaroop for HPD_Sprint5
      this[NavigationMixin.Navigate]({
        type: 'standard__webPage',
        attributes: {
          url: '/open-orders'
        }
      });

    }else if (this.isOpenOrderPage == 'true' && this.isDirectShip == true) {//Added by Divya for EVSE_Phase2_Sprint1-START
      this[NavigationMixin.Navigate]({
        type: 'standard__webPage',
        attributes: {
          url: '/open-direct-ship-orders'
        }
      });    

    } else {//Added by Divya for EVSE_Phase2_Sprint1-END
      this[NavigationMixin.Navigate]({
        type: 'standard__webPage',
        attributes: {
          url: '/order-history'
    }
      });
    }
  }
    

  // --- generic methods start --- //



  // function for closing the model
  closeModal(){
    this.isModalOpen = false;
    this.isEditClicked = false;
    this.isCancelClicked = false;
    this.isModifyOrderClicked = false;
    this.isPartialReturnClicked = false;
    this.isEntireReturnClicked = false;
    this.isShowModifyError = false;   
    this.trackingNumber = this.storedTrackingNumber;
    this.isShippingError = false;     
    this.isReturnError = false;
    this.isShowEditNotes = false;
    this.isShowMoreInfo = false;//Changes by Divya HDMP-24337 
    this.isTaxCalculated = false;
    this.isInstallationReturn = false;
    this.orderItems = this.lstOrderItems;   
    this.errorMessage = null;
    this.modalWidthStyle = 'max-width: 40rem;min-width: 40rem;';   
	this.dealerNoteValue = '';//Added by Faraz for 8722
	this.customerNoteValue = '';//Added by Faraz for 8722
  }

  // Added by Swaroop for HPD_Sprint5 -- Start
  insertUpdateOrderFullfilment(objOrdFullfilment, methodName,isInsert){
    insertUpdateExternalOrdFullFilment({objOrdFulFillWrapper: objOrdFullfilment ,dmlOp: isInsert}).then(result =>{
      if(result){
        this.handleSuccessToastMessage(methodName); 
        this.spinnerflag=false;
        setTimeout(()=> this.getOrderDetails(),1500);
        //this.isLoading = false;
      }else {
        this.isLoading = false;
        this.handleErrorToastMessage(methodName);
      }
    }).catch(error => {
      console.log('Error : ', error);
      this.handleErrorToastMessage(methodName);
      this.isLoading = false;
    });
  }

  editShippingInfo(event){
    this.isShowModifyError = false;
    this.isShowMoreInfo = false;
    if(this.isHrcOrderInProgress){
      this.isEditClicked = true;
      this.isModalOpen = true;
    }
    this.isInsertOrderFullFilment = false;
    this.orderFullFillmentEdit = event.target.dataset.id;
    let tempCarrier = event.target.dataset.carrier;
    if(tempCarrier!='UPS' && tempCarrier!='USPS' && tempCarrier!='FedEX'){
      this.isOtherSelected = true;
      this.shippingVender = 'Other';
    }else{
      this.isOtherSelected = false;
      this.shippingVender = event.target.dataset.carrier;
    }
    this.otherCarrier = event.target.dataset.carrier;
    this.dealerShippingSpeed = event.target.dataset.shipspeed;
    this.trackingNumber = event.target.dataset.tracking;
  }

  callUpdateOrderFulFill(){
    this.validateTrackingNumber();
    if(this.shippingVender && this.trackingNumber && this.dealerShippingSpeed){
      if (this.isShippingError != true) {
        this.isLoading = true;
        let objOrdFullfilment = {};
        objOrdFullfilment.Id = this.orderFullFillmentEdit;
        objOrdFullfilment.orderId = this.orderExternalId;
        objOrdFullfilment.trackingNumber = this.trackingNumber;
        if (this.dealerShippingSpeed) {
          objOrdFullfilment.hondaShippingSpeed = this.dealerShippingSpeed;
        }
        if(this.shippingVender == 'Other'){
          if(this.otherCarrier){
            objOrdFullfilment.shipmentCarrier = this.otherCarrier;
            this.insertUpdateOrderFullfilment(objOrdFullfilment,'insertShippingInfo',this.isInsertOrderFullFilment);
            this.closeModal();
          }else{
            this.errorMessage = 'Please enter Other Carrier Name';
            this.isLoading = false;
          }
        }else{
          objOrdFullfilment.shipmentCarrier = this.shippingVender;
          this.insertUpdateOrderFullfilment(objOrdFullfilment,'insertShippingInfo',this.isInsertOrderFullFilment);
          this.closeModal();
        }
       
      }else {
        //show error
        this.errorMessage = 'Please enter correct values';
        this.isLoading = false;
      }
    }else {
      //show error
      this.errorMessage = 'Please fill the required fields';
      this.isLoading = false;
    }
  }
  // Added by Swaroop for HPD_Sprint5 -- End

  //fuction for updating order
  updateorders(order, methodName){
    updateExternalOrder({objOrder : order}).then(result => {
      if(result){         
        console.log('updateorders ', result); 
        console.log('methodName : ', methodName);
        if(methodName == 'saveEditNotes'){
          this.isLoading = false; 
          this.handleSuccessToastMessage(methodName);
        } else {
          if(order.Status__c == 'READY FOR PICKUP' || order.Status__c == 'ORDER COMPLETE - SHIPPED'){
            this.isLoadingForCancel = true;   
          }
          if(methodName == 'processCancelRequest' || methodName == 'handleReturnEntireOrder'){
            this.isLoadingForCancel = true;        
          } else {
            if (order.Status__c != 'READY FOR PICKUP' && order.Status__c != 'ORDER COMPLETE - SHIPPED' && order.Status__c != 'IN PROGRESS' && order.Status__c != 'ORDER COMPLETE - PICKED UP') {
              console.log('1849')
            this.isLoading = false;
              this.handleSuccessToastMessage(methodName); 
            }else if(methodName == 'updateShippingInfo' || methodName=='handleUpdateReprocessing'){
              this.handleSuccessToastMessage(methodName);
              this.isLoading = false;
            }
          } 
        }       
        if(this.isHpdOrder==true || order.Delivery_Types_c__c =='Install At Dealer'){
        this.getOrderDetails();
        }
      } else {
          this.handleErrorToastMessage(methodName);        
                          
      }         
    }).catch(error => {
      console.log('Error : ',error);
      this.handleErrorToastMessage(methodName);        
      this.isLoading = false;
    });      
  }

  //function for updating orderItem
  updateOrderItem(updateOrderItems,methodName,orderStatus, customerNoteVal){
    if((updateOrderItems && updateOrderItems.length > 0) || Number(this.shipRefundVal) > 0){
      this.isLoading = true;
	  console.log('updateOrderItemsF : ',updateOrderItems);
	  console.log('updateOrderItemsD : ',Number(this.shipRefundVal));
      updateExternalOrderItem({lstOrderItems : updateOrderItems, orderStatus : orderStatus,
        restockingFees : Number(this.restockingFees), shippingRefund : Number(this.shipRefundVal),
         installRefund : Number(this.installFullReturnPrice), TaxRefund : Number(this.returnTax), customerNote : customerNoteVal}).then(result => {       
          console.log('result : ',result); 
          this.getOrderDetails();                         
          //refreshApex(this.wiredOrderList);
          if(methodName != 'modifyOrderDetails'){
            this.isLoadingForCancel = true;  
          }
          if(methodName == 'modifyOrderDetails'){
            if(result){
             /// Ashwin LTIM Added forr 19427 
			       this.handleSuccessToastMessage(methodName);
              this.isLoadingForCancel = false;  // Saravanan LTIM removed it for 19464  
              this.isLoading = false;  // Saravanan LTIM removed it for 19464         
            }else {
              this.handleErrorToastMessage(methodName);
            }           
          }
                                        
      }).catch(error => {
        console.log('error : ',error);
        this.isLoading = false;      
          this.handleErrorToastMessage(methodName);             
      });    
      this.closeModal();
    }else {
      this.closeModal();
    }
  }

  handleSuccessToastMessage(methodName){
    if(methodName == 'processCancelRequest'){
      this.dispatchToastMessage('Success!', 'Your order is successfully cancelled.', 'success');
    }else if(methodName == 'handleUpdateReprocessing') {
      this.dispatchToastMessage('Success!', 'Your request for payment reprocessing is successful.', 'success');
    }else if(methodName == 'handleReturnEntireOrder') {
      this.dispatchToastMessage('Success!', 'Your request for order return is successful.', 'success');
    }else if(methodName == 'handleChargeCustomerClick') {
      this.dispatchToastMessage('Success!', 'The customer transaction is successful.', 'success');
    }else if(methodName == 'handleMarkOrderClick') {
      this.dispatchToastMessage('Success!', 'Order status changed successfully.', 'success');
    }else if(methodName == 'modifyOrderDetails') {
      this.dispatchToastMessage('Success!', 'Order products updated successfully.', 'success');
    }else if(methodName == 'handleDeltaQuantitySubmit') {
      this.dispatchToastMessage('Success!', 'Your order products return request is successful.', 'success');
    } else if (methodName == 'updateShippingInfo' || methodName == 'insertShippingInfo') { // Added by Swaroop for HPD_Sprint5
      this.dispatchToastMessage('Success!', 'Your shipping info is updated successfully.', 'success');
    }else if(methodName == 'saveEditNotes') {
      this.dispatchToastMessage('Success!', 'Your notes is updated successfully.', 'success');
    }      
    
  }

  handleErrorToastMessage(methodName){
    if(methodName == 'processCancelRequest'){
      this.dispatchToastMessage('Error!', 'Your request for order cancellation is failed, Please try again.', 'error'); 
    } else if(methodName == 'handleUpdateReprocessing') {
      this.dispatchToastMessage('Error!', 'Your request for payment reprocessing is failed, Please try again.', 'error');
    }else if(methodName == 'handleReturnEntireOrder') {
      this.dispatchToastMessage('Error!', 'Your request for order return is failed.', 'error');
    }else if(methodName == 'handleChargeCustomerClick') {
      this.dispatchToastMessage('Error!', 'The customer transaction is failed.', 'error');
    }else if(methodName == 'handleMarkOrderClick') {
      this.dispatchToastMessage('Error!', 'Order status change failed.', 'error');
    }else if(methodName == 'modifyOrderDetails') {
      this.dispatchToastMessage('Error!', 'Order products updation failed.', 'error');
    }else if(methodName == 'handleDeltaQuantitySubmit') {
      this.dispatchToastMessage('Error!', 'We’re sorry, an error occurred processing the refund. Please try again later.', 'error');
    } else if (methodName == 'updateShippingInfo' || methodName == 'insertShippingInfo') { // Added by Swaroop for HPD_Sprint5
      this.dispatchToastMessage('Error!', 'Your shipping info updation is failed.', 'error');
    }else if(methodName == 'saveEditNotes') {
      this.dispatchToastMessage('Error!', 'Your notes updation is failed.', 'error');
    }else if(methodName == 'processPayment'){
      this.dispatchToastMessage('Error!','We are Experiencing Technical difficulties, Please try again later')
    }else if (methodName == 'partialmodifiedOrder'){//added by suresh for payment settlement
      this.dispatchToastMessage('Error!', 'We are experiencing technical difficulties please try again later','error');
    }    
  }

  //fuction for Dispatching Toast Event
  dispatchToastMessage(title,message,variant) {
    this.dispatchEvent(
      new ShowToastEvent({
          title: title,
          message: message,
          variant: variant,
          mode : 'pester'
      }));      
  } 

  //function for getting Query Params from the URL
  getUrlParameter(name) {
    name = name.replace(/[\[]/, '\\[').replace(/[\]]/, '\\]');
    var regex = new RegExp('[\\?&]' + name + '=([^&#]*)');
    var results = regex.exec(location.search); 
    return results === null ? '' : decodeURIComponent(results[1].replace(/\+/g, ' '));
  } 

  formatDate(dateString){
    const dateWithoutTime = dateString.toString().split("T")[0];
		const finalDate = dateWithoutTime.split("-")[1]+"/"+dateWithoutTime.split("-")[2]+"/"+dateWithoutTime.split("-")[0];
		dateString = finalDate;
    return finalDate;
  }
  // --- generic methods ends --- //
  ///Added by suresh for HPDTransactionDateTimeStamp
  formatDateTimeStamp(datetimeStamp) {
    const dateWithoutTime = datetimeStamp.toString().split("T")[0];
    const finalDate = dateWithoutTime.split("-")[1] + "/" + dateWithoutTime.split("-")[2] + "/" + dateWithoutTime.split("-")[0];
      //const timeStamp = datetimeStamp.toString().split("Z")[0];
      let date = new Date(datetimeStamp);
      let hours = date.getHours();
      let minutes = date.getMinutes();    
      let newformat = hours >= 12 ? 'PM' : 'AM';
      hours = hours % 12;    
      hours = hours ? hours : 12;
      minutes = minutes < 10 ? '0' + minutes : minutes;
      const exactTime = hours + ':' + minutes + ' ' + newformat;
      console.log(hours + ':' + minutes + ' ' + newformat);
    const finalDataTime = finalDate + ', ' + exactTime;
    return finalDataTime;
  }//end


  //Added by Faraz for 8722 on 25/05/2022 - start
  handleGetAllDealerNotes(){
    console.log('OUTPUT : ',this.recordId);
    getAllDealerNotes({ orderId: this.recordId })
      .then(result => {
        if (result) {
          console.log('dealer data : ', JSON.parse(result));
          let data = JSON.parse(result);
          this.dealerNotesList = data[0]?.Dealers_Notes__r?.records;
          this.isDealerNotesExist = this.dealerNotesList?.length ? true : false;
          this.dealerNotesList?.forEach(element => {
            const d = new Date(element.CreatedDate__c);
            element.createdFormatDate = d.toLocaleString();
          });
          console.log('ss : ',this.dealerNotesList);
        }
      })
      .catch(error => {
        console.error('Error:', error);
    });
  }

  handleAddDealerNote(event){
    if (this.orderExternalId.length && this.dealerNoteValue.length) {
      this.isLoading = true;
      addDealerNotes({ orderId: this.orderExternalId, dealerNote: this.dealerNoteValue})
      .then(result => {
        if (result && result.includes('Note Added')) {
          console.log('Result', result);
          this.closeModal();
          this.handleGetAllDealerNotes();
          this.isLoading = false;
          this.handleSuccessToastMessage('saveEditNotes');
        }else{
          console.log('Result', result);
          this.isLoading = false;
          this.handleErrorToastMessage('saveEditNotes');
        }
      })
      .catch(error => {
        console.log('Error:', error);
        this.closeModal();
        this.isLoading = false;      
        this.handleErrorToastMessage('saveEditNotes');
      });        
    }
  }

  handleCustomerNotesChange(event){
    this.customerNoteValue = event.detail.value;
  }
  //Added by Faraz for 8722 on 25/05/2022 - End

  // Saravanan LTIM Added for HDMP-19453
  get shippingRefundValChange(){
    if(this.updatedShipRefundVal != null && this.updatedShipRefundVal > 0){
        return true;
    }else{
        return false;
    }
  }
   // Saravanan LTIM Added for HDMP-19453
}