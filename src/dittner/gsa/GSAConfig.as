package dittner.gsa {
import dittner.gsa.backend.encryption.EncryptionService;
import dittner.gsa.bootstrap.navigator.ViewNavigator;
import dittner.gsa.bootstrap.viewFactory.ViewFactory;
import dittner.gsa.bootstrap.viewFactory.ViewID;
import dittner.gsa.bootstrap.viewMediatorFactory.ViewMediatorFactory;
import dittner.gsa.bootstrap.walter.Walter;
import dittner.gsa.domain.fileSystem.GSAFileSystem;
import dittner.gsa.domain.store.FileStorage;
import dittner.gsa.domain.user.User;
import dittner.gsa.view.main.MainView;
import dittner.gsa.view.main.MainViewMediator;

import mx.core.IVisualElementContainer;

public class GSAConfig extends Walter {

	public function start(root:IVisualElementContainer):void {
		var viewNavigator:ViewNavigator = new ViewNavigator();
		registerProxy("fileStorage", new FileStorage);
		registerProxy("viewFactory", new ViewFactory());
		registerProxy("viewMediatorFactory", new ViewMediatorFactory());
		registerProxy("viewNavigator", viewNavigator);
		registerProxy("encryptionService", new EncryptionService);
		registerProxy("system", new GSAFileSystem());
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
