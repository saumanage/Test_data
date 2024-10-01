import { LightningElement,track } from 'lwc';
import getDealerSubDiv from '@salesforce/apex/DealerSubDivisionController.getDealerSubDiv';
import { NavigationMixin } from 'lightning/navigation';

export default class DealerNotificationsNavigationPortal extends NavigationMixin(LightningElement) {
    //@track recordId;
    @track getSB =[];
    @track clickedSB1 ='';
    connectedCallback(){
    getDealerSubDiv()
        .then(result => {
            for (let key in result) {
                
                this.getSB.push({value:result[key], key:key});
            }
        
        
        })
        .catch(error => {
        console.error('Error:', error);
    });
    }
 
    onSBClick(event){
        let clickedSB ='';
        clickedSB = event.target.dataset.name;
        
        
        this.clickedSB1 = clickedSB;
        
        this[NavigationMixin.Navigate]({
            type: 'standard__recordRelationshipPage',
            attributes: {
                recordId: clickedSB.split('-')[0],
                objectApiName: 'Dealer_Division__c',
                relationshipApiName: 'Dealer_Notifications__r',
                actionName: 'view'
            },
        });
    }

}