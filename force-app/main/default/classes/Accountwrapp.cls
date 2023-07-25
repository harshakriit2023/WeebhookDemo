public class Accountwrapp {
    @AuraEnabled(cacheable=true)
    public static list<accountlistwrapp> getAccountdetail()
    {
        list<accountlistwrapp> accwraplist = new list<accountlistwrapp>();
        list<account> accountlist = [select id,name from Account limit 5];
        system.debug('===accountlist==='+accountlist);
        if(accountlist != null)
        {
            for(account acc: accountlist)
            {
                system.Debug('==acc=='+acc);
                accountlistwrapp accwrap = new accountlistwrapp();
                accwrap.accid = acc;
                accwraplist.add(accwrap);
                system.debug('==accwraplist=='+accwraplist);
            }
             system.debug('===accwraplist==='+accwraplist);
        }
        return accwraplist;
    }
    
    
    public class accountlistwrapp
    {
        @AuraEnabled 
        public Account accid{get;set;}
    }

}