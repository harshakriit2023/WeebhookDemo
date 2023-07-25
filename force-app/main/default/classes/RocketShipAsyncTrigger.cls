/*
* Created By : Kishan Vasoya 
* Created Date: 25/05/2023
* GitHub: https://github.com/anyei/SFDC-ATARC
* Purpose: In a nutshell, runs processes out of a custom setting. The custom setting has a field indicating
*           the apex class implementing RocketShipAsyncTriggerProcessBase or AsyncTriggerArcProcessFEABAse base class which is the code to execute (the process), 
*           order of execution, a flag to make it active or not (if not active it will not run), a flag to force it to run
*           as queueable, a field to control dependencies (process A is dependent on process B to run, if process B does not run or 
*           has an exception in the code process A will not run) and in addition to all that this also has the capability to pass output from one process
*          to the next one within the same transaction.  
*  
* Test Classes: RocketShipAsyncTriggerTest
*/
public class RocketShipAsyncTrigger {
    
    
   
    public static final string PROCESS_EXECUTED = 'Executed';
    public static final string PROCESS_FAILED = 'Failed';
    
    //possible values listed here NONE, ERROR, WARN, INFO, DEBUG,
    //FINE, FINER, FINEST
    public static final string DEFAULT_LOGGIN_LEVEL =  'DEBUG';
    public static final string CATEGORY_SKIP = 'category';
    public static final string OBJECT_SKIP = 'object';
    public static final string EVENT_SKIP = 'event';
    public static final string PROCESS_SKIP = 'process';
    public static final string FRAMEWORK_NAME = 'ATARC';
    public static final integer GOVERNOR_LIMITS_QUEUEABLE = System.Limits.getLimitQueueableJobs();
    
    @TestVisible static Map < string, map < string, List<Process_Setting__mdt> >> arqSettings;
    
    //must be an instance variable
    //this is the state of engine instance    
    @TestVisible RocketShipAsyncTriggerConfig globalConfig;

    //Salesforce has a weird suggestion on how to test custom metadata type related code
    //I think this is a better solution, this field should be populated by the unit test
    //It will be populated by the real code at runtime.
    @TestVisible static List < Process_Setting__mdt > settings;
    @TestVisible static List< Process_Availability_Rule__mdt > allRules;
    @TestVisible static Map<string, string> rulesSettingsMapping;
    @TestVisible static map<string, map<string, List<Process_Availability_Rule__mdt>>> settingRulesMap;
    @testVisible static Map < string, set < string > > skips;
    @TestVisible static Map < string, RocketShipAsyncTriggerProcessInfo > processesExecStatuses;
    @testVisible static Map < string, object > customData;
    @TestVisible static Map < string, Map < string, Map< string, integer >>> triggerExecTrack;
    @TestVisible static Map < string, System.LoggingLevel > logginLevelMap;
    @TestVisible static List< RocketShipAsyncTriggerDebugStackSetting > processesStack;
    
    @TestVisible static Id CurrentUserId;
    @TestVisible static Id CurrentProfileId;
    @TestVisible static Id currentRoleId;
    
    static boolean orderProcessed;
    static boolean runningAsyncContext;
    
    public static boolean globalSkip;
    public static integer globalTransactionLoop;
    public static boolean globalDebugMode = true;
    static boolean alwaysAvailable;
    
    
    string sObjectName;
    string triggerName;
    string triggerEventTxt;
    
    //load initial config
    static {
        customData = new Map < string, object > ();
        
        arqSettings = new Map < string, Map < string, List<Process_Setting__mdt> >> ();
        
        triggerExecTrack = new Map < string, Map < string, Map< string, integer >>> ();
        
        processesExecStatuses = new Map < string, RocketShipAsyncTriggerProcessInfo > ();

        processesStack = new List< RocketShipAsyncTriggerDebugStackSetting > ();
        
        
        logginLevelMap = new Map < string, System.LoggingLevel > {
            'NONE' => LoggingLevel.NONE,
                'ERROR' => LoggingLevel.ERROR,
                'WARN' => LoggingLevel.WARN,
                'INFO' => LoggingLevel.INFO,
                'DEBUG' => LoggingLevel.DEBUG,
                'FINE' => LoggingLevel.FINE,
                'FINER' => LoggingLevel.FINER,
                'FINEST' => LoggingLevel.FINEST
                
                };
         skips = new Map < string, set < string >> {
                CATEGORY_SKIP => new set < string > (),
                    OBJECT_SKIP => new set < string > (),
                    EVENT_SKIP => new set < string > (),
                    PROCESS_SKIP => new set < string > ()
                    };
                    
                    orderProcessed = false;
        
        globalSkip = false;
        alwaysAvailable = false;
        Global_Setting__c globalConfigSetting = Global_Setting__c.getInstance();
        if(globalConfigSetting != null)  {
            globalSkip = globalConfigSetting.SkipAll__c;
            globalDebugMode = globalConfigSetting.Debug__c;
            globalTransactionLoop = Integer.valueof(globalConfigSetting.LoopLimit__c);
            alwaysAvailable = globalConfigSetting.General_Availability__c;
        }
                
        runningAsyncContext = false;
        
        currentUserId = userinfo.getUserId();
        
        currentProfileId = userinfo.getProfileId();
        
        currentRoleId = userinfo.getUserRoleId();
        
        allRules = new List< Process_Availability_Rule__mdt >();
        
    }
    
    static RocketShipAsyncTriggerQueueable RequestQueuable() {
        
        RocketShipAsyncTriggerQueueable newInstance = null;
        
        if (Limits.getQueueableJobs() < GOVERNOR_LIMITS_QUEUEABLE) {
            newInstance = new RocketShipAsyncTriggerQueueable();
        }
        return newInstance;
    }
    
    @TestVisible static boolean canSkip(boolean gskip, Process_Setting__mdt setting) {
        boolean skip = false;
        
        for (string skipType: skips.keyset()) {
            if (skipType == CATEGORY_SKIP)
                if (skip = skips.get(skipType).contains(setting.Category__c)) break;
            if (skipType == OBJECT_SKIP)
                if (skip = skips.get(skipType).contains(setting.SObject__c)) break;
            if (skipType == EVENT_SKIP)
                if (skip = skips.get(skipType).contains(setting.Event__c)) break;
            if (skipType == PROCESS_SKIP)
                if (skip = skips.get(skipType).contains(setting.DeveloperName)) break;
            
        }
        return skip || gskip;
    }
       
    @TestVisible static void processOrder(boolean firstTime) {
        
        if (orderProcessed != true) {
            Map < string, Map < string, List < integer >>> orderLogicA = new Map < string, Map < string, List < integer >>> ();
            Map < string, Map < string, List < integer >>> orderLogicS = new Map < string, Map < string, List < integer >>> ();
            
            settings = settings == null ? [select DeveloperName , MasterLabel, ApexHelperClassName__c , BreakIfError__c , Category__c , Debug__c , Debug_Level__c , 
                                           DependsOnFailure__c , DependsOnSuccess__c , Event__c , IsActive__c , IsAsync__c , Order__c , SObject__c, isolate__c,
                                           Override_Loop_Limit__c, LoopLimit__c, General_Availability__c,(select DeveloperName, Availability__c, Custom_Scope_Filter__c, Custom_Scope_Filter_Value__c,
                                                                                 Scope__c , Scope_Id_Value__c, Process_Setting__r.DeveloperName from Process_Availability_Rules__r where IsActive__c=true)
                                           from Process_Setting__mdt where isActive__c = true
order by SObject__c, Event__c,Order__c,isAsync__c asc] : settings;//AsyncTriggerArqSettings__c.GetAll().values();
            
            for (Process_Setting__mdt setting: settings) {
                if (setting.IsActive__c && !canSkip(globalSkip, setting)) {
                    
                    if (!processesExecStatuses.containsKey(setting.DeveloperName))
                        processesExecStatuses.put(setting.DeveloperName, new RocketShipAsyncTriggerProcessInfo());
                    
                    if (!arqSettings.containsKey(setting.SObject__c))
                        arqSettings.put(setting.SObject__c, new Map < string, List<Process_Setting__mdt> > ());
                    
                    if (!arqSettings.get(setting.SObject__c).containsKey(setting.Event__c))
                        arqSettings.get(setting.SObject__c).put(setting.Event__c, new List<Process_Setting__mdt>());
                    
                    arqSettings.get(setting.SObject__c).get(setting.Event__c).add(setting);
                    
                }
                
            }
            
            atarcDebug('Config loaded\n' + settings.size());
        }
        
        orderProcessed = true;
    }
    static map<string, set<id> > ParseScopesGeneralAvailability(List<Process_Availability_Rule__mdt> rules, map<string, map<string, map<string,object> > > filterDataObj, set<string> fields){
        map<string, set<id> > scopeIds= new map<string, set<id> >();
        for(Process_Availability_Rule__mdt rule : rules){
            if(!scopeIds.containsKey(rule.Scope__c)) scopeIds.put(rule.Scope__c, new set<id>());
            try{
                if(rule.Custom_Scope_Filter__c != true) scopeIds.get(rule.scope__c).add(rule.Scope_Id_Value__c);
                if(rule.Custom_Scope_Filter__c && !string.isBlank(rule.Custom_Scope_Filter_Value__c) ){
                    filterDataObj.put(rule.developerName, new map<string, map<string, object>>());
                    object result = JSON.deserializeUntyped(rule.Custom_Scope_Filter_Value__c); 
                    if(result instanceof list<object>){
                    list<object> filterDataList = (list<object>) result;
                        for(object o : filterDataList){
                            if(o instanceof map<string, object>){
                                map<string, object> filterData = (map<string,object>)o;
                                if(filterData.containsKey('field')) {
                                    filterDataObj.get(rule.developerName).put(string.valueof(filterData.get('field')), filterData);
                                    fields.add(string.valueof(filterData.get('field')));
                                }
                            }
                        }
                    }
                    
                }
            }catch(Exception err){ atarcDebug(err.getMessage());}
        }
        return scopeIds;
    }
    static map<string, set<id> > GetScopesGeneralAvailability(map<string, set<id> > scopes, set<string> userFields, List<User> currentUser){
        id userid = userinfo.getUserId();
        map<string, set<id> > existingScopes = new map<string, set<id> >();
        if( (scopes.containsKey('Group') && scopes.get('Group').size() > 0) || (scopes.containsKey('Queue') && scopes.get('Queue').size() > 0) ){
            set<id> groupsAndQueues = new set<id>();
            if(scopes.containsKey('Group'))groupsAndQueues.addall(scopes.get('Group'));
            if(scopes.containsKey('Queue'))groupsAndQueues.addall(scopes.get('Queue'));
            for(GroupMember gm : [select Group.Type, GroupId, UserOrGroupId from GroupMember where GroupId in :groupsAndQueues and UserOrGroupId =:userid] ){
                if(!existingScopes.containsKey(gm.Group.Type == 'Regular' ? 'Group' : gm.Group.Type)) existingScopes.put( gm.Group.Type == 'Regular' ? 'Group' : gm.Group.Type, new set<id>());
                existingScopes.get(gm.Group.Type=='Regular'?'Group':gm.Group.Type).add(gm.GroupId);
            }
        }
        if(scopes.containsKey('PermissionSet') && scopes.get('PermissionSet').size() > 0){
            for(PermissionSetAssignment psa : [select Assigneeid, PermissionSetId from PermissionSetAssignment where PermissionSetId in :scopes.get('PermissionSet') and AssigneeId=:userid]){
                if(!existingScopes.containsKey('PermissionSet')) existingScopes.put('PermissionSet', new set<id>());
                existingScopes.get('PermissionSet').add(psa.PermissionSetId);
            }
        }
        if(scopes.containsKey('Profile') && scopes.get('Profile').size() > 0){
            if(!existingScopes.containsKey('Profile')) existingScopes.put('Profile', new set<id>());
                existingScopes.get('Profile').add(currentProfileId);
        }
        if(scopes.containsKey('Role') && scopes.get('Role').size() > 0){
            if(!existingScopes.containsKey('Role')) existingScopes.put('Role', new set<id>());
                existingScopes.get('Role').add(currentRoleId);
        }
        if(scopes.containsKey('User') && scopes.get('User').size() > 0){
            if(!existingScopes.containsKey('User')) existingScopes.put('User', new set<id>());
            existingScopes.get('User').add(currentUserId);
        }
        if(userFields.size() > 0){
                currentUser.add(database.query('select '+string.join(new list<string>(userFields),',') + ' from User where id=:currentUserId'));
        }
            
        
        return existingScopes;
    }
    
    static map<string, map<string, List<Process_Availability_Rule__mdt>>> MatchRulesWithProcess(List<Process_Setting__mdt> settings){
        map<string, map<string, List<Process_Availability_Rule__mdt>>> result = new map<string, map<string, List<Process_Availability_Rule__mdt>>>();
        map<string, map<string, map<string, object> > > fieldsMapping = new map<string, map<string, map<string, object> > >();
        set<string> allfields = new set<string>();
        List<User> currentUser = new List<User>();
        map<string, set<id>> scopeIds;
        map<string, set<id>> existingScopeIds;
        if(allRules.size() <= 0) for(Process_Setting__mdt setting:settings){
           if(setting.Process_Availability_Rules__r != null && setting.Process_Availability_Rules__r.size() > 0) allrules.addall(setting.Process_Availability_Rules__r);
        }
        scopeIds = ParseScopesGeneralAvailability(allrules, fieldsMapping, allfields);
        if( (scopeIds != null && scopeIds.size() > 0) || (fieldsMapping != null && fieldsMapping.size() > 0) ) existingScopeIds = GetScopesGeneralAvailability(scopeIds, allfields, currentUser);
        
        for(Process_Availability_Rule__mdt rule : allrules){
            string settingDeveloperName = rulesSettingsMapping != null ? rulesSettingsMapping.get(rule.developerName) : rule.Process_Setting__r.DeveloperName;
            if(existingScopeIds.containsKey(rule.Scope__c) && existingScopeIds.get(rule.Scope__c).contains(rule.Scope_Id_Value__c)) {
                if(!result.containsKey(settingDeveloperName)) result.put(settingDeveloperName, new map<string, list<Process_Availability_Rule__mdt>>());
                if(!result.get(settingDeveloperName).containsKey(rule.Availability__c))result.get(settingDeveloperName).put(rule.Availability__c, new list<Process_Availability_Rule__mdt>() );
                result.get(settingDeveloperName).get(rule.Availability__c).add(rule);
            }
            if(rule.Custom_Scope_Filter__c & rule.Scope__c == 'User'){
                boolean condition = fieldsMapping.containsKey(rule.developerName) && fieldsMapping.get(rule.DeveloperName).size() > 0;
                if(condition) for(string field : fieldsMapping.get(rule.developerName).keyset()){
                    if(fieldsMapping.get(rule.developerName).get(field).containsKey('value')){
                       object v = fieldsMapping.get(rule.developerName).get(field).get('value');
                        string op = fieldsMapping.get(rule.developerName).get(field).containsKey('op') ? string.valueof(fieldsMapping.get(rule.developerName).get(field).get('op')): null;
                        object fv = currentUser[0].get(field);
                        condition = EvaluateFieldValueWithOp(condition, v, fv, op);
                     } 
                 }
                if(condition) {
                    if(!result.containsKey(settingDeveloperName)) result.put(settingDeveloperName, new map<string, list<Process_Availability_Rule__mdt>>());
                    if(!result.get(settingDeveloperName).containsKey(rule.Availability__c))result.get(settingDeveloperName).put(rule.Availability__c, new list<Process_Availability_Rule__mdt>() );
                    result.get(settingDeveloperName).get(rule.Availability__c).add(rule);
                }
            }
         }
            
        return result;
    }
    
 
  
    static void atarcDebug(object msg) {
        debug(FRAMEWORK_NAME, globalDebugMode, 'INFO', (msg != null) ? string.valueof(msg) : '');
    }
    
    static void debug(string prefix, boolean debugMode, string lvl, string msg) {
        if (debugMode == true) system.debug((logginLevelMap.containsKey(lvl) ? logginLevelMap.get(lvl) : logginLevelMap.get(DEFAULT_LOGGIN_LEVEL)), prefix + ': ' + msg);
    }

    public static void debug(object msg){
        if(!processesStack.isEmpty()){
            RocketShipAsyncTriggerDebugStackSetting currentProcessDebugInfo= processesStack[processesStack.size() - 1];
            debug(currentProcessDebugInfo.name,currentProcessDebugInfo.debugMode,currentProcessDebugInfo.lvl, string.valueof(msg) );
        }
    }
      
    public RocketShipAsyncTrigger(){
        this(trigger.isBefore, trigger.isAfter, trigger.isInsert, trigger.isUpdate, trigger.isDelete, trigger.isUndelete, trigger.new,trigger.old, trigger.newmap, trigger.oldmap);
    }
   
    public RocketShipAsyncTrigger(string sObjectName, boolean isBefore, boolean isAfter, boolean isInsert, boolean isUpdate, boolean isDelete, boolean isUndelete, List < SOBject > newList, List < SObject > oldList, Map < Id, SObject > newMap, Map < id, SObject > oldMap) {
        
        if (String.isEmpty(sObjectName))
            throw new RocketShipAsyncTriggerException('sObject Name must be provided!!');
        
        globalConfig = new RocketShipAsyncTriggerConfig();
        
        this.sObjectName = sObjectName;
        this.triggerName = triggerName;
        
        globalConfig.triggerContext.oldList = oldList;
        globalConfig.triggerContext.newList = newList;
        globalConfig.triggerContext.oldMap = oldmap;
        globalConfig.triggerContext.newMap = newMap;
        globalConfig.skipEverything = globalSkip;
        globalConfig.triggerContext.sObjectName = sObjectName;
        
              
        //the chain of process to execute should be reset every time 
        //a trigger is executed
        globalConfig.Chain = new List < Process_Setting__mdt > ();
        
        
        triggerEventTxt = ((globalConfig.triggerContext.isBefore = isBefore) ? 'Before' : '') + ((globalConfig.triggerContext.isAfter = isAfter) ? 'After' : '') +
            ((globalConfig.triggerContext.IsInsert = isInsert) ? 'Insert' : '') + ((globalConfig.triggerContext.isUpdate = isUpdate) ? 'Update' : '') +
            ((globalConfig.triggerContext.isDelete = isDelete) ? 'Delete' : '');
        triggerEventTxt = ((globalConfig.triggerContext.isUndelete = isUndelete) && globalConfig.triggerContext.isAfter ? '' : (globalConfig.triggerContext.isUndelete == true ? 'BeforeUndelete' : triggerEventTxt));
        globalConfig.triggerContext.eventTxt = triggerEventTxt;

    }
      
    public RocketShipAsyncTrigger(boolean isBefore, boolean isAfter, boolean isInsert, boolean isUpdate, boolean isDelete, boolean isUndelete, List < SOBject > newList, List < SObject > oldList, Map < Id, SObject > newMap, Map < id, SObject > oldMap) {
        
        this(((isDelete == true || isUndelete == true) && oldList.size() > 0 ? oldList[0].getSObjectType().getDescribe().getName() : (newlist.size() > 0) ? newList[0].getSObjectType().getDescribe().getName() : null),
             isBefore,
             isAfter,
             isInsert,
             isUpdate,
             isDelete,
             isUndelete,
             newList,
             oldList,
             newMap,
             oldMap);
    }
       
    public Map < string, RocketShipAsyncTriggerProcessInfo > getProcessesExecutionInformation() {
        Map < string, RocketShipAsyncTriggerProcessInfo > result = new Map < string, RocketShipAsyncTriggerProcessInfo > ();
        result.putall(processesExecStatuses);
        return result;
    }   
  
    public void Start() {
        
        atarcDebug('Start\n' +
                   '\nSOBject:' + sObjectName +
                   '\nEvent:' + triggerEventTxt +
                   '\nRunningOutOfAnAsyncProcess:' + runningAsyncContext +
                   '\nglobalSkip:' + globalSkip +
                   '\nglobalTransactionLoop:' + globalTransactionLoop +
                   '\nglobalDebugMode:' + globalDebugMode  );
        
        if (!orderProcessed)
            processOrder(true);     
        
        if (arqSettings.containsKey(sObjectName) &&
            arqSettings.get(SObjectName).containsKey(triggerEventTxt)
           ) {
               
               List < Process_Setting__mdt > settings = arqSettings.get(sObjectName).get(triggerEventTxt);
               
               atarcDebug('Event match found:' + triggerEventTxt + '\nTotal processes:' + settings.size());
               
               settingRulesMap = MatchRulesWithProcess(settings);
               for (Process_Setting__mdt setting: settings) {
                   globalConfig.Chain.add(setting);
                   atarcDebug(setting.DeveloperName);
               }
               
               Eval(globalConfig, null, null);
           }
        
        

        //finishing up the execution of the current instance
        //cleaning up
        Finish();

    }

    void Finish(){
        atarcDebug('Exit Start\n' +
                   '\nSOBject:' + sObjectName +
                   '\nEvent:' + triggerEventTxt +
                   '\nRunningOutOfAnAsyncProcess:' + runningAsyncContext +
                   '\nglobalSkip:' + globalSkip +
                   '\nglobalTransactionLoop:' + globalTransactionLoop +
                   '\nglobalDebugMode:' + globalDebugMode );
    }   
 
    map < string, RocketShipAsyncTriggerProcessBase > getInstances(RocketShipAsyncTriggerConfig config) {
        map < string, RocketShipAsyncTriggerProcessBase > instances = new Map < string, RocketShipAsyncTriggerProcessBase > ();
        integer globalLoopLimit =  (globalTransactionLoop == null ? 0 :globalTransactionLoop);
        atarcDebug('Generating instances..getInstances');
        for (Process_Setting__mdt setting: config.chain) {
            //instantiate the objects
            //and invoke the filter method
            
            integer loopLimit = setting.LoopLimit__c  == null ? 0 : integer.valueof(setting.LoopLimit__c);
            boolean continueFlag = false;
           
            //simple skip functionality
            if (canSkip(config.skipEverything, setting) )
            {
                atarcDebug('BYPASS FOUND getInstances '+setting.DeveloperName);
                continueFlag = true;
            }
            
            //loop limit controls
            if((setting.Override_Loop_Limit__c && (loopLimit == 0 || getTriggerTrack(setting.DeveloperName) >= loopLimit) ) ||
               (setting.Override_Loop_Limit__c != true && (globalLoopLimit == 0 || getTriggerTrack(setting.DeveloperName) >= globalLoopLimit) ) ){
                   atarcDebug('LIMIT REACHED FOUND getInstances '+setting.DeveloperName);
                   continueFlag = true;
            }
            map<string,List<Process_Availability_Rule__mdt>> aRules = settingRulesMap.containsKey(setting.developerName) ? settingRulesMap.get(setting.developerName) : null;
            if(!alwaysAvailable && setting.General_Availability__c && aRules != null && aRules.containsKey('Unavailable') && aRules.get('Unavailable').size() > 0){
                atarcDebug('Availability Rules FOUND unavailable');
                continueFlag = true;
            }
            if(!alwaysAvailable && setting.General_Availability__c != true && (aRules == null || !aRules.containsKey('Available') || aRules.get('Available').size() <= 0) ){
                atarcDebug('Atarc Process '+setting.DeveloperName+' not available to the public Availability Rules not FOUND available');
                continueFlag = true;
            }
            if(continueFlag){
                 continue;
            }          
            
            object o = RequestInstance(setting.ApexHelperClassName__c, setting.BreakIfError__c);
            RocketShipAsyncTriggerProcessBase instance = (o instanceof RocketShipAsyncTriggerProcessBase ) ?  (RocketShipAsyncTriggerProcessBase) o : null; 
            if (instance != null){
                instances.put(setting.DeveloperName, instance);
                updateTriggerTrack(setting.DeveloperName, sObjectName, triggerEventTxt);
            }
        }
        return instances;
    }

    map < string, RocketShipAsyncTriggerFEAProcessBase > getFEAInstances(RocketShipAsyncTriggerConfig config, set<string> standardInterface) {
        map < string, RocketShipAsyncTriggerFEAProcessBase > instances = new Map < string, RocketShipAsyncTriggerFEAProcessBase > ();
        integer globalLoopLimit =  (globalTransactionLoop == null ? 0 : globalTransactionLoop);
        atarcDebug('Generating instances..getFEAInstances');
        for (Process_Setting__mdt setting: config.chain) {
            //instantiate the objects
            //and invoke the filter method
            //
            integer loopLimit = setting.LoopLimit__c  == null ? 0 : integer.valueof(setting.LoopLimit__c);
            boolean continueFlag = false;           
            //simple skip functionality
            if (canSkip(config.skipEverything, setting) )
            {
                atarcDebug('BYPASS FOUND getFEAInstances '+setting.DeveloperName);
                continueFlag = true;
            }
                        
            //loop limit controls
            if((setting.Override_Loop_Limit__c && (loopLimit == 0 || getTriggerTrack(setting.DeveloperName) >= loopLimit) ) ||
               (setting.Override_Loop_Limit__c != true && (globalLoopLimit == 0 || getTriggerTrack(setting.DeveloperName) >= globalLoopLimit) ) ){
                   atarcDebug('LIMIT REACHED FOUND getFEAInstances '+setting.DeveloperName);
                   continueFlag = true;
            }
            map<string,List<Process_Availability_Rule__mdt>> aRules = settingRulesMap.containsKey(setting.developerName) ? settingRulesMap.get(setting.developerName) : null;
            if(!alwaysAvailable && setting.General_Availability__c && aRules != null && aRules.containsKey('Unavailable') && aRules.get('Unavailable').size() > 0){
                atarcDebug('Availability Rules FOUND unavailable');
                continueFlag = true;
            }
            if(!alwaysAvailable && setting.General_Availability__c != true && (aRules == null || !aRules.containsKey('Available') || aRules.get('Available').size() <= 0) ){
                atarcDebug('Atarc Process '+setting.DeveloperName+' not available to the public Availability Rules not FOUND available');
                continueFlag = true;
            }
           
            //not sure if this could ever happen but in any case let's put this check here
            if(standardInterface.contains(setting.DeveloperName)){
                continueFlag = true;
            }
            if(continueFlag) { 
                continue;
            }
            object o = RequestInstance(setting.ApexHelperClassName__c, setting.BreakIfError__c);
            RocketShipAsyncTriggerFEAProcessBase instance = (o instanceof RocketShipAsyncTriggerFEAProcessBase) ? (RocketShipAsyncTriggerFEAProcessBase)o: null;
            
            if (instance != null){
                instances.put(setting.DeveloperName, instance);
                updateTriggerTrack(setting.DeveloperName, sObjectName, triggerEventTxt);
            }
        }
        return instances;
    }

    static void pushToProcessStack(Process_Setting__mdt setting){
        RocketShipAsyncTriggerDebugStackSetting debuggingInfo = new RocketShipAsyncTriggerDebugStackSetting();
        debuggingInfo.debugMode = setting.debug__c;
        debuggingInfo.lvl = setting.debug_Level__c;
        debuggingInfo.name = setting.DeveloperName;
        processesStack.add(debuggingInfo);
    }
    
    static void runActionPattern(RocketShipAsyncTriggerConfig config, boolean fromAsync, boolean breakTransaction, boolean deletionContext, map < string, RocketShipAsyncTriggerFEAProcessBase > feaInstances, List < Process_Setting__mdt > chain) {
        if (breakTransaction != true) {
            atarcDebug('Running ACTION Pattern');
            if(feaInstances.size() == 0 ) atarcDebug('No fea instances found, action pattern will not run ');
            
            if(feaInstances.size() > 0){
                
                long startTime = system.datetime.now().millisecond();
                atarcDebug('Pending actions to run '+chain.size());
                
                for (integer i =0;i<(deletionContext == true ? config.triggerContext.oldList.size() : config.triggerContext.newList.size());i++) {
                    SObject record = (deletionContext == true ? config.triggerContext.oldList[i] : config.triggerContext.newList[i]);
                    for (Process_Setting__mdt setting: chain) {
                        
                         /**********************************/
                        //simple skip functionality
                        if (canSkip(config.skipEverything, setting)) {
                            atarcDebug('BYPASS FOUND getFEAInstances '+setting.DeveloperName);
                            continue;
                        }
                                    
                        if (feaInstances.containsKey(setting.DeveloperName)) {
                            RocketShipAsyncTriggerFEAProcessBase feaInstance = feaInstances.get(setting.Developername);
                            
                            
                            //configuring
                            config.triggerContext.debugMode = setting.debug__c;
                            config.triggerContext.debugLevel = setting.debug_Level__c;
                            config.triggerContext.processName = setting.DeveloperName;

                            pushToProcessStack(setting);
                            boolean noError = true;
                            
                            //invoking the "action" method
                            try {
                                
                                if( (String.isNotEmpty(setting.DependsOnSuccess__c) && processesExecStatuses.containsKeY(setting.DependsOnSuccess__c) &&  processesExecStatuses.get(setting.DependsOnSuccess__c).status == PROCESS_EXECUTED ) ||
                                    (String.isNotEmpty(setting.DependsOnFailure__c ) && processesExecStatuses.containsKeY(setting.DependsOnFailure__c ) && processesExecStatuses.get(setting.DependsOnFailure__c ).status == PROCESS_FAILED ) ||
                                    (String.isBlank(setting.DependsOnSuccess__c) && String.isBlank(setting.DependsOnFailure__c ) )
                                  )
                                {
                                       
                                       feaInstance.action((deletionContext != true ?  config.triggerContext.oldList[i] : record),(deletionContext != true ? record : null), config.triggerContext);
                                       
                                       long totalTime = system.datetime.now().millisecond() - startTime;
                                       
                                       UpdateStatusSuccess(setting.DeveloperName);
                                       
                                       UpdateProcessTime(setting.DeveloperName, totalTime);
                                       
                                   } 
                                
                            } catch (Exception err) {
                                
                                long totalTime = system.datetime.now().millisecond() - startTime;
                                
                                UpdateStatusFailed(setting.DeveloperName);
                                UpdateProcessTime(setting.DeveloperName, totalTime);
                                
                                debug('EXCEPTION!!:\nCause:'+err.getCause()+'\nLine:'+err.getLineNumber()+'\nMessage:' + err.getMessage() + '\nStack:'+ err.getStackTraceString());
                                processesStack.remove(processesStack.size() - 1);
                                noError = false;
                           
                                //break transaction if error feature
                                if (setting.BreakIfError__c) {
                                    atarcDebug('breaking transaction');
                                    throw err;
                                }
                            }
                            
                            if(noError) processesStack.remove(processesStack.size() -1);
                            
                        }
                        
                        //if this is running from async context
                        //break
                        if(setting.isAsync__c)
                            break;
                    }
                }
            }
            
            atarcDebug('Running ACTION Pattern COMPLETE');
        }
    }
    
    static void runFilterPattern(RocketShipAsyncTriggerConfig config, boolean deletionContext, map < string, RocketShipAsyncTriggerFEAProcessBase > feaInstances, List < Process_Setting__mdt > chain, boolean fromAsync) {
        atarcDebug('Running first loop for FILTER pattern ');
        
        if(feaInstances.size() == 0) atarcDebug('No fea instances found, filter pattern will not run');
        
        //shall not run even a single line of code if no fea instances
        if(feaInstances.size() > 0){
            
            long startTime = system.datetime.now().millisecond();
            
            for ( integer i = 0;i< (deletionContext == true ? config.triggerContext.oldList.size() : config.triggerContext.newList.size()) ; i++ ) {
                SObject record= (deletionContext == true ? config.triggerContext.oldList[i] : config.triggerContext.newList[i]);
                for (Process_Setting__mdt setting: chain) {
                    
                    /**********************************/
                        //simple skip functionality
                        if (canSkip(config.skipEverything, setting)) {
                            atarcDebug('BYPASS FOUND getFEAInstances '+setting.DeveloperName);
                            continue;
                        }
                    if(setting.isAsync__c == true && fromAsync != true) continue;
                    
                    if (feaInstances.containsKey(setting.DeveloperName) ) {
                        
                        RocketShipAsyncTriggerFEAProcessBase feaInstance = feaInstances.get(setting.DeveloperName);
                        
                        //configuring
                        config.triggerContext.debugMode = setting.debug__c;
                        config.triggerContext.debugLevel = setting.debug_Level__c;
                        config.triggerContext.processName = setting.DeveloperName;
                        
                        pushToProcessStack(setting);
                        boolean noError = true;
                        //invoking the "filter" method
                        try {
                            
                            
                            if ((String.isNotEmpty(setting.DependsOnSuccess__c) && processesExecStatuses.containsKeY(setting.DependsOnSuccess__c) && processesExecStatuses.get(setting.DependsOnSuccess__c).status == PROCESS_EXECUTED ) ||
                                (String.isNotEmpty(setting.DependsOnFailure__c) && processesExecStatuses.containsKeY(setting.DependsOnFailure__c) && processesExecStatuses.get(setting.DependsOnFailure__c).status == PROCESS_FAILED ) ||
                                (String.isBlank(setting.DependsOnSuccess__c) && String.isBlank(setting.DependsOnFailure__c))
                            )    
                            {
                                   
                                   feaInstance.filter((deletionContext != true ?  config.triggerContext.oldList[i] : record),(deletionContext != true ? record : null), config.triggerContext);
                                
                                   long totalTime = system.datetime.now().millisecond() - startTime;
                                   
                                   UpdateStatusSuccess(setting.DeveloperName);
                                   
                                   UpdateProcessTime(setting.DeveloperName, totalTime);
                                   
                               } 
                            
                        } catch (Exception err) {
                            
                            long totalTime = system.datetime.now().millisecond() - startTime;
                            
                            UpdateStatusFailed(setting.DeveloperName);
                            UpdateProcessTime(setting.DeveloperName, totalTime);

                            debug('EXCEPTION!!:\nCause:'+err.getCause()+'\nLine:'+err.getLineNumber()+'\nMessage:' + err.getMessage() + '\nStack:'+ err.getStackTraceString());
                            processesStack.remove(processesStack.size() - 1);
                            noError = false;
                            
                            //break transaction if error feature
                            if (setting.BreakIfError__c) {
                                atarcDebug('breaking transaction');
                                throw err;
                            }
                        }
                        
                        if(noError) processesStack.remove(processesStack.size() - 1);
                        
                    }
                    
                }
                 
            }            
        } 
        atarcDebug('Running first loop for FILTER pattern COMPLETE');
    }
    
    static boolean runExecutePattern(RocketShipAsyncTriggerConfig config, boolean fromAsync, map < string, RocketShipAsyncTriggerProcessBase > instances,map < string, RocketShipAsyncTriggerFEAProcessBase > feaInstances, List < Process_Setting__mdt > syncProcessesToRunActionPattern) {
        boolean breakTransaction = false;
        atarcDebug('Running  EXECUTE Pattern');
        
        if(instances.size() == 0 && feaInstances.size() == 0) atarcDebug('No instances or feainstances found, execute pattern will not run .');
        
        if(instances.size() > 0 || feainstances.size() > 0){
            
            while (config.chain.size() > 0) {
                
                atarcDebug('Pending processes size ' + config.chain.size());
                
                //"doing pop", returning and removing the next process to evaluate and execute
                //this is key to get rid of the processed processes from the queue
                Process_Setting__mdt setting = config.chain.remove(0);
                              
             
                //simple skip functionality
                if (canSkip(config.skipEverything, setting)) {
                    atarcDebug('BYPASS FOUND execute '+setting.DeveloperName);                    
                    continue;
                }

                //configuring
                config.triggerContext.debugMode = setting.debug__c;
                config.triggerContext.debugLevel = setting.debug_Level__c;
                config.triggerContext.processName = setting.DeveloperName;
                
                pushToProcessStack(setting);
                
                
                if ( (String.isnotblank(setting.DependsOnSuccess__c) && processesExecStatuses.containsKeY(setting.DependsOnSuccess__c) && processesExecStatuses.get(setting.DependsOnSuccess__c).status == PROCESS_EXECUTED) || 
                    (String.isnotblank(setting.DependsOnFailure__c) && processesExecStatuses.containsKeY(setting.DependsOnFailure__c) && processesExecStatuses.get(setting.DependsOnFailure__c).status == PROCESS_FAILED ) ||
                    (String.isBlank(setting.DependsOnSuccess__c) && String.isBlank(setting.DependsOnFailure__c))
                   )
                {
                       breakTransaction = Run(instances, feaInstances, config, setting, fromAsync);
                       processesStack.remove(processesStack.size() - 1);
                   } 
                
                //async transactions invokations should break this loop
                if (breakTransaction) { //&& DEFAULT_OPERATION_STRATEGY_MODE.equalsIgnoreCase(config.strategyMode) ){                
                    break;
                }
                
                if (feainstances.containskey(setting.DeveloperName))  syncProcessesToRunActionPattern.add(setting);
              
            }
        }
        atarcDebug('Running EXECUTE pattern COMPLETE');
        return breakTransaction;
    }
    
    void Eval(RocketShipAsyncTriggerConfig config, map < string, RocketShipAsyncTriggerProcessBase > instances, map < string, RocketShipAsyncTriggerFEAProcessBase > feaInstances) {
        atarcDebug('Preparing to start invoke processes');
        
        instances =  getInstances(config);
        feaInstances =  getFeaInstances(config, instances.keyset());
        
        List < Process_Setting__mdt > syncProcessesToRunActionPattern = new List < Process_Setting__mdt > ();
        
        boolean deletionContext = config.triggerContext.isdelete == true; //|| config.triggerContext.isUndelete == true;
        
        runFilterPattern(config, deletionContext, feaInstances, config.chain, false);
          
        boolean breakTransaction = runExecutePattern(config, false, instances,feaInstances, syncProcessesToRunActionPattern);

        runActionPattern(config, false, breakTransaction, deletionContext, feaInstances, syncProcessesToRunActionPattern);
    }
    

    static boolean Run(map < string, RocketShipAsyncTriggerProcessBase > instances, map < string, RocketShipAsyncTriggerFEAProcessBase > feaInstances, RocketShipAsyncTriggerConfig config, Process_Setting__mdt setting, boolean fromAsync) {
        
        boolean isAsync = false;
        config.triggerContext.debugMode = setting.debug__c;
        config.triggerContext.debugLevel = setting.debug_Level__c;
        
        //async processes should break the upper loop only if isolate is false
        //so that only one active process thread is working            
        RocketShipAsyncTriggerQueueable asyncWorker = RequestQueuable();
        
        if(!(instances.containsKey(setting.developerName) || feaInstances.containsKey(setting.developerName))) return false;
        
        if (setting.isAsync__c && asyncWorker != null &&
            //to fix specific problems when dml happens on a processes and the objects
            //affected by the dml has async process as well
            !runningAsyncContext ) {          
                //async feature
                //
                
                atarcDebug('Async running...');
                
                asyncWorker.currentSetting = setting;
                asyncWorker.config = config;
                if(setting.isolate__c){
                    asyncWorker.config = new RocketShipAsyncTriggerConfig();
                    asyncWorker.config.Chain = new List<Process_Setting__mdt>();
                    asyncWorker.config.Chain.add(setting);
                    asyncWorker.config.triggerContext = config.triggerContext;
                }
                asyncWorker.pStatuses = processesExecStatuses;
                asyncWorker.fromAsync = true;
                asyncWorker.pCustomData =  customData;
                asyncWorker.pSkips = skips;
                asyncWorker.instances = instances;  
                asyncWorker.feaInstances = feaInstances;    
                asyncWorker.settingRules = settingRulesMap; 
                asyncWorker.pAlwaysAvailable = alwaysAvailable;
                system.enqueueJob(asyncWorker);
                atarcDebug('Processes executed async');
                
                isAsync = setting.isolate__c != true; // if isAsync = true processes in the config.chain will be executed from the recently queued queueable execution for the current object/event               
            } 
         
        else {
            
            atarcDebug('Running '+setting.DeveloperName+'...');
            
            //after class is executed then get the output if any
            //after preparing data for the triggerContext upper loop should run the next process in line.
            object output = null;
            if(instances.containsKey(setting.DeveloperName) || feaInstances.containsKey(setting.DeveloperName))
                output = RunClass(instances, feaInstances, config, setting);
            
            //cleaning the heap a little bit
            if(instances.containsKey(setting.DeveloperName))
                instances.remove(setting.DeveloperName);
            
            customData.put(setting.DeveloperName, output);
                        
        }
        
        return isAsync;
    }
    
    static Object RequestInstance(string apexClassName, boolean throwError) {
        object newInstance = null;
        
        try {
            Type t = Type.forName(apexClassName);
            newInstance = t.newInstance();
        } catch (Exception err) {
                      
            //break transaction if error feature
            if (throwError)
                throw err;
        }
        return newInstance;
        
    }
    
    static Object RunClass(Map < string, RocketShipAsyncTriggerProcessBase > instances, map < string, RocketShipAsyncTriggerFEAProcessBase > feaInstances, RocketShipAsyncTriggerConfig config, Process_Setting__mdt setting) {        
        
        object o =  null;
        
        RocketShipAsyncTriggerProcessBase instance = (          
            instances.containsKey(setting.DeveloperName) ? instances.get(setting.DeveloperName) : null
        );
        RocketShipAsyncTriggerFEAProcessBase feaInstance = (            
            feaInstances.containsKey(setting.DeveloperName) ? feaInstances.get(setting.DeveloperName) : null           
        );
        
        Object output = null;
        
        config.triggerContext.processName = setting.DeveloperName;
        
        
        long startTime = system.datetime.now().millisecond();
        
        try {
            
            if (instance == null && feaInstance == null)
                throw new RocketShipAsyncTriggerException('Not able to instantiate Apex Class ' + setting.ApexHelperClassName__c);
            
            atarcDebug('instance found');
            
            //passing data in between processes feature
            //the output represents the data output from a process            
            output = (instance != null) ? instance.execute(config.triggerContext) : ((feaInstance != null) ? feaInstance.execute(config.triggerContext) : null);
                     
            boolean outputExists = output != null;
            
            long totalTime = system.datetime.now().millisecond() - startTime;
            
            UpdateStatusSuccess(setting.DeveloperName);
            
            UpdateProcessTime(setting.DeveloperName, totalTime);
            
            atarcDebug('*****Processes executed exit ' + setting.ApexHelperClassName__c + '\nOutput Data:' + string.valueof(outputExists) + ' '+ processesExecStatuses.get(setting.DeveloperName));
            
        } catch (Exception err) {
            
            long totalTime = system.datetime.now().millisecond() - startTime;
            
            UpdateStatusFailed(setting.DeveloperName);
            UpdateProcessTime(setting.DeveloperName, totalTime);

            debug('EXCEPTION!!:\nCause:'+err.getCause()+'\nLine:'+err.getLineNumber()+'\nMessage:' + err.getMessage() + '\nStack:'+ err.getStackTraceString());
                     
            //break transaction if error feature
            if (setting.BreakIfError__c) {
                atarcDebug('breaking transaction');
                throw err;
            }
        }
        
        return output;
        
    }
    
    static void updateTriggerTrack(string processName, string sObjectName, string triggerEventTxt) {
        if (!triggerExecTrack.containsKey(sObjectName))
            triggerExecTrack.put(sObjectName, new Map < string, Map<string, integer >> ());
        
        if(!triggerExecTrack.get(sObjectName).containsKey(triggerEventTxt))
            triggerExecTrack.get(sObjectName).put(triggerEventTxt, new Map<string, integer>());
        
        triggerExecTrack.get(SObjectName).get(triggerEventTxt).put(
            processName,
            (
                triggerExecTrack.get(sObjectName).get(triggerEventTxt).containsKey(processName) ? triggerExecTrack.get(sObjectName).get(triggerEventTxt).get(processName) + 1 : 1
            ));
    }
    
    integer getTriggerTrack(string processName) {
        return (
            triggerExecTrack.containsKey(sObjectName) &&
            triggerExecTrack.get(sObjectName).containsKey(triggerEventTxt) && 
            triggerExecTrack.get(sObjectName).get(triggerEventTxt).containsKey(processName) ? triggerExecTrack.get(sObjectName).get(triggerEventTxt).get(processName) : 0
        );
    }
    
    static void UpdateStatusSuccess(string processName) {
        
        if(processesExecStatuses.get(processName).status != PROCESS_FAILED) processesExecStatuses.get(processName).status = PROCESS_EXECUTED;
    }
    
    static void UpdateStatusFailed(string processName) {
        
         processesExecStatuses.get(processName).status = PROCESS_FAILED;
    }
    
    static void UpdateProcessTime(string processName, long totalTime) {
        processesExecStatuses.get(processName).processTime = totalTime;
    }
    
    static boolean isInt(object v) { return v instanceof integer;}
    static boolean isDecimal(object v) { return v instanceof decimal;}
    static boolean isString(object v) { return v instanceof string;}
    static boolean isBoolean(object v) { return v instanceof boolean;}
    static boolean isId(object v) { return v instanceof Id;}
    static boolean boolVal(object v){ return boolean.valueof(v); }
    static integer intVal(object v){ return integer.valueof(v); }
    static decimal decimalVal(object v){ string strO = string.valueof(v); return decimal.valueof(strO); }
    static id idVal(object v){ string strO = string.valueof(v); return Id.valueof(strO); }
    static string stringVal(object v){ return string.valueof(v); }
    static boolean greater(object inV, object fV){
        return (isInt(inV) ? intVal(inV) > intVal(fV) :
                           (isDecimal(inV) ? decimalVal(inV) > decimalVal(fV) :
                           (isString(inV) ? stringVal(inV) > stringVal(fV)  :
                           (isId(inV) ? idVal(inV) > idVal(fv): false))));
    }
    static boolean less(object inV, object fV){
        return (isInt(inV) ? intVal(inV) < intVal(fV) :
                           (isDecimal(inV) ? decimalVal(inV) < decimalVal(fV) :
                           (isString(inV) ? stringVal(inV) < stringVal(fV)  : 
                           (isId(inV) ? idVal(inV) < idVal(fv): false))));
    }
    static boolean equals(object inV, object fV){
        return (isInt(inV) ? intVal(inV) == intVal(fV) :
                           (isDecimal(inV) ? decimalVal(inV) == decimalVal(fV) :
                           (isString(inV) ? stringVal(inV) == stringVal(fV)  : 
                           (isBoolean(inV) ? boolVal(inV) == boolVal(fV)  : 
                           (isId(inV) ? idVal(inV) == idVal(fv): false)))));
    }
    static boolean greaterEq(object inV, object fV){
        return (isInt(inV) ? intVal(inV) >= intVal(fV) :
                           (isDecimal(inV) ? decimalVal(inV) >= decimalVal(fV) :
                           (isString(inV) ? stringVal(inV) >= stringVal(fV)  : 
                           (isId(inV) ? idVal(inV) >= idVal(fv): false))));
    }
    static boolean lessEq(object inV, object fV){
        return (isInt(inV) ? intVal(inV) <= intVal(fV) :
                           (isDecimal(inV) ? decimalVal(inV) <= decimalVal(fV) :
                           (isString(inV) ? stringVal(inV) <= stringVal(fV)  : 
                           (isId(inV) ? idVal(inV) <= idVal(fv): false))));
    }
    static boolean notEq(object inV, object fV){
        return (isInt(inV) ? intVal(inV) != intVal(fV) :
                           (isDecimal(inV) ? decimalVal(inV) != decimalVal(fV) :
                           (isString(inV) ? stringVal(inV) != stringVal(fV)  : 
                           (isBoolean(inV) ? boolVal(inV) != boolVal(fV)  : 
                           (isId(inV) ? idVal(inV) != idVal(fv): false)))));
    }
    static boolean EvaluateFieldValueWithOp(boolean initialCondition, object inV, object fV, string op){
        if(op == '>'){ initialCondition = greater(inV, fV) && initialCondition;  }
        if(op == '<'){ initialCondition = less(inV, fV) && initialCondition; }
        if(op == '='){ initialCondition = equals(inV, fV) && initialCondition; }
        if(op == '>='){ initialCondition = greaterEq(inV, fV) && initialCondition; }
        if(op == '<='){ initialCondition = lessEq(inV, fV) && initialCondition; }
        if(op == '!='){ initialCondition = notEq(inV,fV) && initialCondition; }
        return initialCondition;
    }

    public class RocketShipAsyncTriggerProcessInfo {
        public string status {
            get;
            set;
        }
        public long processTime {
            get;
            set;
        }
    }
    
    class RocketShipAsyncTriggerConfig {
        
        public List < Process_Setting__mdt > Chain {
            get;
            set;
        }
        public RocketShipAsyncTriggerContext triggerContext {
            get;
            set;
        }       
        public boolean skipEverything {
            get;
            set;
        }        
        
        public RocketShipAsyncTriggerConfig() {
            
            triggerContext = new RocketShipAsyncTriggerContext();           
            
                        skipEverything = false;
            
        }
        
    }
    
    public class RocketShipAsyncTriggerContext {
        public boolean isBefore {
            get;
            protected set;            
        }
        public boolean isAfter {
            get;
            protected set;
        }
        public boolean isUpdate {
            get;
            protected set;
        }
        public boolean isDelete {
            get;
            protected set;
        }
        public boolean isInsert {
            get;
            protected set;
        }
        public boolean isUndelete {
            get;
            protected set;
        }
        public integer LoopLimit {
            get {
                return integer.valueof(getSetting().LoopLimit__c);
            }
            set {
                Process_Setting__mdt setting = getSetting();
                setting.LoopLimit__c= value;
                setting.Override_Loop_Limit__c = value > 0;
            }
        }
        public List < SObject > newList {
            get;
            protected set;
        }
        public List < SObject > oldList {
            get;
            protected set;
        }
        public Map < id, SObject > oldMap {
            get;
            protected set;
        }
        public Map < id, SObject > newMap {
            get;
            protected set;
        }
        
        protected string processName;
        protected boolean debugMode = false;
        protected string debugLevel = DEFAULT_LOGGIN_LEVEL;
        protected string sobjectName;
        protected string eventTxt;
        
        
        private Process_Setting__mdt getSetting(){
            Process_Setting__mdt result = null;
                for(Process_Setting__mdt s : arqSettings.get(sObjectName).get(eventTxt))
                {
                    if(s.developerName == processName)
                        result =s;
                }
                return result;
        }
        
        public RocketShipAsyncTriggerContext() {
            
        }
        
        public object getProcessData(string processName) {
            return (customData.containsKey(processName) ? customData.get(processName) : null);
        }
        public void setData(object data) {
            customData.put(processName, data);
        }
        public string getCurrentProcessName() {
            return processName;
        }
        
        public void setFailed() {
            processesExecStatuses.get(processName).status = PROCESS_FAILED;
        }
        
        public string getProcessStatus(string processName) {
            return processesExecStatuses.containsKey(processName) ? processesExecStatuses.get(processName).status : null;
        }
        
        public void debug(object msg) {
            RocketShipAsyncTrigger.debug(processName, debugMode, debugLevel, msg != null ? string.valueof(msg) : '');
        }
         public RocketShipAsyncTriggerContext bypass(string skipType, string skipValue) {
                if (skips.containsKey(skipType)) skips.get(skipType).add(skipValue);
                return this;
            }
            
            public RocketShipAsyncTriggerContext clearBypass(string skipType, string skipValue) {
                if (skips.containsKey(skipType)) skips.remove(skipValue);
                return this;
            }
    }
 
    public abstract class RocketShipAsyncTriggerProcessBase {

        @testvisible protected virtual object execute(RocketShipAsyncTriggerContext triggerContext){
            return null;
        }
        
        
    }    
   
    public abstract class RocketShipAsyncTriggerFEAProcessBase {
             
        @testvisible protected virtual void filter(sObject newRecord, sObject oldRecord, RocketShipAsyncTriggerContext triggerContext){
            
        }       
        
        @testvisible protected virtual object execute(RocketShipAsyncTriggerContext triggerContext){
            return null;
        }        
       
        @testVisible protected virtual void action(SObject newRecord, sObject oldRecord, RocketShipAsyncTriggerContext triggerContext){
            
        }
        
    }
    
    class RocketShipAsyncTriggerQueueable implements Queueable, Database.AllowsCallouts  {
        public RocketShipAsyncTriggerConfig Config {
            get;
            set;
        }
        public Process_Setting__mdt currentSetting {
            get;
            set;
        }
        public Map < string, RocketShipAsyncTriggerProcessInfo > pStatuses {
            get;
            set;
        }
        public string additionalMsg {
            get;
            set;
        }
        public boolean fromAsync {
            get;
            set;
        }
        public Map<string, RocketShipAsyncTriggerProcessBase> instances {
            get;
            set;
        }
        public map < string, RocketShipAsyncTriggerFEAProcessBase > feaInstances{
            get;
            set;
        }
        
        public map < string, object> pCustomData {
            get;
            set;
        }
        
        public Map < string, set < string > > pSkips {
            get;
            set;
        }
        public map<string, map<string, List<Process_Availability_Rule__mdt>>> settingRules{
            get;
            set;
        }
        public boolean palwaysAvailable {get;set;}
        
        public virtual void execute(QueueableContext context) {
            
            atarcDebug('EXECUTING ASYNC ' + currentSetting.ApexHelperClassName__c + '\n' + additionalMsg + '\n'+currentSetting.DeveloperName );
            processOrder(true);
            alwaysAvailable = palwaysAvailable;
            customData = pCustomData;
            
            //TODO: TEST THIS SCENARIO FOR runningAsyncContext = true
            //to overcome sfdc limit 
            //(only one queueable can be called from within a queueable so any dlm inside the implementation 
            //of the this context will be executed within this transaction unfortunately)
            runningAsyncContext = true;
            
            
            //tracking of the executed processes so far
            processesExecStatuses = pstatuses;
            updateTriggerTrack(currentSetting.DeveloperName, config.triggerContext.sobjectName, config.triggerContext.eventTxt );
            skips = pSkips;
            settingRulesMap = settingRules;           
            boolean deletionContext = config.triggerContext.isdelete == true || config.triggerContext.isUndelete == true;
            
            if (feaInstances.containsKey(currentSetting.DeveloperName))
                runFilterPattern(config, deletionContext, feaInstances, new List < Process_Setting__mdt > {
                    currentSetting
                        }, fromAsync);
            
            pushToProcessStack(currentSetting);
            object output = null;
            if(instances.containsKey(currentSetting.DeveloperName) || feaInstances.containsKey(currentSetting.DeveloperName))
               output  = RunClass(instances,feaInstances, config, currentSetting);
            
            //store the output of the current invocation
            customData.put(currentSetting.DeveloperName, output);                        
           
            if (feaInstances.containsKey(currentSetting.DeveloperName))//(includePattern(PATTERN_ACTION, currentSetting))
                runActionPattern(config, true, false, deletionContext, feaInstances, new List < Process_Setting__mdt > {
                    currentSetting
                        });
            
            //unflaggin this allows the eval process to run/chain another queueable
            runningAsyncContext = false;
            
            //chain operations
            //call the next operation according to the order.            
            List<Process_Setting__mdt> dummyList = new List<Process_Setting__mdt>();
            if(!currentSetting.isolate__c) runExecutePattern(config, fromAsync, instances, feaInstances, dummyList);
            
        }
    }

    class RocketShipAsyncTriggerDebugStackSetting{
        public string name {get;set;}
        public boolean debugMode {get;set;}
        public string lvl {get;set;}
    }
    
    public class RocketShipAsyncTriggerException extends Exception {}
    
}