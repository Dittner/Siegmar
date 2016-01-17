package dittner.gsa.bootstrap.viewFactory {
import dittner.gsa.bootstrap.walter.WalterProxy;
import dittner.gsa.view.common.view.ViewBase;
import dittner.gsa.view.fileList.FileListView;
import dittner.gsa.view.fileView.FileView;
import dittner.gsa.view.login.LoginView;
import dittner.gsa.view.painting.PaintingView;
import dittner.gsa.view.settings.SettingsView;

public class ViewFactory extends WalterProxy implements IViewFactory {

	public function ViewFactory():void {}

	public function createView(viewID:String):ViewBase {
		var view:ViewBase;
		switch (viewID) {
			case ViewID.LOGIN :
				view = new LoginView();
				break;
			case ViewID.FILE_LIST :
				view = new FileListView();
				break;
			case ViewID.FILE_VIEW :
				view = new FileView();
				break;
			case ViewID.PAINTING :
				view = new PaintingView();
				break;
			case ViewID.SETTINGS :
				view = new SettingsView();
				break;
			default :
				throw new Error("Unknown view ID:" + viewID);
		}

		return view;
	}

}
}
