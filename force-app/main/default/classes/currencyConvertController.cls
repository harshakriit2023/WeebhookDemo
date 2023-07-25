public class currencyConvertController {
    
    public static decimal convertCurrencyInr(Decimal eur)
    {
        decimal inr = 0.0;
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://api/exchangeratesapi.io/latest');
        req.setMethod('GET');
        
        HttpResponse res = http.send(req);
        map<string,object> jsonbody = (map<string,object>)JSON.deserializeUntyped(res.getBody());
        system.debug('==jsonbody='+jsonbody);
        
        map<string,object> maps = (map<string,object>) jsonbody.get('rate');
        decimal conversionrate = (decimal) maps.get('INR');
        inr = eur * conversionrate;
       	system.debug('===inr=='+inr);
        
        return inr;
            
    }

}