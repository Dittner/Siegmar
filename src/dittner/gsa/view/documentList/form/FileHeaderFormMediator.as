package dittner.gsa.view.documentList.form {
import dittner.gsa.bootstrap.walter.WalterMediator;
import dittner.gsa.bootstrap.walter.message.WalterMessage;
import dittner.gsa.domain.fileSystem.FileHeader;
import dittner.gsa.domain.fileSystem.FileOptionKeys;
import dittner.gsa.domain.fileSystem.FileType;
import dittner.gsa.domain.fileSystem.GSAFileSystem;
import dittner.gsa.message.MediatorMsg;
import dittner.gsa.view.common.form.FileFormMode;
import dittner.gsa.view.documentList.toolbar.ToolAction;

import flash.events.MouseEvent;

public class FileHeaderFormMediator extends WalterMediator {

	[Inject]
	public var view:FileHeaderForm;
	[Inject]
	public var system:GSAFileSystem;

	override protected function activate():void {
		listenMediator(MediatorMsg.START_EDIT, startEdit);
		listenMediator(MediatorMsg.END_EDIT, endEdit);
		view.cancelBtn.addEventListener(MouseEvent.CLICK, cancelHandler);
		view.applyBtn.addEventListener(MouseEvent.CLICK, applyHandler);
	}

	private function startEdit(msg:WalterMessage):void {
		switch (msg.data) {
			case ToolAction.ADD:
				view.add(getReservedTitleHash());
				break;
			case ToolAction.EDIT:
				if (system.selectedFileHeader) {
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
		else throw new Error("Unknown file type selected!");
		return fileHeader;
	}

	private function setData(header:FileHeader):void {
		header.title = view.titleInput.text;
		header.password = view.pwdInput.text;

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
	}

}
}