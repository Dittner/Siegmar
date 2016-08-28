package de.dittner.siegmar.view.common.view {
import de.dittner.siegmar.view.main.MainVM;
import de.dittner.walter.WalterProxy;

import flash.events.Event;

public class ViewModel extends WalterProxy {
	public function ViewModel() {
		super();
	}

	[Inject]
	public var mainVM:MainVM;

	//--------------------------------------
	//  isActive
	//--------------------------------------
	private var _isActive:Boolean = false;
	[Bindable("isActiveChanged")]
	public function get isActive():Boolean {return _isActive;}
	public function set isActive(value:Boolean):void {
		if (_isActive != value) {
			_isActive = value;
			dispatchEvent(new Event("isActiveChanged"));
		}
	}

	public function viewActivated():void {
		isActive = true;
	}

	public function viewDeactivated():void {
		isActive = false;
	}

	public function lockView():void {
		if (mainVM) mainVM.viewLocked = true;
	}

	public function unlockView():void {
		if (mainVM) mainVM.viewLocked = false;
	}
}
}
