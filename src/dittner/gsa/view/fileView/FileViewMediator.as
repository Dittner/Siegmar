package dittner.gsa.view.fileView {
import dittner.gsa.bootstrap.async.IAsyncOperation;
import dittner.gsa.bootstrap.navigator.ViewNavigator;
import dittner.gsa.bootstrap.viewFactory.ViewID;
import dittner.gsa.bootstrap.walter.WalterMediator;
import dittner.gsa.bootstrap.walter.message.WalterMessage;
import dittner.gsa.domain.fileSystem.GSAFileSystem;
import dittner.gsa.domain.user.User;
import dittner.gsa.view.common.list.SelectableDataGroupEvent;
import dittner.gsa.view.fileList.toolbar.ToolAction;

import mx.collections.ArrayCollection;

public class FileViewMediator extends WalterMediator {

	[Inject]
	public var view:FileView;
	[Inject]
	public var system:GSAFileSystem;
	[Inject]
	public var viewNavigator:ViewNavigator;
	[Inject]
	public var user:User;

	override protected function activate():void {
		var op:IAsyncOperation = system.fileStorage.loadFileBody(system.bookLinksFileHeader);
		op.addCompleteCallback(linksLoaded);
	}

	private function linksLoaded(op:IAsyncOperation):void {
		if (op.isSuccess) {
			view.bookLinksBody = op.result;
			view.form.bookLinks = new ArrayCollection(view.bookLinksBody.bookLinks);
		}

		listenProxy(system, GSAFileSystem.FILE_OPENED, fileOpened);
		system.openSelectedFile();
	}

	private function fileOpened(msg:WalterMessage):void {
		if (system.openedFile) {
			view.activate(system.openedFile);
			view.addEventListener(SelectableDataGroupEvent.SELECTED, noteSelected);
			view.toolbar.selectedOpCallBack = actionHandler;
		}
	}

	private function actionHandler(action:String):void {
		switch (action) {
			case ToolAction.ADD:
			case ToolAction.EDIT:
			case ToolAction.REMOVE:
				var completeOp:IAsyncOperation = view.showForm(system.openedFile, action);
				completeOp.addCompleteCallback(function (op:IAsyncOperation):void {
					if (system.openedFile) {
						view.closeForm();
						view.refresh();
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

	override protected function deactivate():void {
		view.toolbar.selectedOpCallBack = null;

		view.clear();
		view.removeEventListener(SelectableDataGroupEvent.SELECTED, noteSelected);

		view.form.clear();
		view.toolbar.editBtn.enabled = view.toolbar.removeBtn.enabled = false;
	}

}
}