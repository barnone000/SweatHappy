/** This class gets and displays the user's daily step count.  The parameter list includes options for:
	-	X and Y display location of type INTEGER
	-	display color of type COLOR
	-	display font of type FONT
	
	The steps can be displayed as steps or as a percent of step goal.	
*/

using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Lang as Lang;
using Toybox.Application as App;
using Toybox.Time.Gregorian as Calendar;
using Toybox.ActivityMonitor as ActMon;
using Toybox.Activity as Act;

class StepsField extends Ui.Drawable {

	var steps = null;
	var stepPercent = null;
	var stepFont = null;
	var stepColor = null;
	var stepX = null;
	var stepY = null;


	function initialize(pstepX, pstepY, pfont, pcolor) {
		Ui.Drawable.initialize({:locX => 0, :locY => 0});
		steps = 0;
		stepPercent = 0;
		stepFont = pfont;
		stepColor = pcolor;
		stepX = pstepX;
		stepY = pstepY;		
	}
	
	function draw(dc) {
		steps = ActMon.getInfo().steps;
		dc.setColor(stepColor, Gfx.COLOR_TRANSPARENT);
		dc.drawText(stepX, stepY, stepFont, steps.toString(), Gfx.TEXT_JUSTIFY_CENTER);
	}
	
	function drawPercent(dc) {
		if (ActMon.getInfo().stepGoal > 0) {
			stepPercent = ((ActMon.getInfo().steps.toDouble()/ActMon.getInfo().stepGoal.toDouble())*100).toNumber();
			dc.setColor(stepColor, Gfx.COLOR_TRANSPARENT);
			dc.drawText(stepX, stepY, stepFont, stepPercent.toString()+"%", Gfx.TEXT_JUSTIFY_CENTER);
		} else {
			dc.drawText(stepX, stepY, stepFont, "--%", Gfx.TEXT_JUSTIFY_CENTER);
		}
	}
		

}