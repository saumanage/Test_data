/*******************************************************************************
Name: B2B_dealerSetting
Business Unit: <Insert business unit here>
Created Date: 7/30/2021, 12:33 PM
Developer: Vikrant Upneja
Description: LWC is created to handle UI and apex calling of dealer side for HDM org.
*******************************************************************************/
import { LightningElement,track } from 'lwc';
import getAccountDetails from '@salesforce/apex/HDMDealerExperienceController.getAccountDetails';
import updateDealerAccount from '@salesforce/apex/HDMDealerExperienceController.updateDealerAccount';
import updateOpsTeam from '@salesforce/apex/HDMDealerExperienceController.updateOpsTeam';// Added by Aditya to fix 19411
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import B2B_Sales_Tax_Disclaimer from '@salesforce/label/c.B2B_Sales_Tax_Disclaimer'; // Pratik LTIM Added for Sp-4 Tax Juri



export default class B2B_dealerSetting extends LightningElement {
    chargeRestockingOptions = [{label : 'Yes',value : 'Yes'},{label : 'No',value : 'No'}];
    restockingTypeOptions = [{label : 'Flat',value : 'Flat'},{label : 'Percentage',value : 'Percentage'}];
    @track restockingType = '';
    @track chargeRestocking = '';
    @track showRestockingFeeSecton = false;
    @track restockingFeesPercentage = '';
    shippingMethod = '';
    shippingMethodOptions = [{label : 'FEDEX',value : 'FEDEX'},{label : 'UPS',value : 'UPS'},{label : 'USPS',value : 'USPS'},{label : 'No Shipping',value : 'No Shipping'}];//modified by suresh for No shipping
    objAccount = '';
    schedulingLink = '';
    hourlyLaborRate = '';
    @track restockingFees = '';
    returnWindow = '';
    @track isHRC = false;
    @track isLoading = true;
    isPercentage = false;
    @track isDealerNonAdmin = false;
    error = {
        isWindowError : false,
        isFeesError : false,
        isPerError : false,
        isSystemError : false 
    }// Added isSystemError by Aditya to fix 19411
    @track lstCarriers = [];

    @track salesJurisdications = [{label : 'All 50 States',value : 'All 50 States'},{label : 'Dealer State Only',value : 'Dealer State Only'}]; // prateek LTIM added for Sprint -4
    @track salesValues = ''; // prateek LTIM added for Sprint -4
    @track lstAllStates = ''; // prateek LTIM added for Sprint -4
    @track salesTaxDisclaimer = B2B_Sales_Tax_Disclaimer ; // prateek LTIM added for Sprint -4

    connectedCallback(){
        getAccountDetails().then(resultWrap => {
            if(resultWrap){              
                console.log('resultWrap : ',resultWrap);
                if(!resultWrap.isDealerAdmin)
                    this.isDealerNonAdmin = true;
                this.objAccount = resultWrap.lstAccounts[0];
                if(this.objAccount.DivisionCd_c__c == '9'){
                    this.isHRC = true;
                }
                this.lstCarriers = resultWrap.lstCarriers;
                let result = resultWrap.lstAccounts[0];
                
                if(this.lstCarriers && result.Preferred_Shipping_Carrier_c__c){
                    this.shippingMethod = this.lstCarriers.filter(item => item.ExternalId == result.Preferred_Shipping_Carrier_c__c)[0].Name__c;
                }
                this.schedulingLink = result.schedule_installation_c__c ? result.schedule_installation_c__c : '';
                this.chargeRestocking = result.Charge_Restocking_Fees_c__c ? result.Charge_Restocking_Fees_c__c : '';
                this.returnWindow = result.Return_Window_c__c ? result.Return_Window_c__c : '';
                this.restockingFees = (result.Restocking_Fees_c__c || result.Restocking_Fees_c__c == 0) ? result.Restocking_Fees_c__c : '';
                this.restockingType = result.Restocking_Fees_Type_c__c ?  result.Restocking_Fees_Type_c__c : '';
                if(this.restockingType && this.restockingType == 'Percentage'){
                    this.isPercentage = true;
                }
                if(this.chargeRestocking == 'No'){
                    this.showRestockingFeeSecton = true;
                }
                //this.hourlyLaborRate = result.Hourly_Labor_Rate_c__c;
                this.restockingFeesPercentage = (result.Restocking_Fees_Percentage_c__c || result.Restocking_Fees_Percentage_c__c == 0) ? result.Restocking_Fees_Percentage_c__c : '';

                // Pratik LTIM Added for Sales Jurisdifications
                 for(var statesVal in resultWrap.wrapSales.mapStatetoCode){

                    this.lstAllStates += resultWrap.wrapSales.mapStatetoCode[statesVal]+';';
                    
                    /**const option = {
                        label: statesVal,
                        value: resultWrap.wrapSales.mapStatetoCode[statesVal]
                    };**/
                    //this.salesJurisdications = [ ...this.salesJurisdications, option ];
                 }

                 this.lstAllStates = this.lstAllStates.substring(0, this.lstAllStates.length-1);

                /**  if(this.lstAllStates == this.objAccount.Sales_Tax_Jurisdiction__c){
                    this.salesValues = 'All 50 States';
                 }else{
                    this.salesValues = 'Dealer State Only';
                 }***/

                 /** Saravanan LTIM 19410 Changes */
                 if(this.objAccount.Sales_Tax_Jurisdiction__c){
                    // 24264 second satement changed to else if to if
                    if(this.objAccount.Sales_Tax_Jurisdiction__c.split(';').length >= 50 ){
                        this.salesValues = 'All 50 States';
                    }
                    else if(this.objAccount.ShippingState__c == this.objAccount.Sales_Tax_Jurisdiction__c){
                        this.salesValues = 'Dealer State Only';
                    }
                    else{
                        this.salesJurisdications.push({label : 'Custom',value : 'Custom'});
                        this.salesValues = 'Custom';
                    }
                 }
                  /** Saravanan LTIM 19410 Changes */

                 if(resultWrap.isDealerAdmin){
                    
                 }

                 // Pratik LTIM Ended for Sales Jurisdifications

            }

            

            this.isLoading = false;
        }).catch(error => {
            this.isLoading = false;
            console.log('Error : ', error);
        });
    }

    handleRestockingTypeChange(event){
        this.restockingType = event.detail.value;
        this.objAccount.Restocking_Fees_Type_c__c = event.detail.value;
        if(this.restockingType == 'Percentage'){
            this.isPercentage = true;
        }else {
            this.isPercentage = false;
        }
        
    }

    handleChargeRestockingChange(event){
        this.chargeRestocking = event.detail.value;
        this.objAccount.Charge_Restocking_Fees_c__c = event.detail.value;
        if(this.chargeRestocking == 'No' ) {       
            this.error.isFeesError = false;
            this.error.isPerError = false;
            if(this.restockingType == 'Percentage'){
                let restockingFeesPer = this.template.querySelector('.restockingFeesPer');
                restockingFeesPer.setCustomValidity('');
                restockingFeesPer.reportValidity();
                this.restockingFeesPercentage = '0';
                this.objAccount.Restocking_Fees_Percentage_c__c = 0;
            } else if(this.restockingType == 'Flat'){
                let restockingFeesCmp = this.template.querySelector('.restockingFees');              
                restockingFeesCmp.setCustomValidity('');
                restockingFeesCmp.reportValidity();
                this.restockingFees = '0';
                this.objAccount.Restocking_Fees_c__c = 0;
            }
            this.showRestockingFeeSecton = true;
        } else if(this.chargeRestocking == 'Yes') {
            this.showRestockingFeeSecton = false;
        }
    }

    shippingMethodChange(event){
        this.shippingMethod = event.detail.value;
        this.objAccount.Preferred_Shipping_Carrier_c__c = this.lstCarriers.find(item => item.Name__c == event.detail.value).ExternalId;
    }

    handleRestockingFeesChange(event){
        let restockingFeesCmp = this.template.querySelector('.restockingFees');
        let amtValue = event.detail.value;
        this.error.isFeesError = false;
        restockingFeesCmp.setCustomValidity('');
        restockingFeesCmp.reportValidity();
        
        if(/^[0-9.]+$/i.test(event.detail.value)){
            if (Math.floor(Number(amtValue)) !== Number(amtValue) ) {
                if(amtValue.toString().split(".")[1].length > 2){
                    this.error.isFeesError = true;
                    restockingFeesCmp.setCustomValidity('Please enter two decimals only.');
                    restockingFeesCmp.reportValidity();
                } else {
                    restockingFeesCmp.setCustomValidity('');
                    restockingFeesCmp.reportValidity();
                    this.error.isFeesError = false;
                    this.restockingFees = event.detail.value;
                    this.objAccount.Restocking_Fees_c__c = Number(event.detail.value);
                    console.log(' this.objAccount:; ', this.objAccount);
                }
            } else {
                restockingFeesCmp.setCustomValidity('');
                restockingFeesCmp.reportValidity();
                this.error.isFeesError = false;
                this.restockingFees = event.detail.value;
                this.objAccount.Restocking_Fees_c__c = Number(event.detail.value);
            }
        }else {
            this.error.isFeesError = true;         
            restockingFeesCmp.setCustomValidity('Please enter a numeric value.');
            restockingFeesCmp.reportValidity();
        }  
    }

    restockingFeesPerChange(event){     
        let restockingFeesPer = this.template.querySelector('.restockingFeesPer');
        let percentagevalue = event.detail.value;
        this.error.isPerError = false;
        restockingFeesPer.setCustomValidity('');
        restockingFeesPer.reportValidity();

        if(/^[0-9.]+$/i.test(event.detail.value)){
            let feesPer = Number(event.detail.value);
            if(feesPer >= 0 && feesPer <= 100 ){
                if (Math.floor(Number(percentagevalue) ) !== Number(percentagevalue)) {
                    if(percentagevalue.toString().split(".")[1].length > 2){
                        this.error.isPerError = true;         
                        restockingFeesPer.setCustomValidity('Please enter two decimals only.');
                        restockingFeesPer.reportValidity();
                    } else {
                        this.error.isPerError = false;      
                        restockingFeesPer.setCustomValidity('');
                        restockingFeesPer.reportValidity();
                        this.restockingFeesPercentage = event.detail.value; 
                        this.objAccount.Restocking_Fees_Percentage_c__c = Number(event.detail.value);
                    }
                } else {
                    this.error.isPerError = false;      
                    restockingFeesPer.setCustomValidity('');
                    restockingFeesPer.reportValidity();
                    this.restockingFeesPercentage = event.detail.value; 
                    this.objAccount.Restocking_Fees_Percentage_c__c = Number(event.detail.value);
                }
                
            }else {
                this.error.isPerError = true;   
                restockingFeesPer.setCustomValidity('Percentage should be in 0 to 100 range.');
                restockingFeesPer.reportValidity();
            }           
        }else {
            this.error.isPerError = true;            
            restockingFeesPer.setCustomValidity('Please enter a numeric value.');
            restockingFeesPer.reportValidity();
        }
    }

    // hourlyLaborRateChange(event){
    //     this.hourlyLaborRate = event.detail.value;
    //     this.objAccount.Hourly_Labor_Rate_c__c = Number(event.detail.value);
    // }

    schedulingLinkChange(event){
        this.schedulingLink = event.detail.value;
        this.objAccount.schedule_installation_c__c = event.detail.value;
    }

    returnWindowChange(event){    
        let returnWindowCmp = this.template.querySelector('.returnWindowNumber');   
        if(event.detail.value){
            if(/^[0-9]+$/i.test(event.detail.value)){
                this.error.isWindowError = false;
                returnWindowCmp.setCustomValidity('');
                returnWindowCmp.reportValidity();
                this.returnWindow = event.detail.value;
                this.objAccount.Return_Window_c__c = Number(event.detail.value);
            }else {           
                this.error.isWindowError = true;
                returnWindowCmp.setCustomValidity('Please enter a numeric value.');
                returnWindowCmp.reportValidity();
            }
        }else {
            this.error.isWindowError = false;
            this.returnWindow = event.detail.value;
            returnWindowCmp.setCustomValidity('');
            returnWindowCmp.reportValidity();
        } 
        
        
    }
    
    /** Pratik Added the following functions */
    salesValuesChanges(event){

        if(event.target.value == 'All 50 States'){
            this.error.isSystemError = false; // Start Added by Aditya to fix 19411
            this.objAccount.Sales_Tax_Jurisdiction__c = this.lstAllStates;
        }else{   
            // Start Added by Aditya to fix 19411        
            if (this.lstAllStates.indexOf(this.objAccount.ShippingState__c) > -1) {
                this.error.isSystemError = false;
                this.objAccount.Sales_Tax_Jurisdiction__c =  this.objAccount.ShippingState__c ;
           }else{
                this.error.isSystemError = true;
                console.log(this.objAccount);
           }
           // End Added by Aditya to fix 19411
        }

    }

    handleSave(event){
        console.log('this.error : ',this.error);
        if(this.error.isWindowError == false && this.error.isFeesError == false && this.error.isPerError == false && this.error.isSystemError == false){
            this.isLoading = true;         
            console.log('account : ',this.objAccount); 
            updateDealerAccount({objAccount : this.objAccount}).then(result => {
                if(result){
                    console.log('result : ',result);               
                    this.dispatchToastMessage('Success!','Your Details are updated successfully.','success')
                }else {
                    this.dispatchToastMessage('Error!', 'We’re experiencing technical difficulties, please try again later', 'error'); 
                }
                this.isLoading = false;
            }).catch(error => {
                this.isLoading = false;
                console.log('Error : ',error);
                this.dispatchToastMessage('Error!', 'We’re experiencing technical difficulties, please try again later', 'error'); 
            });
            // Start Added by Aditya to fix 19411
            }else if (this.error.isSystemError == true){
                updateOpsTeam({objAccount : this.objAccount}).then(result => {
                    console.log('return ops support alert ----------------------------------------->',result);
                    if(result == 'Success'){
                        this.dispatchToastMessage('Error!', 'We’re experiencing technical difficulties, please try again later', 'error');
                    }
                }).catch(error => {
                    console.log('Error creating record in error object for Ops Team alert for Tax jurisdiction: ',error);
                });
                //this.dispatchToastMessage('Error!', 'We’re experiencing technical difficulties, please try again later', 'error');
            }
            // End Added by Aditya to fix 19411
            else {
                this.dispatchToastMessage('Error!', 'Unable to update your details. Please check the entered details', 'error');
            }
       
    }

    dispatchToastMessage(title,message,variant) {
        this.dispatchEvent(
          new ShowToastEvent({
              title: title,
              message: message,
              variant: variant
          }));      
      } 
}