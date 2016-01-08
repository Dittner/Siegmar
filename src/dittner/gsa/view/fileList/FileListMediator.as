package dittner.gsa.view.fileList {
import dittner.gsa.bootstrap.walter.WalterMediator;
import dittner.gsa.view.fileList.form.FileHeaderFormMediator;
import dittner.gsa.view.fileList.list.FileHeaderListMediator;
import dittner.gsa.view.fileList.toolbar.ToolbarMediator;

public class FileListMediator extends WalterMediator {

	[Inject]
	public var view:FileListView;

	override protected function activate():void {
		registerMediator(view.fileHeaderList, new FileHeaderListMediator());
		registerMediator(view.toolbar, new ToolbarMediator());
		registerMediator(view.fileHeaderForm, new FileHeaderFormMediator());
	}

	override protected function deactivate():void {}

}
}