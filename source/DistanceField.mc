/**	This class will calcuate and display the distance moved for the day.  The parameter list includes the options:
	-	X and Y location on the screen of type INTEGER
	-	display color of type COLOR
	-	display font of type FONT
	The distance will be in miles or kilometers(and appended with "m" or "k"), based upon the user's watch settings.  
*/


using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Lang as Lang;
using Toybox.Application as App;
using Toybox.Time.Gregorian as Calendar;
using Toybox.ActivityMonitor as ActMon;
using Toybox.Activity as Act;

class DistanceField extends Ui.Drawable {

	var dist;
	var distX;
	var distY;
	var distColor;
	var distFont;
	var distString;
	var distLabel;

	function initialize(pdistX, pdistY, pdistFont, pdistColor) {
		Ui.Drawable.initialize({:locX => 0, :locY => 0});
		dist = 0;
		distX = pdistX;
		distY = pdistY;
		distColor = pdistColor;
		distFont = pdistFont;
		distString = "";
		distLabel = "m";
	}
	
	function draw(dc) {
		dist = ActMon.getInfo().distance;
		if(dist != null) {
			if (System.getDeviceSettings().distanceUnits == 0) {
				distLabel = "k";
				dist = dist.toFloat()/100000.0;
			} else {
				distLabel = "m";
				dist = dist.toFloat()*.000006213712;
			}
			dc.drawText(distX, distY, distFont, dist.format("%.2f").toString() + distLabel, Gfx.TEXT_JUSTIFY_CENTER);
		} else {
			dc.drawText(distX, distY, distFont, "--", Gfx.TEXT_JUSTIFY_CENTER);
		}
	}
}
			