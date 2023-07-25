public with sharing class UserDetailRecord {

    public string getUserDataId()
    {
        try{
            Http http = new Http();
            HttpRequest request = new HttpRequest(); 
            request.setEndPoint('https://jsonplaceholder.typicode.com/users');
            request.setMethod('GET');
            HttpResponse response = http.send(request);
            if(response.getStatusCode() == 200)
            {
                list<UserNameWrapper> userdata = (list<UserNameWrapper>)JSON.Deserialize(response.getbody(),list<UserNameWrapper>.class);
                system.debug('--after get wrapper data---'+userdata);
                system.debug('--after get wrapper data---'+JSON.Serialize(userdata));
                list<User_JSON_Data__c> userlist = new list<User_JSON_Data__c>();
                for(UserNameWrapper usr:userdata)
                {
                    User_JSON_Data__c udata = new User_JSON_Data__c();
                    udata.Name = usr.name;
                    udata.username__c = usr.username;
                    udata.email__c = usr.email;
                    udata.phone__c = usr.phone;
                    udata.website__c = usr.website;
                    udata.street__c = usr.address.street;
                    udata.suite__c = usr.address.suite;
                    udata.city__c = usr.address.city;
                    udata.zipcode__c = usr.address.zipcode;
                    udata.lng__c = usr.address.geo.lng;
                    udata.lat__c = usr.address.geo.lat;
                    udata.cname__c = usr.company.name;
                    udata.bs__c = usr.company.bs; 
                    udata.catchPhrase__c = usr.company.catchPhrase;
                    userlist.add(udata);
                }
                if(!userlist.isEmpty())
                {
                    Database.saveResult[] srlist = Database.insert(userlist,false);
                    for(DataBase.saveResult sr :srlist)
                    {
                        if(!sr.isSuccess())
                        {
                            system.debug('--sr get error--'+sr.getErrors());
                        }
                    }
                }
            }
        }catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        } 
        return null;
    }

    public class UserNameWrapper{
        public Integer id;
        public string name;
        public string username;
        public string email;
        public addressData address;
        public string phone;
        public string website;
        public companyData company;
    }
   public class addressData{
        public string street;
        public string suite;
        public string city;
        public string zipcode;
        public geodata geo;
    }
    public class geodata
    {
        public string lng;
        public string lat;
    }
    public class companyData
    {
        public string name;
        public string catchPhrase;
        public string bs;
    }
    
    
}