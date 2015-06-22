package dittner.gsa.bootstrap.viewMediatorFactory {
import dittner.gsa.bootstrap.viewFactory.ViewID;
import dittner.gsa.bootstrap.walter.WalterMediator;
import dittner.gsa.bootstrap.walter.WalterProxy;
import dittner.gsa.view.documentList.DocumentListMediator;
import dittner.gsa.view.login.LoginViewMediator;

public class ViewMediatorFactory extends WalterProxy implements IViewMediatorFactory {

	public function ViewMediatorFactory():void {}

	public function create(viewID:String):WalterMediator {
		var mediator:WalterMediator;
		switch (viewID) {
			case ViewID.LOGIN :
				mediator = new LoginViewMediator();
				break;
			case ViewID.DOCUMENT_LIST :
				mediator = new DocumentListMediator();
				break;
			default :
				throw new Error("Unknown view ID:" + viewID);
		}
		return mediator;
	}

}
}
