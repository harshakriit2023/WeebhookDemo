public class ConRelatedWrapperC {
    
    //Account List and AccountWrapper Class List Variables
    public List<AccountWrapper> accWrapList {get; set;}
    public List<Contact> selectedAccountList {get;set;}
    
    public ConRelatedWrapperC(){
        selectedAccountList = new List<Contact>();
        accWrapList = new List<AccountWrapper>();
        List<Account> accList = new List<Account>();
        accList = [SELECT Id, Name, Type, Industry, Phone, (SELECT Name, Phone, Email, Account.Name FROM Contacts) FROM Account LIMIT 10];
        for(Account a: accList) {
            //Add each Account record to AccountWrapperList
            accWrapList.add(new AccountWrapper(a));
        }
    }
    
    public void getSelectedAccounts() {
        
        selectedAccountList.clear();
        for(AccountWrapper obj : accWrapList) {
            if(obj.isSelected == true) {
                for(Contact c : obj.acc.Contacts){
                    selectedAccountList.add(c);
                }
            }
        }
    }
    
    //Account Wrapper Class.
    //This wrapper class contains both the standard salesforce object Account and a Boolean value.
    public class AccountWrapper {
        public Account acc {get; set;}
        public Boolean isSelected {get; set;}
        
        public AccountWrapper(Account a) {
            acc = a;
            isSelected = false;
        }
    }
}