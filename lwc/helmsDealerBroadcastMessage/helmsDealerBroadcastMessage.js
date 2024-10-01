import { LightningElement, wire, track } from 'lwc';
import fetchMetaListLwc from '@salesforce/apex/HELMSDealerBroadcastMessagectrl.fetchMetaListLwc';
const COLUMNS = [
        { fieldName: 'Message__c' ,fixedWidth: 1550,cellAttributes: { alignment: 'center' }}
];

export default class HelmsDealerBroadcastMessage extends LightningElement {
    a_Dynamic_Field = "<h5 style=\"text-align: center\">This section displays timely updates. At this time, there are no new messages.</h5>";
    @track records;
    error;
    columns = COLUMNS;
    @track checkflag = false;

    @wire(fetchMetaListLwc)
    wiredRecs({ data, error }) {
  
        
        if (data) {
            if (data.length > 0) {
                this.checkflag = true;
                
                this.records = data;
                this.error = undefined;
                
            }
            else {
                this.checkflag = false;
            }
        } else if (error) {

            this.checkflag = false;
            this.error = error;
            this.records = undefined;

        }
        else {
            this.checkflag = false;
        }

    }
}