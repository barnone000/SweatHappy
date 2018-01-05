/** This class displays the number of alarms set on the user's watch.  The following are the options from the parameter list:

	-	location on user screen (actMinX and actMinY) INTEGER
	-	color of the active minutes (actMinColor), a Gfx. constant or custom color from resources COLOR
	-	font of the active minutes (actMinFont), a Gfx. constant or custom font from resources FONT
*/

using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Lang as Lang;
using Toybox.Application as App;
using Toybox.Time.Gregorian as Calendar;
using Toybox.ActivityMonitor as ActMon;
using Toybox.Activity as Act;

class AlarmField extends Ui.Drawable {

	var alm;
	var almX;
	var almY;
	var almColor;
	var almFont;
	
	function initialize(palmX, palmY, palmFont, palmColor) {
		Ui.Drawable.initialize({:locX => 0, :locY => 0});
		alm = 0;
		almX = palmX;
		almY = palmY;
		almColor = palmColor;
		almFont = palmFont;
	}
	
	function draw(dc) {
		alm = System.getDeviceSettings().alarmCount;
		dc.setColor(almColor, Gfx.COLOR_TRANSPARENT);
		dc.drawText(almX, almY, almFont, alm.toString(), Gfx.TEXT_JUSTIFY_CENTER);
	}
}