package dittner.gsa.domain.fileSystem {
import dittner.gsa.bootstrap.async.IAsyncOperation;
import dittner.gsa.bootstrap.walter.Walter;
import dittner.gsa.bootstrap.walter.walter_namespace;
import dittner.gsa.domain.store.FileStorage;

use namespace walter_namespace;

public class FileHeader {
	public function FileHeader() {
		Walter.instance.injector.inject(this);
	}

	[Inject]
	public var fileStorage:FileStorage;

	private var _fileID:int = -1;
	public function get isNewFile():Boolean {return fileID == -1;}
	public function get fileID():int {return _fileID;}
	public function set fileID(value:int):void {
		if (_fileID != value) {
			_fileID = value;
		}
	}

	//--------------------------------------
	//  parentID
	//--------------------------------------
	private var _parentID:int = -1;
	public function get parentID():int {return _parentID;}
	public function set parentID(value:int):void {
		if (_parentID != value) {
			_parentID = value;
		}
	}

	//--------------------------------------
	//  fileType
	//--------------------------------------
	private var _fileType:uint;
	public function get isFolder():Boolean {return fileType == FileType.FOLDER;}
	public function get fileType():uint {return _fileType;}
	public function set fileType(value:uint):void {
		if (_fileType != value) {
			_fileType = value;
		}
	}

	//--------------------------------------
	//  title
	//--------------------------------------
	private var _title:String = "";
	public function get title():String {return _title;}
	public function set title(value:String):void {
		if (_title != value) {
			_title = value || "";
		}
	}

	//--------------------------------------
	//  password
	//--------------------------------------
	private var _password:String = "";
	public function get password():String {return _password;}
	public function set password(value:String):void {
		if (_password != value) {
			_password = value || "";
		}
	}

	//--------------------------------------
	//  options
	//--------------------------------------
	private var _options:Object = {};
	public function get options():Object {return _options;}
	public function set options(value:Object):void {
		if (_options != value) {
			_options = value;
		}
	}

	public function store():IAsyncOperation {
		return fileStorage.storeHeader(this);
	}

	public function remove():IAsyncOperation {
		return fileStorage.removeHeader(this);
	}
}
}
