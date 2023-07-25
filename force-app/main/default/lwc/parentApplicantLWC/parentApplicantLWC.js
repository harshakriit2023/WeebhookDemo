import { LightningElement,api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class ParentApplicantLWC extends LightningElement {
    @api recordId;

    connectedCallback(){
        // get parameter form url
        const queryString = window.location.search;
        const urlParams = new URLSearchParams(queryString);
        this.recordId = urlParams.get('id');

        console.log('======In Parent recordId====='+this.recordId);

    }

    handleSave(e){
        console.log('Handle Save Called !');

        // Save and update record
        this.template.querySelectorAll('c-child-co-applicant-l-w-c')
        .forEach(ele => {
            ele.saveClick();
        });
    }

    handleCancel(){
        console.log('Handle Cancle Called !');
        // window.location.href = `/lightning/r/Account/${this.recordId}/view`;
        history.back();
    }


    successCount = 0;
    handlesucess(event){
        this.handleCustomEvent('handlesuccessevent',event.detail.title,event.detail.type,event.detail.message);
        this.successCount++;
        if (this.successCount >= 2) {
            window.location.href = `/lightning/r/Account/${this.recordId}/view`;
        }
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