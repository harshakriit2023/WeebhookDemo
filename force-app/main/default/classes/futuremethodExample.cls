public class futuremethodExample
{
    @future
    public static void Futureexmp(set<id> accId)
    {
        system.debug('===accId==='+accId);
        list<Account> acclist = [select id,name,Number_of_Contact__c,(select id,name,AccountId from contacts) from Account where id in :accId];
        for(Account acc :acclist)
        {
            acc.Number_of_Contact__c = acc.contacts.size();
        }
        update acclist;
    }
}