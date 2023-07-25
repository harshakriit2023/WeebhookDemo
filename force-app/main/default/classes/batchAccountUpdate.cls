global class batchAccountUpdate implements Database.Batchable<sObject>
{
     global Database.QueryLocator start(Database.BatchableContext BC) 
     {
        string query = 'select id,name from Account where name like %test';
        system.debug('====query=='+query);
        return Database.getQueryLocator(query);  
     }
     global void Execute(Database.BatchableContext BC,List<Account> acclist)
     {
        system.debug('====acclist==='+acclist);
        for(Account acc : acclist)
        {
            acc.Name = acc.Name + 'Exmp';
        }
        update acclist;
     }
     global void finish(Database.BatchableContext BC)
     {
         
     }
}