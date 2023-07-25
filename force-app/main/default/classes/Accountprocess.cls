public class Accountprocess
{
    @future
    public static void getprocess(set<Id> AccId)
    {
        list<Account> acclist = [select id,name,NumberofLocations__c,(select id from contacts) from Account where id in :AccId];
        
        if(acclist != null && acclist.size() > 0)
        {
            for(Account acc: acclist)
            {
                list<Contact> con = acc.contacts;
                acc.NumberofLocations__c = con.size();
            }
            update acclist;
            system.debug('==acclist=='+acclist);
        }
    }   
}