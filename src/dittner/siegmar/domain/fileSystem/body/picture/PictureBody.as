package dittner.siegmar.domain.fileSystem.body.picture {
import dittner.siegmar.domain.fileSystem.body.*;
import dittner.siegmar.domain.fileSystem.body.picture.action.PaintingAction;

import flash.display.BitmapData;
import flash.geom.Matrix;
import flash.geom.Rectangle;
import flash.utils.ByteArray;

public class PictureBody extends FileBody {
	public function PictureBody() {
		super();
	}

	//--------------------------------------
	//  image
	//--------------------------------------
	private var _image:BitmapData;
	public function get image():BitmapData {return _image;}
	public function set image(value:BitmapData):void {
		if (_image != value) {
			_image = value;
			adjustBgSize();
			store();
		}
	}

	//--------------------------------------
	//  bg
	//--------------------------------------
	private var _bg:BitmapData;
	[Bindable("bgChanged")]
	public function get bg():BitmapData {return _bg;}
	public function set bg(value:BitmapData):void {
		if (_bg != value) {
			_bg = value;
			adjustBgSize();
			store();
		}
	}

	private function adjustBgSize():void {
		if (image && bg && (image.width != bg.width || image.height != bg.height)) {
			var mtr:Matrix = new Matrix();
			mtr.scale(image.width / bg.width, image.height / bg.height);
			var scaledBG:BitmapData = new BitmapData(image.width, image.height, true, 0);
			scaledBG.draw(bg, mtr);
			bg.dispose();
			_bg = scaledBG;
		}
	}

	//--------------------------------------
	//  actions
	//--------------------------------------
	private var _actions:Array = [];
	public function get actions():Array {return _actions;}
	public function set actions(value:Array):void {
		if (_actions != value) {
			_actions = value;
			store();
		}
	}

	//--------------------------------------
	//  encryptEnabled
	//--------------------------------------
	override public function get encryptEnabled():Boolean {return false;}

	//----------------------------------------------------------------------------------------------
	//
	//  Methods
	//
	//----------------------------------------------------------------------------------------------

	override public function serialize():ByteArray {
		var byteArray:ByteArray = new ByteArray();
		encodeBitmapTo(byteArray, image);
		encodeBitmapTo(byteArray, bg);
		byteArray.writeObject(actions);

		byteArray.position = 0;
		byteArray.compress();
		return byteArray;
	}

	override public function deserialize(ba:ByteArray):void {
		ba.position = 0;
		ba.uncompress();
		_image = decodeBitmapFrom(ba);
		_bg = decodeBitmapFrom(ba);
		_actions = ba.readObject() as Array || [];
	}

	public static function encodeBitmapTo(bytes:ByteArray, bd:BitmapData):void {
		if (bd) {
			var imageBytes:ByteArray = new ByteArray();
			imageBytes.writeBytes(bd.getPixels(new Rectangle(0, 0, bd.width, bd.height)));
			imageBytes.position = 0;

			bytes.writeDouble(imageBytes.length);
			bytes.writeBytes(imageBytes);
			bytes.writeUnsignedInt(bd.width);
			bytes.writeUnsignedInt(bd.height);
			bytes.writeBoolean(bd.transparent);
		}
		else {
			bytes.writeDouble(0);
		}
	}

	public function decodeBitmapFrom(bytes:ByteArray):BitmapData {
		var bd:BitmapData;
		var imageSize:uint = bytes.readDouble();
		if (imageSize != 0) {
			var imageBytes:ByteArray = new ByteArray();
			bytes.readBytes(imageBytes, 0, imageSize);
			imageBytes.position = 0;
			var width:uint = bytes.readUnsignedInt();
			var height:uint = bytes.readUnsignedInt();
			var transparent:Boolean = bytes.readBoolean();

			bd = new BitmapData(width, height, transparent);
			bd.setPixels(new Rectangle(0, 0, width, height), imageBytes);
		}

		return bd;
	}

	public function render():BitmapData {
		if (!image) return null;
		var res:BitmapData = image.clone();
		for each(var action:PaintingAction in actions)
			res = action.exec(res, bg);
		return res;
	}
}
}
