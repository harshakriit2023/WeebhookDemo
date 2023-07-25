public class imageshowcls
{
    public boolean isimageshow {get;set;}
    public string imagstr {get;set;}
    public Account acc {get;set;}
    public imageshowcls()
    {
         acc = [select id,name,Imageshow__c,imageurl__c from Account where name='harsha'];
         system.debug('===acc=='+acc);
         if(acc.Imageshow__c)
         {
             isimageshow = true;
             imagstr = acc.imageurl__c;
         }
         system.debug('===acc=='+acc);
    }
}