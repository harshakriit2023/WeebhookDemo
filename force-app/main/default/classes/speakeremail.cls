public class speakeremail implements Database.Batchable<sobject>
{
    public string query;
    public string subject;
    public string body;
    public speakeremail(string query,string subject,string body)
    {
        this.query = query;
        this.subject = subject;
        this.body = body;
    }
    public Database.QueryLocator start(Database.BatchableContext bc)
    {
        string query = 'select id,Email from contact where Email != null limit 5';
        return Database.getQueryLocator(query);
    }
    public void execute(Database.BatchableContext bc,List<contact> scope)
    {
        for(contact sp : scope)
        {
            emailquerycls.sendemails(sp.Email,this.subject,this.body);
        }
    }
    public void finish(Database.BatchableContext bc)
    {
        
    }
}