public class batchclass implements database.Batchable<sobject>
{
    public Database.Querylocator start(Database.BatchableContext bc)
    {
        string qury = 'select id,name from Account limit 10';
        return Database.getQueryLocator(qury);
    }
    public void execute(Database.BatchableContext bc,List<Account> AccList)
    {
        List<Account> accupdateList = new List<Account>();
        if(AccList != null)
        {
            for(Account acc : AccList)
            {
                acc.name = 'test';
                accupdateList.add(acc);
            }
            update accupdateList;
        }
    }
    public void finish(Database.BatchableContext bc)
    {
    
    }
}