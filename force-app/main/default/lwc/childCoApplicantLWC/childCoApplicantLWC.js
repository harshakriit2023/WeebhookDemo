import { LightningElement,api, track } from 'lwc';
import getForm from '@salesforce/apex/ApplicantWithCoApplicantFieldController.getForm';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class ChildCoApplicantLWC extends LightningElement {
    OBJECT_API_NAME = 'Account';
    FIELD_SET_LIST = ['Section_One','Section_Two','Section_Three'];
    PARENT_ACCOUNT_API_NAME = 'Person_Account__c';
    @api recordId;
    @api parentId;
    @api componentLabel;
    @track fieldsData;

    connectedCallback(){

        console.log('======In Child recordId=======',this.recordId);

        // Get FieldSet Data and record data if available
        getForm({ recordId: this.recordId, objectName: this.OBJECT_API_NAME, fieldSetList: this.FIELD_SET_LIST })
        .then(result => {
            console.log('Data:' ,result);
            if (result) {
                this.fieldsData = result;
                console.log('getForm -> result :: ',JSON.stringify(this.fieldsData));
            }
        }).catch(error => {
            console.log('getForm -> error :: ',error);
        });
    }

    @api
    saveClick(){
        console.log('saveClick');
        // Submit the form and save or update data
        this.template.querySelector('lightning-record-edit-form').submit();
        
    }

    validateFields() {
        console.log('validateFields');
        return [...this.template.querySelectorAll("lightning-input-field")].reduce((validSoFar, field) => {
            return (validSoFar && field.reportValidity());
        }, true);
    }

    handleQSuccess(e) {
        console.log('handleQSuccess');
        console.log('handleQSuccess :: ',e);
        this.handleCustomEvent('handlesuccessevent','Record Saved','success','Record saved successfully !');
    }

    handleQError(error) {
        console.log('handleQError');
        console.log('handleQError :: ',error);

        // this.template.querySelector('[data-id="message"]').setError(e.detail.message);
        //  e.preventDefault();
    }

    handleCustomEvent(eventLabel, title, type, message){
        const toastEvent = new CustomEvent(eventLabel, {
            detail: {
                title: title,
                message: message,
                type: type
            }
        });
        this.dispatchEvent(toastEvent);
    }
}