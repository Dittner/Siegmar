package de.dittner.siegmar.model.domain.fileSystem.header {
import de.dittner.async.IAsyncOperation;
import de.dittner.siegmar.backend.FileStorage;
import de.dittner.siegmar.model.domain.fileSystem.file.FileType;
import de.dittner.siegmar.model.domain.fileSystem.file.FileTypeName;
import de.dittner.siegmar.view.common.utils.AppColors;
import de.dittner.walter.Walter;
import de.dittner.walter.walter_namespace;

use namespace walter_namespace;

public class FileHeader {
	public function FileHeader() {
		Walter.instance.injector.inject(this);
	}

	[Inject]
	public var fileStorage:FileStorage;

	//--------------------------------------
	//  fileID
	//--------------------------------------
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
	//  isReserved
	//--------------------------------------
	private var _isReserved:Boolean = false;
	public function get isReserved():Boolean {return _isReserved;}
	public function set isReserved(value:Boolean):void {
		if (_isReserved != value) {
			_isReserved = value;
		}
	}

	//--------------------------------------
	//  isFavorite
	//--------------------------------------
	private var _isFavorite:Boolean = false;
	public function get isFavorite():Boolean {return _isFavorite;}
	public function set isFavorite(value:Boolean):void {
		if (_isFavorite != value) {
			_isFavorite = value;
		}
	}

	//--------------------------------------
	//  fileTypeName
	//--------------------------------------
	public function get fileTypeName():String {
		return FileTypeName.getNameByType(fileType);
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
	//  options
	//--------------------------------------
	private var _options:Object = {};
	public function get options():Object {return _options;}
	public function set options(value:Object):void {
		if (_options != value) {
			_options = value;
		}
	}

	public function get color():uint {
		switch (fileType) {
			case FileType.ARTICLE :
				return AppColors.DOC_ARTICLE;
			case FileType.DICTIONARY :
				return AppColors.DOC_DICTIONARY;
			case FileType.NOTEBOOK :
				return AppColors.DOC_NOTEBOOK;
			case FileType.PICTURE :
				return AppColors.DOC_PICTURE;
			case FileType.ALBUM :
				return AppColors.DOC_ALBUM;
			case FileType.BOOK_LINKS :
				return AppColors.DOC_BOOK_LINKS;
			default :
				return AppColors.FOLDER;
		}
	}

	public function get symbol():String {
		switch (fileType) {
			case FileType.ARTICLE :
				return "A";
			case FileType.DICTIONARY :
				return "W";
			case FileType.NOTEBOOK :
				return "N";
			case FileType.PICTURE :
				return "B";
			case FileType.ALBUM :
				return "P";
			case FileType.BOOK_LINKS :
				return "H";
			default :
				return "?";
		}
	}

	public function store():IAsyncOperation {
		return fileStorage.storeHeader(this);
	}

	public function remove():IAsyncOperation {
		return fileStorage.removeFile(this);
	}
}
}
