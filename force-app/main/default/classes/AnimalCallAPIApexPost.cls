public with sharing class AnimalCallAPIApexPost {
    
    public static string putAnimlName()
    {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndPoint('https://th-apex-http-callout.herokuapp.com/animals');
        request.setMethod('POST');
        request.setHeader('Content-Type','application/json');
        request.setBody('{"name":"Salesforce"}');
        HttpResponse response = http.send(request);
        if(response.getStatusCode() != 201)
        {
            system.debug('--Status code--'+response.getStatusCode() + '--Status --' +response.getStatus());
        }
        else {
            system.debug('--response--'+response.getBody());
        }
        
        return null;
    }
}