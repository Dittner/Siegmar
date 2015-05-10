package dittner.gsa.view.documentList.form {
import dittner.gsa.domain.fileSystem.FileOptionKeys;
import dittner.gsa.domain.fileSystem.FileType;
import dittner.gsa.domain.fileSystem.GSAFileSystem;
import dittner.gsa.domain.fileSystem.ISystemFile;
import dittner.gsa.domain.fileSystem.SystemFile;
import dittner.gsa.message.ControllerMsg;
import dittner.gsa.view.documentList.toolbar.ToolAction;
import dittner.walter.WalterController;

import flash.events.MouseEvent;

public class DocumentFormController extends WalterController {

	[Inject]
	public var view:DocumentForm;
	[Inject]
	public var system:GSAFileSystem;

	override protected function activate():void {
		listenController(ControllerMsg.START_EDIT_NOTIFICATION, startEditing);
		listenController(ControllerMsg.END_EDIT_NOTIFICATION, endEditing);
		view.cancelBtn.addEventListener(MouseEvent.CLICK, cancelHandler);
		view.applyBtn.addEventListener(MouseEvent.CLICK, applyHandler);
	}

	private function startEditing(action:String):void {
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
		view.folderBtn.enabled = system.openedFolder != system.rootFolder;
		view.dictionaryRadioBtn.enabled = system.openedFolder != system.rootFolder;
		view.visible = true;
	}

	private function endEditing(data:*):void {
		view.visible = false;
		view.clear();
	}

	private function cancelHandler(event:MouseEvent):void {
		sendMessage(ControllerMsg.END_EDIT_NOTIFICATION);
	}

	private function applyHandler(event:MouseEvent):void {
		createAndSaveFile();
		sendMessage(ControllerMsg.END_EDIT_NOTIFICATION);
	}

	private function createAndSaveFile():void {
		var file:ISystemFile;
		if (view.subjectBtn.selected) file = system.rootFolder.createFolder();
		else if (view.folderBtn.selected) file = system.openedFolder.createFolder();
		else if (view.dictionaryRadioBtn.selected) file = system.openedFolder.createDocument(FileType.DICTIONARY);
		else if (view.articleRadioBtn.selected) file = system.openedFolder.createDocument(FileType.ARTICLE);
		else if (view.albumRadioBtn.selected) file = system.openedFolder.createDocument(FileType.PHOTOALBUM);
		else throw new Error("Unknown file type selected!");

		(file as SystemFile).title = view.titleInput.text;
		(file as SystemFile).password = view.pwdInput.text;

		if (view.authorInput.text) (file as SystemFile).options[FileOptionKeys.AUTHOR] = view.authorInput.text;
		if (view.dateInput.text) (file as SystemFile).options[FileOptionKeys.DATE_CREATED] = view.dateInput.text;
		file.store();
	}

	override protected function deactivate():void {
		view.cancelBtn.removeEventListener(MouseEvent.CLICK, cancelHandler);
		view.applyBtn.removeEventListener(MouseEvent.CLICK, applyHandler);
	}

}
}