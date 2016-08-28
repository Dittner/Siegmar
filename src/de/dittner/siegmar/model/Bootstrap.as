package de.dittner.siegmar.model {
import de.dittner.siegmar.backend.DeferredCommandManager;
import de.dittner.siegmar.backend.EncryptionService;
import de.dittner.siegmar.backend.FileStorage;
import de.dittner.siegmar.domain.fileSystem.SiegmarFileSystem;
import de.dittner.siegmar.domain.user.User;
import de.dittner.siegmar.logging.CLog;
import de.dittner.siegmar.logging.LogCategory;
import de.dittner.siegmar.view.common.view.ViewFactory;
import de.dittner.siegmar.view.common.view.ViewModelFactory;
import de.dittner.siegmar.view.common.view.ViewNavigator;
import de.dittner.siegmar.view.fileList.FileListVM;
import de.dittner.siegmar.view.fileList.form.FileHeaderFormVM;
import de.dittner.siegmar.view.fileView.FileViewVM;
import de.dittner.siegmar.view.login.LoginVM;
import de.dittner.siegmar.view.main.MainVM;
import de.dittner.siegmar.view.main.MainView;
import de.dittner.siegmar.view.painting.PaintingVM;
import de.dittner.siegmar.view.settings.SettingsVM;
import de.dittner.walter.Walter;
import de.dittner.walter.walter_namespace;

use namespace walter_namespace;

public class Bootstrap extends Walter {
	public function Bootstrap(mainView:MainView) {
		super();
		this.mainView = mainView;
	}

	//----------------------------------------------------------------------------------------------
	//
	//  Methods
	//
	//----------------------------------------------------------------------------------------------

	private var mainView:MainView;

	public function start():void {
		var storage:FileStorage = new FileStorage();
		registerProxy("fileStorage", storage);
		registerProxy("user", new User());
		registerProxy("encryptionService", new EncryptionService());
		registerProxy("deferredCommandManager", new DeferredCommandManager());
		registerProxy("viewNavigator", new ViewNavigator());
		registerProxy("viewFactory", new ViewFactory());
		registerProxy("vmFactory", new ViewModelFactory());
		registerProxy("system", new SiegmarFileSystem());

		registerProxy("mainVM", new MainVM());
		registerProxy("loginVM", new LoginVM());
		registerProxy("fileListVM", new FileListVM());
		registerProxy("fileHeaderFormVM", new FileHeaderFormVM());
		registerProxy("fileViewVM", new FileViewVM());
		registerProxy("paintingVM", new PaintingVM());
		registerProxy("settingsVM", new SettingsVM());

		if (pendingInjectProxies.length > 0)
			CLog.err(LogCategory.SYSTEM, "Invalid proxies keys or names! Please check it!");
		showFirstView();
	}

	private function showFirstView():void {
		var viewNavigator:ViewNavigator = getProxy("viewNavigator") as ViewNavigator;
		var viewFactory:ViewFactory = getProxy("viewFactory") as ViewFactory;
		viewNavigator.navigate(viewFactory.firstViewID);
		mainView.activate();
	}

}
}
