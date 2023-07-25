public with sharing class AnimalCallAPIApex {
   
    public static string getAnimalName(string Id)
    {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndPoint('https://th-apex-http-callout.herokuapp.com' +Id);
        request.setmethod('GET');
        HttpResponse response = http.send(request);
        object animals;
        string resultvalue;
        if(response.getStatusCode() == 200)
        {
        Map<String, object> result = (Map<String, object>) json.deserializeUntyped(response.getBody());
            system.debug('--result---'+response.getBody());
            animals = result.get('animals');
            if(animals != null){
                map<string,object> result1 =(map<string,object>) JSON.deserializeUntyped(JSON.serialize(animals));
                system.debug('--result1--'+result1);
                resultvalue = (string) result1.get('name');
                system.debug('---resultvalue---'+resultvalue);
            }
        } 
        return resultvalue;
    }
}