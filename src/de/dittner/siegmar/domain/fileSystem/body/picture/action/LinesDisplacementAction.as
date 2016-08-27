package de.dittner.siegmar.domain.fileSystem.body.picture.action {
import flash.display.BitmapData;
import flash.geom.Point;
import flash.geom.Rectangle;

[RemoteClass(alias="dittner.siegmar.domain.fileSystem.body.picture.action.LinesDisplacementAction")]
public class LinesDisplacementAction extends PaintingAction {
	public function LinesDisplacementAction() {
		super();
	}

	override public function get key():String {return LINES_DISPLACEMENT;}

	public var lineWeight:uint = 5;
	public var linesNum:uint = 100;
	public var maxLineLength:uint = 50;
	public var maxDisplacement:uint = 20;
	public var isBgEnabled:Boolean = true;
	public var isVerticalPos:Boolean = false;

	override public function exec(src:BitmapData, bg:BitmapData):BitmapData {
		var res:BitmapData = src.clone();
		var srcImage:BitmapData = useBg && bg ? bg : new BitmapData(src.width, src.height, true, bgColorEnabled ? 0xff000000 + bgColor : 0);
		var lineRect:Rectangle = new Rectangle();
		var destPos:Point = new Point();
		var i:int;

		if (isVerticalPos) {
			lineRect.width = lineWeight;
			for (i = 0; i < linesNum; i++) {
				lineRect.x = Math.floor(Math.random() * (res.width - lineWeight));
				lineRect.height = lineWeight * Math.floor(1 + Math.random() * (maxLineLength - 1));
				lineRect.y = Math.abs(Math.floor(Math.random() * (res.height - lineRect.height)));
				destPos.x = lineRect.x;
				destPos.y = lineRect.y;
				if (isBgEnabled) res.copyPixels(srcImage, lineRect, destPos);
				destPos.y += Math.floor(Math.random() * 2 * maxDisplacement - maxDisplacement);
				res.copyPixels(src, lineRect, destPos);
			}
		}
		else {
			lineRect.height = lineWeight;
			for (i = 0; i < linesNum; i++) {
				lineRect.y = Math.floor(Math.random() * (res.height - lineWeight));
				lineRect.width = lineWeight * Math.floor(1 + Math.random() * (maxLineLength - 1));
				lineRect.x = Math.abs(Math.floor(Math.random() * (res.height - lineRect.height)));
				destPos.x = lineRect.x;
				destPos.y = lineRect.y;
				if (isBgEnabled) res.copyPixels(srcImage, lineRect, destPos);
				destPos.x += Math.floor(Math.random() * 2 * maxDisplacement - maxDisplacement);
				res.copyPixels(src, lineRect, destPos);
			}
		}

		src.dispose();
		if (srcImage != bg) srcImage.dispose();
		return res;
	}
}
}
