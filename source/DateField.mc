/**  This class calculates and displays the date.  
Options  in parameter list include:
	-	x and y location on the screen (dateX, dateY) INTEGER
	-	color (dateColor) either Gfx.constant or custom color from resources COLOR
	-	font (dateFont) either Gfx. constant or custom font from resources FONT
	-	format options (dateFormat) INTEGER
(default)	0: Day, Mon #D (Mon, Jan 21)
			1: Day, #D Mon (Mon, 21 Jan)
			2: Mon d# (Jan 21)
			3: d# Mon (21 Jan)
			4: M#/D#/Y### (1/21/2018)
			5: D#/M#/Y### (21/1/2018)	
*/


using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Lang as Lang;
using Toybox.Application as App;
using Toybox.Time.Gregorian as Calendar;
using Toybox.ActivityMonitor as ActMon;
using Toybox.Activity as Act;

class DateField extends Ui.Drawable {

	var date = null;
	var dateString = null;
	
	var dateFont = null;
	var dateColor = null;
	var dateFormat = null;
	var dateX = null;
	var dateY = null;
	
	function initialize(pdateX, pdateY, pdateFont, pdateColor, pdateFormat) {
		Ui.Drawable.initialize({:locX => 0, :locY => 0});
		date = null;
		dateString = null;
		dateFont = pdateFont;
		dateColor = pdateColor;
		dateFormat = pdateFormat;
		dateX = pdateX;
		dateY = pdateY;
	}
	
	function draw(dc) {
		switch(dateFormat) {
				case 1:
					date = Calendar.info(Time.now(), Time.FORMAT_MEDIUM);
					dateString = Lang.format("$1$, $2$ $3$",[date.day_of_week, date.day, date.month]);
					break;
				case 2:
					date = Calendar.info(Time.now(), Time.FORMAT_MEDIUM);
					dateString = Lang.format("$1$ $2$",[date.month, date.day]);
					break;
				case 3:
					date = Calendar.info(Time.now(), Time.FORMAT_MEDIUM);
					dateString = Lang.format("$1$ $2$",[date.day, date.month]);
					break;
				case 4:
					date = Calendar.info(Time.now(), Time.FORMAT_SHORT);
					dateString = Lang.format("$1$/$2$/$3$",[date.month, date.day, date.year]);
					break;
				case 5:
					date = Calendar.info(Time.now(), Time.FORMAT_SHORT);
					dateString = Lang.format("$1$/$2$/$3$",[date.day, date.month, date.year]);
					break;
				case 0:
				default:
					date = Calendar.info(Time.now(), Time.FORMAT_MEDIUM);
					dateString = Lang.format("$1$, $2$ $3$",[date.day_of_week, date.month, date.day]);
					break;
			}

		dc.setColor(dateColor, Gfx.COLOR_TRANSPARENT);
		dc.drawText(dateX, dateY, dateFont,  dateString, Gfx.TEXT_JUSTIFY_CENTER);
	}
}