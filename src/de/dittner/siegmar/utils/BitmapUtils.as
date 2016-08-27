package de.dittner.siegmar.utils {
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.geom.Matrix;

public class BitmapUtils {
	public function BitmapUtils() {}

	public static function scaleToSize(src:BitmapData, size:int):BitmapData {
		var sc:Number = 175 / Math.max(src.width, src.height);
		var res:BitmapData = new BitmapData(src.width * sc, src.height * sc, false, 0xffFFff);
		var bitmap:Bitmap = new Bitmap(src);
		var m:Matrix = new Matrix();
		m.scale(sc, sc);
		res.draw(bitmap, m, null, null, null, true);
		return res;
	}
}
}
