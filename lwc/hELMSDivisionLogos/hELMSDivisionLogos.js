import { LightningElement, track, wire } from 'lwc';
//LMS-3695 Fetching Logos based on Subdivision field from Dealer Subdivision object for Dealer Users.
//import { ShowToastEvent } from 'lightning/platformShowToastEvent';
//import DivisionLogos from '@salesforce/resourceUrl/DivisionLogos';
import MarineLogo from '@salesforce/resourceUrl/MarineLogo';
import PowerEquipmentLogo from '@salesforce/resourceUrl/PowerEquipmentLogo';
import PowersportsLogo from '@salesforce/resourceUrl/PowersportsLogo';
import AcuraLogo from '@salesforce/resourceUrl/AcuraLogo';
import HondaLogos from '@salesforce/resourceUrl/HondaLogos';
import getActions from '@salesforce/apex/HELMSOpportunityController.getActionsImage';
export default class hELMSDivisionLogos extends LightningElement {
		@track actions;
		isPowerEquip = false;
		isMarine = false;
		isMotorcycle = false;
		isAcura = false;
		isHonda = false;
		@wire(getActions)
    wiredGetActions(result) {
        if (result.data) {
						for ( var i = 0; i < result.data.length; i++ ){
								if(result.data[i].name == 'PowerEquipment'){
									this.isPowerEquip = true;	
								}
								if(result.data[i].name == 'Marine'){
									this.isMarine = true;	
								}
								if(result.data[i].name == 'Motorcycle'){
									this.isMotorcycle = true;	
								}
								if(result.data[i].name == 'Acura'){
									this.isAcura = true;	
								} 
								if(result.data[i].name == 'Honda'){
									this.isHonda = true;	
								} 
						}
        } 
    }
    Marine = MarineLogo + '/MarineImage/Marine.png';
    PowerEquipment = PowerEquipmentLogo + '/PowerEquipmentImage/PowerEquipment.png';
    Powersports = PowersportsLogo + '/PowersportsImage/Powersports.png';
	Acura = AcuraLogo + '/AcuraImage/Acura.png';
	Honda = HondaLogos + '/HondaImage/Honda.png';
}