public class sendmsgGrid
{
	public static void getsendEmailData(){

        string apikey = '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';
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://api.sendgrid.com/v3/mail/send');
        req.setMethod('POST');
        req.setHeader('Content-Type','application/json');
        req.setHeader('Authorization', 'Bearer '+apikey);
        req.setBody('{"personalizations":[{"to":[{"email":"patelharsha415@gmail.com","name":"Harsha"}],"subject":"Hello, World!"}],"content": [{"type": "text/plain", "value": "Heya!"}],"from":{"email":"no-reply@sendgrid.com","name":"Harsha"},"reply_to":{"email":"harshakriit2023@gmail.com","name":"soni"}}');
        req.setTimeout(120000);
        HttpResponse res = new HttpResponse();
        Http http = new Http();    
        res = http.send(req);
        System.debug('res.getBody() ::: '+res.getBody());
        System.debug('res.getstatuscode() ::: '+res.getstatuscode());  
 
	}
    
	public class getpersonalizations{
		public personalizations[] personalizations;
	}

	public class to
	{
		public string email;
		public string name;
	}
	public class toaddress
	{
		public to[] todetails;
		public string subject;
	}
	public class content
	{
		public string type;
		public string value;
	}
	public 	class froms{
		public string email;
		public string name;
	}
	public class reply_to{
		public string email;
		public string name;
	}
	public class personalizations{
		public toaddress[] to;
		public content[] content;
		public froms[] froms;
		public reply_to[] reply_to;
	}
}