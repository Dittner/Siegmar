package dittner.gsa.view.documentList.form {
import dittner.gsa.bootstrap.walter.WalterMediator;
import dittner.gsa.domain.fileSystem.FileOptionKeys;
import dittner.gsa.domain.fileSystem.FileType;
import dittner.gsa.domain.fileSystem.GSAFileSystem;
import dittner.gsa.domain.fileSystem.IGSAFile;
import dittner.gsa.message.ControllerMsg;
import dittner.gsa.view.documentList.toolbar.ToolAction;

import flash.events.MouseEvent;

public class DocumentFormMediator extends WalterMediator {

	[Inject]
	public var view:DocumentForm;
	[Inject]
	public var system:GSAFileSystem;

	override protected function activate():void {
		listenMediator(ControllerMsg.START_EDIT, startEdit);
		listenMediator(ControllerMsg.END_EDIT, endEdit);
		view.cancelBtn.addEventListener(MouseEvent.CLICK, cancelHandler);
		view.applyBtn.addEventListener(MouseEvent.CLICK, applyHandler);
	}

	private function startEdit(action:String):void {
		switch (action) {
			case ToolAction.ADD:
				view.add();
				break;
			case ToolAction.EDIT:
				view.edit(null);
				break;
			case ToolAction.REMOVE:
				view.remove(null);
				break;
		}
		view.visible = true;
	}

	private function endEdit(data:*):void {
		view.visible = false;
		view.clear();
	}

	private function cancelHandler(event:MouseEvent):void {
		sendMessage(ControllerMsg.END_EDIT);
	}

	private function applyHandler(event:MouseEvent):void {
		createAndSaveFile();
		sendMessage(ControllerMsg.END_EDIT);
	}

	private function createAndSaveFile():void {
		var file:IGSAFile;
		if (view.folderBtn.selected) file = system.createFolder();
		else if (view.dictionaryRadioBtn.selected) file = system.createDocument(FileType.DICTIONARY);
		else if (view.articleRadioBtn.selected) file = system.createDocument(FileType.ARTICLE);
		else if (view.albumRadioBtn.selected) file = system.createDocument(FileType.PHOTOALBUM);
		else throw new Error("Unknown file type selected!");

		file.header.title = view.titleInput.text;
		file.header.password = view.pwdInput.text;

		if (view.authorInput.text) file.header.options[FileOptionKeys.AUTHOR] = view.authorInput.text;
		if (view.dateInput.text) file.header.options[FileOptionKeys.DATE_CREATED] = view.dateInput.text;
		file.store();
	}

	override protected function deactivate():void {
		view.cancelBtn.removeEventListener(MouseEvent.CLICK, cancelHandler);
		view.applyBtn.removeEventListener(MouseEvent.CLICK, applyHandler);
	}

}
}