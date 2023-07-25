import { LightningElement,api } from 'lwc';
// import executeBatch from '@salesforce/apex/ExecuteDuplicateBatchForLWC.executeBatch';
// import getJobDetails from '@salesforce/apex/ExecuteDuplicateBatchForLWC.getJobDetails';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent'; 
export default class MergeQuickActionHandler extends LightningElement {
    batchJobId;
    isLoading;

    @api async invoke()
    {
        console.log('======invoke called start=====');
        this.isLoading = true;
        this.batchJobId = await executeBatch({batchSize : 200,isMarge : true})
        console.log('=====batchJobId======',this.batchJobId);
        if(this.batchJobId != null)
        {
            console.log('=====In If =======');
            this.intervalId = setInterval(() => {
                    this.getBatchStatus();
                console.log('Interval executed!');
            }, 5000);
        }
        console.log('-invoke Completed--');
    }

    async getBatchStatus() {
        console.log('--getBatchStatus start---');
        this.status = await getJobDetails({jobId : this.batchJobId})
        console.log('=====status=======',this.status);
        if(this.status == 'Completed')
        {
            clearInterval(this.intervalId);
            console.log('======Completed=====');
            this.dispatchEvent(new ShowToastEvent({
                title: 'Leads Merge',
                message: 'Leads are merged successfully.',
                variant: 'success',
            }))  
            this.isLoading = false;
            this[NavigationMixin.Navigate]({
                type: 'standard__objectPage',
                attributes: {
                    objectApiName: 'Lead',
                    actionName: 'list'
                },
                state: {
                    filterName: 'Recent'
                },
            });
        }
        console.log('--getBatchStatus Completed---');
    }
}