public class streetapiCallcon
{
    public static void getStreetblog()
    {
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://us-street.api.smartystreets.com/street-address?key=21102174564513388&candidates=10&street=&city=&state=&zipcode=&match=enhanced&license=us-rooftop-geocoding-cloudt');
        req.setMethod('GET');
        HttpResponse res = http.send(req);
        system.debug('===res body==='+res.getBody());
        
        if(res.getStatusCode() == 200 && res.getBody() != null)
        {
            system.debug('====');
            system.debug('==res.getStatusCode()=='+res.getStatusCode());
            streetapiCall str = (streetapiCall)JSON.deserialize(res.getBody(),List<streetapiCall>.class);
            system.debug('str===='+str);
        }
    }   
}