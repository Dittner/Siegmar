package dittner.gsa.bootstrap.viewControllerFactory {
import dittner.gsa.bootstrap.viewFactory.ViewID;
import dittner.gsa.view.documentList.DocumentListController;
import dittner.gsa.view.login.LoginController;
import dittner.walter.WalterController;
import dittner.walter.WalterModel;

public class ViewControllerFactory extends WalterModel implements IViewControllerFactory {

	public function ViewControllerFactory():void {}

	public function createViewMediator(viewID:String):WalterController {
		var mediator:WalterController;
		switch (viewID) {
			case ViewID.LOGIN :
				mediator = new LoginController();
				break;
			case ViewID.DOCUMENT_LIST :
				mediator = new DocumentListController();
				break;
			default :
				throw new Error("Unknown view ID:" + viewID);
		}
		return mediator;
	}

}
}
