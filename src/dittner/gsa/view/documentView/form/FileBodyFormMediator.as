package dittner.gsa.view.documentView.form {
import dittner.gsa.bootstrap.async.IAsyncOperation;
import dittner.gsa.bootstrap.walter.WalterMediator;
import dittner.gsa.bootstrap.walter.message.WalterMessage;
import dittner.gsa.domain.fileSystem.GSAFileSystem;
import dittner.gsa.message.MediatorMsg;
import dittner.gsa.view.documentList.toolbar.ToolAction;

public class FileBodyFormMediator extends WalterMediator {

	[Inject]
	public var view:FileBodyForm;
	[Inject]
	public var system:GSAFileSystem;

	override protected function activate():void {
		listenMediator(MediatorMsg.START_EDIT, startEdit);
		listenMediator(MediatorMsg.END_EDIT, endEdit);
	}

	private function startEdit(msg:WalterMessage):void {
		if (!system.openedFile) return;
		var op:IAsyncOperation;
		switch (msg.data) {
			case ToolAction.ADD:
				op = view.createNote(system.openedFile);
				break;
			case ToolAction.EDIT:
				if (system.openedFile.selectedNote) op = view.editNote(system.openedFile);
				break;
			case ToolAction.REMOVE:
				if (system.openedFile.selectedNote) op = view.removeNote(system.openedFile);
				break;
		}
		if (op) {
			view.visible = true;
			op.addCompleteCallback(closeForm);
		}
	}

	private function endEdit(msg:WalterMessage):void {
		view.visible = false;
		view.clear();
	}

	private function closeForm(op:IAsyncOperation):void {
		sendMessage(MediatorMsg.END_EDIT);
	}

	override protected function deactivate():void {
	}

}
}