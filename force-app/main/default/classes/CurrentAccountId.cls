public class CurrentAccountId
{
    public string CurrentRecordId{get;set;}
    public Account acc{get;set;}
    public string paramValue{get;set;}
    public CurrentAccountId(ApexPages.StandardController con)
    {
        CurrentRecordId = ApexPages.CurrentPage().getparameters().get('id');
        acc = [select id,Name,Type from Account where id = : CurrentRecordId];
        paramValue = ApexPages.CurrentPage().getparameters().get('namevalue');
        
    }
}