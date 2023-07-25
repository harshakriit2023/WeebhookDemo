public class interviewFour
{
    public list<Account> lstacc{get;set;}
    public interviewFour()
    {
        lstacc = [select id,name,phone from Account limit 10];
        system.debug('===lstacc==='+lstacc);
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Selet an Account by Clicking its Name.'));
    }
    public PageReference click()
    {
        string str =  URL.getSalesforceBaseUrl().toExternalForm()+'/001/o?id=lstacc.get(0).id';
        PageReference acctPage = new PageReference(str);
        acctPage.setRedirect(true);
        return acctPage;
        /*ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'you clicked on Name...'));
        return null;*/
    }   
}