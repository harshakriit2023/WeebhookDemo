@RestResource(urlMapping = '/leadCreate/')
global class createmyfirstAPIclass {
    
    global static string dopost()
    {
        string firstname;
        string lstname;
        string comp;
        string fieldvalue;
        string fieldname;
        
        RestRequest req = RestContext.Request;
        RestResponse res = RestContext.Response;
        
        system.debug('==request=='+req.requestBody);
        system.debug('==param==='+req.params);
        
        string arr = req.requestBody.tostring();
        system.debug('==arr==='+arr);
        
        JSONParser parse = JSON.createParser(arr);
        system.debug('==parse=='+parse);
        while(parse.nextToken()!= null)
        {
            if(parse.getCurrentToken() != JsonToken.END_OBJECT)
            {
                parse.nextValue();
                fieldname = parse.getCurrentName();
               	fieldvalue = parse.getText();
                if(fieldname == 'First Name')
                {
                    firstname = parse.getText();
                }
                else if(fieldname == 'Last Name')
                {
                    lstname = parse.getText();
                }
                else if(fieldname == 'Company')
                {
                    comp = parse.getText();
                }
            }
        } 
        Lead l = new lead(FirstName = firstname,LastName = lstname,Company = comp);
        insert l;
        system.debug('==l=='+l);
        return l.Id;
    }
    

}