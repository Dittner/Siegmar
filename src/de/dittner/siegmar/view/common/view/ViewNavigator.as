package de.dittner.siegmar.view.common.view {
import de.dittner.walter.WalterProxy;
import de.dittner.walter.walter_namespace;

import flash.events.Event;

use namespace walter_namespace;

public class ViewNavigator extends WalterProxy {
	public static const SELECTED_VIEW_CHANGED_MSG:String = "selectedViewChangedMsg";
	public function ViewNavigator() {
		super();
	}

	[Inject]
	public var viewFactory:IViewFactory;


	//--------------------------------------
	//  selectedView
	//--------------------------------------
	private var _selectedView:ViewBase;
	[Bindable("selectedViewChanged")]
	public function get selectedView():ViewBase {return _selectedView;}
	private function setSelectedView(value:ViewBase):void {
		if (_selectedView != value) {
			_selectedView = value;
			dispatchEvent(new Event("selectedViewChanged"));
		}
	}

	//----------------------------------------------------------------------------------------------
	//
	//  Methods
	//
	//----------------------------------------------------------------------------------------------

	public function navigate(viewID:String):void {
		if (selectedView && selectedView.viewID == viewID) return;
		if (_selectedView) _selectedView.invalidate(NavigationPhase.VIEW_REMOVE);

		setSelectedView(viewFactory.createView(viewID));
		selectedView.invalidate(NavigationPhase.VIEW_ACTIVATE);

		sendMessage(SELECTED_VIEW_CHANGED_MSG, selectedView);
	}

	override protected function activate():void {}

	override protected function deactivate():void {}

}
}