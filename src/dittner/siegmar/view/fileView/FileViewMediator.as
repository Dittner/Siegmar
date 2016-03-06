package dittner.siegmar.view.fileView {
import dittner.async.IAsyncOperation;
import dittner.siegmar.bootstrap.navigator.ViewNavigator;
import dittner.siegmar.bootstrap.viewFactory.ViewID;
import dittner.siegmar.bootstrap.walter.WalterMediator;
import dittner.siegmar.bootstrap.walter.message.WalterMessage;
import dittner.siegmar.domain.fileSystem.SiegmarFileSystem;
import dittner.siegmar.domain.fileSystem.body.links.BookLinksBody;
import dittner.siegmar.domain.user.User;
import dittner.siegmar.message.MediatorMsg;
import dittner.siegmar.view.common.list.SelectableDataGroupEvent;
import dittner.siegmar.view.fileList.toolbar.ToolAction;

import flash.events.Event;

import spark.events.TextOperationEvent;

public class FileViewMediator extends WalterMediator {

	[Inject]
	public var view:FileView;
	[Inject]
	public var system:SiegmarFileSystem;
	[Inject]
	public var viewNavigator:ViewNavigator;
	[Inject]
	public var user:User;

	private var bookLinksBody:BookLinksBody;

	override protected function activate():void {
		view.vm = this;
		var op:IAsyncOperation = system.fileStorage.loadFileBody(system.bookLinksFileHeader);
		op.addCompleteCallback(linksLoaded);
	}

	private function linksLoaded(op:IAsyncOperation):void {
		if (op.isSuccess) bookLinksBody = op.result;

		listenProxy(system, SiegmarFileSystem.FILE_OPENED, fileOpened);
		system.openSelectedFile();
	}

	private function fileOpened(msg:WalterMessage):void {
		if (system.openedFile) {
			view.activate(system.openedFile, bookLinksBody);
			view.addEventListener(SelectableDataGroupEvent.SELECTED, noteSelected);
			view.addEventListener("orderChanged", notesOrderChanged);
			view.header.filterInput.addEventListener(TextOperationEvent.CHANGE, filterChanged);
			view.toolbar.selectedOpCallBack = actionHandler;
		}
	}

	private function actionHandler(action:String):void {
		switch (action) {
			case ToolAction.CREATE:
			case ToolAction.EDIT:
			case ToolAction.REMOVE:
				var completeOp:IAsyncOperation = view.showForm(system.openedFile, action);
				completeOp.addCompleteCallback(function (op:IAsyncOperation):void {
					if (system.openedFile) {
						view.closeForm();
						if (op.isSuccess && op.result) {
							view.refresh();
							if (action == ToolAction.CREATE) view.scrollToBottom();
						}
					}
				});
				break;
			case ToolAction.CLOSE:
				system.closeOpenedFile();
				viewNavigator.navigate(ViewID.FILE_LIST);
				break;
			case ToolAction.LOGOUT:
				user.logout();
				viewNavigator.navigate(ViewID.LOGIN);
				break;
		}
	}

	private function noteSelected(event:SelectableDataGroupEvent):void {
		if (system.openedFile)
			system.openedFile.selectedNote = event.data;
		view.toolbar.editBtn.enabled = view.toolbar.removeBtn.enabled = event.data != null;
	}

	private function filterChanged(event:TextOperationEvent):void {
		view.filterNotes(view.header.filterInput.text.toLowerCase());
	}

	private function notesOrderChanged(event:Event):void {
		system.openedFile.body.store();
	}

	public function lock():void {
		sendMessage(MediatorMsg.LOCK);
	}

	public function unlock():void {
		sendMessage(MediatorMsg.UNLOCK);
	}

	override protected function deactivate():void {
		view.toolbar.selectedOpCallBack = null;

		view.clear();
		view.removeEventListener(SelectableDataGroupEvent.SELECTED, noteSelected);
		view.header.filterInput.removeEventListener(TextOperationEvent.CHANGE, filterChanged);
		view.removeEventListener("orderChanged", notesOrderChanged);

		view.header.filterInput.text = "";
		view.form.clear();
		view.toolbar.editBtn.enabled = view.toolbar.removeBtn.enabled = false;
	}

}
}