public class showSelectdAccounts
{
    public list<Account> lstacc{get;set;}
    public list<Account> selectedAcc{get;set;}
    public boolean noacc{get;set;}
    public list<wrapper> lstwrapper{get;set;}
    public showSelectdAccounts()
    {
        noacc = false;
        lstwrapper = new list<wrapper>();       
        lstacc = [select id,name,industry from Account limit 10];
        for(Account accobj :lstacc)
        {
            wrapper wrobj = new wrapper();
            wrobj.acc = accobj;
            lstwrapper.add(wrobj);
        }
       system.debug('===lstwrapperlstwrapper=='+lstwrapper);
    }
    public void showSelected()
    {
        selectedAcc = new list<Account>();
        system.debug('===selectedAcc=='+selectedAcc);
        selectedAcc.clear();
        system.debug('===selectedAcc=='+selectedAcc);
        for(wrapper obj:lstwrapper)
        {
            if(obj.isselected == true)
            {
                noacc = true;
                selectedAcc.add(obj.acc);
            }
        
        }
        system.debug('===selectedAcc=='+selectedAcc);
        if(!noacc)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'NoAccount Selected'));
        }
    }
    public class wrapper
    {
        public boolean isselected{get;set;}
        public Account acc{get;set;}
    }
}