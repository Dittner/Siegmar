package dittner.gsa {
import dittner.gsa.backend.encryption.EncryptionService;
import dittner.gsa.backend.sqlOperation.SQLFactory;
import dittner.gsa.bootstrap.deferredOperation.DeferredOperationManager;
import dittner.gsa.bootstrap.navigator.ViewNavigator;
import dittner.gsa.bootstrap.viewFactory.ViewFactory;
import dittner.gsa.bootstrap.viewFactory.ViewID;
import dittner.gsa.bootstrap.viewControllerFactory.ViewControllerFactory;
import dittner.gsa.domain.fileSystem.GSAFileSystem;
import dittner.gsa.domain.store.FileStorage;
import dittner.gsa.domain.user.User;
import dittner.gsa.view.main.MainView;
import dittner.gsa.view.main.MainController;
import dittner.walter.Walter;

import mx.core.IVisualElementContainer;

public class GSAConfig extends Walter {

	public function start(root:IVisualElementContainer):void {
		var viewNavigator:ViewNavigator = new ViewNavigator();
		registerModel("deferredOperationManager", new DeferredOperationManager());
		registerModel("viewFactory", new ViewFactory());
		registerModel("viewControllerFactory", new ViewControllerFactory());
		registerModel("viewNavigator", viewNavigator);
		registerModel("sqlFactory", new SQLFactory);
		registerModel("encryptionService", new EncryptionService);
		registerModel("fileStorage", new FileStorage);
		registerModel("system", new GSAFileSystem());
		registerModel("user", new User());

		const mainView:MainView = new MainView();
		mainView.percentHeight = 100;
		mainView.percentWidth = 100;
		root.addElement(mainView);
		registerController(mainView, new MainController());
		viewNavigator.navigate(ViewID.LOGIN);
	}

}
}
