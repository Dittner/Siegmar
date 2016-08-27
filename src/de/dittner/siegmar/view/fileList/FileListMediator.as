package de.dittner.siegmar.view.fileList {
import de.dittner.siegmar.bootstrap.walter.WalterMediator;
import de.dittner.siegmar.view.fileList.favorites.FavoriteFileHeaderListMediator;
import de.dittner.siegmar.view.fileList.form.FileHeaderFormMediator;
import de.dittner.siegmar.view.fileList.list.FileHeaderListMediator;
import de.dittner.siegmar.view.fileList.toolbar.ToolbarMediator;

public class FileListMediator extends WalterMediator {

	[Inject]
	public var view:FileListView;

	override protected function activate():void {
		registerMediator(view.favoritesList, new FavoriteFileHeaderListMediator());
		registerMediator(view.fileHeaderList, new FileHeaderListMediator());
		registerMediator(view.toolbar, new ToolbarMediator());
		registerMediator(view.fileHeaderForm, new FileHeaderFormMediator());
	}

	override protected function deactivate():void {}

}
}