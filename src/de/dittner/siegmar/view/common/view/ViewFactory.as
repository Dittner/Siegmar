package de.dittner.siegmar.view.common.view {
import de.dittner.siegmar.bootstrap.walter.WalterProxy;
import de.dittner.siegmar.view.fileList.FileListView;
import de.dittner.siegmar.view.fileView.FileView;
import de.dittner.siegmar.view.login.LoginView;
import de.dittner.siegmar.view.painting.PaintingView;
import de.dittner.siegmar.view.settings.SettingsView;

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
