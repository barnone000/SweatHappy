/**This class gets and displays the user's message notifications.  The parameter list includes the following options:
-	X and Y display location of type INTEGER
-	display color of type COLOR
-	display font of type FONT
*/
using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Lang as Lang;
using Toybox.Application as App;
using Toybox.Time.Gregorian as Calendar;
using Toybox.ActivityMonitor as ActMon;
using Toybox.Activity as Act;

class MessageField extends Ui.Drawable {

	var messages;
	var messagesX;
	var messagesY;
	var messagesColor;
	var messagesFont;

	function initialize(pmessagesX, pmessagesY, pmessagesFont, pmessagesColor) {
		Ui.Drawable.initialize({:locX => 0, :locY => 0});
		messages = 0;
		messagesX = pmessagesX;
		messagesY = pmessagesY;
		messagesColor = pmessagesColor;
		messagesFont = pmessagesFont;
	}
	
	function draw(dc) {
		messages = System.getDeviceSettings().notificationCount;
		dc.setColor(messagesColor, Gfx.COLOR_TRANSPARENT);
		dc.drawText(messagesX, messagesY, messagesFont, messages.toString(), Gfx.TEXT_JUSTIFY_CENTER);
	}
}