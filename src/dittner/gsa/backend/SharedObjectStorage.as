package dittner.gsa.backend {
import flash.events.AsyncErrorEvent;
import flash.net.SharedObject;

public class SharedObjectStorage {
	public function SharedObjectStorage() {}

	protected const STORAGE_PREF:String = "storage-";

	protected var sharedObject:SharedObject;

	//--------------------------------------
	//  storageId
	//--------------------------------------
	private var _storageId:String = "";
	public function get storageId():String {return _storageId;}

	public function init(storageId:String):void {
		if (sharedObject) throw new Error("Already initialized!");
		_storageId = storageId;
		try {
			sharedObject = SharedObject.getLocal(STORAGE_PREF + storageId);
			sharedObject.addEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);
		}
		catch (error:Error) {
			trace("Error creating shared object:" + error.message);
		}
	}

	private function asyncErrorHandler(event:AsyncErrorEvent):void {
		trace("Async error:" + event.error.message);
	}

	public function dispose():void {
		if (sharedObject) {
			try {
				sharedObject.close();
				sharedObject = null;
			}
			catch (error:Error) {
				trace("Error closing shared object:" + error.message);
			}
		}
	}

	public function getField(key:String):* {
		return sharedObject ? sharedObject.data[key] : null;
	}

	public function writeField(key:String, value:*):void {
		if (sharedObject) {
			sharedObject.data[key] = value;
			sharedObject.flush();
		}
	}

	public function deleteField(key:String):void {
		if (sharedObject) {
			sharedObject.data[key] = null;
			delete sharedObject.data[key];
			sharedObject.flush();
		}
	}

	public function getStorageData():Object {
		return sharedObject ? sharedObject.data : null;
	}

	public function isEmpty():Boolean {
		if (sharedObject && sharedObject.data) {
			for (var p:String in sharedObject.data) {
				return false;
			}
		}
		else return false;
		return true;
	}

}
}
