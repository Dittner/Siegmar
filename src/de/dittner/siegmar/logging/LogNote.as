package de.dittner.siegmar.logging {
public class LogNote {
	public function LogNote() {}

	public var logType:uint = LogType.INFO;
	public var time:String = "";
	public var category:String = "";
	public var text:String = "";
	public var symbol:String = "";

	public function toString():String {
		return symbol + "# " + time + " [" + category + "] " + text + "\n";
	}

	public function toHtmlString():String {
		return '<font color = "#9fa4cc">' + time + " [" + category + "] " + "</font>" + '<font color = "# ' + getColor(logType).toString(16) + '">' + text + "</font>";
	}

	private function getColor(logNoteType:uint):uint {
		switch (logNoteType) {
			case LogType.INFO:
				return 0xc3fffa;
			case LogType.WARN:
				return 0xebea8a;
			case LogType.ERROR:
				return 0xf09ab3;
			default :
				return 0xffFFff;
		}
	}
}
}
