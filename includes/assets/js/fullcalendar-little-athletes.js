// change based on the demo
// then change what's displayed per day

$(document).ready(function() {
	
	/*isFilter = ($('##filtering li').length > 0);							// TRUE IF filter options exist
	if(isFilter) {															// IF filter options exist
		$('##filtering li').click(function() {								// ON filter option CLICK
			filter(this);													// filter THIS option
		});												 
	}*/
	
	//var efilter = ($('##filtering li').length > 0);
	
	var date = new Date();
	var d = date.getDate();
	var m = date.getMonth();
	var y = date.getFullYear();
	
	$('#calendar').fullCalendar({
		firstDay: 1,			// determines what day to start week on
		editable: false,
		defaultView: 'month',
		header: {
			left:   'prev',
			center: 'title',
			right:  'today next'
		},
		timeFormat: 'h:mmt', //{ - h:mmtt} 5:00pm - 6:30pm
		displayEventEnd: true,
		eventSources: [
			{
				url: '/cpsite/adm/fh/productmodule/index.cfm?action=public:dropinprogramscheduleitem.listEvents&prod=little-athletes-ec&reload=true', 
				textColor: '#333', 
				color: '#e4e4e4'
			},
			{
				url: '/cpsite/adm/fh/productmodule/index.cfm?action=public:dropinprogramscheduleitem.listAlerts&prod=little-athletes-ec&reload=true', 
				className:  'fc-event-alert'
			}
			  //,
			//{url: '/eventcalendarjq/cal_littleathletesalerts.cfm'}
						
		],
		/*events: [
			{
				title  : 'event1',
				start  : '2014-12-01',
				description : 'test event 1'
			},
			{
				title  : 'event2',
				start  : '2014-12-05',
				end    : '2014-12-07',
				description : 'test event 2'
			},
			{
				title  : 'event3',
				start  : '2014-12-09T12:30:00',
				allDay : false, // will make the time show,
				description : 'test event 3'
			}
		],*/
		viewDisplay   : function(view) {		// Limites daterange as needed
			var now = new Date(); 
			var end = new Date();
			end.setMonth(now.getMonth() + 1); 	//Adjust as needed
			
			var cal_date_string = view.start.getMonth()+'/'+view.start.getFullYear();
			var cur_date_string = now.getMonth()+'/'+now.getFullYear();
			var end_date_string = end.getMonth()+'/'+end.getFullYear();
			
			if(cal_date_string == cur_date_string) { jQuery('.fc-button-prev').addClass("fc-state-disabled"); }
			else { jQuery('.fc-button-prev').removeClass("fc-state-disabled"); }
			
			if(end_date_string == cal_date_string) { jQuery('.fc-button-next').addClass("fc-state-disabled"); }
			else { jQuery('.fc-button-next').removeClass("fc-state-disabled"); }
		},
		eventRender: function(event, element) {
			//console.log(event);
			element.addClass('fc-' + event.programprm);
			console.log(event.isalert);
			element.qtip({
				content: {
					text: event.description,
					title: event.title,
					button: 'Close'
				},
				show: {
					solo: true,
					event: 'mousedown'
				},
				hide: {
					event: false
				},
				position: {
					my: 'top center',  // Position my top left...
					at: 'bottom center', // at the bottom right of...
					target: element // my target
				},
				style: {
					classes: 'myCustomClass qtip-shadow'
				}
			});
			
		}		
	});
	
	/*filter = function(active) {
		console.log($('##filtering'))
		//$('##filtering li').fadeTo(0, 0.5).removeClass('active');		// fade all li's to 0, remove any 'active' class
		$(active).fadeTo(250, 1).addClass('active');					// fade THIS li to 1, THIS add 'active' class
		$('##calendar').fullCalendar('rerenderEvents');					// rerender calender with new options
	}*/
			
});