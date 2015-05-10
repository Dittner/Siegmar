package dittner.gsa.domain.fileSystem {
import dittner.gsa.domain.store.FileStorage;
import dittner.gsa.utils.async.IAsyncOperation;

public class SystemFile implements ISystemFile {
	public function SystemFile() {
		super();
	}

	[Inject]
	public var fileStorage:FileStorage;

	//----------------------------------------------------------------------------------------------
	//
	//  Properties
	//
	//----------------------------------------------------------------------------------------------

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
			_title = value;
		}
	}

	//--------------------------------------
	//  password
	//--------------------------------------
	private var _password:String = "";
	public function get password():String {return _password;}
	public function set password(value:String):void {
		if (_password != value) {
			_password = value;
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

	//----------------------------------------------------------------------------------------------
	//
	//  Methods
	//
	//----------------------------------------------------------------------------------------------

	public function store():IAsyncOperation {
		return fileStorage.store(this);
	}

	public function remove():IAsyncOperation {
		return fileStorage.remove(this);
	}

	public function getHeaderInfo():Object {
		var res:Object = {};
		res.parentID = parentID;
		res.fileType = fileType;
		res.title = title;
		res.password = password;
		res.options = options;
		return res;
	}

	public function setFromHeaderInfo(data:Object):void {
		id = data.id;
		parentID = data.parentID;
		fileType = data.fileType;
		title = data.title || "";
		password = data.password || "";
		options = data.options;
	}
}
}
