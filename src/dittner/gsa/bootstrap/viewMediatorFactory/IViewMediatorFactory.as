package dittner.gsa.bootstrap.viewMediatorFactory {
import dittner.gsa.bootstrap.walter.WalterMediator;

public interface IViewMediatorFactory {
	function create(viewId:String):WalterMediator;
}
}
