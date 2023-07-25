import { LightningElement,track,api } from 'lwc';
import { createRecord } from 'lightning/uiRecordApi';
import LEAD_OBJECT from '@salesforce/schema/Lead';
import FIRST_NAME_FIELD from '@salesforce/schema/Lead.FirstName';
import LAST_NAME_FIELD from '@salesforce/schema/Lead.LastName';
import Company from '@salesforce/schema/Lead.Company';
import Email from '@salesforce/schema/lead.Email';

export default class LeadForm extends LightningElement {
  
    firstName = '';
    lastName = '';
    company = '';
    Email = '';

    handleFirstNameChange(event) {
        this.firstName = event.target.value;
        console.log('firstName:',this.firstName);
    }
    handleLastNameChange(event) {
        this.lastName = event.target.value;
        console.log('lastName:',this.lastName);
    }

    handlecompanyChange(event) {
        this.company = event.target.value;
        console.log('company:',this.company);
    }

    handleEmailChange(event) {
        this.email = event.target.value;
        console.log('email:',this.email);
    }
   
    updateLead() {
        console.log('updatelead');
        const fields = {};
        fields[FIRST_NAME_FIELD.fieldApiName] = this.firstName;
        fields[LAST_NAME_FIELD.fieldApiName] = this.lastName;
        fields[Company.fieldApiName] = this.company;

        const recordInput = { apiName: LEAD_OBJECT.objectApiName, fields };
        console.log('--recordInput--'+recordInput);
        createRecord(recordInput)
        .then(result => {
            if(result){
                console.log('result-',result);
            }else{
                console.log('no result-');
            }
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Lead created successfully',
                    variant: 'success'
                })
            );
        })
        .catch(error => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message: error.body.message,
                    variant: 'error'
                })
            );
        });
    }
}