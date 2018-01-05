/** This class will get and display the number of floors climbed for the day.  The parameter list includes options for:
-	X and Y locations on the screen of type INTEGER
-	display color of type COLOR
-	display font of type FONT
The floors climbed can be displayed as the number of floors climbed, or as a percentage of the user's daily floors climbed goal.
*/

using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Lang as Lang;
using Toybox.Application as App;
using Toybox.Time.Gregorian as Calendar;
using Toybox.ActivityMonitor as ActMon;
using Toybox.Activity as Act;

class FloorsClimbedField extends Ui.Drawable {

	var floors;
	var floorGoal;
	var floorPercent;
	var floorsX;
	var floorsY;
	var floorsColor;
	var floorsFont;
	
	function initialize(pfloorsX, pfloorsY, pfloorsFont, pfloorsColor) {
		Ui.Drawable.initialize({:locX => 0, :locY => 0});
		floors = 0;
		floorGoal = 0;
		floorPercent = 0;
		floorsX = pfloorsX;
		floorsY = pfloorsY;
		floorsColor = pfloorsColor;
		floorsFont = pfloorsFont;
	}
	
	function draw(dc) {
		floors = ActMon.getInfo().floorsClimbed;
		dc.setColor(floorsColor, Gfx.COLOR_TRANSPARENT);
		dc.drawText(floorsX, floorsY, floorsFont, floors.toString(), Gfx.TEXT_JUSTIFY_CENTER);
	}
	
	function drawPercent(dc) {
		floors = ActMon.getInfo().floorsClimbed;
		floorGoal = ActMon.getInfo().floorsClimbedGoal;
		if (floorGoal > 0) {
			floorPercent = (floors.toDouble()/floorGoal.toDouble()) * 100;
		}
		dc.setColor(floorsColor, Gfx.COLOR_TRANSPARENT);
		dc.drawText(floorsX, floorsY, floorsFont, floorPercent.toNumber().toString()+"%", Gfx.TEXT_JUSTIFY_CENTER);	
	}
}