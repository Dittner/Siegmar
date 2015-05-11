package dittner.gsa.view.documentList {
import dittner.gsa.view.documentList.form.DocumentFormController;
import dittner.gsa.view.documentList.list.FileListController;
import dittner.gsa.view.documentList.toolbar.ToolbarController;
import dittner.walter.WalterController;

public class DocumentListController extends WalterController {

	[Inject]
	public var view:DocumentListView;

	override protected function activate():void {
		registerController(view.fileList, new FileListController());
		registerController(view.toolbar, new ToolbarController());
		registerController(view.documentForm, new DocumentFormController());
	}

	override protected function deactivate():void {}

}
}