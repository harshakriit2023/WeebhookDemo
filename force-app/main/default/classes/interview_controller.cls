public class interview_controller
{
    public list<Account> accList{get;set;}
    public interview_controller()
    {
        accList = [select id,name,BillingState ,phone,Website from Account limit 10];
        system.debug('===accList=='+accList);
    }
}