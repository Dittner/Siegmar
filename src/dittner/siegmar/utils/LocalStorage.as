package dittner.siegmar.utils {
import dittner.async.utils.invalidateOf;

import flash.net.SharedObject;

public class LocalStorage {

	public function LocalStorage() {}

	private static var _sharedObject:SharedObject;
	private static function get sharedObject():SharedObject {
		if (!_sharedObject) _sharedObject = SharedObject.getLocal("localStorage");
		return _sharedObject;
	}

	private static var needFlush:Boolean = false;

	public static function has(key:String):Boolean {
		return sharedObject && sharedObject.data[key];
	}

	public static function read(key:String):* {
		return sharedObject ? sharedObject.data[key] : null;
	}

	public static function write(key:String, object:*):void {
		if (sharedObject) {
			sharedObject.data[key] = object;
			needFlush = true;
			invalidateOf(flushNow);
		}
	}

	public static function remove(key:String):void {
		if (sharedObject) {
			sharedObject.data[key] = null;
			delete sharedObject.data[key];
			needFlush = true;
			invalidateOf(flushNow);
		}
	}

	public static function flushNow():void {
		if (needFlush) {
			needFlush = false;
			if (sharedObject) sharedObject.flush();
		}
	}
}
}
