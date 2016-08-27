package de.dittner.siegmar.view.common.view {
import de.dittner.siegmar.view.common.view.ViewBase;

public interface IViewFactory {
	function createView(viewId:String):ViewBase;
}
}
