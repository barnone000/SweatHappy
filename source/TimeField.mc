/** This class calculates and displays the time.
	The date will be formated in accordance with the user's watch settings: military(24hr) or am/pm(12hr) format.
	Options given in the parameter list are:
	-	font (timeFont) Gfx. constant or custom font from resources FONT
	-	color (timeColor) Gfx. constant or custom color from resources COLOR
	-	location on screen (timeX and timeY) INTEGER
*/

using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Lang as Lang;
using Toybox.Application as App;
using Toybox.Time.Gregorian as Calendar;
using Toybox.ActivityMonitor as ActMon;
using Toybox.Activity as Act;

class TimeField extends Ui.Drawable {

	var time = null;
	var timeString = null;
	
	var timeFont = null;
	var timeColor = null;
	var timeX = null;
	var timeY = null;
	
	function initialize(ptimeX, ptimeY, pfont, pcolor) {
		Ui.Drawable.initialize({:locX => 0, :locY => 0});
		time = null;
		timeString = null;
		timeFont = pfont;
		timeColor = pcolor;
		timeX = ptimeX;
		timeY = ptimeY;
	}
	
	function draw(dc) {
		time = Calendar.info(Time.now(), Time.FORMAT_SHORT);
		if (!System.getDeviceSettings().is24Hour) {
			if (time.hour < 12) {
				timeString = Lang.format("$1$:$2$ $3$", [time.hour, time.min.format("%02d"), "am"]);
			} else if (time.hour == 12) {
				timeString = Lang.format("$1$:$2$ $3$", [time.hour, time.min.format("%02d"), "pm"]);
			} else {
				timeString = Lang.format("$1$:$2$ $3$", [(time.hour-12), time.min.format("%02d"), "pm"]);
			}
		} else {
			timeString = Lang.format("$1$:$2$", [time.hour, time.min.format("%02d")]);
		}
		
		dc.setColor(timeColor, Gfx.COLOR_TRANSPARENT);
		dc.drawText(timeX, timeY, timeFont, timeString, Gfx.TEXT_JUSTIFY_CENTER);
	}
}