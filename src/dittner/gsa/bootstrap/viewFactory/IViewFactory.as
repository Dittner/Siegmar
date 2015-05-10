package dittner.gsa.bootstrap.viewFactory {
import dittner.gsa.view.common.view.ViewBase;

public interface IViewFactory {
	function createView(viewId:String):ViewBase;
}
}
