package dittner.gsa.view.login {
import dittner.gsa.bootstrap.navigator.ViewNavigator;
import dittner.gsa.bootstrap.viewFactory.ViewID;
import dittner.gsa.domain.user.IUser;
import dittner.gsa.utils.AppInfo;
import dittner.gsa.bootstrap.async.AsyncOperationResult;
import dittner.gsa.bootstrap.async.IAsyncOperation;
import dittner.walter.WalterController;

import flash.events.MouseEvent;

import mx.events.FlexEvent;

public class LoginController extends WalterController {

	[Inject]
	public var view:LoginView;
	[Inject]
	public var viewNavigator:ViewNavigator;
	[Inject]
	public var user:IUser;

	override protected function activate():void {
		view.completeBtn.addEventListener(MouseEvent.CLICK, completeHandler);
		view.passwordInput.addEventListener(FlexEvent.ENTER, completeHandler);
		view.privacyLevelInput.addEventListener(FlexEvent.ENTER, completeHandler);
		view.userNameInput.addEventListener(FlexEvent.ENTER, completeHandler);

		if (user.isRegistered) {
			view.userName = user.userName;
			view.authorizeUser();
		}
		else {
			view.userName = "";
			view.registerUser();
		}
	}

	private function completeHandler(event:*):void {
		if (view.passwordInput.text.length <= AppInfo.MIN_PWD_LEN) return;
		var op:IAsyncOperation;
		op = user.isRegistered ? user.login(enteredPwd, enteredPL) : user.register(enteredName, enteredPwd, enteredPL);
		op.addCompleteCallback(loginHandler);
	}

	private function get enteredPwd():String {return view.passwordInput.text;}
	private function get enteredName():String {return view.userNameInput.text;}
	private function get enteredPL():uint {return uint(view.privacyLevelInput.text);}

	private function loginHandler(result:AsyncOperationResult):void {
		if (result.isSuccess) {
			view.isInvalidPassword = false;
			viewNavigator.navigate(ViewID.DOCUMENT_LIST);
		}
		else {
			view.isInvalidPassword = true;
		}
	}

	override protected function deactivate():void {
		view.completeBtn.removeEventListener(MouseEvent.CLICK, completeHandler);
		view.passwordInput.removeEventListener(FlexEvent.ENTER, completeHandler);
		view.privacyLevelInput.removeEventListener(FlexEvent.ENTER, completeHandler);
		view.userNameInput.removeEventListener(FlexEvent.ENTER, completeHandler);
		view.clear();
	}
}
}