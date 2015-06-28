package dittner.gsa.view.documentView.document {
import dittner.gsa.bootstrap.walter.WalterMediator;
import dittner.gsa.bootstrap.walter.message.WalterMessage;
import dittner.gsa.domain.fileSystem.GSAFileSystem;
import dittner.gsa.domain.fileSystem.body.note.Note;
import dittner.gsa.message.MediatorMsg;
import dittner.gsa.view.common.list.SelectableDataGroupEvent;

public class DocumentMediator extends WalterMediator {

	[Inject]
	public var view:Document;
	[Inject]
	public var system:GSAFileSystem;

	override protected function activate():void {
		listenProxy(system, GSAFileSystem.FILE_OPENED, fileOpened);
		listenMediator(MediatorMsg.END_EDIT, endEdit);
		system.openSelectedFile();
		view.addEventListener(SelectableDataGroupEvent.SELECTED, noteSelected);
	}

	private function fileOpened(msg:WalterMessage):void {
		if (system.openedFile) {
			view.activate(system.openedFile)
		}
	}

	private function endEdit(data:* = null):void {
		if (system.openedFile) {
			view.refresh();
		}
	}

	private function noteSelected(event:SelectableDataGroupEvent):void {
		if (system.openedFile) {
			system.openedFile.selectedNote = event.data as Note;
			sendMessage(MediatorMsg.NOTE_SELECTED, event.data as Note);
		}
	}

	override protected function deactivate():void {
		view.clear();
		view.removeEventListener(SelectableDataGroupEvent.SELECTED, noteSelected);
	}

}
}