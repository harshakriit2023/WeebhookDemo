public with sharing class Accountdetailscon {
    public Account[] account {get;set;}
    public boolean showpageblock {get;set;}
    public account newaccount {get;set;}
    public string accountid {get;set;}
    public Accountdetailscon() {
        newaccount = new account();
        showpageblock = true;
        account = [SELECT id,Name, Phone, Rating, Industry FROM Account limit 100];
        //getaccount();  
    }
    public void getaccount()
    {
        account = [SELECT id,Name, Phone, Rating, Industry FROM Account limit 100];
        System.debug('==account===='+account);  
    }
    public PageReference savebtn()
    {       
        try{
        Account acc = new Account();
        acc.Name = newaccount.Name;
        acc.Phone = newaccount.Phone;
        acc.Rating = newaccount.Rating;
        acc.Industry = newaccount.Industry;
        insert acc;
        showpageblock = true;
        account.add(acc);
        return null;
        }
        catch(exception e)
        {
            System.debug('exception'+e);
        }
        return null;      
    }
    public PageReference deletebtn()
    {
        system.debug('====accountid ==='+accountid);
        if(accountid != null && accountid != '')
        {
            account deleteacc = [SELECT id FROM Account where id =:accountid limit 100];
            System.debug('====deleteacc==='+deleteacc);
            if(deleteacc != null)
            {
                try{
                      delete deleteacc;
                }
                catch(exception e)
                {
                    ApexPages.addMessages(e);
                }
            }
            else
            {
                return new PageReference('/apex/Accountdetails');
            }
        }
        system.debug('====accountid ==='+accountid);    
        PageReference pageRef = new PageReference('/apex/Accountdetails');
        pageRef.setRedirect(true);
        return pageRef; 
    }
    public PageReference updatebtn()
    {
        System.debug('==account get==='+account);
        try{
            update account;
            System.debug('==updateacc==='+account);
        }
        catch(exception e)
        {
            ApexPages.addMessages(e);
        }
        //getaccount();
        PageReference pageRef = new PageReference('/apex/Accountdetails');
        pageRef.setRedirect(true);
        return pageRef; 

    }  
}