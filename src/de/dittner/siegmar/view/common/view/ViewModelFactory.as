package de.dittner.siegmar.view.common.view {
import de.dittner.siegmar.view.fileList.FileListVM;
import de.dittner.siegmar.view.fileList.form.FileHeaderFormVM;
import de.dittner.siegmar.view.fileView.FileViewVM;
import de.dittner.siegmar.view.login.LoginVM;
import de.dittner.siegmar.view.main.MainVM;
import de.dittner.siegmar.view.painting.PaintingVM;
import de.dittner.siegmar.view.settings.SettingsVM;
import de.dittner.walter.WalterProxy;

public class ViewModelFactory extends WalterProxy {
	public static var instance:ViewModelFactory;

	public function ViewModelFactory() {
		super();
		if (instance) throw new Error("ViewFactory must be Singleton!");
		instance = this;
	}

	[Inject]
	public var mainVM:MainVM;
	[Inject]
	public var loginVM:LoginVM;
	[Inject]
	public var fileListVM:FileListVM;
	[Inject]
	public var fileHeaderFormVM:FileHeaderFormVM;
	[Inject]
	public var fileViewVM:FileViewVM;
	[Inject]
	public var paintingVM:PaintingVM;
	[Inject]
	public var settingsVM:SettingsVM;

}
}
