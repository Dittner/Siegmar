package dittner.gsa.view.main {

import dittner.gsa.backend.encryption.EncryptionService;
import dittner.gsa.bootstrap.deferredOperation.DeferredOperationManager;
import dittner.gsa.bootstrap.navigator.ViewNavigator;
import dittner.gsa.message.ControllerMsg;
import dittner.gsa.view.common.view.ViewBase;
import dittner.walter.WalterController;
import dittner.walter.message.WalterMessage;

public class MainController extends WalterController {

	[Inject]
	public var view:MainView;
	[Inject]
	public var deferredOperationManager:DeferredOperationManager;
	[Inject]
	public var encryptionService:EncryptionService;
	[Inject]
	public var viewNavigator:ViewNavigator;

	override protected function activate():void {
		listenModel(deferredOperationManager, DeferredOperationManager.START_EXECUTION_MSG, lockView);
		listenModel(deferredOperationManager, DeferredOperationManager.END_EXECUTION_MSG, unlockView);
		listenModel(encryptionService, EncryptionService.START_ENCRYPTING_MSG, lockView);
		listenModel(encryptionService, EncryptionService.END_ENCRYPTING_MSG, unlockView);
		listenModel(viewNavigator, ViewNavigator.SELECTED_VIEW_CHANGED_MSG, selectedViewChanged);
		listenController(ControllerMsg.LOCK, lockView);
		listenController(ControllerMsg.UNLOCK, unlockView);
	}

	private function selectedViewChanged(msg:WalterMessage):void {
		showView(msg.data as ViewBase);
	}

	private function showView(updatedView:ViewBase):void {
		view.removeView();
		if (view) view.addView(updatedView);
	}

	override protected function deactivate():void {
		throw new Error("Don't remove MainController, don't unregister MainView!");
	}

	private var lockRequestNum:int = 0;
	public function lockView(msg:WalterMessage):void {
		locked = true;
		lockRequestNum++;
	}

	public function unlockView(msg:WalterMessage):void {
		if (lockRequestNum > 0) lockRequestNum--;
		if (lockRequestNum == 0) locked = false;
	}

	//--------------------------------------
	//  locked
	//--------------------------------------
	private var _locked:Boolean = false;
	public function get locked():Boolean {return _locked;}
	public function set locked(value:Boolean):void {
		if (_locked != value) {
			_locked = value;
			if (locked) view.lock();
			else view.unlock();
		}
	}

}
}