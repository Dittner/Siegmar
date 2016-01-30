package dittner.siegmar.bootstrap.viewMediatorFactory {
import dittner.siegmar.bootstrap.walter.WalterMediator;

public interface IViewMediatorFactory {
	function create(viewId:String):WalterMediator;
}
}
