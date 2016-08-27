package de.dittner.siegmar.bootstrap.viewMediatorFactory {
import de.dittner.siegmar.bootstrap.walter.WalterMediator;

public interface IViewMediatorFactory {
	function create(viewId:String):WalterMediator;
}
}
