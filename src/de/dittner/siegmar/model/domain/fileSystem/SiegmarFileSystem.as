package de.dittner.siegmar.model.domain.fileSystem {
import de.dittner.async.AsyncOperation;
import de.dittner.async.IAsyncOperation;
import de.dittner.siegmar.backend.FileStorage;
import de.dittner.siegmar.model.domain.fileSystem.body.FileBody;
import de.dittner.siegmar.model.domain.fileSystem.body.NoteListBody;
import de.dittner.siegmar.model.domain.fileSystem.body.album.AlbumBody;
import de.dittner.siegmar.model.domain.fileSystem.body.links.BookLinksBody;
import de.dittner.siegmar.model.domain.fileSystem.body.picture.PictureBody;
import de.dittner.siegmar.model.domain.fileSystem.body.settings.SettingsBody;
import de.dittner.siegmar.model.domain.fileSystem.file.FileType;
import de.dittner.siegmar.model.domain.fileSystem.file.SiegmarFile;
import de.dittner.siegmar.model.domain.fileSystem.header.FileHeader;
import de.dittner.siegmar.model.domain.fileSystem.header.RootFolderHeader;
import de.dittner.siegmar.model.domain.user.User;
import de.dittner.walter.WalterProxy;
import de.dittner.walter.message.WalterMessage;
import de.dittner.walter.walter_namespace;

import flash.events.Event;

import mx.collections.ArrayCollection;

use namespace walter_namespace;

public class SiegmarFileSystem extends WalterProxy {
	public function SiegmarFileSystem() {
		super();
	}

	public static const FILE_SELECTED:String = "fileSelected";
	public static const HEADERS_UPDATED:String = "headersUpdated";
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
			if (openedFolderHeader) {
				var path:String = "";
				for each(var header:FileHeader in openedFolderStack)
					path += header.title + " / ";
				setOpenedFolderPath(path);
			}
		}
	}

	//--------------------------------------
	//  openedFolderPath
	//--------------------------------------
	private var _openedFolderPath:String = "";
	[Bindable("openedFolderPathChanged")]
	public function get openedFolderPath():String {return _openedFolderPath;}
	private function setOpenedFolderPath(value:String):void {
		if (_openedFolderPath != value) {
			_openedFolderPath = value;
			dispatchEvent(new Event("openedFolderPathChanged"));
		}
	}

	//--------------------------------------
	//  selectedFileHeader
	//--------------------------------------
	private var _selectedFileHeader:FileHeader;
	[Bindable("selectedFileHeaderChanged")]
	public function get selectedFileHeader():FileHeader {return _selectedFileHeader;}
	public function set selectedFileHeader(value:FileHeader):void {
		if (_selectedFileHeader != value) {
			_selectedFileHeader = value;
			dispatchEvent(new Event("selectedFileHeaderChanged"));
			sendMessage(FILE_SELECTED, _selectedFileHeader);
		}
	}

	//--------------------------------------
	//  availableHeaderColl
	//--------------------------------------
	private var _availableHeaderColl:ArrayCollection;
	[Bindable("availableHeaderCollChanged")]
	public function get availableHeaderColl():ArrayCollection {return _availableHeaderColl;}
	private function setAvailableHeaderColl(value:ArrayCollection):void {
		if (_availableHeaderColl != value) {
			_availableHeaderColl = value;
			dispatchEvent(new Event("availableHeaderCollChanged"));
			sendMessage(HEADERS_UPDATED, availableHeaderColl);
		}
	}

	//--------------------------------------
	//  openedFile
	//--------------------------------------
	private var _openedFile:SiegmarFile;
	[Bindable("openedFileChanged")]
	public function get openedFile():SiegmarFile {return _openedFile;}
	private function setOpenedFile(value:SiegmarFile):void {
		if (_openedFile != value) {
			_openedFile = value;
			dispatchEvent(new Event("openedFileChanged"));
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
		initOp = new SiegmarFileSystemInitializeOp(this);
		initOp.addCompleteCallback(initializeComplete);
		return initOp;
	}

	private function initializeComplete(op:SiegmarFileSystemInitializeOp):void {
		if (op.isSuccess) {
			_rootFolderHeader = createRootFolderHeader();
			_bookLinksFileHeader = op.bookLinksFileHeader;
			_settingsFileHeader = op.settingsFileHeader;

			listenProxy(fileStorage, FileStorage.FILE_STORED, fileStored);
			listenProxy(fileStorage, FileStorage.FILE_REMOVED, fileRemoved);
		}
	}

	override protected function activate():void {}

	private var openSelectedFileOp:IAsyncOperation;
	public function openSelectedFile():IAsyncOperation {
		if (openSelectedFileOp && openSelectedFileOp.isProcessing) return openSelectedFileOp;
		openSelectedFileOp = new AsyncOperation();

		if (openedFile) {
			openSelectedFileOp.dispatchSuccess(openedFile);
		}
		else if (selectedFileHeader && !selectedFileHeader.isFolder) {
			var op:IAsyncOperation = fileStorage.loadFileBody(selectedFileHeader);
			op.addCompleteCallback(fileBodyLoaded)
		}
		else {
			_openedFile = null;
			if(!selectedFileHeader)
				openSelectedFileOp.dispatchError("No selected file header to load!");
			else if(selectedFileHeader.isFolder)
				openSelectedFileOp.dispatchError("Folder is not a file!");
		}
		return openSelectedFileOp;
	}

	private function fileBodyLoaded(op:IAsyncOperation):void {
		if (op.isSuccess) {
			var file:SiegmarFile;
			file = new SiegmarFile();
			file.header = selectedFileHeader;
			file.body = op.result as FileBody;
			setOpenedFile(file);
			openSelectedFileOp.dispatchSuccess(file);
		}
		else {
			openSelectedFileOp.dispatchError(op.error);
		}
	}

	private function fileStored(msg:WalterMessage):void {
		if (!initOp || !initOp.isProcessing) loadFileHeaders();
	}

	private function fileRemoved(msg:WalterMessage):void {
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
			case FileType.ALBUM :
				body = new AlbumBody();
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
		op.addCompleteCallback(headersLoaded);
	}

	private function headersLoaded(op:IAsyncOperation):void {
		var headers:Array = op.isSuccess ? op.result as Array : [];
		headers.sortOn(["fileType", "title"], [Array.NUMERIC, Array.CASEINSENSITIVE]);
		setAvailableHeaderColl(new ArrayCollection(headers));
		selectedFileHeader = null;
	}

	public function openFolder(header:FileHeader):void {
		if (header && header.isFolder) {
			if (header != openedFolderHeader) {
				openedFolderStack.push(header);
				setOpenedFolderHeader(header);
			}
			else {
				sendMessage(HEADERS_UPDATED, availableHeaderColl);
			}
		}
	}

	public function openPrevFolder():void {
		if (openedFolderStack.length > 1) openedFolderStack.pop();
		setOpenedFolderHeader(openedFolderStack[openedFolderStack.length - 1]);
	}

	public function closeOpenedFile():void {
		_openedFile = null;
		_selectedFileHeader = null;
	}

	public function logout():void {
		_openedFile = null;
		_openedFolderHeader = null;
		openedFolderStack.length = 0;
		setAvailableHeaderColl(new ArrayCollection());
		user.logout();
	}

}
}
