@RestResource(urlMapping='/opportunities/')
global with sharing class SoapAPIcallingOpportunityManager
{
    //Post Request
    @HttpPost
    global static String createOpportunity(String name,string stage,string closeDate,string source)
    {
        
        //RestRequest request = RestContext.Request;
        //string oppId = request.requestURI.substring(request.requestURI.lastIndexof('/')+1);
        //opportunity opp = [select id,Name,StageName,CloseDate,LeadSource from opportunity where id=:Ids];
        //system.debug('--opp--'+opp);
        //return opp.id;
        opportunity opp = new opportunity(name=name,StageName=stage,CloseDate=Date.valueof(closeDate),LeadSource=source);
        insert opp;
        return name;
        //String res = 'Name = ' + name;
       // return res;
    }
    //get request
    @HttpGet
    global static String getopportunityId()
    {
        RestRequest request = RestContext.Request;
        return request.requestURI;
        // string oppId = request.requestURI.substring(request.requestURI.lastIndexof('/')+1);
        // system.debug('--oppId---'+oppId);
        // // string oppId = '0062w000005NALQAA4';
        // opportunity opp =  [select id,Name,StageName,CloseDate,LeadSource from opportunity where id=:oppId];
        //return opp.id;
    }

    //put request
    @HttpPut
    global static Id upsertOpportunityId(String name,string stage,string closeDate,string source,string id)
    {
        opportunity opp = new opportunity(Id=id,name=name,StageName=stage,CloseDate=Date.valueof(closeDate),LeadSource=source);
        upsert opp;
        return opp.id;
    } 

    //patch
    @HttpPatch
    global static Id updateOpportunityId(String name,string stage,string closeDate,string source,string id)
    {
        /*RestRequest request = RestContext.request;
        string oppId = request.requestURI.substring(request.requestURI.lastIndexof('/')+1);
        system.debug('--oppId---'+oppId);
        opportunity thisopp = [select Id from opportunity where Id=:oppId];
        Map<string,object> result = (Map<string,object>)JSON.deserializeUntyped(request.requestbody.tostring());
        for(string fieldName : result.keyset())
        {
            system.debug('---fieldName---'+fieldName);
            thisopp.put(fieldName,result.get(fieldName));
            system.debug('--fieldName--'+fieldName);
        }
        update thisopp;
        return thisopp.id;*/
        opportunity opp = new opportunity(Id=id,name=name,StageName=stage,CloseDate=Date.valueof(closeDate),LeadSource=source);
        update opp;
        return opp.id;
    }

}