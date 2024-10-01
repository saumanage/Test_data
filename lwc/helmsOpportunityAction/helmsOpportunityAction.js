import { LightningElement, track, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getActions from '@salesforce/apex/HELMSOpportunityController.getActions';

export default class HelmsOpportunityAction extends LightningElement {
    @track actions;
    @track recordTypeId;
    @track header = 'New Opportunity';

    @wire(getActions)
    wiredGetActions(result) {
        if (result.data) {
            this.actions = result.data;
            this.error = undefined;
        } else if (result.error) {
            this.error = error;
            this.actions = undefined;
        }
    }

    handleShowModal() {
        const modal = this.template.querySelector('c-modal');
        modal.show();
    }

    handleCloseModal() {
        const modal = this.template.querySelector('c-modal');
        modal.hide();
    }

    handleClick(event){
        this.recordTypeId = event.target.dataset.recordtypeid;
        this.header = 'New Opportunity : ' + event.target.dataset.name;
        this.handleShowModal();
    }

    handleSubmit(event){
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Success',
                message: 'Opportunity created',
                variant: 'success'
            })
        );
        this.handleCloseModal();
    }
}