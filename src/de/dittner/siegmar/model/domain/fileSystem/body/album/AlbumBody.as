package de.dittner.siegmar.model.domain.fileSystem.body.album {
import de.dittner.siegmar.model.domain.fileSystem.body.FileBody;

import de.dittner.async.AsyncOperation;
import de.dittner.async.IAsyncOperation;

import flash.display.BitmapData;
import flash.events.Event;
import flash.utils.ByteArray;

import mx.collections.ArrayCollection;

public class AlbumBody extends FileBody {
	public function AlbumBody() {
		super();
	}

	//--------------------------------------
	//  photoColl
	//--------------------------------------
	private var _photoColl:ArrayCollection = new ArrayCollection();
	[Bindable("photoCollChanged")]
	public function get photoColl():ArrayCollection {return _photoColl;}
	private function setPhotoColl(value:ArrayCollection):void {
		if (_photoColl != value) {
			_photoColl = value;
			dispatchEvent(new Event("photoCollChanged"));
		}
	}

	public function addPhoto(bitmap:BitmapData, title:String):IAsyncOperation {
		var op:IAsyncOperation = fileStorage.storePhoto(bitmap, title, fileID);
		op.addCompleteCallback(addPhotoComplete);
		return op;
	}

	private function addPhotoComplete(op:IAsyncOperation):void {
		if (op.isSuccess) {
			photoColl.addItem(op.result);
		}
	}

	public function updatePhoto(id:int, bitmap:BitmapData, title:String):IAsyncOperation {
		for each(var info:Object in photoColl) {
			if (info.id == id) {
				info.title = title;
				break;
			}
		}
		return fileStorage.updatePhoto(id, bitmap, title, fileID);
	}

	public function removePhoto(id:int):IAsyncOperation {
		for (var i:int = 0; i < photoColl.length; i++) {
			var info:Object = photoColl[i];
			if (info.id == id) {
				photoColl.removeItemAt(i);
				break;
			}
		}
		return fileStorage.removePhoto(id);
	}

	private var loadPhotoCollOp:IAsyncOperation;
	public function loadPhotoColl():IAsyncOperation {
		var op:IAsyncOperation;

		if (!loadPhotoCollOp) {
			loadPhotoCollOp = new AsyncOperation();
			op = fileStorage.loadPhotosInfo(fileID);
			op.addCompleteCallback(photosInfoLoaded);
			return loadPhotoCollOp;
		}
		else if (loadPhotoCollOp.isProcessing) {
			return loadPhotoCollOp;
		}
		else {
			op = new AsyncOperation();
			op.dispatchSuccess(photoColl);
			return op;
		}
	}

	private function photosInfoLoaded(op:IAsyncOperation):void {
		if (op.isSuccess) {
			setPhotoColl(new ArrayCollection(op.result));
			loadPhotoCollOp.dispatchSuccess(photoColl);
		}
		else {
			loadPhotoCollOp.dispatchError();
			loadPhotoCollOp = null;
		}
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
