package dittner.gsa.bootstrap.viewFactory {
import dittner.gsa.view.common.view.ViewBase;
import dittner.gsa.view.documentList.DocumentListView;
import dittner.gsa.view.login.LoginView;
import dittner.walter.WalterModel;

public class ViewFactory extends WalterModel implements IViewFactory {

	public function ViewFactory():void {}

	public function createView(viewID:String):ViewBase {
		var view:ViewBase;
		switch (viewID) {
			case ViewID.LOGIN :
				view = new LoginView();
				break;
			case ViewID.DOCUMENT_LIST :
				view = new DocumentListView();
				break;
			default :
				throw new Error("Unknown view ID:" + viewID);
		}

		return view;
	}

}
}
