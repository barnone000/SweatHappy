/**
	Garmin watchface that displays the following:
	-	4 of the following data fields (selected by user)
		    0 Alarms
            1 Notifications
            2 Battery
            3 HeartRate                        
            4 StepCount
            5 StepCountPercent
            6 Calories
            7 Elevation (ft or meters, dependent on user's watch settings)
            8 Distance (mi or km, dependent on user's watch settings)
            9 DailyActiveMinutes
            10 DailyActiveMinutesPercent (based off a goal of 1/7th the weekly goal)
            11 WeeklyActiveMinutes
            12 WeeklyActiveMinutesPercent
            13 FloorsClimbed
            14 FloorsClimbedPercent
	-	date (format selected by user)
	        0 DayMonDD
            1 DayDDMon
            2 MonDD
			3 DDMon
            4 MM/DD/YYYY
            5 DD/MM/YYYY
	-	time (12 or 24 hour format, dependant on user's watch settings)
	-	color for each data field display, time, date and logo
			0 ColorWhite                        
            1 ColorGray
            2 ColorRed
            3 ColorDarkRed
            4 ColorOrange
            5 ColorYellow
            6 ColorGreen
            7 ColorDarkGreen
            8 ColorBlue
            9 ColorDarkBlue
            10 ColorPurple
            11 ColorPink
	-	bluetooth connection to phone (user selects feature on/off)
			0 Bluetooth Indicator not Present
			1 Bluetooth Indicator Present

created on: Sept. 25, 2017
updated on: Jan. 4, 2018
current version: 2.1.1
created by: 
*/

using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System;
using Toybox.Lang;
using Toybox.Time;
using Toybox.Time.Gregorian as Calendar;
using Toybox.Activity as Act;
using Toybox.ActivityMonitor as Monitor;
using Toybox.Background;

class RunHappyCirclesView extends Ui.WatchFace {
	//user selected data fields to display
	var PROP_FIELDS = new [5];
	var fieldProperties = ["Field1", "Field2", "Field3", "Field4", "Phone"];
	var icons = new [6];
	//user selected colors	
	var PROP_COLORS = new [10];
	var colorProperties = ["Circle1Color", "Circle2Color","Circle3Color", "Circle4Color", "Smile1Color", "Smile2Color", "Smile3Color", "LogoColor", "TimeColor", "DateColor"];
	var colorNum = null;
	//user selected date layout
	var PROP_DATE_FORMAT = 0;
	
	//locations of data fields, icons, time and date
	var bluetoothLocation = new[2];
	var circleXLocations = new [4];
	var circleYLocations = new [4];
	var dateLocation, timeLocation, sweatLocation, happyLocation, SHLocation = new [2];
	var smileXLocations, smileYLocations = new [3];
	//size of each data "bubble"
	var smileRadii = new [3];
	var circleRadius, SHRadius;
	
	//fonts	
	var dateFont = null;
	var timeFont = null;
	var sysFont = null;
	var logoFont = null;
	
    function initialize() {
    	WatchFace.initialize();
    	//initialize property variables (user selections)
    	//default values are notifications, battery life, calories, step count as a percent, bluetooth indicator present
    	//initialize all colors to blue
    	PROP_FIELDS = [ 1, 2, 5, 6, 1];

    	for (var i = 0; i<PROP_COLORS.size(); i++) {
    		PROP_COLORS[i] = Gfx.COLOR_BLUE;
    	}
		//get user selections for display fields, colors and date format  
    	for (var i = 0; i<PROP_FIELDS.size(); i++) {
			PROP_FIELDS[i] = Application.getApp().getProperty(fieldProperties[i]);
    	}
    	
    	for (var i = 0; i<PROP_COLORS.size(); i++) {
    		colorNum = Application.getApp().getProperty(colorProperties[i]);
    		PROP_COLORS[i]  = returnColor(colorNum);
    	}
    	
    	PROP_DATE_FORMAT = Application.getApp().getProperty("DateFormat");
    }
    	
    function onLayout(dc) {
		setLocations(dc);
		loadIcons(dc);	
    }

    function onShow() {	}

    function onUpdate(dc) {
    	//set background to black, and clear
    	dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_BLACK);
    	dc.clear();
		dc.setPenWidth(3);
		
    	//draw the smiley faces
    	for (var j = 0; j<smileXLocations.size(); j++){
			dc.setColor(PROP_COLORS[j+4], Gfx.COLOR_TRANSPARENT);
			dc.drawCircle(smileXLocations[j], smileYLocations[j], smileRadii[j]);
			dc.fillCircle(smileXLocations[j]-.3*smileRadii[j], smileYLocations[j]-.3*smileRadii[j], 2);
			dc.fillCircle(smileXLocations[j]+.3*smileRadii[j], smileYLocations[j]-.3*smileRadii[j], 2);
			dc.drawArc(smileXLocations[j], smileYLocations[j], smileRadii[j]/2, Gfx.ARC_CLOCKWISE, 350, 190);
		}
		
		//draw the "sweat happy" logo
		dc.setColor(PROP_COLORS[7], Gfx.COLOR_TRANSPARENT);
		dc.drawText(sweatLocation[0], sweatLocation[1], logoFont, "sweat", Gfx.TEXT_JUSTIFY_CENTER);
		dc.drawText(happyLocation[0], happyLocation[1], logoFont, "happy", Gfx.TEXT_JUSTIFY_CENTER);
		dc.drawCircle(SHLocation[0], SHLocation[1], SHRadius);
		
		//draw the bluetooth icon
		if (PROP_FIELDS[4] == 1) {
			if (System.getDeviceSettings().phoneConnected == true) {
				dc.drawBitmap(bluetoothLocation[0], bluetoothLocation[1], icons[4]);
			} else {
				dc.drawBitmap(bluetoothLocation[0], bluetoothLocation[1], icons[5]);
			}
		}
		
		//draw the time
		var time = new TimeField(timeLocation[0], timeLocation[1], timeFont, PROP_COLORS[8]);
		time.draw(dc);
		
		//draw the date
		var date = new DateField(dateLocation[0], dateLocation[1], dateFont, PROP_COLORS[9], PROP_DATE_FORMAT);
		date.draw(dc);
		
		//draw data fields, with no default
		for (var i = 0; i<circleXLocations.size(); i++) {
			dc.setColor(PROP_COLORS[i], Gfx.COLOR_TRANSPARENT);
			dc.drawCircle(circleXLocations[i], circleYLocations[i], circleRadius);
			dc.drawBitmap(circleXLocations[i]-7, circleYLocations[i]-24, icons[i]);
			switch (PROP_FIELDS[i]) {
				case 0:
					var alarm = new AlarmField(circleXLocations[i], circleYLocations[i], sysFont, PROP_COLORS[i]);
					alarm.draw(dc);
					break;
				case 1:
					var messages = new MessageField(circleXLocations[i], circleYLocations[i], sysFont, PROP_COLORS[i]);
					messages.draw(dc);
					break;
				case 2:
					var battery = new BatteryField(circleXLocations[i], circleYLocations[i], sysFont, PROP_COLORS[i]);
					battery.draw(dc);
					break;
				case 3:
					var heartRate = new HeartRateField(circleXLocations[i], circleYLocations[i], sysFont, PROP_COLORS[i]);
					heartRate.draw(dc);
					break;
				case 4:
					var steps = new StepsField(circleXLocations[i], circleYLocations[i], sysFont, PROP_COLORS[i]);
					steps.draw(dc);
					break;
				case 5:
					var stepsPer = new StepsField(circleXLocations[i], circleYLocations[i], sysFont, PROP_COLORS[i]);
					stepsPer.drawPercent(dc);
					break;
				case 6:
					var calories = new CaloriesField(circleXLocations[i], circleYLocations[i], sysFont, PROP_COLORS[i]);
					calories.draw(dc);
					break;
				case 7:
					var elevation = new AltitudeField(circleXLocations[i], circleYLocations[i], sysFont, PROP_COLORS[i]);
					elevation.draw(dc);
					break;
				case 8:
					var distance = new DistanceField(circleXLocations[i], circleYLocations[i], sysFont, PROP_COLORS[i]);
					distance.draw(dc);
					break;
				case 9:
					var activeMinDay = new ActiveMinutesField(circleXLocations[i], circleYLocations[i], sysFont, PROP_COLORS[i], 0, 0);
					activeMinDay.draw(dc);
					break;
				case 10:
					var activeMinWeek = new ActiveMinutesField(circleXLocations[i], circleYLocations[i], sysFont, PROP_COLORS[i], 0, 1);
					activeMinWeek.draw(dc);
					break;
				case 11:
					var activeMinDayPer = new ActiveMinutesField(circleXLocations[i], circleYLocations[i], sysFont, PROP_COLORS[i], 1, 0);
					activeMinDayPer.draw(dc);
					break;
				case 12:
					var activeMinWeekPer = new ActiveMinutesField(circleXLocations[i], circleYLocations[i], sysFont, PROP_COLORS[i], 1, 1);
					activeMinWeekPer.draw(dc);
					break;
				case 13:
					var floors = new FloorsClimbedField(circleXLocations[i], circleYLocations[i], sysFont, PROP_COLORS[i]);
					floors.draw(dc);
					break;
				case 14:
					var floorsPercent = new FloorsClimbedField(circleXLocations[i], circleYLocations[i], sysFont, PROP_COLORS[i]);
					floorsPercent.drawPercent(dc);
					break;					
				default:
					break;
			}
		}
    }

    function onHide() {	}

    function onExitSleep() {	}

    function onEnterSleep() {	}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////HELPER FUNCTIONS///////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	/** This function takes the number from user selection and translates to the appropriate color.  
		Only Garmin native colors are included. */    
    
    function returnColor(colorNum) {
    	switch(colorNum) {
    		case 0:
    			return Gfx.COLOR_WHITE;
    			break;
    		case 1:
    			return Gfx.COLOR_LT_GRAY;
    			break;
    		case 2:
    			return Gfx.COLOR_RED;
    			break;
    		case 3:
    			return Gfx.COLOR_DK_RED;
    			break;
    		case 4:
    			return Gfx.COLOR_ORANGE;
    			break;
    		case 5:
    			return Gfx.COLOR_YELLOW;
    			break;
    		case 6:
    			return Gfx.COLOR_GREEN;
    			break;
    		case 7:
    			return Gfx.COLOR_DK_GREEN;
    			break;
    		case 8:
    			return Gfx.COLOR_BLUE;
    			break;
    		case 9:
    			return Gfx.COLOR_DK_BLUE;
    			break;
    		case 10:
    			return Gfx.COLOR_PURPLE;
    			break;
    		case 11:
    			return Gfx.COLOR_PINK;
    			break;
    		default:
    			return Gfx.COLOR_WHITE;
    			break;
		}
	}

	/** This function loads the appropriate icon based upon the user selections.
		Steps and Steps as a percent share an icon.
		Active Minutes Daily, Weekly and as a percent share an icon.
		Floors Complete and as a percent share an icon.
		Default is a transparent icon. */	
	function loadIcons(dc){
	
		icons[icons.size()-2] = Ui.loadResource(Rez.Drawables.PhoneIcon);
		icons[icons.size()-1] = Ui.loadResource(Rez.Drawables.NoPhoneIcon);
		
		for (var i=0; i<icons.size()-2; i++) {//last two for bluetooth icons
			switch (PROP_FIELDS[i]) {
				case 0:
					icons[i] = Ui.loadResource(Rez.Drawables.AlarmIcon);
					break;
				case 1:
					icons[i] = Ui.loadResource(Rez.Drawables.MessageIcon);
					break;
				case 2:
					icons[i] = Ui.loadResource(Rez.Drawables.BatteryIcon);
					break;
				case 3:
					icons[i] = Ui.loadResource(Rez.Drawables.HeartRateIcon);
					break;
				case 4:
				case 5:
					icons[i] = Ui.loadResource(Rez.Drawables.StepsIcon);
					break;
				case 6:
					icons[i] = Ui.loadResource(Rez.Drawables.CaloriesIcon);
					break;
				case 7:
					icons[i] = Ui.loadResource(Rez.Drawables.ElevationIcon);
					break;
				case 8:
					icons[i] = Ui.loadResource(Rez.Drawables.DistanceIcon);
					break;
				case 9:
				case 10:
				case 11:
				case 12:
					icons[i] = Ui.loadResource(Rez.Drawables.MinutesIcon);
					break;
				case 13:
				case 14:
					icons[i] = Ui.loadResource(Rez.Drawables.FloorsIcon);
					break;
				default:
					icons[i] = Ui.loadResource(Rez.Drawables.NullIcon);
					break;
			}
		}
	}
	
	/**This function sets locations and fonts based upon the watch shape and size. */
	
	function setLocations(dc) {
    	circleRadius = 30;
    	SHRadius = 25;
    	timeFont = Ui.loadResource(Rez.Fonts.TB40);
    	dateFont = Ui.loadResource(Rez.Fonts.TB20);
		sysFont = Ui.loadResource(Rez.Fonts.TB20);
		logoFont = Ui.loadResource(Rez.Fonts.TB15);
		
		if (System.getDeviceSettings().screenShape == System.SCREEN_SHAPE_ROUND) {
	    	if (System.getDeviceSettings().screenWidth < 220) {  //SmallRound
	    		circleXLocations = [ 35,  80,  110, 170];//[.1605,.36697,.504587,.77981 ]
    			circleYLocations = [132, 176,  30,  150];//[.6055, .807339,.137614,.68807]
    			timeLocation = [dc.getWidth()/2, 65];//.298165
    			dateLocation = [dc.getWidth()/2, 105];//.4375
    			SHLocation = [165, 48];
    			smileXLocations = [58, 119, 130];
    			smileYLocations = [40, 145, 185];
    			smileRadii = [20, 15, 20];
    			bluetoothLocation = [20, 50];
	    	} else {						//largeRound
	    		circleXLocations = [ 42,  90,  115, 193];//[.175, .375, .479166, .80416]
    			circleYLocations = [155, 200,  35,  165];//[.64, .8333, .14583, .6875]
    			circleRadius = 31;
    			timeLocation = [dc.getWidth()/2, 73];//.304
    			dateLocation = [dc.getWidth()/2, 127];//.54166
    			SHLocation = [179, 53];
    			SHRadius = 25;
    			smileXLocations = [58, 130, 149];
    			smileYLocations = [50, 165, 205];
    			smileRadii = [22, 15, 25];
    			timeFont = Ui.loadResource(Rez.Fonts.TB60);
    			bluetoothLocation = [15, 60];
    		}
		} else if (System.getDeviceSettings().screenShape == System.SCREEN_SHAPE_RECTANGLE) {
    		if (System.getDeviceSettings().screenWidth > System.getDeviceSettings().screenHeight) {  //longRectangle
    			circleXLocations = [32,  35,  94, 170];
    			circleYLocations = [40, 113,  31,  117];
    			timeLocation = [dc.getWidth()/2, 65];
    			dateLocation = [dc.getWidth()/2, 90];
    			SHLocation = [175, 57];
    			smileXLocations = [85, 121, 142];
    			smileYLocations = [130, 125, 27];
    			smileRadii = [17, 14, 15];
    			timeFont = Ui.loadResource(Rez.Fonts.TB30);
    			bluetoothLocation = [125, 48];
     		} else {										//tallRectangle
     			circleXLocations = [ 30, 34, 113, 117];
    			circleYLocations = [174, 90, 95, 170];
    			dateLocation = [dc.getWidth()/2, 40];
    			timeLocation = [dc.getWidth()/2, 5];
    			SHLocation = [72, 135];
    			smileXLocations = [15, 74, 133];
    			smileYLocations = [132, 190, 50];
    			smileRadii = [12, 14, 13];
    			bluetoothLocation = [65, 65];
    		}
    	} else {					//semiRound
	   		    circleXLocations = [ 45,  105,  110, 165];
    			circleYLocations = [132, 150,  30,  141];
    			timeLocation = [dc.getWidth()/2, 63];
    			dateLocation = [dc.getWidth()/2+1, 100];
    			SHLocation = [165, 48];
    			smileXLocations = [21, 53, 192];
    			smileYLocations = [88, 37, 92];
    			smileRadii = [17, 25, 18];
    			bluetoothLocation = [12, 49];
    	}
    	sweatLocation = [SHLocation[0], SHLocation[1]-20];
    	happyLocation = [SHLocation[0], SHLocation[1]];
    }
     
}