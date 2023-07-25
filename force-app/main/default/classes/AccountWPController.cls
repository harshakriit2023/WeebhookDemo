public class AccountWPController 
{
    public list<AccountWrapper> accwrp {get;set;}
    public list<Account> selectedAccounts {get;set;}
    public list<Account> acclist = new list<Account>();
    public list<AccountWrapper> acctoshow;
    public Integer counter = 0;
    public Integer limitsize = 20;
    public Integer totalsize = 0;
    public List<User> usrs;
    public list<AccountWrapper> Accountlist = new list<AccountWrapper>();
    
    public AccountWPController()
    {
        accwrp = new list<AccountWrapper>();
        acctoshow = new list<AccountWrapper>();
        selectedAccounts = new list<Account>();
        acclist = [select id,name,Rating,Phone from Account limit 100];
        system.debug('====acclist==='+acclist);
        for(Account acc : acclist)
        {
            accwrp.add(new AccountWrapper(acc));
        }
        system.debug('====accwrp===='+accwrp);
        totalsize = accwrp.size();
        system.debug('====totalsize===='+totalsize);
        system.debug('====counter===='+counter);
        system.debug('====limitsize===='+limitsize);
        if((counter+limitsize) <= totalsize)
        {
            for(integer i = 0; i< limitsize; i++)
            {
                acctoshow.add(accwrp.get(i));
            }
            system.debug('====if::acctoshow===='+acctoshow.size());
            system.debug('====if::acctoshow===='+acctoshow);
        }
        else{
            for(integer i = 0; i< totalsize; i++)
            {
                acctoshow.add(accwrp.get(i));
            }
            system.debug('====else::acctoshow===='+acctoshow.size());
            system.debug('====else::acctoshow===='+acctoshow);
        }
    }
    public void beggin()
    {
        acctoshow.clear();
        Counter = 0;
        if((counter+limitsize) <= totalsize)
        {
            for(integer i = 0; i< limitsize; i++)
            {
                acctoshow.add(accwrp.get(i));
            }
            system.debug('====if::acctoshow===='+acctoshow.size());
            system.debug('====if::acctoshow===='+acctoshow);
        }
        else{
            for(integer i = 0; i< totalsize; i++)
            {
                acctoshow.add(accwrp.get(i));
            }
            system.debug('====else::acctoshow===='+acctoshow.size());
            system.debug('====else::acctoshow===='+acctoshow);
        }
    }
    public void next()
    {
        system.debug('====acctoshow next ===='+acctoshow.size());
        acctoshow.clear();
        counter = counter + limitsize;
        system.debug('===next::counter==='+counter);
        system.debug('===next::totalsize==='+totalsize);
        if((counter+limitsize) <= totalsize)
        {           
            system.debug('===counter==='+counter);
            for(integer i = counter-1;i<(counter+limitsize);i++)
            {
                system.debug('====if::acctoshow counter ===='+i);
                acctoshow.add(accwrp.get(i));
            }           
            system.debug('====if::acctoshow next ===='+acctoshow.size());
            system.debug('====if ::acctoshow next ===='+acctoshow);
        }
        else{
            for(integer i=counter;i<totalsize;i++)
            {
                acctoshow.add(accwrp.get(i));
            }
            system.debug('====else::acctoshow next ===='+acctoshow.size());
            system.debug('====else::acctoshow next ===='+acctoshow);
        }
    }
    public void previous()
    {
        acctoshow.clear();
        counter = counter - limitsize;
        system.debug('===previous::counter==='+counter);
        for(integer i=counter;i<totalsize;i++)
        {
            acctoshow.add(accwrp.get(i));
        }
        system.debug('===previous::acctoshow==='+acctoshow.size());
        system.debug('===previous::acctoshow==='+acctoshow);
    }
    public list<AccountWrapper> getAccount()
    {
        system.debug('====getAccount====');
        system.debug('====accwrp===='+accwrp);
        if(Accountlist == null)
        {
            Accountlist = accwrp;
        }
        return Accountlist;
    }
    public list<AccountWrapper> getaccs()
    {
        return acctoshow;
    }
    public List <User> getUsrs(){
        return usrs;
    }
    public boolean getDisbaleNext()
    {
        if((counter+limitsize) >= totalsize)
        {
            return true;
        }
        else{
            return false;
        }
    }
    public boolean getDisbalePrevious()
    {
        if(counter == 0)
        {
            return true;
        }
        else{
            return false;
        }
    }
    public void  processSelected()
    {       
        selectedAccounts = new list<Account>();
        for(AccountWrapper ac : accwrp)
        {           
            if(ac.isselected == true)
            {
                selectedAccounts.add(ac.acc);
            }
            system.debug('===selectedAccounts==='+selectedAccounts);
        }
        
    }
    public pageReference updateUsrs(){
        usrs = [select Id, Username, Firstname, Lastname, Name, Email, UserType from User];
        return null;
    }
    public class AccountWrapper{
        public Account acc {get;set;}
        public boolean isselected {get;set;}
        public AccountWrapper(Account a)
        {
            acc = a;
            isselected = false;
        }
    }
}