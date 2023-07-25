public class SearchAccountwithContact {
    @AuraEnabled(cacheable=true)
    public static list<Account> getContact(string searchKey) {
        system.debug('---searchKey---'+searchKey);
        string str = '%'+searchKey+'%';
        system.debug('---str---');
        list<Account> accList = [select Id,Name,Industry from Account where Name like :str];
        system.debug('--acclist--'+accList);
        return acclist;        
    }
}