package dittner.gsa.domain.fileSystem {
import dittner.gsa.bootstrap.async.AsyncOperationResult;
import dittner.gsa.bootstrap.async.IAsyncOperation;
import dittner.gsa.bootstrap.walter.WalterProxy;
import dittner.gsa.bootstrap.walter.message.WalterMessage;
import dittner.gsa.bootstrap.walter.walter_namespace;
import dittner.gsa.domain.fileSystem.body.DictionaryBody;
import dittner.gsa.domain.fileSystem.body.FileBody;
import dittner.gsa.domain.store.FileStorage;

use namespace walter_namespace;

public class GSAFileSystem extends WalterProxy {

	public static const FILE_SELECTED:String = "fileSelected";
	public static const HEADERS_UPDATED:String = "headersUpdated";
	public static const FOLDER_OPENED:String = "folderOpened";

	[Inject]
	public var fileStorage:FileStorage;

	//----------------------------------------------------------------------------------------------
	//
	//  Properties
	//
	//----------------------------------------------------------------------------------------------

	//--------------------------------------
	//  rootFolder
	//--------------------------------------
	private var _rootFolderHeader:FileHeader;
	public function get rootFolderHeader():FileHeader {return _rootFolderHeader;}

	//--------------------------------------
	//  openedFolderHeader
	//--------------------------------------
	private var openedFolderStack:Array = [];
	private var _openedFolderHeader:FileHeader;
	public function get openedFolderHeader():FileHeader {return _openedFolderHeader;}
	private function setOpenedFolderHeader(value:FileHeader):void {
		if (_openedFolderHeader != value) {
			_openedFolderHeader = value;
			sendMessage(FOLDER_OPENED, _openedFolderHeader);
			loadFileHeaders();
		}
	}

	//--------------------------------------
	//  selectedFileHeader
	//--------------------------------------
	private var _selectedFileHeader:FileHeader;
	public function get selectedFileHeader():FileHeader {return _selectedFileHeader;}
	public function set selectedFileHeader(value:FileHeader):void {
		if (_selectedFileHeader != value) {
			_selectedFileHeader = value;
			sendMessage(FILE_SELECTED, _selectedFileHeader);
		}
	}

	//--------------------------------------
	//  availableHeaders
	//--------------------------------------
	private var _availableHeaders:Array = [];
	public function get availableHeaders():Array {return _availableHeaders;}
	private function setAvailableHeaders(value:Array):void {
		if (_availableHeaders != value) {
			_availableHeaders = value;
			sendMessage(HEADERS_UPDATED, _availableHeaders);
		}
	}

	//----------------------------------------------------------------------------------------------
	//
	//  Methods
	//
	//----------------------------------------------------------------------------------------------

	override protected function activate():void {
		_rootFolderHeader = createRootFolderHeader();
		listenProxy(fileStorage, FileStorage.FILE_STORED, fileStored);
	}

	private function fileStored(msg:WalterMessage):void {
		loadFileHeaders();
	}

	private function createRootFolderHeader():FileHeader {
		var f:RootFolderHeader = new RootFolderHeader();
		f.fileID = 0;
		f.fileType = FileType.FOLDER;
		return f;
	}

	public function createFileHeader(fileType:int):FileHeader {
		var header:FileHeader = new FileHeader();
		header.parentID = openedFolderHeader.fileID;
		header.fileType = fileType;
		return header;
	}

	public function createFileBody(fileType:int):FileBody {
		switch (fileType) {
			case FileType.DICTIONARY :
				return new DictionaryBody();
				break;
			default :
				throw new Error("Unknown doc type:" + fileType);
		}
	}

	private function loadFileHeaders():void {
		var op:IAsyncOperation = fileStorage.loadFileHeaders(openedFolderHeader.fileID);
		op.addCompleteCallback(filesLoaded);
	}

	private function filesLoaded(res:AsyncOperationResult):void {
		setAvailableHeaders(res.isSuccess ? res.data as Array : []);
		selectedFileHeader = null;
	}

	public function openFolder(header:FileHeader):void {
		if (header && header != openedFolderHeader && header.isFolder) {
			openedFolderStack.push(header);
			setOpenedFolderHeader(header);
		}
	}

	public function openPrevFolder():void {
		if (openedFolderStack.length > 1) openedFolderStack.pop();
		setOpenedFolderHeader(openedFolderStack[openedFolderStack.length - 1]);
	}

	public function openedFolderStackToString():String {
		var res:String = "";
		for each(var header:FileHeader in openedFolderStack)
			res += header.title + " / ";
		return res;
	}

}
}
