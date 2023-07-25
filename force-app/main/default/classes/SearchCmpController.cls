public with sharing class SearchCmpController {
    @AuraEnabled(cacheable=true)
    public static list<Account> getAccount(){
        try {
            system.debug('---getAccount-----');
            return [select id,Name,Industry,Phone from Account];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}