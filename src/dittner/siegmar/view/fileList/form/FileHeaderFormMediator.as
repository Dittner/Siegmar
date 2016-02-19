package dittner.siegmar.view.fileList.form {
import dittner.siegmar.bootstrap.async.IAsyncOperation;
import dittner.siegmar.bootstrap.walter.WalterMediator;
import dittner.siegmar.bootstrap.walter.message.WalterMessage;
import dittner.siegmar.domain.fileSystem.FileOptionKeys;
import dittner.siegmar.domain.fileSystem.SiegmarFileSystem;
import dittner.siegmar.domain.fileSystem.file.FileType;
import dittner.siegmar.domain.fileSystem.header.FileHeader;
import dittner.siegmar.domain.store.FileStorage;
import dittner.siegmar.domain.user.User;
import dittner.siegmar.message.MediatorMsg;
import dittner.siegmar.view.common.form.FileFormMode;
import dittner.siegmar.view.common.list.SelectableDataGroupEvent;
import dittner.siegmar.view.common.utils.AppColors;
import dittner.siegmar.view.fileList.toolbar.ToolAction;

import flash.events.MouseEvent;

import mx.collections.ArrayCollection;

public class FileHeaderFormMediator extends WalterMediator {

	[Inject]
	public var view:FileHeaderForm;
	[Inject]
	public var system:SiegmarFileSystem;
	[Inject]
	public var fileStorage:FileStorage;
	[Inject]
	public var user:User;

	private var selectedFolder:FileHeader;
	private var appliedFolder:FileHeader;
	private var foldersStack:Array;

	override protected function activate():void {
		view.userName = user.userName;
		listenMediator(MediatorMsg.START_EDIT, startEdit);
		listenMediator(MediatorMsg.END_EDIT, endEdit);
		view.cancelBtn.addEventListener(MouseEvent.CLICK, cancelHandler);
		view.applyBtn.addEventListener(MouseEvent.CLICK, applyHandler);
		view.destinationFolderList.addEventListener(SelectableDataGroupEvent.DOUBLE_CLICKED, viewListDoubleClicked);
		view.applyDestFolderBtn.addEventListener(MouseEvent.CLICK, destFolderApplied);
		view.backBtn.addEventListener(MouseEvent.CLICK, backBtnClicked);
		view.backBtn.enabled = false;
	}

	private function backBtnClicked(event:MouseEvent):void {
		if (foldersStack.length > 1) {
			foldersStack.pop();
			var f:FileHeader = foldersStack.pop() as FileHeader;
			selectFolder(f);
		}
	}

	private function selectFolder(folder:FileHeader):void {
		selectedFolder = folder;
		foldersStack.push(folder);
		var op:IAsyncOperation = fileStorage.loadFileHeaders(selectedFolder.fileID);
		op.addCompleteCallback(filesLoaded);
		updateListControls();
	}

	private function updateListControls():void {
		view.backBtn.enabled = foldersStack.length > 1;
		view.pathLbl.text = "Ausgewählter Ordner: " + openedFolderStackToString();
		var isFileFolder:Boolean = appliedFolder ? appliedFolder.fileID == selectedFolder.fileID : system.openedFolderHeader.fileID == selectedFolder.fileID;
		view.pathLbl.setStyle("color", isFileFolder ? AppColors.HELL_TÜRKIS : 0xffFFff);
		view.applyDestFolderBtn.enabled = !isFileFolder;
	}

	private function viewListDoubleClicked(event:SelectableDataGroupEvent):void {
		var selectedFileHeader:FileHeader = event.data as FileHeader;
		if (!selectedFileHeader) return;

		if (selectedFileHeader.isFolder) {
			if (system.selectedFileHeader.fileID != selectedFileHeader.fileID)
				selectFolder(event.data as FileHeader)
		}
	}

	private function destFolderApplied(event:MouseEvent):void {
		appliedFolder = selectedFolder;
		updateListControls();
	}

	public function openedFolderStackToString():String {
		var res:String = "";
		for each(var header:FileHeader in foldersStack)
			res += header.title + " / ";
		return res;
	}

	private function filesLoaded(op:IAsyncOperation):void {
		var files:Array = op.isSuccess ? op.result as Array : [];
		files.sortOn(["fileType", "title"], [Array.NUMERIC, Array.CASEINSENSITIVE]);
		var coll:ArrayCollection = new ArrayCollection(files);
		coll.filterFunction = fileFilterFunc;
		coll.refresh();
		view.destinationFolderColl = coll;
	}

	public function fileFilterFunc(header:FileHeader):Boolean {
		return header.isFolder;
	}

	private function startEdit(msg:WalterMessage):void {
		foldersStack = [];
		appliedFolder = null;
		switch (msg.data) {
			case ToolAction.CREATE:
				view.add(getReservedTitleHash());
				break;
			case ToolAction.EDIT:
				if (system.selectedFileHeader) {
					selectFolder(system.rootFolderHeader);
					view.edit(system.selectedFileHeader, getReservedTitleHash(false));
				}
				break;
			case ToolAction.REMOVE:
				if (system.selectedFileHeader) view.remove(system.selectedFileHeader);
				break;
		}
		view.visible = true;
	}

	private function endEdit(data:*):void {
		view.visible = false;
		view.clear();
	}

	private function cancelHandler(event:MouseEvent):void {
		sendMessage(MediatorMsg.END_EDIT);
	}

	private function applyHandler(event:MouseEvent):void {
		if (appliedFolder) system.selectedFileHeader.parentID = appliedFolder.fileID;
		if (view.mode == FileFormMode.ADD) createAndSaveNewFile();
		else if (view.mode == FileFormMode.EDIT) updateAndSaveFile();
		else if (view.mode == FileFormMode.REMOVE) removeFileHeader();
		sendMessage(MediatorMsg.END_EDIT);
	}

	private function createAndSaveNewFile():void {
		var fileHeader:FileHeader = createFileHeader();
		setData(fileHeader);
		fileHeader.store();
	}

	private function createFileHeader():FileHeader {
		var fileHeader:FileHeader;
		if (view.folderBtn.selected) fileHeader = system.createFileHeader(FileType.FOLDER);
		else if (view.dictionaryRadioBtn.selected) fileHeader = system.createFileHeader(FileType.DICTIONARY);
		else if (view.articleRadioBtn.selected) fileHeader = system.createFileHeader(FileType.ARTICLE);
		else if (view.albumRadioBtn.selected) fileHeader = system.createFileHeader(FileType.ALBUM);
		else if (view.notebookRadioBtn.selected) fileHeader = system.createFileHeader(FileType.NOTEBOOK);
		else if (view.pictureRadioBtn.selected) fileHeader = system.createFileHeader(FileType.PICTURE);
		else throw new Error("Unknown file type selected!");
		return fileHeader;
	}

	private function setData(header:FileHeader):void {
		header.title = view.titleInput.text;

		if (view.authorInput.text) header.options[FileOptionKeys.AUTHOR] = view.authorInput.text;
		if (view.dateInput.text) header.options[FileOptionKeys.DATE_CREATED] = view.dateInput.text;
	}

	private function updateAndSaveFile():void {
		if (system.selectedFileHeader) {
			setData(system.selectedFileHeader);
			system.selectedFileHeader.store();
		}
	}

	private function removeFileHeader():void {
		if (system.selectedFileHeader) system.selectedFileHeader.remove();
	}

	private function getReservedTitleHash(includeSelectedHeader:Boolean = true):Object {
		var hash:Object = {};
		for each(var header:FileHeader in system.availableHeaders)
			hash[header.title] = includeSelectedHeader || system.selectedFileHeader != header;
		return hash;
	}

	override protected function deactivate():void {
		view.cancelBtn.removeEventListener(MouseEvent.CLICK, cancelHandler);
		view.applyBtn.removeEventListener(MouseEvent.CLICK, applyHandler);
		view.applyDestFolderBtn.removeEventListener(MouseEvent.CLICK, destFolderApplied);
		view.backBtn.removeEventListener(MouseEvent.CLICK, backBtnClicked);
		view.destinationFolderList.removeEventListener(SelectableDataGroupEvent.DOUBLE_CLICKED, viewListDoubleClicked);
	}

}
}