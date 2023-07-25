public without sharing class leadQuoteController {
    @AuraEnabled
       public static void createLead(List<Lead> lead) {
           try{
               system.debug('lead data'+lead);
             
                upsert lead;
          
           }catch(Exception e)
           {
               system.debug('Error Message'+e.getMessage());
           }
          
         
       }
        @AuraEnabled
       public static List<Lead> displayLead(string recordId) {
        system.debug('--displayLead::recordId--'+recordId);
           List<Lead> leadList=[SELECT Id,Quote_Date__c,Treatment__c,Value__c,Expiry_Date__c from Lead where id=:recordId];
           system.debug('--leadList---'+leadList);
           return leadList;
       }
   
       @AuraEnabled
       public static Lead fetchLead(string leadId) {
        system.debug('---fetchLead::leadId---'+leadId);
           Lead leadRec = [Select Id, Name, Consultation__c from Lead Where Id =: leadId];
           return leadRec;
       }
       
       @AuraEnabled
       public static List<Vinci_Quote__c> displayQuote(string leadId) {
        system.debug('--displayQuote::leadId---'+leadId);
        List<Vinci_Quote__c> quoteList = [Select Id, Name, Quote_Date__c, Expiry_Date__c, Quote_From__c, Treatment__c, Value__c,deposit_1__c,Treatment_2__c,Value_1__c,deposit_2__c,Treatment_3__c,Value_2__c,deposit_3__c,Subtotal__c,Total__c,Discount_Value__c,Description__c from Vinci_Quote__c Where Lead__c =: leadId];
        system.debug('---displayQuote::quoteList----'+quoteList);
        return quoteList;
       }
       
       @AuraEnabled
       public static List<Vinci_Quote__c> createQuote(List<Vinci_Quote__c> quoteRecord, String leadId){
           system.debug('---quoteRecord--'+quoteRecord); 
           system.debug('---leadId--'+leadId);           
           if(quoteRecord != null && quoteRecord.size() >0)
           {
               insert quoteRecord;
           }
           system.debug('---quoteRecord--'+quoteRecord);
           List<Vinci_Quote__c> quoteList = displayQuote(leadId);
           system.debug('---quoteList---'+quoteList);
           return quoteList;
       }
       
       @AuraEnabled
       public static List<Vinci_Quote__c> deleteVinciQuote(String quoteId, String leadId){
           System.debug(quoteId+leadId);
           DELETE [Select Id from Vinci_Quote__c Where Id =: quoteId];
           List<Vinci_Quote__c> quoteList = displayQuote(leadId);
           return quoteList;
       }
       
       @AuraEnabled
       public static List<String> getPiclistValues(String objectName, string fieldName){
           system.debug('----fieldName::fieldName--'+fieldName);
           List<String> pickListValues = new List<String>();
           Schema.SObjectType sobjType = Schema.getGlobalDescribe().get(objectName); 
           Schema.DescribeSObjectResult describeResult = sobjType.getDescribe(); 
           Map<String,Schema.SObjectField> fieldsMap = describeResult.fields.getMap();
           Schema.DescribeFieldResult fieldResult = fieldsMap.get(fieldName).getDescribe();
           if(String.valueof(fieldResult.getType()).equalsIgnoreCase('PICKLIST')){
               List<Schema.PicklistEntry> pickListValueList = fieldResult.getPicklistValues();            
               for (Schema.PicklistEntry pickListValue: pickListValueList) {
                   pickListValues.add(pickListValue.getLabel());
               }
           }else{
               throw new AuraHandledException('Only piclist field are supported.');
           }
           return pickListValues;
       }
   }