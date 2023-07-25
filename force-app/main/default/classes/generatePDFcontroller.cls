public with sharing class generatePDFcontroller {
    @AuraEnabled
    public static List<String> getPickList(String objName,String fldName) {
        List<String> pkList = new List<String>();Map<String,Schema.SObjectType> allObj = Schema.getGlobalDescribe();
        Map<String,Schema.SObjectField> allFlds = allObj.get(objName).getDescribe().fields.getMap();
        List<Schema.PicklistEntry> pickList = allFlds.get(fldName).getDescribe().getPickListValues();
        for(Schema.PicklistEntry pk : pickList){
            pkList.add(pk.getValue());
        }
        return pkList;
    }
    @AuraEnabled
    public static Account createAccount(Account ac){
        system.debug('--ac---'+ac);
        insert ac;
        return ac;
        
    }

}