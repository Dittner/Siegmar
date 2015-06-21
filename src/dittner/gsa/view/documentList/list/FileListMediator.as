package dittner.gsa.view.documentList.list {
import dittner.gsa.bootstrap.async.AsyncOperationResult;
import dittner.gsa.bootstrap.async.IAsyncOperation;
import dittner.gsa.bootstrap.walter.WalterMediator;
import dittner.gsa.bootstrap.walter.message.WalterMessage;
import dittner.gsa.domain.fileSystem.GSAFileSystem;
import dittner.gsa.domain.store.FileStorage;
import dittner.gsa.view.common.list.SelectableDataGroup;

import flash.events.Event;

import mx.collections.ArrayCollection;

public class FileListMediator extends WalterMediator {

	[Inject]
	public var view:FileList;
	[Inject]
	public var system:GSAFileSystem;
	[Inject]
	public var fileStorage:FileStorage;

	override protected function activate():void {
		listenProxy(fileStorage, FileStorage.FILE_STORED, loadFiles);
		view.list.addEventListener(SelectableDataGroup.SELECTED, viewListItemSelectedHandler);
		loadFiles();
	}

	private function loadFiles(msg:WalterMessage = null):void {
		var op:IAsyncOperation = fileStorage.loadFiles(system.openedFolder.header.id);
		op.addCompleteCallback(filesLoaded);
	}

	private function viewListItemSelectedHandler(event:Event):void {
		//sendRequest(ScreenMsg.SELECT_SCREEN, new RequestMessage(null, null, view.screenList.selectedItem.id));
	}

	private function filesLoaded(res:AsyncOperationResult):void {
		view.list.dataProvider = new ArrayCollection(res.isSuccess ? res.data as Array : []);
	}

	override protected function deactivate():void {
		view.list.removeEventListener(SelectableDataGroup.SELECTED, viewListItemSelectedHandler);
	}

}
}