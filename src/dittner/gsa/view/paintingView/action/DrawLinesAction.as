package dittner.gsa.view.paintingView.action {
import flash.display.BitmapData;
import flash.geom.Point;
import flash.geom.Rectangle;

[RemoteClass(alias="dittner.gsa.view.paintingView.action.DrawLinesAction")]
public class DrawLinesAction extends PaintingAction {
	public function DrawLinesAction() {
		super();
	}

	override public function get key():String {return DRAW_LINES;}

	public var lineWeight:uint = 1;
	public var lineStep:uint = 1;
	public var isVerticalPos:Boolean = false;

	override public function exec(src:BitmapData, bg:BitmapData):BitmapData {
		var res:BitmapData = src;
		var srcImage:BitmapData = useBg && bg ? bg : new BitmapData(src.width, src.height, true, bgColorEnabled ? 0xff000000 + bgColor : 0);
		var lineRect:Rectangle;
		var destPos:Point;
		var i:int;

		if (isVerticalPos) {
			lineRect = new Rectangle(0, 0, lineWeight, src.height);
			destPos = new Point(0, 0);
			for (i = 0; i < src.width; i += 2 * lineStep) {
				lineRect.x = i;
				destPos.x = i;
				res.copyPixels(srcImage, lineRect, destPos);
			}
		}
		else {
			lineRect = new Rectangle(0, 0, src.width, lineWeight);
			destPos = new Point(0, 0);
			for (i = 0; i < src.height; i += 2 * lineStep) {
				lineRect.y = i;
				destPos.y = i;
				res.copyPixels(srcImage, lineRect, destPos);
			}
		}

		if (srcImage != bg) srcImage.dispose();
		return res;
	}
}
}
