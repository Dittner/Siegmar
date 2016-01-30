package dittner.siegmar.domain.fileSystem.body {
import dittner.siegmar.bootstrap.async.IAsyncOperation;
import dittner.siegmar.bootstrap.walter.Walter;
import dittner.siegmar.bootstrap.walter.walter_namespace;
import dittner.siegmar.domain.store.FileStorage;

import flash.utils.ByteArray;

use namespace walter_namespace;

public class FileBody {
	public function FileBody() {
		Walter.instance.injector.inject(this);
	}

	[Inject]
	public var fileStorage:FileStorage;

	public function serialize():ByteArray {
		return null;
	}

	//--------------------------------------
	//  id
	//--------------------------------------
	private var _id:int = -1;
	public function get id():int {return _id;}
	public function set id(value:int):void {
		if (_id != value) {
			_id = value;
		}
	}

	//--------------------------------------
	//  fileID
	//--------------------------------------
	private var _fileID:int = -1;
	public function get fileID():int {return _fileID;}
	public function set fileID(value:int):void {
		if (_fileID != value) {
			_fileID = value;
		}
	}

	//--------------------------------------
	//  encryptEnabled
	//--------------------------------------
	public function get encryptEnabled():Boolean {return true;}

	//----------------------------------------------------------------------------------------------
	//
	//  Methods
	//
	//----------------------------------------------------------------------------------------------

	public function deserialize(ba:ByteArray):void {}

	public function store():IAsyncOperation {
		return fileStorage.storeBody(this);
	}

}
}
