public class ApplicantWithCoApplicantFieldController {
    @AuraEnabled
    public static List<FieldSetForm> getForm(Id recordId, String objectName, List<String> fieldSetList) {
        
        List<FieldSetForm> listFieldSet = new List<FieldSetForm>();
        
        for (String fieldSet : fieldSetList) {
            FieldSetForm form = new FieldSetForm();
            
            form.Fields = getFields(recordId, objectName, fieldSet);
            form.fieldSetLabel = fieldSet.replace('_',' ');
            form.fieldSetName = fieldSet;
            form.Record = getRecord(recordId, objectName, form.Fields);
            listFieldSet.add(form);
        }

        
        return listFieldSet;
    }
    
    private static List<Field> getFields(Id recordId, String objectName, String fieldSetName) {
        Schema.SObjectType objectType = null;
        
        if (recordId != null) {
            objectType = recordId.getSobjectType();
        }
        else if (String.isNotBlank(objectName)) {
            objectType = Schema.getGlobalDescribe().get(objectName);
        }
        System.debug('objectType::'+objectType);
        Schema.DescribeSObjectResult objectDescribe = objectType.getDescribe();
        System.debug('objectDescribe::'+objectDescribe);
        Map<String, Schema.FieldSet> fieldSetMap = objectDescribe.fieldSets.getMap();
        System.debug('fieldSetMap::'+fieldSetMap);
        Schema.FieldSet fieldSet = fieldSetMap.get(fieldSetName);
        System.debug('fieldSet::'+fieldSet);
        List<Schema.FieldSetMember> fieldSetMembers = fieldSet.getFields();
        System.debug('fieldSetMembers::'+fieldSetMembers);

        List<Field> fields = new List<Field>();
        for (Schema.FieldSetMember fsm : fieldSetMembers) {
            Field f = new Field(fsm);

            fields.add(f);
        }
        System.debug('fields::'+fields);
        return fields;
    }
    
    private static SObject getRecord(Id recordId, String objectName, List<Field> fields) {
        if (recordId == null) {
            Schema.SObjectType objectType = Schema.getGlobalDescribe().get(objectName);
            return objectType.newSObject();
        }
        
        List<String> fieldsToQuery = new List<String>();
        for (Field f : fields) {
            fieldsToQuery.add(f.APIName);
        }
        
        Schema.SObjectType objectType = recordId.getSobjectType();
        Schema.DescribeSObjectResult objectDescribe = objectType.getDescribe();
        String objectAPIName = objectDescribe.getName();
        
        String recordSOQL = 'SELECT ' + String.join(fieldsToQuery, ',') +
                            '  FROM ' + objectAPIName +
                            ' WHERE Id = :recordId';

        SObject record = Database.query(recordSOQL);
        
        return record;
    }
    
    public class FieldSetForm {
        @AuraEnabled
        public List<Field> Fields { get; set; }
        
        @AuraEnabled
        public SObject Record { get; set; }

        @AuraEnabled
        public String fieldSetName { get; set; }

        @AuraEnabled
        public String fieldSetLabel { get; set; }
        
        public FieldSetForm() {
            Fields = new List<Field>();
            fieldSetName = '';
        }
    }

    public class Field {

        public Field(Schema.FieldSetMember f) {
            this.DBRequired = f.DBRequired;
            this.APIName = f.fieldPath;
            this.Label = f.label;
            this.Required = f.required;
            this.Type = String.valueOf(f.getType());
        }
        
        public Field(Boolean DBRequired) {
            this.DBRequired = DBRequired;
        }
        
        @AuraEnabled
        public Boolean DBRequired { get;set; }
        
        @AuraEnabled
        public String APIName { get;set; }
        
        @AuraEnabled
        public String Label { get;set; }
        
        @AuraEnabled
        public Boolean Required { get;set; }
        
        @AuraEnabled
        public String Type { get; set; }
    }
}