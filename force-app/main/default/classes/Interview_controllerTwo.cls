public class Interview_controllerTwo
{
    public List<Account> AccountList{get;set;}
    public boolean showmsg{get;set;}
    public string seachstring {get;set;}
    
    public Interview_controllerTwo()
    {
        AccountList = new list<Account>();
        showmsg = false;
    }   
    public pagereference displayAccountList()
    {
        String AccountQuery = 'select id, name,BillingState,Phone,Website from Account';
        system.debug('===AccountQuery==='+AccountQuery);
        if(seachstring != '' && seachstring != null)

        AccountQuery = AccountQuery + ' where name LIKE \'%' + seachstring+'%\' ';
        system.debug('===AccountQuery==='+AccountQuery);
        AccountList=database.query(AccountQuery);
        system.debug('===AccountList==='+AccountList);
        if(AccountList.size()>0 && AccountList!=null)
            showmsg=false;
        else{
            Apexpages.addmessage(new Apexpages.message(Apexpages.severity.WARNING,'No Account Found'));
            showmsg = true;
        }
        /*String AccountQuery = 'select id, name,BillingState,Phone,Website from Account';
        system.debug('===AccountQuery==='+AccountQuery);
         if(seachstring != '' && seachstring != null)

         AccountQuery = AccountQuery + ' where name LIKE \'%' + seachstring+'%\' ';
         system.debug('===AccountQuery==='+AccountQuery);
        
         AccountList=database.query(AccountQuery);
         system.debug('===AccountList==='+AccountList);

         if(AccountList.size()>0 && AccountList!=null)

         showmsg=false;

         else{

         ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.Warning,'No Accounts Found');

         ApexPages.addMessage(errMsg);

         showmsg=true;

        }*/
     return null;
    }
       
}