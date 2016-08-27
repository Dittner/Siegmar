package de.dittner.siegmar.view.common.view {
import de.dittner.siegmar.bootstrap.walter.WalterMediator;

public interface IViewMediatorFactory {
	function create(viewId:String):WalterMediator;
}
}
