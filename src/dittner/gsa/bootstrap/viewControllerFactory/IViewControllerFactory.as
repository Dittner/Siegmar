package dittner.gsa.bootstrap.viewControllerFactory {
import dittner.walter.WalterController;

public interface IViewControllerFactory {
	function create(viewId:String):WalterController;
}
}
