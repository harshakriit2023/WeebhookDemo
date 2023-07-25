public with sharing class displayAllAccount {

    @AuraEnabled(cacheable=true)
    public static list<Account> getAccountDetails(){
        List<Account> acclist = new List<Account>();
        try {
            system.debug('---Account Details----');
           acclist = [select Id,Name,Industry,Phone from Account limit 10];
           system.debug('---acclist----'+acclist);          
        } catch (Exception e) {
            system.debug('----error message---'+e.getMessage());
        }
        return acclist;
    }
    @AuraEnabled(cacheable=true)
    public static List<Account> getSearchAccountData(string searchKey){
        list<Account> acclist = new list<Account>();
       try {
            system.debug('---searchKey----'+searchKey);
            string strname = '%'+searchKey+'%';
            acclist = [select id,Name,Industry,Phone from Account where Name LIKE :strname];
            system.debug('---acclist---'+acclist);
        } catch (Exception e) {
            system.debug('----error message---'+e.getMessage());
        }
        return acclist;
    }
}