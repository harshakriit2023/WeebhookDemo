public class LeadMergeProcess {
  public static void LeadMerge(List<Lead> leadList)
    {
        Lead masterLead;      
        String allPIN = '';
        List<Lead> forDeleteLeadList = new List<Lead>();
        List<String> pinList = new List<String>();
        
        Map<String, String> childMap = getChildObjectAndField();
    System.debug('childMap ::::::::' + childMap);
        
        if(leadList == null || leadList.isEmpty()) return;
        
        System.debug('In the if ::::::::');
        System.debug('leadList :::::::::' + leadList);
        
        for(Lead l : leadList)
        {
            System.debug('Main for ::::::::');
            if(l.Company != null)
            {
                System.debug('PIN is not null');
                pinList.add(l.Company);
            }
            if(masterLead == null)
            {
                masterLead = l;
                System.debug('masterLead ::::::::' + masterLead);
            }
            else
            {
                System.debug('In the else ::::::::');
                System.debug('l ::::::::' + l);
                forDeleteLeadList.add(l);
                
                forLeadMergeProcess(childMap,l,masterLead);
            }
        }
        System.debug('pinList ::::::' + pinList);
        if(!pinList.isEmpty())
        {
            System.debug('In if of pinList');
            allPIN = String.join(pinList, ',');
            System.debug('allPIN ::::::' + allPIN);
            masterLead.Company = allPIN;
            update masterLead;
        }
        if(!forDeleteLeadList.isEmpty())
        {
            System.debug('forDeleteLeadList ::::::::::' + forDeleteLeadList);
            //delete forDeleteLeadList;
        }
    }
    
    public static Map<String, String> getChildObjectAndField()
    {
        Map<String, String> childListMap = new Map<String,String>();
        List<Schema.Childrelationship> childList = Schema.getGlobalDescribe().get('Lead').getdescribe().getChildRelationships();
        System.debug('childList :::::::' + childList);
        Schema.DescribeSObjectResult desList = Schema.getGlobalDescribe().get('Lead').getdescribe();
        System.debug('desList :::::::' + desList);
        for(Schema.ChildRelationship cr : childList){
            childListMap.put(String.valueOf(cr.getChildSObject()),String.valueOf(cr.getField()));
        }
        System.debug('childListMap.size() :::::::' + childListMap.size());
        System.debug('childListMap :::::::' + childListMap);
        return childListMap;
    }
    
    public static void forLeadMergeProcess(Map<String, String> childMap,Lead l,Lead masterLead)
    {
        String obj,field;
        String queryString;
        List<SObject> forUpdateList = new List<SObject>();
        
        for(String chidObj : childMap.keySet())
        {
            obj = chidObj;
            field = childMap.get(chidObj);
            System.debug('obj out ======' + obj);
            System.debug('--field ::::::::-'+field);
            if(field != 'WhoId' && obj != 'OutgoingEmailRelation' && obj != 'VoiceCallChangeEvent' && obj != 'ProcessInstanceHistory' && obj != 'ServiceAppointmentChangeEvent' && obj != 'ActivityHistory' && obj != 'AttachedContentDocument' && obj != 'CampaignMemberChangeEvent' && obj != 'CombinedAttachment' && obj != 'ContentDocumentLinkChangeEvent' && obj != 'ContentVersionChangeEvent' && obj != 'EmailStatus' && obj != 'EventChangeEvent' && obj != 'EventRelationChangeEvent' && obj != 'FlowExecutionErrorEvent' && obj != 'NoteAndAttachment' && obj != 'OpenActivity')
            {
                System.debug('obj ======' + obj);
                System.debug('field ======' + field);
                queryString = 'SELECT ' + field + ' FROM ' + obj + ' WHERE ' + field + ' = \'' +  l.Id + '\'';
                System.debug('queryString :::::' + queryString);
                List<SObject> objResult = Database.query(queryString);
                if(!objResult.isEmpty())
                {
                    System.debug('objResult :::::' + objResult);
                    for(SObject reParent : objResult)
                    {
                        System.debug('reParent :::::' + reParent);
                        System.debug('field :::::' + field);
                          
                        // Get the DescribeSObjectResult for the object
                        Schema.DescribeSObjectResult objectDescribe = Schema.getGlobalDescribe().get(obj).getDescribe();
                        
                        // Get the field map for the object
                        Map<String, Schema.SObjectField> fieldMap = objectDescribe.fields.getMap();
                        
                        System.debug('fieldMap ::::::' + fieldMap);
                        
                        for (String fieldName : fieldMap.keySet()) {
                            System.debug('=========fieldName======' + fieldName);
                            if (fieldMap.get(field).getDescribe().isUpdateable()) 
                            {
                                // Field is updateable
                                reParent.put(field , masterLead.Id);
                                System.debug('This updated field ::::::::' + reParent.get(field));
                                forUpdateList.add(reParent);
                                //}
                            } else {
                                // Field is not updateable
                                System.debug('This field is not editable: ' + fieldName);
                            }
                        }
                        System.debug('reParent.get(field) before:::::::' + reParent.get(field));
                    }
                }
            }
        }
        if(!forUpdateList.isEmpty())
        {
            update forUpdateList;
        }
    }
}