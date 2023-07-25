@RestResource(urlMapping='/api/webhook/github/pushDetail/*')
global without sharing class WebhookSubscripForGithub {
    @HttpPost
    global static void doPost(){
        try{
            RestRequest request = RestContext.request;
            RestResponse response = RestContext.response;
            System.debug('request:'+request);
            System.debug('response:'+response);

        }catch(Exception e){
            System.debug('Error'+e.getMessage());
        }
    }
   
}