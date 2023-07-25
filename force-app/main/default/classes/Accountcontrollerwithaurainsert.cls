public class Accountcontrollerwithaurainsert {

    @AuraEnabled
    public static list<Account> createAccount()
    {
        list<Account> acclist = [select id,name,rating,phone from Account limit 10];
        system.debug('==acclist==='+acclist);
        return acclist;
    }
}