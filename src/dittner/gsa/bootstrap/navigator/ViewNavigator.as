package dittner.gsa.bootstrap.navigator {
import dittner.gsa.bootstrap.viewControllerFactory.IViewControllerFactory;
import dittner.gsa.bootstrap.viewFactory.IViewFactory;
import dittner.gsa.view.common.view.ViewBase;
import dittner.walter.WalterController;
import dittner.walter.WalterModel;
import dittner.walter.walter_namespace;

use namespace walter_namespace;

public class ViewNavigator extends WalterModel {
	public static const SELECTED_VIEW_CHANGED_MSG:String = "selectedViewChangedMsg";

	[Inject]
	public var viewFactory:IViewFactory;
	[Inject]
	public var viewControllerFactory:IViewControllerFactory;

	private var selectedController:WalterController;

	//--------------------------------------
	//  selectedViewID
	//--------------------------------------
	private var _selectedViewID:String = "";
	public function get selectedViewID():String {return _selectedViewID;}

	//--------------------------------------
	//  selectedView
	//--------------------------------------
	private var _selectedView:ViewBase;
	public function get selectedView():ViewBase {return _selectedView;}

	//----------------------------------------------------------------------------------------------
	//
	//  Methods
	//
	//----------------------------------------------------------------------------------------------

	public function navigate(viewID:String):void {
		if (_selectedViewID != viewID) {
			unregisterController();
			_selectedViewID = viewID;
			_selectedView = viewFactory.createView(selectedViewID);
			registerController();
			sendMessage(SELECTED_VIEW_CHANGED_MSG, selectedView);
		}
	}

	private function registerController():void {
		var controller:WalterController = viewControllerFactory.create(selectedViewID);
		walter.registerController(selectedView, controller);
		selectedController = controller;
	}

	private function unregisterController():void {
		if (!selectedView) return;
		walter.unregisterController(selectedController);
	}

	override protected function activate():void {}

	override protected function deactivate():void {}

}
}