package dittner.gsa.bootstrap.viewMediatorFactory {
import dittner.gsa.bootstrap.viewFactory.ViewID;
import dittner.gsa.bootstrap.walter.WalterMediator;
import dittner.gsa.bootstrap.walter.WalterProxy;
import dittner.gsa.view.fileList.FileListMediator;
import dittner.gsa.view.fileView.FileViewMediator;
import dittner.gsa.view.login.LoginViewMediator;
import dittner.gsa.view.painting.PaintingViewMediator;
import dittner.gsa.view.settings.SettingsViewMediator;

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
