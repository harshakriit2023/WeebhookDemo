import { LightningElement, track, wire } from 'lwc';
import { loadScript, loadStyle } from 'lightning/platformResourceLoader';
import FullCalendarJS from '@salesforce/resourceUrl/FullCalendarJS';
import fetchEvents from '@salesforce/apex/FullCalendarController.fetchEvents';
import fetchEventswithUser from '@salesforce/apex/FullCalendarController.fetchEventswithUser';
import getUsers from '@salesforce/apex/FullCalendarController.getUsers';
import { NavigationMixin } from 'lightning/navigation';
/**
 * @description: FullcalendarJs class with all the dependencies
 */
export default class FullCalendarJs extends NavigationMixin(LightningElement) {
    //users list
    users;
    isSelected;
    selectedUserId = [];
    //To avoid the recursion from renderedcallback
    fullCalendarJsInitialised = false;
 
    //Fields to store the event data -- add all other fields you want to add
    title;
    startDate;
    endDate;
 
    eventsRendered = false;//To render initial events only once
    openSpinner = false; //To open the spinner in waiting screens
    openModal = false; //To open form
 
    @track
    events = []; //all calendar events are stored in this field
 
    //To store the orignal wire object to use in refreshApex method
    eventOriginalData = [];

    //get all Users
    @wire(getUsers)
    wiredUsers({ error, data }) {
        if (data) {
            this.users = data;
            console.log('this.users',this.users);
        } else if (error) {
            console.error(error);
        }
    }
 
    //Get data from server - in this example, it fetches from the event object
    @wire(fetchEvents)
    eventObj(value){
        this.eventOriginalData = value; //To use in refresh cache

        const {data, error} = value;
        if(data){
            //format as fullcalendar event object
            console.log('events::::::',data);
            let events = data.map(event => {
                return { id : event.Id, 
                        title : event.title, 
                        start : event.startString,
                        end : event.endString,
                        url : event.url,
                        description : event.description,
                        resource : event.resource
                        // textColor : event.textColor,
                        // borderColor : event.borderColor,
                        // backgroundColor : event.bgcolor
                        };
            });
            this.events = JSON.parse(JSON.stringify(events));
            console.log('data :::::::',this.events);
            this.error = undefined;
 
            //load only on first wire call - 
            // if events are not rendered, try to remove this 'if' condition and add directly 
            if(! this.eventsRendered){
                //Add events to calendar             
                const ele = this.template.querySelector("div.fullcalendarjs");
                $(ele).fullCalendar('renderEvents', this.events, true);
                this.eventsRendered = true;
               
            }
        }else if(error){
            this.events = [];
            this.error = 'No events are found';
        }
   }
   onUserClick(event){
    console.log('onUserClick');
    console.log('selected:',event.target.checked);
    console.log('selected:',event.target.value);
    this.isSelected = event.target.checked;
    if(this.isSelected){
        if (this.isSelected) {
            this.selectedUserId = event.target.value;     
        }
    }else{
        this.selectedUserId = null;
    }
    this.loadUserTask(); 
   }
   async loadUserTask(){
    console.log('-loadUserTask-');
    if (this.selectedUserId) {
        fetchEventswithUser({ userId: this.selectedUserId })
        .then((result) => {
            console.log('');
            let events = result.map(event => {
                return { id : event.Id, 
                        title : event.title, 
                        start : event.startString,
                        end : event.endString,
                        url : event.url,
                        description : event.description,
                        resource : event.resource
                        // textColor : event.textColor,
                        // borderColor : event.borderColor,
                        // backgroundColor : event.bgcolor
                        };
            });
            this.events = JSON.parse(JSON.stringify(events));
            console.log('data :::::::',this.events);
            const ele = this.template.querySelector("div.fullcalendarjs");
            $(ele).fullCalendar("removeEvents");
            $(ele).fullCalendar("addEventSource",this.events,true);
            $(ele).fullCalendar("rerenderEvents");
            this.eventsRendered = true;
        })
        .catch((error) => {
            console.error({
                message: "Error occured on FullCalendarJS",
                error,
            });
        });
    }else{
        fetchEventswithUser({})
        .then((result) => {
            console.log('');
            let events = result.map(event => {
                return { id : event.Id, 
                        title : event.title, 
                        start : event.startString,
                        end : event.endString,
                        url : event.url,
                        description : event.description,
                        resource : event.resource
                        // textColor : event.textColor,
                        // borderColor : event.borderColor,
                        // backgroundColor : event.bgcolor
                        };
            });
            this.events = JSON.parse(JSON.stringify(events));
            console.log('data :::::::',this.events);
            const ele = this.template.querySelector("div.fullcalendarjs");
            $(ele).fullCalendar("removeEvents");
            $(ele).fullCalendar("addEventSource",this.events,true);
            $(ele).fullCalendar("rerenderEvents");
            this.eventsRendered = true;
        })
        .catch((error) => {
            console.error({
                message: "Error occured on FullCalendarJS",
                error,
            });
        });
    }
    
   }
   /**
    * Load the fullcalendar.io in this lifecycle hook method
    */
   renderedCallback() {
      // Performs this operation only on first render
      if (this.fullCalendarJsInitialised) {
         return;
      }
      this.fullCalendarJsInitialised = true;
 
      // Executes all loadScript and loadStyle promises
      // and only resolves them once all promises are done
        Promise.all([
            loadScript(this, FullCalendarJS + "/FullCalendarJS/jquery.min.js"),
            loadScript(this, FullCalendarJS + "/FullCalendarJS/moment.min.js"),
            loadScript(this, FullCalendarJS + "/FullCalendarJS/fullcalendar.min.js"),
            loadStyle(this, FullCalendarJS + "/FullCalendarJS/fullcalendar.min.css"),
        ])
        .then(() => {
            //initialize the full calendar
        this.initialiseFullCalendarJs();
        })
        .catch((error) => {
        console.error({
            message: "Error occured on FullCalendarJS",
            error,
        });
        });
   }
 
    initialiseFullCalendarJs() {
        const ele = this.template.querySelector("div.fullcalendarjs");
        const modal = this.template.querySelector('div.modalclass');
        console.log(FullCalendar);

        function goforNewUrl(){
            console.log('====goforNewUrl called======')
            var tglCurrent = $('#YourCalendar').fullCalendar('getDate');
            var tgl=moment(tglCurrent).format('MM/DD/YYYY');
            const taskLink = `/00T/e?retURL=/lightning/n/Event_Day_Calendar&save_new_url=/00T/e&Faid={!Userid}&anm={!Username}&evt4=${tgl}&RecurrenceStartDateTime=${tgl}&retURL=/apex/Event_Day_Calendar`;
            window.open(taskLink, '_self');
            this.navigateToScheduleEventCalender();
        }
        //Actual fullcalendar renders here - https://fullcalendar.io/docs/v3/view-specific-options
        $(ele).fullCalendar({
            customButtons: {
                NewTaskButton: {
                    text: 'New Task',
                    click: function() {
                        console.log('New Task');
                        var tglCurrent = $('#YourCalendar').fullCalendar('getDate');
                        var tgl=moment(tglCurrent).format('MM/DD/YYYY');
                        console.log('tgl : '+tgl);
                        const taskLink = `/00T/e?retURL=/lightning/n/Event_Day_Calendar&save_new_url=/00T/e&Faid={!Userid}&anm={!Username}&evt4=${tgl}&RecurrenceStartDateTime=${tgl}&retURL=/apex/Event_Day_Calendar`;
                        window.open(taskLink, '_Blank');
                        this.navigateToScheduleEventCalender();
                    }
                }    
            },
            header: {
                left: "NewTaskButton",
                center: "title",
                right: "today,prev,next",
            },
            defaultDate: new Date(), // default day is today - to show the current date
            defaultView : 'agendaDay', //To display the default view - as of now it is set to week view
            navLinks: true, // can click day/week names to navigate views
            // editable: true, // To move the events on calendar - TODO 
            selectable: true, //To select the period of time
            eventClick: function(calEvent,jsEvent,view)
            {
                console.log('====eventClick======');
                this.onClickTask(url);
            },
            dayClick: function(date, jsEvent, view) {
                console.log('Date: ' + date.format('MM/DD/YYYY'));
                goforNewUrl();
            },
            eventLimit: true, // allow "more" link when too many events
            events: this.events, // all the events that are to be rendered - can be a duplicate statement here
        });
    }

    navigateToScheduleEventCalender() {
        const pageReference = {
            type: 'standard__namedPage',
            attributes: {
                pageName: 'Event_Day_Calendar' 
            }
        };

        this[NavigationMixin.Navigate](pageReference);
    }

    onClickTask(url)
    {
        window.open(url,'_self');
    }
}