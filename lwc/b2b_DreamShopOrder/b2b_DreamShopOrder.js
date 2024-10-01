/*******************************************************************************
Name: b2b_DreamShopOrder
Business Unit: <Insert business unit here>
Created Date: 7/30/2021, 12:33 PM
Developer: Vikrant Upneja
Description: LWC is created to handle UI and apex calling of dealer side for HDM org.
*******************************************************************************

MODIFICATIONS – Date | Dev Name         | Method | User Story
20/07/2022           | Rajrishi Kaushik | connectedCallback | HDMP-10201
*******************************************************************************/

import { LightningElement,api,wire,track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import getorderlist from '@salesforce/apex/B2B_GetOrderExt.OrderInfo';
import id from '@salesforce/user/Id';
import verifyaccessToken from '@salesforce/apex/HDMDealerExperienceController.verifyaccessToken';//added by suresh for PR
import fetchBTlatestStatus from '@salesforce/apex/HDMDealerExperienceController.fetchBTlatestStatus';//added by suresh for PR
const DIRECTSHIP = 'DirectShip';//Added by Divya for EVSE_Phase2_Sprint1-HDMP-24335
import BTAuthGuide from '@salesforce/resourceUrl/BTAuthGuide';
import showBTTokenMsg from '@salesforce/apex/B2B_GetOrderExt.showBTTokenMsg';

export default class b2b_DreamShopOrder extends NavigationMixin(LightningElement){
     
    @track openorderpage;
    @track opendirectshiporderpage;//Added by Divya for EVSE_Phase2_Sprint1-HDMP-24335
    @track searchvalue;      
    @track isDirectShipOrders = true;//Added by Divya for EVSE_Phase2_Sprint1-HDMP-24335  
    orderNumberSort = {'sortIcon' : 'utility:down', 'sortedDirection' : 'desc', 'iconStyle':''};
    customerNameSort = {'sortIcon' : 'utility:down', 'sortedDirection' : 'desc', 'iconStyle':''};
    phoneNumberSort = {'sortIcon' : 'utility:down', 'sortedDirection' : 'desc', 'iconStyle':''};
    statusrSort = {'sortIcon' : 'utility:down', 'sortedDirection' : 'desc', 'iconStyle':''};
    orderedDateSort = {'sortIcon' : 'utility:down', 'sortedDirection' : 'desc', 'iconStyle':''};
    totalAmountSort = {'sortIcon' : 'utility:down', 'sortedDirection' : 'desc', 'iconStyle':''};
    shipToStoreSort = {'sortIcon' : 'utility:down', 'sortedDirection' : 'desc', 'iconStyle':''};              
    paymentStatusSort =  {'sortIcon' : 'utility:down', 'sortedDirection' : 'desc', 'iconStyle':''};//added by suresh for PR           
            
    @track Order__x;
    lstOrders;
    @track error;
    @track isLoading = true;
    @api recordId;
    @track btstatus; //added by suresh for pR
    @track displaySearchAPIErrorMessage = false;
    @track accessTokenErrorMessage = false;
    @track dealerAccRevokedErrorMessage = false;

    isBTTokenActive = true;
    btAuthGuideUrL = BTAuthGuide; 
    
    connectedCallback(){
        var baseurl = window.location.href;
        // Added by Divya for EVSE Phase2_Sprint1_Stories-Start-HDMP-24335
        if(baseurl.includes('direct')==true){
            this.opendirectshiporderpage=true;
            this.openorderpage=true;
        }// Added by Divya for EVSE Phase2_Sprint1_Stories-END-HDMP-24335
        else if(baseurl.includes('open')==true){
            this.openorderpage=true;
            this.opendirectshiporderpage = false;// Added by Divya for EVSE Phase2_Sprint1_Stories-HDMP-24335
        }
        else{
            this.openorderpage=false;
        }

        sessionStorage.setItem('isOpenOrders', this.openorderpage);
        getorderlist({pageurl:this.openorderpage,pageurldirectship:this.opendirectshiporderpage})// Modified by Divya for EVSE Phase2_Sprint1_Stories-HDMP-24335
        .then(async result => {
            let orders = result;
            let orderList = [];
            if(this.opendirectshiporderpage == true && orders.length == 0){
                this.isDirectShipOrders = false;
            }
            console.log('orders for DirectShip ',orders);
            console.log('orders for DirectShip ',this.isDirectShipOrders);
            console.log('orders for DirectShip length ',orders.length);
            console.log('orders for DirectShip page ',this.opendirectshiporderpage);
            let accessTokenfromBT;
            await verifyaccessToken({ dealerPOIID: orders[0].AccountId__r.PoIId_c__c,orderid : orders[0].Id}).then( result => {
                
                accessTokenfromBT = result.accessToken;
                this.accessTokenErrorMessage = result.isRefreshTokenError;
                this.dealerAccRevokedErrorMessage = result.isDealerAccRevoked;

            });
            if(accessTokenfromBT != 'Contact BT' ){
                await fetchBTlatestStatus({accid : orders[0].AccountId__r.PoIId_c__c, access_Token :accessTokenfromBT}).then(result =>{
                     this.btstatus = result ;
                     if(result == false){
                        this.displaySearchAPIErrorMessage = true;
                     }
                     });
            }
            
            orders.forEach( async item => {
                let objOrder = Object.assign({}, item);
                //added by suresh for PR
                
                if(accessTokenfromBT  == 'Contact BT' ){
                    objOrder.latestStatus = (objOrder.BT_Transaction_Status_c__c == 'Settled')? 'Complete' : 'Contact BT';
                }else if(accessTokenfromBT != 'Contact BT' && this.btstatus == true ){   
                             
                objOrder.latestStatus =(objOrder.BT_Transaction_Status_c__c == 'Authorized' || objOrder.BT_Transaction_Status_c__c  == 'Authorization_Expired') ? 'Pending' :
                (objOrder.BT_Transaction_Status_c__c  == 'Submitted_For_Settlement' || objOrder.BT_Transaction_Status_c__c  == 'Settling') ? 'In Progress' :
                (objOrder.BT_Transaction_Status_c__c == 'Settled') ? 'Complete' :(objOrder.BT_Transaction_Status_c__c  == 'Voided') ? 'Payment Cancelled' :
                (objOrder.BT_Transaction_Status_c__c  == 'Processor_Declined' || objOrder.BT_Transaction_Status_c__c  == 'Gateway_Rejected' || objOrder.BT_Transaction_Status_c__c  == 'Settlement_Declined') ? 'Payment Failure' : 'Unavailable' ;
                this.isLoading = false;
                }else if(accessTokenfromBT != 'Contact BT' && this.btstatus == false ){
                    objOrder.latestStatus = (objOrder.BT_Transaction_Status_c__c == 'Settled')? 'Complete' : 'Unavailable';
                }else{
                    this.isLoading = false;
                 } 
                objOrder.OrderedDate__c = this.formatDate(objOrder.OrderedDate__c);
                objOrder.Status__c = (objOrder.Status__c == 'Activated') ? 'SUBMITTED' : 
                                    (objOrder.Status__c == 'CUSTOMER CANCELED') ? 'CUSTOMER CANCELLED' : 
                                    (objOrder.Status__c == 'DEALER CANCELED') ? 'DEALER CANCELLED' : objOrder.Status__c; 
                                                   
                                                  
                if((objOrder.SHIPPING_from_cart_c__c && objOrder.SHIPPING_from_cart_c__c > 0 && objOrder.Type__c != DIRECTSHIP) || (objOrder.SHIPPING_from_cart_c__c == 0 && objOrder.Product_Division_c__c == '9')){//Modified by Divya for EVSE_Phase2-Sprint1-HDMP-24335
                    objOrder.shipToStore ='Ship To Home';                            
                    console.log('objOrder.Type__c '+objOrder.Type__c);                         
                }else if(objOrder.SHIPPING_from_cart_c__c && objOrder.SHIPPING_from_cart_c__c > 0 && objOrder.Type__c == DIRECTSHIP){//Added by Divya for EVSE_Phase2-Sprint1-START-HDMP-24335
                    objOrder.shipToStore = 'DIRECT SHIP';
                    console.log('objOrder.Type__c '+objOrder.Type__c);                             
                }else{ //Added by Divya for EVSE_Phase2-Sprint1-END HDMP-24335                     
                    if(objOrder.Delivery_Types_c__c && objOrder.Delivery_Types_c__c == 'Install At Dealer'){
                        objOrder.shipToStore = 'Dealer Install';
                        if(objOrder.Status__c == 'SUBMITTED'){
                            objOrder.Status__c = 'READY FOR INSTALLATION';
                        }
                      }else {
                        objOrder.shipToStore ='Pickup At Dealer';
                      } 
                }
                //objOrder.OrderNumber = objOrder.OrderNumber__c ? parseInt(objOrder.OrderNumber__c) : objOrder.OrderNumber__c;
                //R2B changes for HDMP-10201
                objOrder.OrderNumber = objOrder.OrderReferenceNumber__c ? objOrder.OrderReferenceNumber__c : objOrder.OrderNumber__c;
                objOrder.phone = objOrder.BillingPhoneNumber__c ? parseInt(objOrder.BillingPhoneNumber__c) : '';
                objOrder.customerName = objOrder.Customer_Name_c__c ? objOrder.Customer_Name_c__c.toLowerCase() : '';
                objOrder.Total_Return_c__c = objOrder.Total_Return_c__c ? objOrder.Total_Return_c__c : 0;
                //objOrder.totalAmount = objOrder.Updated_Order_Total_c__c ? '$'+ objOrder.Updated_Order_Total_c__c.toFixed(2) : '$0.00';
                const unavailableAmt =  objOrder.Total_Unavailable_Amt_c__c != null ? objOrder.Total_Unavailable_Amt_c__c.toFixed(2) : 0;
                objOrder.totalAmount = (Math.abs(objOrder.Updated_Order_Total_c__c - unavailableAmt -  objOrder.Total_Return_c__c)).toFixed(2); //Added Total_Unavailable_Amt_c__c by Swaroop for HRC - 27195
                objOrder.totalAmount = objOrder.totalAmount ? '$' + objOrder.totalAmount : '$0.00';
                objOrder.Updated_Order_Total_c__c = objOrder.Updated_Order_Total_c__c ? parseFloat((Math.abs(objOrder.Updated_Order_Total_c__c - objOrder.Total_Return_c__c)).toFixed(2)) : 0.00;                                                   
                orderList.push(objOrder);
            })
            this.Order__x = orderList;
            this.lstOrders = orderList;                  
            this.isLoading = false;
            console.log('this.Order__x : ',this.Order__x);
        })
        .catch(error => {
            this.error = error;
            this.isLoading = false;
            console.log('error : ',error);
        });

        //Added this function to display message in Dealer Console for CAPS-4066
        showBTTokenMsg() 
        .then(result => {
            if(result){
                this.isBTTokenActive = result;
            }else{
                this.isBTTokenActive = result;
            }
        })
        .catch(error =>{
            console.log(error);
        })
    }  
    
    handlesearch(event){
        let searchvalue = event.target.value;
        searchvalue = searchvalue.toLowerCase();
        console.log('OUTPUT : ',searchvalue);
        let orders = [];
        this.lstOrders.forEach(item => {
            if(item.OrderNumber && item.OrderNumber.toString().toLowerCase().includes(searchvalue) || 
                item.OrderedDate__c && item.OrderedDate__c.toLowerCase().includes(searchvalue) ||
                item.Customer_Name_c__c && item.Customer_Name_c__c.toLowerCase().includes(searchvalue) ||
                item.BillingPhoneNumber__c && item.BillingPhoneNumber__c.toString().toLowerCase().includes(searchvalue) ||
                item.shipToStore && item.shipToStore.toLowerCase().includes(searchvalue) || 
                item.totalAmount && item.totalAmount.toString().toLowerCase().includes(searchvalue) ||
                item.Status__c && item.Status__c.toLowerCase().includes(searchvalue) ||
                item.latestStatus && item.latestStatus.toLowerCase().includes(searchvalue)){ //modified by suresh for PR
                    orders.push(item);
            }
        });

        this.Order__x = orders;           
        console.log('Search result : ',JSON.parse(this.Order__x));         

    }

    navigateToOrderRecordPage(event){ 

            let orderRecordId=  event.target.dataset.recordId;
            console.log('Orderid ',orderRecordId);
            this[NavigationMixin.Navigate]({
                type: 'standard__webPage',
                attributes : {
                    url : '/orderhistoryview?Id='+orderRecordId
                }
            });
    }
    
    getUrlParameter(name) {
        name = name.replace(/[\[]/, '\\[').replace(/[\]]/, '\\]');
        var regex = new RegExp('[\\?&]' + name + '=([^&#]*)');
        var results = regex.exec(location.search); 
        return results === null ? '' : decodeURIComponent(results[1].replace(/\+/g, ' '));
    }     

    handleSortOrders(event) { 
        console.log('idd : ',event.currentTarget.dataset.id);
        let fieldName = event.currentTarget.dataset.id;
        let direction;
       
        if(fieldName == 'OrderNumber'){
            this.orderNumberSort.sortedDirection = this.orderNumberSort.sortedDirection === "asc" ? "desc" : "asc";
            this.orderNumberSort.sortIcon = this.orderNumberSort.sortedDirection === "desc" ? 'utility:down' : 'utility:up';
            this.orderNumberSort.iconStyle = this.orderNumberSort.sortedDirection === "desc" ? '' : 'line-height: 1rem;';
            direction = this.orderNumberSort.sortedDirection;
        }else if(fieldName == 'customerName'){
            this.customerNameSort.sortedDirection = this.customerNameSort.sortedDirection === "asc" ? "desc" : "asc";
            this.customerNameSort.sortIcon = this.customerNameSort.sortedDirection === "desc" ? 'utility:down' : 'utility:up';
            this.customerNameSort.iconStyle = this.customerNameSort.sortedDirection === "desc" ? '' : 'line-height: 1rem;';
            direction = this.customerNameSort.sortedDirection;
        }else if(fieldName == 'phone'){
            this.phoneNumberSort.sortedDirection = this.phoneNumberSort.sortedDirection === "asc" ? "desc" : "asc";
            this.phoneNumberSort.sortIcon = this.phoneNumberSort.sortedDirection === "desc" ? 'utility:down' : 'utility:up';
            this.phoneNumberSort.iconStyle = this.phoneNumberSort.sortedDirection === "desc" ? '' : 'line-height: 1rem;';
            direction = this.phoneNumberSort.sortedDirection;
        }else if(fieldName == 'Status__c'){
            this.statusrSort.sortedDirection = this.statusrSort.sortedDirection === "asc" ? "desc" : "asc";
            this.statusrSort.sortIcon = this.statusrSort.sortedDirection === "desc" ? 'utility:down' : 'utility:up';
            this.statusrSort.iconStyle = this.statusrSort.sortedDirection === "desc" ? '' : 'line-height: 1rem;';
            direction = this.statusrSort.sortedDirection;
        }else if(fieldName == 'OrderedDate__c'){
            this.orderedDateSort.sortedDirection = this.orderedDateSort.sortedDirection === "asc" ? "desc" : "asc";
            this.orderedDateSort.sortIcon = this.orderedDateSort.sortedDirection === "desc" ? 'utility:down' : 'utility:up';
            this.orderedDateSort.iconStyle = this.orderedDateSort.sortedDirection === "desc" ? '' : 'line-height: 1rem;';
            direction = this.orderedDateSort.sortedDirection;
        }else if(fieldName == 'Updated_Order_Total_c__c'){
            this.totalAmountSort.sortedDirection = this.totalAmountSort.sortedDirection === "asc" ? "desc" : "asc";
            this.totalAmountSort.sortIcon = this.totalAmountSort.sortedDirection === "desc" ? 'utility:down' : 'utility:up';
            this.totalAmountSort.iconStyle = this.totalAmountSort.sortedDirection === "desc" ? '' : 'line-height: 1rem;';
            direction = this.totalAmountSort.sortedDirection;
        }else if(fieldName == 'shipToStore'){
            this.shipToStoreSort.sortedDirection = this.shipToStoreSort.sortedDirection === "asc" ? "desc" : "asc";
            this.shipToStoreSort.sortIcon = this.shipToStoreSort.sortedDirection === "desc" ? 'utility:down' : 'utility:up';
            this.shipToStoreSort.iconStyle = this.shipToStoreSort.sortedDirection === "desc" ? '' : 'line-height: 1rem;';
            direction = this.shipToStoreSort.sortedDirection;
        }else if(fieldName == 'BT_Transaction_Status_c__c'){//added by suresh for PR
            this.paymentStatusSort.sortedDirection = this.paymentStatusSort.sortedDirection === "asc" ? "desc" : "asc";
            this.paymentStatusSort.sortIcon = this.paymentStatusSort.sortedDirection === "desc" ? 'utility:down' : 'utility:up';
            this.paymentStatusSort.iconStyle = this.paymentStatusSort.sortedDirection === "desc" ? '' : 'line-height: 1rem;';
            direction = this.paymentStatusSort.sortedDirection;
        } 
        this.changeIconOnSort(fieldName);               
        console.log('FN: ', fieldName);          
        let table = JSON.parse(JSON.stringify(this.lstOrders));                               
        console.log(table);                          
        let reverse = direction === 'asc' ? 1 : -1;
        console.log(reverse);
        if(fieldName == 'OrderedDate__c'){
            if(reverse == 1){
                table.sort((a, b) => { 
                    const dateA = new Date(a.OrderedDate__c);
                    const dateB = new Date(b.OrderedDate__c);
                    return dateA - dateB;
                });
            }else{
                table.sort((a, b) => { 
                    const dateA = new Date(a.OrderedDate__c);
                    const dateB = new Date(b.OrderedDate__c);
                    return dateB - dateA;
                });
            }
        }else if(fieldName == 'Updated_Order_Total_c__c'){
            if(reverse == 1){
                table.sort((a, b) => { 
                    return a.Updated_Order_Total_c__c - b.Updated_Order_Total_c__c;
                });
            }else{
                table.sort((a, b) => { 
                    return b.Updated_Order_Total_c__c - a.Updated_Order_Total_c__c;
                });
            }
        }
        else{
        table.sort((a,b) => {return a[fieldName] > b[fieldName] ? 1 * reverse : -1 * reverse});
        }
        console.log(table);
        this.Order__x = table;
    }

    changeIconOnSort(fieldName){
        if(fieldName == 'OrderNumber'){          
            this.customerNameSort = {'sortIcon' : 'utility:down', 'sortedDirection' : 'desc', 'iconStyle':''};
            this.phoneNumberSort = {'sortIcon' : 'utility:down', 'sortedDirection' : 'desc', 'iconStyle':''};
            this.statusrSort = {'sortIcon' : 'utility:down', 'sortedDirection' : 'desc', 'iconStyle':''};
            this.orderedDateSort = {'sortIcon' : 'utility:down', 'sortedDirection' : 'desc', 'iconStyle':''};
            this.totalAmountSort = {'sortIcon' : 'utility:down', 'sortedDirection' : 'desc', 'iconStyle':''};
            this.shipToStoreSort = {'sortIcon' : 'utility:down', 'sortedDirection' : 'desc', 'iconStyle':''};
            this.paymentStatusSort =  {'sortIcon' : 'utility:down', 'sortedDirection' : 'desc', 'iconStyle':''};
        }else if(fieldName == 'customerName'){
            this.orderNumberSort = {'sortIcon' : 'utility:down', 'sortedDirection' : 'desc', 'iconStyle':''};           
            this.phoneNumberSort = {'sortIcon' : 'utility:down', 'sortedDirection' : 'desc', 'iconStyle':''};
            this.statusrSort = {'sortIcon' : 'utility:down', 'sortedDirection' : 'desc', 'iconStyle':''};
            this.orderedDateSort = {'sortIcon' : 'utility:down', 'sortedDirection' : 'desc', 'iconStyle':''};
            this.totalAmountSort = {'sortIcon' : 'utility:down', 'sortedDirection' : 'desc', 'iconStyle':''};
            this.shipToStoreSort = {'sortIcon' : 'utility:down', 'sortedDirection' : 'desc', 'iconStyle':''};
            this.paymentStatusSort =  {'sortIcon' : 'utility:down', 'sortedDirection' : 'desc', 'iconStyle':''};
        }else if(fieldName == 'phone'){
            this.orderNumberSort = {'sortIcon' : 'utility:down', 'sortedDirection' : 'desc', 'iconStyle':''};
            this.customerNameSort = {'sortIcon' : 'utility:down', 'sortedDirection' : 'desc', 'iconStyle':''};           
            this.statusrSort = {'sortIcon' : 'utility:down', 'sortedDirection' : 'desc', 'iconStyle':''};
            this.orderedDateSort = {'sortIcon' : 'utility:down', 'sortedDirection' : 'desc', 'iconStyle':''};
            this.totalAmountSort = {'sortIcon' : 'utility:down', 'sortedDirection' : 'desc', 'iconStyle':''};
            this.shipToStoreSort = {'sortIcon' : 'utility:down', 'sortedDirection' : 'desc', 'iconStyle':''};
            this.paymentStatusSort =  {'sortIcon' : 'utility:down', 'sortedDirection' : 'desc', 'iconStyle':''};
        }else if(fieldName == 'Status__c'){
            this.orderNumberSort = {'sortIcon' : 'utility:down', 'sortedDirection' : 'desc', 'iconStyle':''};
            this.customerNameSort = {'sortIcon' : 'utility:down', 'sortedDirection' : 'desc', 'iconStyle':''};
            this.phoneNumberSort = {'sortIcon' : 'utility:down', 'sortedDirection' : 'desc', 'iconStyle':''};          
            this.orderedDateSort = {'sortIcon' : 'utility:down', 'sortedDirection' : 'desc', 'iconStyle':''};
            this.totalAmountSort = {'sortIcon' : 'utility:down', 'sortedDirection' : 'desc', 'iconStyle':''};
            this.shipToStoreSort = {'sortIcon' : 'utility:down', 'sortedDirection' : 'desc', 'iconStyle':''};
            this.paymentStatusSort =  {'sortIcon' : 'utility:down', 'sortedDirection' : 'desc', 'iconStyle':''};
        }else if(fieldName == 'OrderedDate__c'){
            this.orderNumberSort = {'sortIcon' : 'utility:down', 'sortedDirection' : 'desc', 'iconStyle':''};
            this.customerNameSort = {'sortIcon' : 'utility:down', 'sortedDirection' : 'desc', 'iconStyle':''};
            this.phoneNumberSort = {'sortIcon' : 'utility:down', 'sortedDirection' : 'desc', 'iconStyle':''};
            this.statusrSort = {'sortIcon' : 'utility:down', 'sortedDirection' : 'desc', 'iconStyle':''};          
            this.totalAmountSort = {'sortIcon' : 'utility:down', 'sortedDirection' : 'desc', 'iconStyle':''};
            this.shipToStoreSort = {'sortIcon' : 'utility:down', 'sortedDirection' : 'desc', 'iconStyle':''};
            this.paymentStatusSort =  {'sortIcon' : 'utility:down', 'sortedDirection' : 'desc', 'iconStyle':''};
        }else if(fieldName == 'Updated_Order_Total_c__c'){
            this.orderNumberSort = {'sortIcon' : 'utility:down', 'sortedDirection' : 'desc', 'iconStyle':''};
            this.customerNameSort = {'sortIcon' : 'utility:down', 'sortedDirection' : 'desc', 'iconStyle':''};
            this.phoneNumberSort = {'sortIcon' : 'utility:down', 'sortedDirection' : 'desc', 'iconStyle':''};
            this.statusrSort = {'sortIcon' : 'utility:down', 'sortedDirection' : 'desc', 'iconStyle':''};
            this.orderedDateSort = {'sortIcon' : 'utility:down', 'sortedDirection' : 'desc', 'iconStyle':''};           
            this.shipToStoreSort = {'sortIcon' : 'utility:down', 'sortedDirection' : 'desc', 'iconStyle':''};
            this.paymentStatusSort =  {'sortIcon' : 'utility:down', 'sortedDirection' : 'desc', 'iconStyle':''};
        }else if(fieldName == 'shipToStore'){
            this.orderNumberSort = {'sortIcon' : 'utility:down', 'sortedDirection' : 'desc', 'iconStyle':''};
            this.customerNameSort = {'sortIcon' : 'utility:down', 'sortedDirection' : 'desc', 'iconStyle':''};
            this.phoneNumberSort = {'sortIcon' : 'utility:down', 'sortedDirection' : 'desc', 'iconStyle':''};
            this.statusrSort = {'sortIcon' : 'utility:down', 'sortedDirection' : 'desc', 'iconStyle':''};
            this.orderedDateSort = {'sortIcon' : 'utility:down', 'sortedDirection' : 'desc', 'iconStyle':''};
            this.totalAmountSort = {'sortIcon' : 'utility:down', 'sortedDirection' : 'desc', 'iconStyle':''};            
            this.paymentStatusSort =  {'sortIcon' : 'utility:down', 'sortedDirection' : 'desc', 'iconStyle':''};          
        }else if(fieldName == 'BT_Transaction_Status_c__c'){//added by suresh for PR
            this.orderNumberSort = {'sortIcon' : 'utility:down', 'sortedDirection' : 'desc', 'iconStyle':''};
            this.customerNameSort = {'sortIcon' : 'utility:down', 'sortedDirection' : 'desc', 'iconStyle':''};
            this.phoneNumberSort = {'sortIcon' : 'utility:down', 'sortedDirection' : 'desc', 'iconStyle':''};
            this.statusrSort = {'sortIcon' : 'utility:down', 'sortedDirection' : 'desc', 'iconStyle':''};
            this.orderedDateSort = {'sortIcon' : 'utility:down', 'sortedDirection' : 'desc', 'iconStyle':''};
            this.totalAmountSort = {'sortIcon' : 'utility:down', 'sortedDirection' : 'desc', 'iconStyle':''}; 
            this.shipToStoreSort = {'sortIcon' : 'utility:down', 'sortedDirection' : 'desc', 'iconStyle':''};           
        }
    }

    formatDate(dateString){
        const dateWithoutTime = dateString.toString().split("T")[0];
		const finalDate = dateWithoutTime.split("-")[1]+"/"+dateWithoutTime.split("-")[2]+"/"+dateWithoutTime.split("-")[0];
		dateString = finalDate;
        return finalDate;
    }    

}