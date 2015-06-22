package dittner.gsa.view.documentList.toolbar {
import dittner.gsa.bootstrap.navigator.ViewNavigator;
import dittner.gsa.bootstrap.viewFactory.ViewID;
import dittner.gsa.bootstrap.walter.WalterMediator;
import dittner.gsa.bootstrap.walter.message.WalterMessage;
import dittner.gsa.domain.fileSystem.GSAFileSystem;
import dittner.gsa.domain.user.IUser;
import dittner.gsa.message.MediatorMsg;

public class ToolbarMediator extends WalterMediator {

	[Inject]
	public var view:Toolbar;
	[Inject]
	public var viewNavigator:ViewNavigator;
	[Inject]
	public var user:IUser;
	[Inject]
	public var system:GSAFileSystem;

	override protected function activate():void {
		listenProxy(system, GSAFileSystem.FILE_SELECTED, fileSelected);
		listenMediator(MediatorMsg.START_EDIT, startEditing);
		listenMediator(MediatorMsg.END_EDIT, endEditing);
		view.selectedOpCallBack = actionHandler;
	}

	private function fileSelected(msg:WalterMessage):void {
		view.editBtn.enabled = view.removeBtn.enabled = system.selectedFileHeader != null;
	}

	private function startEditing(msg:WalterMessage):void {
		view.enabled = false;
	}
	private function endEditing(msg:WalterMessage):void {
		view.enabled = true;
	}

	private function actionHandler(action:String):void {
		switch (action) {
			case ToolAction.ADD:
			case ToolAction.EDIT:
			case ToolAction.REMOVE:
				sendMessage(MediatorMsg.START_EDIT, action);
				break;
			case ToolAction.LOGOUT:
				user.logout();
				viewNavigator.navigate(ViewID.LOGIN);
				break;
		}
	}

	override protected function deactivate():void {
		view.selectedOpCallBack = null;
	}

}
}