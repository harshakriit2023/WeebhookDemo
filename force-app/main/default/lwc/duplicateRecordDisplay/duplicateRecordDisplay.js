import { LightningElement,api,track } from 'lwc';
// import getJobDetails from '@salesforce/apex/ExecuteDuplicateBatchForLWC.getJobDetails';
// import executeBatch from '@salesforce/apex/ExecuteDuplicateBatchForLWC.executeBatch';
// import getDuplicateRecord from '@salesforce/apex/ExecuteDuplicateBatchForLWC.getDuplicateRecord';
// import { RefreshEvent } from 'lightning/refresh';

export default class DuplicateRecordDisplay extends LightningElement {
    @api recordId;
    isLoading = true;
    batchSize = 200;
    batchJobId;
    status;
    intervalId;
    duplicateRecNo;

    async connectedCallback() {
        console.log('======connectedCallback called ========');
        console.log('=======recordId=====',this.recordId);
        await getJobDetails({recordId : this.recordId});
        console.log('=======isMergeShow======',this.isMergeShow);
        this.batchJobId = await executeBatch({batchSize : this.batchSize,isMarge : false});
        console.log('=======batchJobId======',this.batchJobId);

        if(this.batchJobId != null)
        {
            console.log('=====In If =======');
            this.intervalId = setInterval(() => {
                    this.getBatchStatus();
                console.log('Interval executed!');
            }, 5000);
        }
    }

    //get the batch status
    async getBatchStatus() {
        this.status = await getJobDetails({jobId : this.batchJobId})
        console.log('=====status=======',this.status);
        if(this.status == 'Completed')
        {
            clearInterval(this.intervalId);
            console.log('======Completed=====')
            this.duplicateRecNo = await getDuplicateRecord({recordId : this.recordId})
            console.log('======duplicateRecNo=====',this.duplicateRecNo);
            this.isLoading = false;
            this.dispatchEvent(new RefreshEvent());
        }
    }
}