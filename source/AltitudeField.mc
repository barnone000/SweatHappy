/**	This class displays the user's current altitude.  The parameter list includes:
	-	X and Y location INTEGER
	-	display color, of type COLOR
	-	display font, of type FONT
	
	The altitude will be displayed in meters or feet (with "m" or "ft" label) depending on user's watch settings.
*/	


using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Lang as Lang;
using Toybox.Application as App;
using Toybox.Time.Gregorian as Calendar;
using Toybox.ActivityMonitor as ActMon;
using Toybox.Activity as Act;

class AltitudeField extends Ui.Drawable {

	var alt;
	var altX;
	var altY;
	var altColor;
	var altFont;
	var altLabel;

	function initialize(paltX, paltY, paltFont, paltColor) {
		Ui.Drawable.initialize({:locX => 0, :locY => 0});
		alt = 0;
		altX = paltX;
		altY = paltY;
		altColor = paltColor;
		altFont = paltFont;
		altLabel = "m";
	}
	
	function draw(dc) {
		alt = Activity.getActivityInfo().altitude;
		dc.setColor(altColor, Gfx.COLOR_TRANSPARENT);
		if (alt != null) {
			if (System.getDeviceSettings().elevationUnits == 1) {
				alt = alt * 3.28;
				altLabel = "ft";
			}
			dc.drawText(altX, altY, altFont, alt.toNumber().toString() + altLabel, Gfx.TEXT_JUSTIFY_CENTER);
		} else {
			dc.drawText(altX, altY, altFont, "--", Gfx.TEXT_JUSTIFY_CENTER);
		}				
	}
}
