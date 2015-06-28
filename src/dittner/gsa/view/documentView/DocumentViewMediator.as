package dittner.gsa.view.documentView {
import dittner.gsa.bootstrap.walter.WalterMediator;
import dittner.gsa.view.documentList.toolbar.ToolbarMediator;
import dittner.gsa.view.documentView.document.DocumentMediator;
import dittner.gsa.view.documentView.form.FileBodyFormMediator;
import dittner.gsa.view.documentView.docInfo.DocInfoBoardMediator;

public class DocumentViewMediator extends WalterMediator {

	[Inject]
	public var view:DocumentView;

	override protected function activate():void {
		registerMediator(view.document, new DocumentMediator());
		registerMediator(view.form, new FileBodyFormMediator());
		registerMediator(view.toolbar, new ToolbarMediator());
		registerMediator(view.fileInfoBoard, new DocInfoBoardMediator());
	}

	override protected function deactivate():void {}

}
}