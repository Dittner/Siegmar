package dittner.siegmar.view.fileList {
import dittner.siegmar.bootstrap.walter.WalterMediator;
import dittner.siegmar.view.fileList.favorites.FavoriteFileHeaderListMediator;
import dittner.siegmar.view.fileList.form.FileHeaderFormMediator;
import dittner.siegmar.view.fileList.list.FileHeaderListMediator;
import dittner.siegmar.view.fileList.toolbar.ToolbarMediator;

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