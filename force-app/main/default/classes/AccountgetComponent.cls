public with sharing class AccountgetComponent {
    @AuraEnabled(cacheable=true)
    public static List<Account> getAccounts(String strAccountName) {
      String strKey = '%'+strAccountName+'%';
      system.debug('---getAccounts::strKey---'+strKey);
      List<Account> accList = [SELECT Id,Name,AccountNumber FROM Account WHERE name like :strKey ];
      system.debug('--getAccounts::accList---'+accList);
      return accList;
    }
}