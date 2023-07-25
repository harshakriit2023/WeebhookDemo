public without sharing class ScheduleEventCalenderController
{
    Public List<calEvent>  events{get;set;}
    public string  startDatetime{get;set;}
    public string endDatetime{get;set;}
    public string milidate{get;set;}
    public string lastSetDate {get;set;}
    public string currentagenda {get;set;}
    public String Userid{get;set;}
    public String Username{get;set;}
   
    public boolean GetNextEvents{get;set;}
    
    public ScheduleEventCalenderController(ApexPages.StandardController controller)
    {
        Id userRoleId = UserInfo.getUserRoleId();
		Set<Id> roleIds = new Set<Id>{ userRoleId };
        List<Id> userIds = GetRoles.getChildRolesWithUsers(roleIds);
        userIds.add(Id.valueOf(UserInfo.getUserId()));
        System.debug('userIds :::::' + userIds);
        list<Task> CurrentMonthEventList = [SELECT Id,StartDateTime__c,EndDateTime__c,CompletedDateTime,IsRecurrence,IsReminderSet,Subject,Ownerid,owner.Name FROM Task 
                                                    WHERE  isRecurrence = false 
                                                    AND  StartDateTime__c = THIS_MONTH
                                                    AND StartDateTime__c = THIS_YEAR LIMIT 1000];
        System.debug('CurrentMonthEventList :::' + CurrentMonthEventList);
        CreateCalanderView(CurrentMonthEventList);
        Userid = Userinfo.getUserid();
        Username = Userinfo.getUsername();
        GetNextEvents = false;
        startDatetime = '';
        endDatetime = '';
    }

    //==============================================================================//
    //The calendar plugin is expecting dates is a certain format. We can use this string to get it formated correctly
    //String dtFormat = 'EEE, dd MMM yyyy HH:mm:ss z';
    

    public PageReference CreateCalanderView(list<Task> EventList)
    {
        events = new List<calEvent>();
        //user currentLoginUser = [Select UserRoleId,Email from user where id = :UserInfo.getUserId() LIMIT 1];
        //Set<Id> userIdSet = new Set<Id>();
        //userIdSet.add(currentLoginUser.UserRoleId);
        //Set<ID> finalUserIdSet = getAllSubRoleIds(userIdSet);
        //finalUserIdSet.add(UserInfo.getUserRoleId());
        
        //Owner.UserRole.id in: finalUserIdSet and
        //System.debug('---finalUserIdSet----'+finalUserIdSet);
                                                    
        String dtFormat = 'yyyy-MM-dd hh:mm:ss';
        if(!EventList.isEmpty()){
            for(Task ev : EventList)
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
                
                myEvent1.title = ev.Subject +'- '+ ev.owner.Name;
                //myEvent1.allDay = ev.IsAllDayEvent;
                myEvent1.startString = startDatetime;
                myEvent1.endString = endDatetime;
                myEvent1.url = '/'+ev.id;
                myEvent1.className = 'event-personal';
                myEvent1.textColor = '#90EE90';
                myEvent1.bgcolor = '#E0FFFF';
                myEvent1.borderColor = '#E0FFFF';
                
                events.add(myEvent1);
            }
        }
        return null;
    }
    
    public void getCurrentMonthEvent()
    {
        //String DateinMillie = apexpages.currentpage().getparameters().get('milidate');
        //System.debug('Date:-->'+DateinMillie);
        System.debug('Date:-->'+milidate);
        if(milidate != null && milidate != ''){
            //Fri May 04 2018 19:53:40 GMT+0530
            string clickmonth = milidate.split(' ')[1];
            integer clickYear = integer.valueof(milidate.split(' ')[3]);
            integer Integermonth = GetIntegerMonth(clickmonth);
            System.debug('clickmonth:-->'+clickmonth+'--clickYear----'+clickYear);
            GetNextEvents = false;
            integer Intrmonth = GetIntegerMonth(clickmonth);
            System.debug('Intrmonth :-->'+Intrmonth );
            list<Task> NewEventList = [SELECT Id,StartDateTime__c,CompletedDateTime,EndDateTime__c,IsRecurrence,IsReminderSet,Subject FROM Task WHERE  isRecurrence = false                                                     
                                                            AND  CALENDAR_MONTH(StartDateTime__c) =: GetIntegerMonth(clickmonth)
                                                            AND CALENDAR_YEAR(StartDateTime__c) =: clickYear LIMIT 1000];
            if(currentagenda == 'month'){
                lastSetDate = clickYear+'-'+GetIntegerMonth(clickmonth)+'-01';
            }else{
                integer firstDayOfWeek = integer.valueof(milidate.split(' ')[2]);
                lastSetDate = clickYear+'-'+GetIntegerMonth(clickmonth)+'-'+firstDayOfWeek;
            }
            System.debug('lastSetDate :-->'+lastSetDate);
            //2014-05-01
            CreateCalanderView(NewEventList);    
        }
    }
    
    public void EventAfterAllRender()
    {
        GetNextEvents = true;
    }   
    
    public integer GetIntegerMonth(string clickmonth)
    {
        if(clickmonth == 'Jan')
            return 1;
        if(clickmonth == 'Feb')
            return 2;
        if(clickmonth == 'Mar')
            return 3;
        if(clickmonth == 'Apr')
            return 4;
        if(clickmonth == 'May')
            return 5;
        if(clickmonth == 'Jun')
            return 6;
        if(clickmonth == 'Jul')
            return 7;
        if(clickmonth == 'Aug')
            return 8;
        if(clickmonth == 'Sep')
            return 9;
        if(clickmonth == 'Oct')
            return 10;
        if(clickmonth == 'Nov')
            return 11;
        if(clickmonth == 'Dec')
            return 12;
            
        return null;    
    }   
    
    //======================Calender================================ 
    //Class to hold calendar event data
    public class calEvent{
        public String title {get;set;}
       // public Boolean allDay {get;set;}
        public String startString {get;set;}
        public String endString {get;set;}
        public String url {get;set;}
        public String className {get;set;}
        public String bgcolor {get;set;}
        public String textColor{get;set;}
        Public String borderColor{get;set;}
        Public String description{get;set;}
    } 
    //=====================================================
}