/** This class will display the user's watch's remaining battery life.  The parameter list includes options for
	-	X and Y locations of type INTEGER
	-	display font of type FONT
	-	display color of type COLOR
	The battery life is displayed in the following colors, with a "%" appended:
	-	RED when < 10
	-	YELLOW when > 10 and < 20
	-	parameter color when >20
*/


using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Lang as Lang;
using Toybox.Application as App;
using Toybox.Time.Gregorian as Calendar;
using Toybox.ActivityMonitor as ActMon;
using Toybox.Activity as Act;

class BatteryField extends Ui.Drawable {

	var batLife;
	var batX;
	var batY;
	var batFont;
	var batColor;

	function initialize(pbatX, pbatY, pbatFont, pbatColor) {
		Ui.Drawable.initialize({:locX => 0, :locY => 0});
		batLife = 0;
		batX = pbatX;
		batY = pbatY;
		batFont = pbatFont;
		batColor = pbatColor;
	}
	
	function draw(dc) {
		batLife = System.getSystemStats().battery;
		if (batLife > 20) {
			dc.setColor(batColor, Gfx.COLOR_TRANSPARENT);
		} else if (batLife > 10) {
			dc.setColor(Gfx.COLOR_YELLOW, Gfx.COLOR_TRANSPARENT);
		} else {
			dc.setColor(Gfx.COLOR_RED, Gfx.COLOR_TRANSPARENT);
		}
		dc.drawText(batX, batY, batFont, batLife.toNumber().toString() +"%", Gfx.TEXT_JUSTIFY_CENTER);
	}
}