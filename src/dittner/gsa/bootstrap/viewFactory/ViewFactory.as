package dittner.gsa.bootstrap.viewFactory {
import dittner.gsa.bootstrap.walter.WalterProxy;
import dittner.gsa.view.common.view.ViewBase;
import dittner.gsa.view.documentList.DocumentListView;
import dittner.gsa.view.documentView.DocumentView;
import dittner.gsa.view.login.LoginView;
import dittner.gsa.view.paintingView.PaintingView;

public class ViewFactory extends WalterProxy implements IViewFactory {

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
			case ViewID.DOCUMENT_VIEW :
				view = new DocumentView();
				break;
			case ViewID.PAINTING_VIEW :
				view = new PaintingView();
				break;
			default :
				throw new Error("Unknown view ID:" + viewID);
		}

		return view;
	}

}
}
