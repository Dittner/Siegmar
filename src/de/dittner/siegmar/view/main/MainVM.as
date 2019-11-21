package de.dittner.siegmar.view.main {
import de.dittner.siegmar.view.common.view.ViewNavigator;
import de.dittner.walter.WalterProxy;

import flash.events.Event;

public class MainVM extends WalterProxy {
	public function MainVM() {
		super();
	}

	[Bindable]
	[Inject]
	public var viewNavigator:ViewNavigator;

	//--------------------------------------
	//  currentState
	//--------------------------------------
	private var _currentState:String = "normal";
	[Bindable("currentStateChanged")]
	public function get currentState():String {return _currentState;}
	public function set currentState(value:String):void {
		if (_currentState != value) {
			_currentState = value;
			dispatchEvent(new Event("currentStateChanged"));
		}
	}

	//--------------------------------------
	//  viewLocked
	//--------------------------------------
	private var _viewLocked:Boolean = false;
	[Bindable("viewLockedChanged")]
	public function get viewLocked():Boolean {return _viewLocked;}
	public function set viewLocked(value:Boolean):void {
		if (_viewLocked != value) {
			_viewLocked = value;
			currentState = _viewLocked ? "lock" : "normal";
			dispatchEvent(new Event("viewLockedChanged"));
		}
	}

	override protected function deactivate():void {
		throw new Error("Don't remove MainVM, don't unregister MainVM!");
	}

}
}