public class contactDetailwrapper{
    
    public list<wrappobject> wrappobjectlist {get;set;}
    public list<Contact> selectedAccount {get;set;}
    public list<Account> acclist;
    public contactDetailwrapper()
    {
        wrappobjectlist = new list<wrappobject>();
        selectedAccount = new list<Contact>();
        acclist = [select id,name,Phone,Rating,(select id,Name,Phone,Account.Name from Contacts) from Account limit 10];
        system.debug('====acclist==='+acclist);
        for(Account ac : acclist)
        {
            system.debug('====ac==='+ac);
            wrappobjectlist.add(new wrappobject(ac));
            system.debug('====wrappobjectlist======'+wrappobjectlist);
        }
    }
    public void processselected()
    {
        //selectedAccount.clear();
        if(wrappobjectlist != null)
        {
            for(wrappobject wobj : wrappobjectlist)
            {
                if(wobj.selected == true)
                {                 
                    for(Contact con : wobj.acc.Contacts)
                    {
                        selectedAccount.add(con);
                    }       
                  system.debug('====selectedAccount======'+selectedAccount);
                }
            }
        }
    }
    

    public class wrappobject{
        
        public Account acc {get;set;}
        public boolean selected {get;set;}
        public wrappobject(Account a)
        {
            system.debug('===acc==='+acc);
            acc = a;
            selected = false;
        }
    }
    
    
}