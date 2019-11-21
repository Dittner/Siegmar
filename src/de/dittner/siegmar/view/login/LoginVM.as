package de.dittner.siegmar.view.login {
import de.dittner.async.IAsyncOperation;
import de.dittner.siegmar.backend.FileStorage;
import de.dittner.siegmar.model.Device;
import de.dittner.siegmar.model.domain.fileSystem.SiegmarFileSystem;
import de.dittner.siegmar.model.domain.user.User;
import de.dittner.siegmar.view.common.view.ViewID;
import de.dittner.siegmar.view.common.view.ViewModel;
import de.dittner.siegmar.view.common.view.ViewNavigator;

public class LoginVM extends ViewModel {
	public function LoginVM() {
		super();
	}

	[Inject]
	public var viewNavigator:ViewNavigator;
	[Inject]
	public var user:User;
	[Inject]
	public var fileStorage:FileStorage;
	[Inject]
	public var system:SiegmarFileSystem;

	[Bindable]
	public var isLoginSuccess:Boolean = false;
	[Bindable]
	public var isLoginWithError:Boolean = false;
	[Bindable]
	public var errorText:String = "";

	override public function viewActivated():void {
		super.viewActivated();
		isLoginSuccess = false;
	}

	public function login(userName:String, pwd:String, privacyLevel:String, dbPwd:String):void {
		if (isLoginSuccess) return;
		if (pwd.length <= Device.MIN_PWD_LEN) return;
		var op:IAsyncOperation;
		if (user.isRegistered)
			op = user.login(pwd, uint(privacyLevel), dbPwd);
		else
			op = user.register(userName, pwd, uint(privacyLevel), dbPwd);
		op.addCompleteCallback(loginHandler);
		lockView();
	}

	private function loginHandler(op:IAsyncOperation):void {
		if (op.isSuccess) {
			isLoginWithError = false;
			errorText = "";
			var initOp:IAsyncOperation = system.initialize();
			initOp.addCompleteCallback(systemInitialized);
		}
		else {
			isLoginWithError = true;
			errorText = op.error;
			unlockView();
		}
	}

	private function systemInitialized(op:IAsyncOperation):void {
		if (op.isSuccess) {
			isLoginSuccess = true;
			navigateToFileList();
		}
		else {
			isLoginWithError = true;
			errorText = op.error;
		}
	}

	private function navigateToFileList():void {
		unlockView();
		viewNavigator.navigate(ViewID.FILE_LIST);
	}
}
}