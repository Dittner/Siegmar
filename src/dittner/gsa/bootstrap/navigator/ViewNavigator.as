package dittner.gsa.bootstrap.navigator {
import dittner.gsa.bootstrap.viewFactory.IViewFactory;
import dittner.gsa.bootstrap.viewMediatorFactory.IViewMediatorFactory;
import dittner.gsa.bootstrap.walter.WalterMediator;
import dittner.gsa.bootstrap.walter.WalterProxy;
import dittner.gsa.bootstrap.walter.walter_namespace;
import dittner.gsa.view.common.view.ViewBase;

use namespace walter_namespace;

public class ViewNavigator extends WalterProxy {
	public static const SELECTED_VIEW_CHANGED_MSG:String = "selectedViewChangedMsg";

	[Inject]
	public var viewFactory:IViewFactory;
	[Inject]
	public var viewMediatorFactory:IViewMediatorFactory;

	private var selectedMediator:WalterMediator;

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
			unregisterMediator();
			_selectedViewID = viewID;
			_selectedView = viewFactory.createView(selectedViewID);
			registerMediator();
			sendMessage(SELECTED_VIEW_CHANGED_MSG, selectedView);
		}
	}

	private function unregisterMediator():void {
		if (!selectedView) return;
		walter.unregisterMediator(selectedMediator);
	}

	private function registerMediator():void {
		var mediator:WalterMediator = viewMediatorFactory.create(selectedViewID);
		walter.registerMediator(selectedView, mediator);
		selectedMediator = mediator;
	}

	override protected function activate():void {}

	override protected function deactivate():void {}

}
}