package dittner.gsa.view.login {
import dittner.gsa.bootstrap.async.IAsyncOperation;
import dittner.gsa.bootstrap.navigator.ViewNavigator;
import dittner.gsa.bootstrap.viewFactory.ViewID;
import dittner.gsa.bootstrap.walter.WalterMediator;
import dittner.gsa.domain.fileSystem.GSAFileSystem;
import dittner.gsa.domain.store.FileStorage;
import dittner.gsa.domain.user.User;
import dittner.gsa.utils.AppInfo;
import dittner.gsa.utils.delay.doLaterInMSec;

import flash.events.MouseEvent;

import mx.events.FlexEvent;

public class LoginViewMediator extends WalterMediator {

	[Inject]
	public var view:LoginView;
	[Inject]
	public var viewNavigator:ViewNavigator;
	[Inject]
	public var user:User;
	[Inject]
	public var fileStorage:FileStorage;
	[Inject]
	public var system:GSAFileSystem;

	override protected function activate():void {
		view.isLoginSuccess = false;
		view.completeBtn.addEventListener(MouseEvent.CLICK, completeHandler);
		view.passwordInput.addEventListener(FlexEvent.ENTER, completeHandler);
		view.privacyLevelInput.addEventListener(FlexEvent.ENTER, completeHandler);
		view.dataBasePasswordInput.addEventListener(FlexEvent.ENTER, completeHandler);
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
		if (view.isLoginSuccess) return;
		if (view.passwordInput.text.length <= AppInfo.MIN_PWD_LEN) return;
		var op:IAsyncOperation;
		if (user.isRegistered)
			op = user.login(enteredPwd, enteredPL, enteredDataBasePwd);
		else
			op = user.register(enteredName, enteredPwd, enteredPL, enteredDataBasePwd);
		op.addCompleteCallback(loginHandler);
	}

	private function get enteredPwd():String {return view.passwordInput.text;}
	private function get enteredName():String {return view.userNameInput.text;}
	private function get enteredPL():uint {return uint(view.privacyLevelInput.text);}
	private function get enteredDataBasePwd():String {return view.dataBasePasswordInput.text;}

	private function loginHandler(op:IAsyncOperation):void {
		if (op.isSuccess) {
			view.isLoginWithError = false;
			view.errorLbl.text = "";
			var initOp:IAsyncOperation = system.initialize();
			initOp.addCompleteCallback(systemInitialized);
		}
		else {
			view.isLoginWithError = true;
			view.errorLbl.text = op.error;
		}
	}

	private function systemInitialized(op:IAsyncOperation):void {
		if (op.isSuccess) {
			view.isLoginSuccess = true;
			doLaterInMSec(navigateToFileList, 500);
		}
		else {
			view.isLoginWithError = true;
			view.errorLbl.text = op.error;
		}
	}

	private function navigateToFileList():void {
		viewNavigator.navigate(ViewID.FILE_LIST);
	}

	override protected function deactivate():void {
		view.completeBtn.removeEventListener(MouseEvent.CLICK, completeHandler);
		view.passwordInput.removeEventListener(FlexEvent.ENTER, completeHandler);
		view.privacyLevelInput.removeEventListener(FlexEvent.ENTER, completeHandler);
		view.dataBasePasswordInput.removeEventListener(FlexEvent.ENTER, completeHandler);
		view.userNameInput.removeEventListener(FlexEvent.ENTER, completeHandler);
		view.clear();
	}
}
}