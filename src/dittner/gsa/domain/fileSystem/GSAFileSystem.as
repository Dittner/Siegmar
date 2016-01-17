package dittner.gsa.domain.fileSystem {
import dittner.gsa.bootstrap.async.IAsyncOperation;
import dittner.gsa.bootstrap.walter.WalterProxy;
import dittner.gsa.bootstrap.walter.message.WalterMessage;
import dittner.gsa.bootstrap.walter.walter_namespace;
import dittner.gsa.domain.fileSystem.body.FileBody;
import dittner.gsa.domain.fileSystem.body.NoteListBody;
import dittner.gsa.domain.fileSystem.body.links.BookLinksBody;
import dittner.gsa.domain.fileSystem.body.picture.PictureBody;
import dittner.gsa.domain.fileSystem.body.settings.SettingsBody;
import dittner.gsa.domain.fileSystem.file.FileType;
import dittner.gsa.domain.fileSystem.file.GSAFile;
import dittner.gsa.domain.fileSystem.header.FileHeader;
import dittner.gsa.domain.fileSystem.header.RootFolderHeader;
import dittner.gsa.domain.store.FileStorage;
import dittner.gsa.domain.user.User;

use namespace walter_namespace;

public class GSAFileSystem extends WalterProxy {

	public static const FILE_SELECTED:String = "fileSelected";
	public static const HEADERS_UPDATED:String = "headersUpdated";
	public static const FILE_OPENED:String = "fileOpened";
	public static const FOLDER_OPENED:String = "folderOpened";

	[Inject]
	public var fileStorage:FileStorage;
	[Inject]
	public var user:User;

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

	//--------------------------------------
	//  openedFile
	//--------------------------------------
	private var _openedFile:GSAFile;
	public function get openedFile():GSAFile {return _openedFile;}
	private function setOpenedFile(value:GSAFile):void {
		if (_openedFile != value) {
			_openedFile = value;
			sendMessage(FILE_OPENED, _openedFile);
		}
	}

	//--------------------------------------
	//  bookLinksFileHeader
	//--------------------------------------
	private var _bookLinksFileHeader:FileHeader;
	public function get bookLinksFileHeader():FileHeader {return _bookLinksFileHeader;}

	//--------------------------------------
	//  settingsFileHeader
	//--------------------------------------
	private var _settingsFileHeader:FileHeader;
	public function get settingsFileHeader():FileHeader {return _settingsFileHeader;}

	//----------------------------------------------------------------------------------------------
	//
	//  Methods
	//
	//----------------------------------------------------------------------------------------------

	private var initOp:IAsyncOperation;
	public function initialize():IAsyncOperation {
		if (initOp && initOp.isProcessing) return initOp;
		initOp = new GSAFileSystemInitializeOp(this);
		initOp.addCompleteCallback(initializeComplete);
		return initOp;
	}

	private function initializeComplete(op:GSAFileSystemInitializeOp):void {
		if (op.isSuccess) {
			_rootFolderHeader = createRootFolderHeader();
			_bookLinksFileHeader = op.bookLinksFileHeader;
			_settingsFileHeader = op.settingsFileHeader;

			listenProxy(fileStorage, FileStorage.FILE_STORED, fileStored);
		}
	}

	override protected function activate():void {}

	public function openSelectedFile():void {
		if (selectedFileHeader && !selectedFileHeader.isFolder) {
			var op:IAsyncOperation = fileStorage.loadFileBody(selectedFileHeader);
			op.addCompleteCallback(fileBodyLoaded)
		}
		else {
			_openedFile = null;
		}
	}

	private function fileBodyLoaded(op:IAsyncOperation):void {
		if (op.isSuccess) {
			var file:GSAFile;
			file = new GSAFile();
			file.header = selectedFileHeader;
			file.body = op.result as FileBody;
			setOpenedFile(file);
		}
	}

	private function fileStored(msg:WalterMessage):void {
		if (!initOp || !initOp.isProcessing) loadFileHeaders();
	}

	private function createRootFolderHeader():FileHeader {
		var f:RootFolderHeader = new RootFolderHeader();
		f.fileID = 0;
		f.fileType = FileType.FOLDER;
		return f;
	}

	public function createFileHeader(fileType:int, isReserved:Boolean = false):FileHeader {
		var header:FileHeader = new FileHeader();
		header.parentID = isReserved ? -1 : openedFolderHeader.fileID;
		header.fileType = fileType;
		header.isReserved = isReserved;
		return header;
	}

	public function createFileBody(header:FileHeader):FileBody {
		var body:FileBody;
		switch (header.fileType) {
			case FileType.DICTIONARY :
			case FileType.NOTEBOOK :
			case FileType.ARTICLE :
				body = new NoteListBody();
				break;
			case FileType.PICTURE :
				body = new PictureBody();
				break;
			case FileType.BOOK_LINKS :
				body = new BookLinksBody();
				break;
			case FileType.SETTINGS :
				body = new SettingsBody();
				break;
			default :
				throw new Error("Unknown doc type:" + header.fileType);
		}
		body.fileID = header.fileID;
		return body;
	}

	private function loadFileHeaders():void {
		var op:IAsyncOperation = fileStorage.loadFileHeaders(openedFolderHeader.fileID);
		op.addCompleteCallback(filesLoaded);
	}

	private function filesLoaded(op:IAsyncOperation):void {
		var files:Array = op.isSuccess ? op.result as Array : [];
		files.sortOn(["fileType", "title"], [Array.NUMERIC, Array.CASEINSENSITIVE]);
		setAvailableHeaders(files);
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

	public function closeOpenedFile():void {
		_openedFile = null;
		_openedFolderHeader = null;
		openedFolderStack.length = 0;
		availableHeaders.length = 0;
	}

	public function logout():void {
		_openedFile = null;
		_openedFolderHeader = null;
		openedFolderStack.length = 0;
		availableHeaders.length = 0;
	}

}
}
