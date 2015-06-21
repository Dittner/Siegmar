package dittner.gsa.view.documentList.toolbar {
import dittner.gsa.bootstrap.navigator.ViewNavigator;
import dittner.gsa.bootstrap.viewFactory.ViewID;
import dittner.gsa.bootstrap.walter.WalterMediator;
import dittner.gsa.bootstrap.walter.message.WalterMessage;
import dittner.gsa.domain.user.IUser;
import dittner.gsa.message.ControllerMsg;

public class ToolbarMediator extends WalterMediator {

	[Inject]
	public var view:Toolbar;
	[Inject]
	public var viewNavigator:ViewNavigator;
	[Inject]
	public var user:IUser;

	override protected function activate():void {
		listenMediator(ControllerMsg.START_EDIT, startEditing);
		listenMediator(ControllerMsg.END_EDIT, endEditing);
		view.selectedOpCallBack = actionHandler;
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
				sendMessage(ControllerMsg.START_EDIT, action);
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