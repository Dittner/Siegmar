package dittner.siegmar.bootstrap.viewFactory {
import dittner.siegmar.bootstrap.walter.WalterProxy;
import dittner.siegmar.view.common.view.ViewBase;
import dittner.siegmar.view.fileList.FileListView;
import dittner.siegmar.view.fileView.FileView;
import dittner.siegmar.view.login.LoginView;
import dittner.siegmar.view.painting.PaintingView;
import dittner.siegmar.view.settings.SettingsView;

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
