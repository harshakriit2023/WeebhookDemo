public class emailquerycls 
{
    public static void sendemails(string address,string subject,string body)
    {
        Messaging.SingleEmailMessage  email = new Messaging.SingleEmailMessage();
        string[] toaddress = new string[]{address};
        email.settoAddresses(toaddress);
        email.setSubject(subject);
        email.setPlainTextBody(body);
        Messaging.sendemail(new Messaging.SingleEmailMessage[] {email});
        
    }
}