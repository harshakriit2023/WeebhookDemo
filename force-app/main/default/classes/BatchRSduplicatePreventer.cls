public class BatchRSduplicatePreventer implements Schedulable,Database.Batchable<sObject>, Database.Stateful {
   public List<String> errorList = new List<String>();
    public Set<String> masterDupIdFoReduceDup = new Set<String>();
    public Duplicate_Configuration__c dupConfig;
    //public Boolean isForLWCRunning = false;

    public BatchRSduplicatePreventer(){}
  
    public BatchRSduplicatePreventer(Duplicate_Configuration__c obj){
        System.debug('---obj--'+obj);
        this.dupConfig = obj;
    }
    
    public Database.queryLocator start(Database.BatchableContext BC){
        System.debug('--start batch--');
        Datetime dt = system.now().addHours(-4);//dt: Query variable don't delete;
        Datetime dtlastTenMinutes = system.now().addMinutes(-10);//dtlastTenMinutes: Query variable don't delete;
        System.debug('-dtlastTenMinutes--'+dtlastTenMinutes);
        String query = RSduplicatePreventer.generateQueryFromDuplicateConfiguration(dupConfig);
        System.debug('###########STARTQUERY#############:'+query);
        return Database.getQueryLocator(query);
    }
    public void execute(Database.BatchableContext BC, List<sObject> sobjectFinalList){
        Map<String,Set<Id>> crtSobjectMAP = new Map<String,Set<ID>>();
        Map<String,Set<String>> criteriaVsFieldsMap = new Map<String,set<String>>();

        if(dupConfig.Criteria_1__c != null && dupConfig.Criteria_1__c != ''){
            
        }

    }
    
    public void execute(Database.BatchableContext BC, List<sObject> sobjList){
        system.debug('---execute-----');
        try{
            System.debug('--sobjList-'+sobjList);
            Map<String,Set<ID>> crtSobjectMAP = new Map<String,Set<ID>>();
            Map<String,Set<String>> criteriaVsFieldsMap = new Map<String,Set<String>>();
            
            if(dupConfig.Criteria_1__c != null && dupConfig.Criteria_1__c != ''){
                Set<String> fieldAPISet = new Set<String>(dupConfig.Criteria_1__c.split('\\+'));
                criteriaVsFieldsMap.put('Criteria1',fieldAPISet);
            }
            System.debug('---criteriaVsFieldsMap---'+criteriaVsFieldsMap);
            if(dupConfig.Criteria_2__c != null && dupConfig.Criteria_2__c != ''){Set<String> fieldAPISet = new Set<String>(dupConfig.Criteria_2__c.split('\\+'));criteriaVsFieldsMap.put('Criteria2',fieldAPISet);}
            if(dupConfig.Criteria_3__c != null && dupConfig.Criteria_3__c != ''){Set<String> fieldAPISet = new Set<String>(dupConfig.Criteria_3__c.split('\\+'));criteriaVsFieldsMap.put('Criteria3',fieldAPISet);}
            if(dupConfig.Criteria_4__c != null && dupConfig.Criteria_4__c != ''){Set<String> fieldAPISet = new Set<String>(dupConfig.Criteria_4__c.split('\\+'));criteriaVsFieldsMap.put('Criteria4',fieldAPISet);}
            if(dupConfig.Criteria_5__c != null && dupConfig.Criteria_5__c != ''){Set<String> fieldAPISet = new Set<String>(dupConfig.Criteria_5__c.split('\\+'));criteriaVsFieldsMap.put('Criteria5',fieldAPISet);}
            
            MAP<String, Set<String>> criteriaFieldValueMAP = new MAP<String, Set<String>> ();
            
            String orderBy = '';
            String mainQuery = '';
            Map<String,Set<String>> criteriaStringVsCriteriaValuesMap = new Map<String,Set<String>>();
            Set<String> allQuerySelectorFields = new Set<String>();
            allQuerySelectorFields.add('id');
            System.debug('--sobjList---'+sobjList);
            for(SObject obj : sobjList){
                if(criteriaVsFieldsMap != null && !criteriaVsFieldsMap.keyset().isEmpty()){
                    for(String criteriaKey: criteriaVsFieldsMap.keyset()){
                        for(String fieldAPI : criteriaVsFieldsMap.get(criteriaKey)){
                            System.debug('--fieldAPI--'+fieldAPI);
                            allQuerySelectorFields.add(fieldAPI);
                            if(obj.get(fieldAPI) != null){
                                if(!criteriaFieldValueMAP.containsKey(fieldAPI)){
                                    criteriaFieldValueMAP.put(fieldAPI, new Set<String>());
                                }
                                criteriaFieldValueMAP.get(fieldAPI).add(String.valueof(obj.get(fieldAPI)));
                                system.debug('=====criteriaFieldValueMAP====='+JSON.serialize(criteriaFieldValueMAP));
                            }
                        }
                    }
                }
            }
            
            system.debug('=====criteriaFieldValueMAP====='+JSON.serialize(criteriaFieldValueMAP));
            if(dupConfig.Keep_Record__c != null && dupConfig.Keep_Record__c != '')
            {
                if(dupConfig.Keep_Record__c == 'CreatedDate Oldest First'){
                    orderBy = ' order by CreatedDate ASC';
                }else if(dupConfig.Keep_Record__c == 'CreatedDate Oldest Last'){
                    orderBy = ' order by CreatedDate DESC';
                }else if(dupConfig.Keep_Record__c == 'LastModified Oldest First'){
                    orderBy = ' order by LastModifiedDate ASC';
                }else if(dupConfig.Keep_Record__c == 'LastModified Oldest Last'){
                    orderBy = ' order by LastModifiedDate DESC';
                }
            }
            
            String whereQery = '';
            String objName = dupConfig.SObject_API_Name__c;
            List<String> criteriaQuery = new List<String>();
            List<String> criteria = new List<String>();
             //system.debug('==criteria====='+criteria);
            system.debug('==allQuerySelectorFields====='+JSON.serialize(allQuerySelectorFields));
            system.debug('==criteriaVsFieldsMap====='+JSON.serialize(criteriaVsFieldsMap));
            
            if(criteriaVsFieldsMap != null && !criteriaVsFieldsMap.keyset().isEmpty()){
                for(String criteriaKey: criteriaVsFieldsMap.keyset()){
                    string whereClause = '(';
                    for(String fieldAPI : criteriaVsFieldsMap.get(criteriaKey)){
                        if(criteriaFieldValueMAP.get(fieldAPI) != null){
                            if(whereClause != '(')
                            {
                                whereClause += ' AND ';
                            }
                            whereClause += fieldAPI+' in '+setToQueryVariable(criteriaFieldValueMAP.get(fieldAPI))+'';
                            system.debug('===whereClause===='+whereClause);
                        }
                    }
                    whereClause+=')';
                    criteriaQuery.add(whereClause);
                    system.debug('===criteriaQuery===='+JSON.serialize(criteriaQuery));
                }
                whereQery = String.join(criteriaQuery,' OR ');
                if(whereQery != null && whereQery != '' && !whereQery.contains('()')){
                    mainQuery = ' select '+String.join(new List<String>(allQuerySelectorFields),',')+' from ' + objName + ' where ' + whereQery + orderBy;
                }
            }

            Map<String,Set<String>> fetchedValVsValueMap1 = new Map<String,Set<String>>();
            Map<String,Set<String>> fetchedValVsValueMap2 = new Map<String,Set<String>>();
            Map<String,Set<String>> fetchedValVsValueMap3 = new Map<String,Set<String>>();
            Map<String,Set<String>> fetchedValVsValueMap4 = new Map<String,Set<String>>();
            Map<String,Set<String>> fetchedValVsValueMap5 = new Map<String,Set<String>>();
            set<string> currentcriteriaids = new set<string>();
            
            List<SObject>  sobjectFinalList = new List<SObject>();
            system.debug('===mainQuery===='+mainQuery);
            if(mainQuery != null && mainQuery != ''){
                Map<id,SObject> queryResultMap = new Map<id,SObject>(Database.query(mainQuery));
                system.debug('===queryResultMap===='+JSON.serialize(queryResultMap));


               /* if(!dupConfig.Allow_Sucessful_Donations__c){
                    if(dupConfig.SObject_API_Name__c == 'Account'){
                        Map<String,List<Donation__c>> accIdVsDonationListMap = new Map<String,List<Donation__c>>();
                        for(Donation__c don: [Select id,Person_Account__c,Payment_Succeed__c from Donation__c where Person_Account__c in: queryResultMap.values()]){
                            if(!accIdVsDonationListMap.containsKey(don.Person_Account__c))
                                accIdVsDonationListMap.put(don.Person_Account__c,new List<Donation__c>());
                            accIdVsDonationListMap.get(don.Person_Account__c).add(don);
                        }
                        System.debug('====accIdVsDonationListMap===='+JSON.serialize(accIdVsDonationListMap));
                        for(string accid: accIdVsDonationListMap.keyset()){
                            Boolean isSuccess = false;
                            for(Donation__c don: accIdVsDonationListMap.get(accid)){
                                if(don.Payment_Succeed__c == 'Yes'){
                                    isSuccess = true;
                                }
                            }
                            if(!isSuccess){
                                sobjectFinalList.add(queryResultMap.get(ID.valueOf(accid)));
                            }
                        }
                    }else if(dupConfig.SObject_API_Name__c == 'Person_Relation__c'){
                        Map<String,List<Donation__c>> prIdVsDonationListMap = new Map<String,List<Donation__c>>();
                        for(Donation__c don: [Select id,Person_Account__c,Person_Relation__c,Payment_Succeed__c from Donation__c where Person_Relation__c in: queryResultMap.values()]){
                            if(!prIdVsDonationListMap.containsKey(don.Person_Relation__c))
                                prIdVsDonationListMap.put(don.Person_Relation__c,new List<Donation__c>());
                            prIdVsDonationListMap.get(don.Person_Relation__c).add(don);
                        }
                        System.debug('====prIdVsDonationListMap===='+JSON.serialize(prIdVsDonationListMap));
                        for(string accid: prIdVsDonationListMap.keyset()){
                            Boolean isSuccess = false;
                            for(Donation__c don: prIdVsDonationListMap.get(accid)){
                                if(don.Payment_Succeed__c == 'Yes'){
                                    isSuccess = true;
                                }
                            }
                            if(!isSuccess){
                                sobjectFinalList.add(queryResultMap.get(ID.valueOf(accid)));
                            }
                        }
                    }
                }else{
                    sobjectFinalList = queryResultMap.values();
                }*/

               system.debug('===sobjList===='+JSON.serialize(sobjList));
               system.debug('===queryResultMap===='+queryResultMap);
                List<Merge_Duplicate_Data__c> dupInsertList = new List<Merge_Duplicate_Data__c>();
                if(queryResultMap != null && !queryResultMap.isEmpty()){
                    Map<String,List<SObject>> criteriaVsSObjectListMap = new Map<String,List<SObject>>();
                    for(SObject sobj: sobjList)
                    {    
                        for(String criteriaKey: criteriaVsFieldsMap.keyset()) {//Criteria1,Criteria2,Criteria3...5
                            Boolean isNotNull = true;
                            String fetchedValue = '';
                            
                            for(String fieldAPI : criteriaVsFieldsMap.get(criteriaKey)){
                                if(sobj.get(fieldAPI) != null){
                                    if(fetchedValue == ''){
                                        fetchedValue = String.valueOf(sobj.get(fieldAPI)).toLowerCase();
                                    }else{
                                        fetchedValue +='#'+ String.valueOf(sobj.get(fieldAPI)).toLowerCase();
                                    }
                                }else{
                                    isNotNull = false;
                                    break;
                                }
                            }
                            system.debug('===fetchedValue===='+fetchedValue);
                            system.debug('===current PA ID===='+sobj.get('id'));
                            system.debug('===criteriaKey===='+criteriaKey);
                            
                            system.debug('===fetchedValVsValueMap1===='+JSON.serialize(fetchedValVsValueMap1));
                            system.debug('===fetchedValVsValueMap2===='+JSON.serialize(fetchedValVsValueMap2));
                            system.debug('===fetchedValVsValueMap3===='+JSON.serialize(fetchedValVsValueMap3));
                            system.debug('===fetchedValVsValueMap4===='+JSON.serialize(fetchedValVsValueMap4));
                            system.debug('===fetchedValVsValueMap5===='+JSON.serialize(fetchedValVsValueMap5));
                            
                            if(isNotNull)
                            {

                                /*if(!criteriaVsSObjectListMap.containsKey(fetchedValue))
                                    criteriaVsSObjectListMap.put(fetchedValue,new List<SObject>());
                                criteriaVsSObjectListMap.get(fetchedValue).add(sobj);*/
                                
                                if(criteriaKey == 'Criteria1' && fetchedValVsValueMap1.get(fetchedValue) == null)
                                {
                                    system.debug('===1111===='+11111);
                                    if(!fetchedValVsValueMap1.containsKey(fetchedValue))
                                        fetchedValVsValueMap1.put(fetchedValue,new set<String>());
                                    fetchedValVsValueMap1.get(fetchedValue).add(string.valueOf(sobj.get('id')));
                                }
                                else if(criteriaKey == 'Criteria2' && fetchedValVsValueMap2.get(fetchedValue) == null)
                                {
                                    system.debug('===2222===='+2222);
                                    if(!fetchedValVsValueMap2.containsKey(fetchedValue))
                                            fetchedValVsValueMap2.put(fetchedValue,new Set<String>());
                                        fetchedValVsValueMap2.get(fetchedValue).add(String.valueOf(sobj.get('id')));
                                }
                                else if(criteriaKey == 'Criteria3' && fetchedValVsValueMap3.get(fetchedValue) == null)
                                {
                                    system.debug('===333===='+3333);
                                    if(!fetchedValVsValueMap3.containsKey(fetchedValue))
                                            fetchedValVsValueMap3.put(fetchedValue,new Set<String>());
                                        fetchedValVsValueMap3.get(fetchedValue).add(String.valueOf(sobj.get('id')));
                                }
                                else if(criteriaKey == 'Criteria4' && fetchedValVsValueMap4.get(fetchedValue) == null)
                                {
                                    system.debug('===4444===='+4444);
                                    if(!fetchedValVsValueMap4.containsKey(fetchedValue))
                                            fetchedValVsValueMap4.put(fetchedValue,new Set<String>());
                                        fetchedValVsValueMap4.get(fetchedValue).add(String.valueOf(sobj.get('id')));
                                }
                                else if(criteriaKey == 'Criteria5' && fetchedValVsValueMap5.get(fetchedValue) == null)
                                {
                                    system.debug('===5555===='+5555);
                                    if(!fetchedValVsValueMap5.containsKey(fetchedValue))
                                            fetchedValVsValueMap5.put(fetchedValue,new Set<String>());
                                        fetchedValVsValueMap5.get(fetchedValue).add(String.valueOf(sobj.get('id')));
                                }
                                else
                                {
                                    system.debug('===66666===='+66666);
                                    
                                    if(criteriaKey == 'Criteria1')
                                    {   
                                        if(!fetchedValVsValueMap1.containsKey(fetchedValue))
                                            fetchedValVsValueMap1.put(fetchedValue,new set<String>());
                                        fetchedValVsValueMap1.get(fetchedValue).add(string.valueOf(sobj.get('id')));
                                    }

                                    if(fetchedValVsValueMap1.get(fetchedValue) != null)
                                        currentcriteriaids = fetchedValVsValueMap1.get(fetchedValue);
                                    
                                    system.debug('===111 currentcriteriaids===='+currentcriteriaids);
                                    if(criteriaKey == 'Criteria2' && !currentcriteriaids.contains(String.valueOf(sobj.get('id'))))
                                    {
                                        system.debug('===7777===='+7777);
                                        if(!fetchedValVsValueMap2.containsKey(fetchedValue))
                                            fetchedValVsValueMap2.put(fetchedValue,new Set<String>());
                                        fetchedValVsValueMap2.get(fetchedValue).add(String.valueOf(sobj.get('id')));
                                    }
                                    
                                    if(fetchedValVsValueMap2.get(fetchedValue) != null)
                                        currentcriteriaids.addall(fetchedValVsValueMap2.get(fetchedValue));
                                    system.debug('===222 currentcriteriaids===='+currentcriteriaids);
                                    
                                    if(criteriaKey == 'Criteria3' && !currentcriteriaids.contains(String.valueOf(sobj.get('id'))))
                                    {
                                        system.debug('===8888===='+88888);
                                        if(!fetchedValVsValueMap3.containsKey(fetchedValue))
                                            fetchedValVsValueMap3.put(fetchedValue,new Set<String>());
                                        fetchedValVsValueMap3.get(fetchedValue).add(String.valueOf(sobj.get('id')));
                                    }
                                    
                                    if(fetchedValVsValueMap3.get(fetchedValue) != null)
                                        currentcriteriaids.addall(fetchedValVsValueMap3.get(fetchedValue));
                                    system.debug('===333 currentcriteriaids===='+currentcriteriaids);
                                    
                                    if(criteriaKey == 'Criteria4' && !currentcriteriaids.contains(String.valueOf(sobj.get('id'))))
                                    {
                                        system.debug('===8888===='+88888);
                                        if(!fetchedValVsValueMap4.containsKey(fetchedValue))
                                            fetchedValVsValueMap4.put(fetchedValue,new Set<String>());
                                        fetchedValVsValueMap4.get(fetchedValue).add(String.valueOf(sobj.get('id')));
                                    }
                                    
                                    if(fetchedValVsValueMap4.get(fetchedValue) != null)
                                        currentcriteriaids.addall(fetchedValVsValueMap4.get(fetchedValue));
                                    system.debug('===444 currentcriteriaids===='+currentcriteriaids);
                                    
                                    if(criteriaKey == 'Criteria5' && !currentcriteriaids.contains(String.valueOf(sobj.get('id'))))
                                    {
                                        system.debug('===8888===='+88888);
                                        if(!fetchedValVsValueMap5.containsKey(fetchedValue))
                                            fetchedValVsValueMap5.put(fetchedValue,new Set<String>());
                                        fetchedValVsValueMap5.get(fetchedValue).add(String.valueOf(sobj.get('id')));
                                    }
                                    
                                    if(fetchedValVsValueMap5.get(fetchedValue) != null)
                                        currentcriteriaids.addall(fetchedValVsValueMap5.get(fetchedValue));
                                    system.debug('===333 currentcriteriaids===='+currentcriteriaids);
                                }
                            }
                        }
                    }
                    
                    system.debug('===fetchedValVsValueMap1===='+JSON.serialize(fetchedValVsValueMap1));
                    system.debug('===fetchedValVsValueMap2===='+JSON.serialize(fetchedValVsValueMap2));
                    system.debug('===fetchedValVsValueMap3===='+JSON.serialize(fetchedValVsValueMap3));
                    system.debug('===fetchedValVsValueMap4===='+JSON.serialize(fetchedValVsValueMap4));
                    system.debug('===fetchedValVsValueMap5===='+JSON.serialize(fetchedValVsValueMap5));

                    if(!fetchedValVsValueMap1.isEmpty()){for(string valCriteria: fetchedValVsValueMap1.keyset()){for(String recID: fetchedValVsValueMap1.get(valCriteria)){
                        if(!criteriaVsSObjectListMap.containsKey(valCriteria))
                            criteriaVsSObjectListMap.put(valCriteria,new List<SObject>());
                        criteriaVsSObjectListMap.get(valCriteria).add(queryResultMap.get(recID));
                    }}}
                    if(!fetchedValVsValueMap2.isEmpty()){for(string valCriteria: fetchedValVsValueMap2.keyset()){for(String recID: fetchedValVsValueMap2.get(valCriteria)){
                        if(!criteriaVsSObjectListMap.containsKey(valCriteria))
                            criteriaVsSObjectListMap.put(valCriteria,new List<SObject>());
                        criteriaVsSObjectListMap.get(valCriteria).add(queryResultMap.get(recID));
                    }}}
                    if(!fetchedValVsValueMap3.isEmpty()){for(string valCriteria: fetchedValVsValueMap3.keyset()){for(String recID: fetchedValVsValueMap3.get(valCriteria)){
                        if(!criteriaVsSObjectListMap.containsKey(valCriteria))
                            criteriaVsSObjectListMap.put(valCriteria,new List<SObject>());
                        criteriaVsSObjectListMap.get(valCriteria).add(queryResultMap.get(recID));
                    }}}
                    if(!fetchedValVsValueMap4.isEmpty()){for(string valCriteria: fetchedValVsValueMap4.keyset()){for(String recID: fetchedValVsValueMap4.get(valCriteria)){
                        if(!criteriaVsSObjectListMap.containsKey(valCriteria))
                            criteriaVsSObjectListMap.put(valCriteria,new List<SObject>());
                        criteriaVsSObjectListMap.get(valCriteria).add(queryResultMap.get(recID));
                    }}}
                    if(!fetchedValVsValueMap5.isEmpty()){for(string valCriteria: fetchedValVsValueMap5.keyset()){for(String recID: fetchedValVsValueMap5.get(valCriteria)){
                        if(!criteriaVsSObjectListMap.containsKey(valCriteria))
                            criteriaVsSObjectListMap.put(valCriteria,new List<SObject>());
                        criteriaVsSObjectListMap.get(valCriteria).add(queryResultMap.get(recID));
                    }}}

                    system.debug('===criteriaVsSObjectListMap===='+JSON.serialize(criteriaVsSObjectListMap));
                    
                    for(String fethedValKey: criteriaVsSObjectListMap.keyset()){
                        if(criteriaVsSObjectListMap.get(fethedValKey).size() > 1){
                            Integer masterCounter = 1;
                            for(SObject dupRec : criteriaVsSObjectListMap.get(fethedValKey)){
                                if(masterCounter!=1){
                                    if(!masterDupIdFoReduceDup.contains(String.valueOf(criteriaVsSObjectListMap.get(fethedValKey).get(0).get('Id'))+String.valueOf(dupRec.get('id')))){
                                        if(String.valueOf(criteriaVsSObjectListMap.get(fethedValKey).get(0).get('Id')) != String.valueOf(dupRec.get('id'))){
                                            Merge_Duplicate_Data__c ddf= new Merge_Duplicate_Data__c();
                                            ddf.Master_ID__c = String.valueOf(criteriaVsSObjectListMap.get(fethedValKey).get(0).get('Id'));
                                            ddf.Duplicate_ID__c = String.valueOf(dupRec.get('id'));
                                            ddf.SObject_API_Name__c = objName;
                                            ddf.Unique_ID__c = String.valueOf(criteriaVsSObjectListMap.get(fethedValKey).get(0).get('Id')) +'#' + String.valueOf(dupRec.get('id'));
                                            dupInsertList.add(ddf);
                                            masterDupIdFoReduceDup.add(ddf.Master_ID__c+ddf.Duplicate_ID__c);
                                        }
                                    }
                                }else{
                                    masterCounter=masterCounter+1;
                                }
                            }   
                        }
                    }
                    system.debug('===dupInsertList===='+JSON.serialize(dupInsertList));
                    if(dupInsertList != null && !dupInsertList.isEmpty()){
                        Database.UpsertResult[] srList = Database.upsert(dupInsertList, Merge_Duplicate_Data__c.Unique_ID__c, false);
                        System.debug('--srList---'+srList);
                        // Iterate through each returned result
                        for(Database.UpsertResult sr : srList) {
                            if (sr.isSuccess()) {
                                // Operation was successful, so get the ID of the record that was processed
                                System.debug('Successfully inserted Merge Duplicate Data. Merge Duplicate Data ID: ' + sr.getId());
                            }
                            else {
                                // Operation failed, so get all errors                
                                for(Database.Error err : sr.getErrors()) {
                                    System.debug('The following error has occurred.');
                                    System.debug(err.getStatusCode() + ': ' + err.getMessage());
                                    System.debug('Merge Duplicate Data fields that affected this error: ' + err.getFields());
                                    errorList.add('Error While Savind Data, Error Code: '+err.getStatusCode()+', Error Message: '+err.getMessage()+', fields: '+err.getFields());
                                }
                            }
                        }
                    }
                }
            }
        }
        catch(Exception e)
        {
            system.debug('===error: ===='+e.getMessage());  
            system.debug('===error: ===='+e.getLineNumber());
            errorList.add('<b>Exception::</b> <b>Error Message: </b> '+e.getMessage()+' and line number:'+e.getLineNumber()+'<br><br>' +'<b>User ID: </b>'+userinfo.getuserid());
        }
    }
    
    public void finish(Database.BatchableContext BC) {
        /*if(errorList!=null && errorList.size()>0){
            SendEmailOnExceptionClass.sendEmail('Error in BatchRSduplicatePreventer',Json.serialize(errorList));
        }
        if(!Test.isRunningTest() && !isForLWCRunning)
        {
        	Database.executeBatch(new RSDuplicateMergerBatch(dupConfig.SObject_API_Name__c),100);
        }*/
    }
    
    public void execute(SchedulableContext scon) {
        if(!Test.isRunningTest()){
            for(Duplicate_Configuration__c config : [Select ID,name,Criteria_1__c,Custom_Where_Clause__c,Record_Limit__c,Criteria_2__c,Criteria_3__c,Criteria_4__c,Criteria_5__c,Keep_Record__c,SObject_API_Name__c from Duplicate_Configuration__c where Active__c = true limit 100]){
                Database.executeBatch(new BatchRSduplicatePreventer(config));
            }
        }
    }
    
    public String setToQueryVariable(set<String> criteriaFieldValueSet){
        String queryVariable = '';
        for(String eachValue: criteriaFieldValueSet){
            if(queryVariable == ''){
                queryVariable = '\''+String.escapeSingleQuotes(eachValue)+'\'';
            }else{
                queryVariable += ',\''+String.escapeSingleQuotes(eachValue)+'\'';
            }
        }
        queryVariable = '(' + queryVariable + ')';
        return queryVariable;
    }
}