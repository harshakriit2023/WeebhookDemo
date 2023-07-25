public class AnimalsCallouts 
{ 	
	public static HttpResponse makegetcallout(){
		http http = new http();
		httprequest request = new httprequest();
		request.setendpoint('https://th-apex-http-callout.herokuapp.com/animals');
		request.setMethod('GET');
		system.debug('==request=='+request);
		httpresponse response = http.send(request);
		system.debug('response'+response);
		if(response.getStatusCode() == 200)
		{
			map<string,object> result = (map<string,object>) JSON.deserializeUntyped(response.getbody());
			system.debug('result=='+result);
			list<object> animal = (list<object>) result.get('animals');
			system.debug('==animal=='+animal);
			for(object ani : animal)
			{
				system.debug(ani);
			}
            system.Debug('===result==='+result);
		}
		return response;
	}
	public static HttpResponse makepostcallout()
	{                              
		Http http = new http();
		httprequest request = new httprequest();
		request.setendpoint('https://th-apex-http-callout.herokuapp.com/animals');
		request.setMethod('GET');
		request.setheader('content-type','application/json;charset=UTF-8');
		request.setbody('{"name":"mighty moose"}');
		system.debug('===request==='+request);       
		httpresponse response = http.send(request);
		if(response.getStatusCode() != 201)
		{
			system.debug('the status  code:'+ response.getStatusCode() + ' ' + response.getStatus());
		}
		else
		{
			system.debug(response.getbody());
		}
		return response;
	}
    public static string getAnimalcalloutbyId(integer id)
    {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://th-apex-http-callout.herokuapp.com/animals/'+id);
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        AnimalResult result = (AnimalResult) JSON.deserialize(response.getBody(), AnimalResult.class);
        system.debug('=====result==='+result);       
        return result.animal.name;   
    }
    public class Animal {
        public Integer id;
        public String name;
        public String eats;
        public String says;
	}
    public class AnimalResult {
 	 public Animal animal;
	}
}