package de.dittner.siegmar {
import de.dittner.siegmar.backend.encryption.EncryptionService;
import de.dittner.siegmar.bootstrap.navigator.ViewNavigator;
import de.dittner.siegmar.bootstrap.viewFactory.ViewFactory;
import de.dittner.siegmar.bootstrap.viewFactory.ViewID;
import de.dittner.siegmar.bootstrap.viewMediatorFactory.ViewMediatorFactory;
import de.dittner.siegmar.bootstrap.walter.Walter;
import de.dittner.siegmar.domain.fileSystem.SiegmarFileSystem;
import de.dittner.siegmar.domain.store.FileStorage;
import de.dittner.siegmar.domain.user.User;
import de.dittner.siegmar.view.main.MainView;
import de.dittner.siegmar.view.main.MainViewMediator;

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
