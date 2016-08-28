package de.dittner.siegmar.model.domain.fileSystem.body.picture.action {
import flash.display.BitmapData;

[RemoteClass(alias="dittner.siegmar.domain.fileSystem.body.picture.action.PaintingAction")]
public class PaintingAction {
	public static const LINES_DISPLACEMENT:String = "LINES_DISPLACEMENT";
	public static const DRAW_LINES:String = "DRAW_LINES";
	public static const ALL:Array = [LINES_DISPLACEMENT, DRAW_LINES];
	public static function keyToName(key:String):String {
		switch (key) {
			case LINES_DISPLACEMENT :
				return "Die Linien verschieben";
			case DRAW_LINES :
				return "Die Linien zeichnen";
			default :
				return key;
		}
	}

	public function PaintingAction() {
		super();
	}

	public var useBg:Boolean = false;
	public var bgColor:uint = 0;
	public var bgColorEnabled:Boolean = true;

	public function get key():String {return "";}

	public function exec(src:BitmapData, bg:BitmapData):BitmapData {
		throw new Error("Abstract method must be override!");
	}
}
}
