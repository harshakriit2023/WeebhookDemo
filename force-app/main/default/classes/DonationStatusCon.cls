public class DonationStatusCon {
    
    public string currentRecordId {get;set;}
    public Donation__c don {get;set;}
    public Integer counter {get;set;}
    public boolean IsEnable {get;set;}
    
    public DonationStatusCon()
    {
        currentRecordId =  ApexPages.CurrentPage().getparameters().get('donid');
        system.debug('===currentRecordId==='+currentRecordId);  
        counter = 0;    
        IsEnable = true;
        selectDonationstatus();     
    }
    
    public PageReference selectDonationstatus()
    {   
        system.debug('===currentRecordId==='+currentRecordId);
        IsEnable = true;
        if(currentRecordId != null && currentRecordId != '')
        {
            List<Donation__c> don = new List<Donation__c>();
            don = new List<Donation__c>([select id,Name,Payment_Date__c,Payment_Succeed__c,Payment_Amount__c,Donation_Amount_for_CI__c from Donation__c where id =: currentRecordId]);
            system.debug('===selectDonationstatus::don==='+don);                
            counter = counter + 1;
            system.debug('===counter==='+counter);
            if(don.get(0).Payment_Succeed__c == 'Yes')
            {
                IsEnable = false;
                system.debug('===IsEnable==='+IsEnable);
            }   
        }
        system.debug('===counter==='+counter);
        system.debug('===IsEnable==='+IsEnable);
        return null;    
    }
        
}