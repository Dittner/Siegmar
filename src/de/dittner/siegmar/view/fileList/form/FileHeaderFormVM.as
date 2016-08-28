package de.dittner.siegmar.view.fileList.form {
import de.dittner.async.AsyncOperation;
import de.dittner.async.IAsyncOperation;
import de.dittner.siegmar.backend.FileStorage;
import de.dittner.siegmar.domain.fileSystem.FileOptionKeys;
import de.dittner.siegmar.domain.fileSystem.SiegmarFileSystem;
import de.dittner.siegmar.domain.fileSystem.file.FileType;
import de.dittner.siegmar.domain.fileSystem.header.FileHeader;
import de.dittner.siegmar.domain.user.User;
import de.dittner.siegmar.logging.CLog;
import de.dittner.siegmar.logging.LogCategory;
import de.dittner.siegmar.view.common.form.FileFormMode;
import de.dittner.siegmar.view.common.form.FormOperationResult;
import de.dittner.siegmar.view.common.view.ViewModel;

import flash.events.Event;

import mx.collections.ArrayCollection;
import mx.formatters.DateFormatter;

public class FileHeaderFormVM extends ViewModel {
	public function FileHeaderFormVM() {
		super();
		if (!dateFormatter) {
			dateFormatter = new DateFormatter();
			dateFormatter.formatString = 'MM.DD.YYYY JJ:NN';
		}
	}

	[Bindable]
	[Inject]
	public var system:SiegmarFileSystem;

	[Bindable]
	[Inject]
	public var fileStorage:FileStorage;

	[Bindable]
	[Inject]
	public var user:User;

	//----------------------------------------------------------------------------------------------
	//
	//  Properties
	//
	//----------------------------------------------------------------------------------------------

	//--------------------------------------
	//  mode
	//--------------------------------------
	private var _mode:String = FileFormMode.ADD;
	[Bindable("modeChanged")]
	public function get mode():String {return _mode;}

	[Bindable("modeChanged")]
	public function get isAddMode():Boolean {return _mode == FileFormMode.ADD;}

	[Bindable("modeChanged")]
	public function get isRemoveMode():Boolean {return _mode == FileFormMode.REMOVE;}

	[Bindable("modeChanged")]
	public function get isEditMode():Boolean {return _mode == FileFormMode.EDIT;}

	//--------------------------------------
	//  selectedFolder
	//--------------------------------------
	private var _selectedFolder:FileHeader;
	[Bindable("selectedFolderChanged")]
	public function get selectedFolder():FileHeader {return _selectedFolder;}
	public function set selectedFolder(value:FileHeader):void {
		if (_selectedFolder != value) {
			_selectedFolder = value;
			dispatchEvent(new Event("selectedFolderChanged"));
		}
	}

	//--------------------------------------
	//  appliedFolder
	//--------------------------------------
	private var _appliedFolder:FileHeader;
	[Bindable("appliedFolderChanged")]
	public function get appliedFolder():FileHeader {return _appliedFolder;}
	public function set appliedFolder(value:FileHeader):void {
		if (_appliedFolder != value) {
			_appliedFolder = value;
			dispatchEvent(new Event("appliedFolderChanged"));
		}
	}

	//--------------------------------------
	//  curFileHeader
	//--------------------------------------
	private var _curFileHeader:FileHeader;
	[Bindable("curFileHeaderChanged")]
	public function get curFileHeader():FileHeader {return _curFileHeader;}
	public function set curFileHeader(value:FileHeader):void {
		if (_curFileHeader != value) {
			_curFileHeader = value;
			dispatchEvent(new Event("curFileHeaderChanged"));
		}
	}

	//--------------------------------------
	//  curDateText
	//--------------------------------------
	private var _curDateText:String = "";
	[Bindable("curDateTextChanged")]
	public function get curDateText():String {return _curDateText;}
	public function set curDateText(value:String):void {
		if (_curDateText != value) {
			_curDateText = value;
			dispatchEvent(new Event("curDateTextChanged"));
		}
	}

	//--------------------------------------
	//  author
	//--------------------------------------
	private var _author:String = "";
	[Bindable("authorChanged")]
	public function get author():String {return _author;}
	public function set author(value:String):void {
		if (_author != value) {
			_author = value;
			dispatchEvent(new Event("authorChanged"));
		}
	}

	//--------------------------------------
	//  fileTitle
	//--------------------------------------
	private var _fileTitle:String = "";
	[Bindable("fileTitleChanged")]
	public function get fileTitle():String {return _fileTitle;}
	public function set fileTitle(value:String):void {
		if (_fileTitle != value) {
			_fileTitle = value;
			dispatchEvent(new Event("fileTitleChanged"));
		}
	}

	//--------------------------------------
	//  selectedFileType
	//--------------------------------------
	private var _selectedFileType:uint;
	[Bindable("selectedFileTypeChanged")]
	public function get selectedFileType():uint {return _selectedFileType;}
	public function set selectedFileType(value:uint):void {
		if (_selectedFileType != value) {
			_selectedFileType = value;
			dispatchEvent(new Event("selectedFileTypeChanged"));
		}
	}

	//--------------------------------------
	//  infoOfRemovingFile
	//--------------------------------------
	private var _infoOfRemovingFile:String = "";
	[Bindable("infoOfRemovingFileChanged")]
	public function get infoOfRemovingFile():String {return _infoOfRemovingFile;}
	public function set infoOfRemovingFile(value:String):void {
		if (_infoOfRemovingFile != value) {
			_infoOfRemovingFile = value;
			dispatchEvent(new Event("infoOfRemovingFileChanged"));
		}
	}

	//--------------------------------------
	//  reservedTitleHash
	//--------------------------------------
	private var _reservedTitleHash:Object = {};
	[Bindable("reservedTitleHashChanged")]
	public function get reservedTitleHash():Object {return _reservedTitleHash;}
	public function set reservedTitleHash(value:Object):void {
		if (_reservedTitleHash != value) {
			_reservedTitleHash = value;
			dispatchEvent(new Event("reservedTitleHashChanged"));
		}
	}

	//--------------------------------------
	//  curOperation
	//--------------------------------------
	private var _curOperation:IAsyncOperation;
	[Bindable("curOperationChanged")]
	public function get curOperation():IAsyncOperation {return _curOperation;}
	private function setCurOperation(value:IAsyncOperation):void {
		if (_curOperation != value) {
			_curOperation = value;
			dispatchEvent(new Event("curOperationChanged"));
		}
	}

	//--------------------------------------
	//  folderStack
	//--------------------------------------
	private var _folderStack:Array = [];
	[Bindable("folderStackChanged")]
	public function get folderStack():Array {return _folderStack;}
	private function setFoldersStack(value:Array):void {
		if (_folderStack != value) {
			_folderStack = value;
			dispatchEvent(new Event("folderStackChanged"));
		}
	}

	//--------------------------------------
	//  folderStackLength
	//--------------------------------------
	private var _folderStackLength:int = 0;
	[Bindable("folderStackLengthChanged")]
	public function get folderStackLength():int {return _folderStackLength;}
	private function setFolderStackLength(value:int):void {
		if (_folderStackLength != value) {
			_folderStackLength = value;
			dispatchEvent(new Event("folderStackLengthChanged"));
		}
	}

	//--------------------------------------
	//  folderStackPath
	//--------------------------------------
	private var _folderStackPath:String = "";
	[Bindable("folderStackPathChanged")]
	public function get folderStackPath():String {return _folderStackPath;}
	public function set folderStackPath(value:String):void {
		if (_folderStackPath != value) {
			_folderStackPath = value;
			dispatchEvent(new Event("folderStackPathChanged"));
		}
	}

	//--------------------------------------
	//  destinationFolderColl
	//--------------------------------------
	private var _destinationFolderColl:ArrayCollection;
	[Bindable("destinationFolderCollChanged")]
	public function get destinationFolderColl():ArrayCollection {return _destinationFolderColl;}
	public function set destinationFolderColl(value:ArrayCollection):void {
		if (_destinationFolderColl != value) {
			_destinationFolderColl = value;
			dispatchEvent(new Event("destinationFolderCollChanged"));
		}
	}

	//----------------------------------------------------------------------------------------------
	//
	//  Methods
	//
	//----------------------------------------------------------------------------------------------
	private static var dateFormatter:DateFormatter;

	public function add():IAsyncOperation {
		setCurOperation(new AsyncOperation());
		setFoldersStack([]);
		setFolderStackLength(0);
		appliedFolder = null;
		_mode = FileFormMode.ADD;
		buildReservedTitleHash(false);

		curDateText = dateFormatter.format(new Date());
		author = user.userName;
		selectedFileType = FileType.FOLDER;
		dispatchEvent(new Event("modeChanged"));
		return curOperation;
	}

	public function edit(fileHeader:FileHeader):IAsyncOperation {
		setCurOperation(new AsyncOperation());
		curFileHeader = fileHeader;
		setFoldersStack([]);
		setFolderStackLength(0);
		appliedFolder = null;
		_mode = FileFormMode.EDIT;
		buildReservedTitleHash(false);
		selectFolder(system.rootFolderHeader);

		fileTitle = fileHeader.title;
		author = fileHeader.options[FileOptionKeys.AUTHOR] || "";
		curDateText = fileHeader.options[FileOptionKeys.DATE_CREATED] || "";
		selectedFileType = fileHeader.fileType;
		dispatchEvent(new Event("modeChanged"));
		return curOperation;
	}

	public function remove(fileHeader:FileHeader):IAsyncOperation {
		setCurOperation(new AsyncOperation());
		setFoldersStack([]);
		appliedFolder = null;
		curFileHeader = fileHeader;
		_mode = FileFormMode.REMOVE;
		infoOfRemovingFile = (fileHeader.isFolder ? "Ordner: " : "Datei: ") + fileHeader.title.toUpperCase();
		dispatchEvent(new Event("modeChanged"));
		return curOperation;
	}

	private function buildReservedTitleHash(includeSelectedHeader:Boolean = true):Object {
		reservedTitleHash = {};
		for each(var header:FileHeader in system.availableHeaderColl)
			reservedTitleHash[header.title] = includeSelectedHeader || system.selectedFileHeader != header;
		return reservedTitleHash;
	}

	public function cancel():void {
		if (curOperation) {
			curOperation.dispatchSuccess(FormOperationResult.CANCEL);
			clear();
		}
	}

	public function apply():void {
		if (curOperation) {
			if (appliedFolder) system.selectedFileHeader.parentID = appliedFolder.fileID;
			if (mode == FileFormMode.ADD) createAndSaveNewFile();
			else if (mode == FileFormMode.EDIT) updateAndSaveFile();
			else if (mode == FileFormMode.REMOVE) removeFileHeader();
			curOperation.dispatchSuccess(FormOperationResult.OK);
			clear();
		}
	}

	private function createAndSaveNewFile():void {
		var fileHeader:FileHeader = createFileHeader();
		setData(fileHeader);
		fileHeader.store();
	}

	private function createFileHeader():FileHeader {
		var fileHeader:FileHeader;
		switch (selectedFileType) {
			case FileType.FOLDER :
				fileHeader = system.createFileHeader(FileType.FOLDER);
				break;
			case FileType.ARTICLE :
				fileHeader = system.createFileHeader(FileType.ARTICLE);
				break;
			case FileType.DICTIONARY :
				fileHeader = system.createFileHeader(FileType.DICTIONARY);
				break;
			case FileType.NOTEBOOK :
				fileHeader = system.createFileHeader(FileType.NOTEBOOK);
				break;
			case FileType.ALBUM :
				fileHeader = system.createFileHeader(FileType.ALBUM);
				break;
			case FileType.PICTURE :
				fileHeader = system.createFileHeader(FileType.PICTURE);
				break;
			default :
				CLog.err(LogCategory.UI, "VM, unknown file type: " + selectedFileType);
				throw new Error("VM, unknown file type: " + selectedFileType);
		}
		return fileHeader;
	}

	private function setData(header:FileHeader):void {
		header.title = fileTitle;
		if (author) header.options[FileOptionKeys.AUTHOR] = author;
		if (curDateText) header.options[FileOptionKeys.DATE_CREATED] = curDateText;
	}

	private function updateAndSaveFile():void {
		if (curFileHeader) {
			setData(curFileHeader);
			curFileHeader.store();
		}
	}

	private function removeFileHeader():void {
		if (curFileHeader) curFileHeader.remove();
	}

	public function selectFolder(header:FileHeader):void {
		if (header && header.isFolder && curFileHeader.fileID != header.fileID) {
			selectedFolder = header;
			folderStack.push(header);
			setFolderStackLength(folderStack.length);
			var op:IAsyncOperation = fileStorage.loadFileHeaders(selectedFolder.fileID);
			op.addCompleteCallback(filesLoaded);
			folderStackPath = "Ausgewählter Ordner: " + openedFolderStackToString();
		}
	}

	public function openPrevFolder():void {
		if (folderStack.length > 1) {
			folderStack.pop();
			var f:FileHeader = folderStack.pop() as FileHeader;
			selectFolder(f);
			setFolderStackLength(folderStack.length);
		}
	}

	private function filesLoaded(op:IAsyncOperation):void {
		var files:Array = op.isSuccess ? op.result as Array : [];
		files.sortOn(["fileType", "title"], [Array.NUMERIC, Array.CASEINSENSITIVE]);
		var coll:ArrayCollection = new ArrayCollection(files);
		coll.filterFunction = fileFilterFunc;
		coll.refresh();
		destinationFolderColl = coll;
	}

	public function openedFolderStackToString():String {
		var res:String = "";
		for each(var header:FileHeader in folderStack)
			res += header.title + " / ";
		return res;
	}

	public function fileFilterFunc(header:FileHeader):Boolean {
		return header.isFolder;
	}

	private function clear():void {
		author = "";
		curDateText = "";
		appliedFolder = null;
		setCurOperation(null);
	}

}
}