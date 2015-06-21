package dittner.gsa.view.documentList {
import dittner.gsa.bootstrap.walter.WalterMediator;
import dittner.gsa.view.documentList.form.DocumentFormMediator;
import dittner.gsa.view.documentList.list.FileListMediator;
import dittner.gsa.view.documentList.toolbar.ToolbarMediator;

public class DocumentListMediator extends WalterMediator {

	[Inject]
	public var view:DocumentListView;

	override protected function activate():void {
		registerMediator(view.fileList, new FileListMediator());
		registerMediator(view.toolbar, new ToolbarMediator());
		registerMediator(view.documentForm, new DocumentFormMediator());
	}

	override protected function deactivate():void {}

}
}