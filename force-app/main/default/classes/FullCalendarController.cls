/**
 * @name: FullCalendarController
 * @description: Controller class of fullCalendarJs lightning web component
 * @usage: it is used to fetch, create, delete events from lwc component.
 
 * @author: www.auraenabled.com
 */
public with sharing class FullCalendarController {

    public class EventException extends Exception {}
    /**
     * @description: To retrieve the most recent events
     */
    @AuraEnabled(cacheable=true)
    public static List<User> getUsers() {
        return [SELECT Id, Name, Email ,Profile.name,profile.UserType FROM User WHERE IsActive = true AND (Profile.UserType != 'Guest' AND Profile.UserType != 'CsnOnly')];
    }
    @AuraEnabled(cacheable=true)
    public static list<calEvent> fetchEvents() {
        List<Task> taskList = [SELECT Id,StartDateTime__c,EndDateTime__c,CompletedDateTime,IsRecurrence,IsReminderSet,Subject,Ownerid,Owner.Name FROM Task 
                                WHERE  isRecurrence = false 
                                AND  StartDateTime__c = THIS_MONTH
                                AND StartDateTime__c = THIS_YEAR LIMIT 1000];
        return createTask(taskList);       
    }

    @AuraEnabled(cacheable=true)
    public static list<calEvent> fetchEventswithUser(List<String> userId) {
        System.debug('---fetchEventswithUser--');
        System.debug('---userId--'+userId);
        String query = 'SELECT Id,StartDateTime__c,EndDateTime__c,CompletedDateTime,IsRecurrence,IsReminderSet,Subject,Ownerid,Owner.Name FROM Task WHERE  isRecurrence = false AND  StartDateTime__c = THIS_MONTH AND StartDateTime__c = THIS_YEAR ';
        if (!userId.isEmpty()) {
            query += ' AND OwnerId = :userId';
        }
        query += ' LIMIT 1000';     
        List<Task> taskList = Database.query(query);
        return createTask(taskList);        
    }

    @AuraEnabled
    public static list<calEvent> createTask(list<Task> taskList){
        System.debug('taskList::'+taskList);
        List<calEvent> tasks = new List<calEvent>();
        String startDatetime;
        String endDatetime;
        String dtFormat = 'yyyy-MM-dd hh:mm:ss';
        if(!taskList.isEmpty()){
            for(Task ev : taskList)
            {
                calEvent myEvent1 = new calEvent(); 
                
                if(ev.StartDateTime__c != null)
                {
                    system.debug('====ev====='+ev);
                    //system.debug('====ev OWNER====='+ev.ownerid);
                    system.debug('===startDatetime==='+ev.StartDateTime__c);
                    startDatetime = ev.StartDateTime__c.format('yyyy-MM-dd hh:mm:ss') ;
                    endDatetime = ev.EndDateTime__c.format('yyyy-MM-dd hh:mm:ss') ;
                    system.debug('===startDatetime after format==='+startDatetime);
                    system.debug('===endDatetime after format==='+endDatetime);
                    myEvent1.description = ev.StartDateTime__c.format('hh:mm a') + ' - ' + ev.EndDateTime__c.format('hh:mm a');
                }
                myEvent1.taskId = ev.Id;
                myEvent1.title = ev.Subject + ' - ' + ev.owner.Name;             
                myEvent1.startString = startDatetime;
                myEvent1.endString = endDatetime;
                myEvent1.url = '/'+ev.id; 
                myEvent1.resource = ev.ownerId;        
                //myEvent1.textColor = '#90EE90';
                //myEvent1.bgcolor = '#E0FFFF';
               // myEvent1.borderColor = '#E0FFFF';
                
                tasks.add(myEvent1);
            }
        }
        System.debug('tasks::'+tasks);
        return tasks;
    }
    public class calEvent{
        @AuraEnabled
        public string taskId{get;set;}         
        @AuraEnabled
        public String title {get;set;}   
        @AuraEnabled  
        public String startString {get;set;}
        @AuraEnabled
        public String endString {get;set;}
        @AuraEnabled
        public String url {get;set;}
    //     @AuraEnabled
    //    public String bgcolor {get;set;}
    //     @AuraEnabled
    //     public String textColor{get;set;}
    //     @AuraEnabled
    //     public String borderColor{get;set;}
        @AuraEnabled
        public String description{get;set;}
        @AuraEnabled
        public String resource{get;set;}
    } 

    /**
     * @description To create an event from web component 
     * @param task - json string with event details - title, start and end for now
     */
    /*@AuraEnabled
    public static Id createEvent(String task){

        //The following logic to be replaced with your respective event object
        if(String.isBlank(task)){
            return null;
        }
        Map<String, Object> taskMap = (Map<String, Object>) JSON.deserializeUntyped(task);
        
        Task newTask = new Task();
        newTask.Subject = taskMap.get('title') != null ? (String)taskMap.get('title') : null;

        String startdate = taskMap.get('start') != null ? 
                            ((String)taskMap.get('start')).replace('T', ' ').replace('.000Z', '') : 
                            null;
        String endDate = taskMap.get('end') != null ? 
                            ((String)taskMap.get('end')).replace('T', ' ').replace('.000Z', '') : 
                            null;

        newTask.StartDateTime__c = startdate != null ? Datetime.valueOfGmt(startdate) : null;
        newTask.EndDateTime__c = endDate != null ? Datetime.valueOfGmt(endDate) : null;
        // newEvent.IsAllDayEvent = taskMap.get('start') != null ? taskMap.get('start') : null;
        insert newTask;

        return newTask.Id; 

    }*/  
}