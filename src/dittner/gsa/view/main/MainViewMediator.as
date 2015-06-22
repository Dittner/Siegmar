package dittner.gsa.view.main {

import dittner.gsa.backend.encryption.EncryptionService;
import dittner.gsa.bootstrap.deferredOperation.DeferredOperationManager;
import dittner.gsa.bootstrap.navigator.ViewNavigator;
import dittner.gsa.bootstrap.walter.WalterMediator;
import dittner.gsa.bootstrap.walter.message.WalterMessage;
import dittner.gsa.message.MediatorMsg;
import dittner.gsa.view.common.view.ViewBase;

public class MainViewMediator extends WalterMediator {

	[Inject]
	public var view:MainView;
	[Inject]
	public var deferredOperationManager:DeferredOperationManager;
	[Inject]
	public var encryptionService:EncryptionService;
	[Inject]
	public var viewNavigator:ViewNavigator;

	override protected function activate():void {
		listenProxy(deferredOperationManager, DeferredOperationManager.START_EXECUTION_MSG, lockView);
		listenProxy(deferredOperationManager, DeferredOperationManager.END_EXECUTION_MSG, unlockView);
		listenProxy(encryptionService, EncryptionService.START_ENCRYPTING_MSG, lockView);
		listenProxy(encryptionService, EncryptionService.END_ENCRYPTING_MSG, unlockView);
		listenProxy(viewNavigator, ViewNavigator.SELECTED_VIEW_CHANGED_MSG, selectedViewChanged);
		listenMediator(MediatorMsg.LOCK, lockView);
		listenMediator(MediatorMsg.UNLOCK, unlockView);
	}

	private function selectedViewChanged(msg:WalterMessage):void {
		showView(msg.data as ViewBase);
	}

	private function showView(updatedView:ViewBase):void {
		view.removeView();
		if (view) view.addView(updatedView);
	}

	override protected function deactivate():void {
		throw new Error("Don't remove MainMediator, don't unregister MainView!");
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