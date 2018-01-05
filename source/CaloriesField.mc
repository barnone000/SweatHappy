/**	The following class will calculate and display the user's total calories burned for the day.  The following are parameter options:
	-	X and Y locations on user screen of type INTEGER
	-	display font of type FONT
	-	display color of type COLOR
*/


using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Lang as Lang;
using Toybox.Application as App;
using Toybox.Time.Gregorian as Calendar;
using Toybox.ActivityMonitor as ActMon;
using Toybox.Activity as Act;

class CaloriesField extends Ui.Drawable {

	var cals;
	var calsX;
	var calsY;
	var calsFont;
	var calsColor;
	
	function initialize(pcalsX, pcalsY, pcalsFont, pcalsColor) {
		Ui.Drawable.initialize({:locX => 0, :locY => 0});
		cals = 0;
		calsX = pcalsX;
		calsY = pcalsY;
		calsFont = pcalsFont;
		calsColor = pcalsColor;
	}
	
	function draw(dc) {
		cals = ActMon.getInfo().calories;
		dc.setColor(calsColor, Gfx.COLOR_TRANSPARENT);
		if (cals != null) {
			dc.drawText(calsX, calsY, calsFont, cals.toString(), Gfx.TEXT_JUSTIFY_CENTER);
		} else {
			dc.drawText(calsX, calsY, calsFont, "---", Gfx.TEXT_JUSTIFY_CENTER);
		}
	}
}