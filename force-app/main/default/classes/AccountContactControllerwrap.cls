public class AccountContactControllerwrap{
      
    @AuraEnabled(cacheable=true)
    public static List<AccountContactListWrapper> getAllAccountWithContacts(){
        List<AccountContactListWrapper> accWrapperList = new List<AccountContactListWrapper>();
        List<Account> accList = [SELECT Id, Name, BillingState, Website, Phone,
                                    (SELECT Id, FirstName, LastName, Name, Email From Contacts),(select Id,Name from opportunities)
                                    FROM Account  LIMIT 5];
        if(!accList.isEmpty()){
            for(Account acc : accList){
                AccountContactListWrapper accWrapper = new AccountContactListWrapper();
                accWrapper.accRecord = acc;
                accWrapper.contactList = acc.Contacts;
                accWrapper.opportunityList = acc.opportunities;
                accWrapperList.add(accWrapper);
            }
        }
        return accWrapperList;
    }
      
    // wrapper class with @AuraEnabled and {get;set;} properties 
    public class AccountContactListWrapper{
        @AuraEnabled
        public Account accRecord{get;set;}
        @AuraEnabled
        public List<Contact> contactList{get;set;}
        @AuraEnabled
        public list<opportunity> opportunityList{get;set;}
    }
}