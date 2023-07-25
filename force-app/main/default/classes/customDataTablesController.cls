public class customDataTablesController {
    
    @AuraEnabled
    public static List<Account> fetchAccounts(){
        return [SELECT Id, Name, Industry, Type, Rating FROM ACCOUNT LIMIT 10];
    }
    
  
    @AuraEnabled
    public static List<String> fetchRatingValues(){
        
        //List<SelectOption> options = new List<SelectOption>();
        List<String> ratingOptions = new List<String>();
        
        Schema.DescribeFieldResult fieldResult = Account.Rating.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        
        /**for(Schema.PicklistEntry f : ple){
            options.add(new SelectOption(f.getLabel(),f.getValue()));
        }*/
        
        for(Schema.PicklistEntry a: ple){
            ratingOptions.add(a.getValue());
        }
        
        return ratingOptions;
    }
    
}