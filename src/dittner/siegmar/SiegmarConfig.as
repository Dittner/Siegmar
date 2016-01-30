package dittner.siegmar {
import dittner.siegmar.backend.encryption.EncryptionService;
import dittner.siegmar.bootstrap.navigator.ViewNavigator;
import dittner.siegmar.bootstrap.viewFactory.ViewFactory;
import dittner.siegmar.bootstrap.viewFactory.ViewID;
import dittner.siegmar.bootstrap.viewMediatorFactory.ViewMediatorFactory;
import dittner.siegmar.bootstrap.walter.Walter;
import dittner.siegmar.domain.fileSystem.SiegmarFileSystem;
import dittner.siegmar.domain.store.FileStorage;
import dittner.siegmar.domain.user.User;
import dittner.siegmar.view.main.MainView;
import dittner.siegmar.view.main.MainViewMediator;

import mx.core.IVisualElementContainer;

public class SiegmarConfig extends Walter {

	public function start(root:IVisualElementContainer):void {
		var viewNavigator:ViewNavigator = new ViewNavigator();
		registerProxy("fileStorage", new FileStorage);
		registerProxy("viewFactory", new ViewFactory());
		registerProxy("viewMediatorFactory", new ViewMediatorFactory());
		registerProxy("viewNavigator", viewNavigator);
		registerProxy("encryptionService", new EncryptionService);
		registerProxy("system", new SiegmarFileSystem());
		registerProxy("user", new User());

		const mainView:MainView = new MainView();
		mainView.percentHeight = 100;
		mainView.percentWidth = 100;
		root.addElement(mainView);
		registerMediator(mainView, new MainViewMediator());
		viewNavigator.navigate(ViewID.LOGIN);
	}

}
}
