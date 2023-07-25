public class nameCreditialApexClass {
	
    public static string getNameCreditial(){
		
  		HttpRequest req = new HttpRequest();
		req.setEndpoint('https://my_endpoint.example.com');
		req.setMethod('GET');


        String username = 'Testuname';
        String password = 'Testpass';   
        
        
        Blob headerValue = Blob.valueOf(username + ':' + password);
        String authorizationHeader = 'BASIC ' +
        EncodingUtil.base64Encode(headerValue);
        req.setHeader('Authorization', authorizationHeader);
           
        // Create a new http object to send the request object
        // A response object is generated as a result of the request  
          
        Http http = new Http();
        HTTPResponse res = http.send(req);
        System.debug(res.getBody());
        return JSON.serialize(res);
    }
}