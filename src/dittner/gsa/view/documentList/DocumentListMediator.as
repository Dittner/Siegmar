package dittner.gsa.view.documentList {
import dittner.gsa.bootstrap.walter.WalterMediator;
import dittner.gsa.view.documentList.form.FileHeaderFormMediator;
import dittner.gsa.view.documentList.list.FileHeaderListMediator;
import dittner.gsa.view.documentList.toolbar.ToolbarMediator;

public class DocumentListMediator extends WalterMediator {

	[Inject]
	public var view:DocumentListView;

	override protected function activate():void {
		registerMediator(view.fileHeaderList, new FileHeaderListMediator());
		registerMediator(view.toolbar, new ToolbarMediator());
		registerMediator(view.documentForm, new FileHeaderFormMediator());
	}

	override protected function deactivate():void {}

}
}