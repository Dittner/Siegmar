package dittner.gsa.view.documentList.subject {
import dittner.gsa.domain.fileSystem.GSAFileSystem;
import dittner.gsa.utils.async.AsyncOperationResult;
import dittner.gsa.utils.async.IAsyncOperation;
import dittner.gsa.view.common.list.SelectableDataGroup;
import dittner.walter.WalterController;

import flash.events.Event;

import mx.collections.ArrayCollection;

public class SubjectListController extends WalterController {

	[Inject]
	public var view:SelectableDataGroup;
	[Inject]
	public var system:GSAFileSystem;

	override protected function activate():void {
		view.addEventListener(SelectableDataGroup.SELECTED, viewListItemSelectedHandler);
		var op:IAsyncOperation = system.rootFolder.loadFilesHeaders();
		op.addCompleteCallback(subjectsLoaded);
	}

	private function viewListItemSelectedHandler(event:Event):void {
		//sendRequest(ScreenMsg.SELECT_SCREEN, new RequestMessage(null, null, view.screenList.selectedItem.id));
	}

	private function subjectsLoaded(res:AsyncOperationResult):void {
		view.dataProvider = new ArrayCollection(res.data as Array);
	}

	override protected function deactivate():void {
		view.removeEventListener(SelectableDataGroup.SELECTED, viewListItemSelectedHandler);
	}

}
}