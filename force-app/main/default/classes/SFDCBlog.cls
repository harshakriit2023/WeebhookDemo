public class SFDCBlog
{
    public static void getBlogs()
    {
        system.debug('===getBlogs=====');
        Http http = new Http();
        
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://sfdcstop.herokuapp.com/blogs');
        req.setMethod('GET');
        req.setHeader('Content-Type','application/json;charset=UTF-8');
        req.setHeader('Accept','application/json');
        system.debug('===req====='+req);
        HttpResponse res = http.send(req);
        system.debug('===res====='+res.getBody());
        if(res.getStatusCode() == 200 && res.getbody() != null)
        {
            system.debug('====in if===');
            SFDCBlogWrapperclass  responseApiValue = SFDCBlogWrapperclass.parse(res.getBody()); 
            system.debug('===responseApiValue==='+responseApiValue.author);
            if(responseApiValue.blogs != null && responseApiValue.blogs.size() > 0)
            {
                system.debug('==responseApiValue.blogs==='+responseApiValue.blogs);
                for(Integer i=1;i<responseApiValue.blogs.size();i++)
                {
                    system.debug('===responseApiValue.blogs=='+responseApiValue.blogs[i]);
                    SFDCBlogWrapperclass.Blogs blogs = responseApiValue.blogs.get(i);
                    system.debug('====blogs===='+blogs);
                    system.debug('===Blog id===='+blogs.id);
                    system.debug('===Blog title===='+blogs.title);
                    system.debug('===Blog url===='+blogs.url);
                }
            }
        }
        
    }
    
}