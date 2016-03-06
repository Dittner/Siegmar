package dittner.siegmar.domain.fileSystem.body.album {
import dittner.async.AsyncOperation;
import dittner.async.IAsyncOperation;
import dittner.siegmar.domain.fileSystem.body.*;

import flash.display.BitmapData;
import flash.utils.ByteArray;

public class AlbumBody extends FileBody {
	public function AlbumBody() {
		super();
	}

	private var photosInfo:Array;

	public function addPhoto(bitmap:BitmapData, title:String):IAsyncOperation {
		var op:IAsyncOperation = fileStorage.storePhoto(bitmap, title, fileID);
		op.addCompleteCallback(addPhotoComplete);
		return op;
	}

	private function addPhotoComplete(op:IAsyncOperation):void {
		if (photosInfo && op.isSuccess) {
			photosInfo.push(op.result);
		}
	}

	public function updatePhoto(id:int, bitmap:BitmapData, title:String):IAsyncOperation {
		if (photosInfo) {
			for each(var info:Object in photosInfo) {
				if (info.id == id) {
					info.title = title;
					break;
				}
			}
		}
		return fileStorage.updatePhoto(id, bitmap, title, fileID);
	}

	public function removePhoto(id:int):IAsyncOperation {
		if (photosInfo) {
			for (var i:int = 0; i < photosInfo.length; i++) {
				var info:Object = photosInfo[i];
				if (info.id == id) {
					photosInfo.splice(i, 1);
					break;
				}
			}
		}
		return fileStorage.removePhoto(id);
	}

	public function loadPhotosInfo():IAsyncOperation {
		var op:IAsyncOperation;
		if (photosInfo) {
			op = new AsyncOperation();
			op.dispatchSuccess(photosInfo);
		}
		else {
			op = fileStorage.loadPhotosInfo(fileID);
			op.addCompleteCallback(photosInfoLoaded);
		}
		return op;
	}

	private function photosInfoLoaded(op:IAsyncOperation):void {
		if (op.isSuccess) photosInfo = op.result;
	}

	public function loadPhoto(id:int):IAsyncOperation {
		return fileStorage.loadPhotoBitmap(id);
	}

	public function loadPreview(id:int):IAsyncOperation {
		return fileStorage.loadPhotoPreview(id);
	}

	//----------------------------------------------------------------------------------------------
	//
	//  Methods
	//
	//----------------------------------------------------------------------------------------------

	override public function serialize():ByteArray {
		return null;
	}

	override public function deserialize(ba:ByteArray):void {}

}
}
