package de.dittner.siegmar.bootstrap.viewFactory {
import de.dittner.siegmar.view.common.view.ViewBase;

public interface IViewFactory {
	function createView(viewId:String):ViewBase;
}
}
