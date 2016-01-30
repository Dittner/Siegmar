package dittner.siegmar.bootstrap.viewMediatorFactory {
import dittner.siegmar.bootstrap.viewFactory.ViewID;
import dittner.siegmar.bootstrap.walter.WalterMediator;
import dittner.siegmar.bootstrap.walter.WalterProxy;
import dittner.siegmar.view.fileList.FileListMediator;
import dittner.siegmar.view.fileView.FileViewMediator;
import dittner.siegmar.view.login.LoginViewMediator;
import dittner.siegmar.view.painting.PaintingViewMediator;
import dittner.siegmar.view.settings.SettingsViewMediator;

public class ViewMediatorFactory extends WalterProxy implements IViewMediatorFactory {

	public function ViewMediatorFactory():void {}

	public function create(viewID:String):WalterMediator {
		var mediator:WalterMediator;
		switch (viewID) {
			case ViewID.LOGIN :
				mediator = new LoginViewMediator();
				break;
			case ViewID.FILE_LIST :
				mediator = new FileListMediator();
				break;
			case ViewID.FILE_VIEW :
				mediator = new FileViewMediator();
				break;
			case ViewID.PAINTING :
				mediator = new PaintingViewMediator();
				break;
			case ViewID.SETTINGS :
				mediator = new SettingsViewMediator();
				break;
			default :
				throw new Error("Unknown view ID:" + viewID);
		}
		return mediator;
	}

}
}
