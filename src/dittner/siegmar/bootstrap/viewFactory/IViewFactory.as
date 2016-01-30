package dittner.siegmar.bootstrap.viewFactory {
import dittner.siegmar.view.common.view.ViewBase;

public interface IViewFactory {
	function createView(viewId:String):ViewBase;
}
}
