package de.dittner.siegmar.view.login {
import de.dittner.siegmar.view.login.*;
import dittner.async.IAsyncOperation;
import dittner.async.utils.doLaterInMSec;
import de.dittner.siegmar.bootstrap.navigator.ViewNavigator;
import de.dittner.siegmar.bootstrap.viewFactory.ViewID;
import de.dittner.siegmar.bootstrap.walter.WalterMediator;
import de.dittner.siegmar.domain.fileSystem.SiegmarFileSystem;
import de.dittner.siegmar.domain.store.FileStorage;
import de.dittner.siegmar.domain.user.User;
import de.dittner.siegmar.message.MediatorMsg;
import de.dittner.siegmar.utils.AppInfo;

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
	public var system:SiegmarFileSystem;

	override protected function activate():void {
		view.vm = this;
		view.isLoginSuccess = false;

		if (user.isRegistered) {
			view.userName = user.userName;
			view.authorizeUser();
		}
		else {
			view.userName = "";
			view.registerUser();
		}
	}

	public function login():void {
		if (view.isLoginSuccess) return;
		if (view.passwordInput.text.length <= AppInfo.MIN_PWD_LEN) return;
		var op:IAsyncOperation;
		if (user.isRegistered)
			op = user.login(enteredPwd, enteredPL, enteredDataBasePwd);
		else
			op = user.register(enteredName, enteredPwd, enteredPL, enteredDataBasePwd);
		op.addCompleteCallback(loginHandler);
		sendMessage(MediatorMsg.LOCK);
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
			sendMessage(MediatorMsg.UNLOCK);
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
		sendMessage(MediatorMsg.UNLOCK);
		viewNavigator.navigate(ViewID.FILE_LIST);
	}

	override protected function deactivate():void {
		view.clear();
	}
}
}