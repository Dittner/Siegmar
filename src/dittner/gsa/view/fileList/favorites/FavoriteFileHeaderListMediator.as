package dittner.gsa.view.fileList.favorites {
import dittner.gsa.bootstrap.async.IAsyncOperation;
import dittner.gsa.bootstrap.navigator.ViewNavigator;
import dittner.gsa.bootstrap.viewFactory.ViewID;
import dittner.gsa.bootstrap.walter.WalterMediator;
import dittner.gsa.bootstrap.walter.message.WalterMessage;
import dittner.gsa.domain.fileSystem.GSAFileSystem;
import dittner.gsa.domain.fileSystem.file.FileType;
import dittner.gsa.domain.fileSystem.header.FileHeader;
import dittner.gsa.domain.store.FileStorage;
import dittner.gsa.view.common.list.SelectableDataGroupEvent;
import dittner.gsa.view.fileList.toolbar.ToolbarMediator;

import mx.collections.ArrayCollection;

public class FavoriteFileHeaderListMediator extends WalterMediator {

	[Inject]
	public var view:FavoriteFileHeaderList;
	[Inject]
	public var system:GSAFileSystem;
	[Inject]
	public var viewNavigator:ViewNavigator;
	[Inject]
	public var fileStorage:FileStorage;
	private var favoriteHeaders:Array = [];

	override protected function activate():void {
		view.list.dataProvider = new ArrayCollection();

		listenProxy(system, GSAFileSystem.FILE_SELECTED, systemFileSelected);
		listenMediator(ToolbarMediator.FAVORITE_FILES_CHANGED_KEY, addHeaderToFavorites);

		view.list.addEventListener(SelectableDataGroupEvent.SELECTED, viewListItemSelectedHandler);
		view.list.addEventListener(SelectableDataGroupEvent.DOUBLE_CLICKED, viewListDoubleClicked);
		view.list.addEventListener(SelectableDataGroupEvent.REMOVE, favoriteHeaderRemoved);
		system.openFolder(system.rootFolderHeader);
		var op:IAsyncOperation = fileStorage.loadFavoriteFileHeaders();
		op.addCompleteCallback(favoriteHeadersLoaded);
	}

	private function viewListItemSelectedHandler(event:SelectableDataGroupEvent):void {
		if (event.data is FileHeader) system.selectedFileHeader = event.data as FileHeader;
	}

	private function viewListDoubleClicked(event:SelectableDataGroupEvent):void {
		if (!event.data is FileHeader) return;

		if ((event.data as FileHeader).isFolder) {
			system.openFolder(event.data as FileHeader);
		}
		else {
			system.selectedFileHeader = event.data as FileHeader;
			var viewID:String = system.selectedFileHeader.fileType == FileType.PICTURE ? ViewID.PAINTING : ViewID.FILE_VIEW;
			viewNavigator.navigate(viewID);
		}
	}

	private function favoriteHeaderRemoved(event:SelectableDataGroupEvent):void {
		var removingHeader:FileHeader = event.data as FileHeader;
		if (!removingHeader) return;

		for (var i:int = 0; i < favoriteHeaders.length; i++) {
			if (favoriteHeaders[i] == event.data) {
				favoriteHeaders.splice(i, 1);
				view.list.refresh();
				removingHeader.isFavorite = false;
				removingHeader.store();
				break;
			}
		}
	}

	private function systemFileSelected(msg:WalterMessage):void {
		if (view.list.selectedItem && view.list.selectedItem != msg.data)
			view.list.selectedItem = null;
	}

	private function addHeaderToFavorites(msg:WalterMessage):void {
		var header:FileHeader = msg.data as FileHeader;
		if (header) {
			var hasSuchHeader:Boolean = false;
			for each(var h:FileHeader in favoriteHeaders)
				if (h.fileID == header.fileID) {
					hasSuchHeader = true;
					break;
				}
			if (header.isFavorite && !hasSuchHeader) {
				favoriteHeaders.push(header);
				favoriteHeaders.sortOn(["fileType", "title"], [Array.NUMERIC, Array.CASEINSENSITIVE]);
				view.list.refresh();
			}
		}
	}

	private function favoriteHeadersLoaded(op:IAsyncOperation):void {
		favoriteHeaders = op.isSuccess ? op.result as Array : [];
		favoriteHeaders.sortOn(["fileType", "title"], [Array.NUMERIC, Array.CASEINSENSITIVE]);
		view.list.dataProvider = new ArrayCollection(favoriteHeaders);
	}

	override protected function deactivate():void {
		view.list.removeEventListener(SelectableDataGroupEvent.SELECTED, viewListItemSelectedHandler);
		view.list.removeEventListener(SelectableDataGroupEvent.DOUBLE_CLICKED, viewListDoubleClicked);
		view.list.removeEventListener(SelectableDataGroupEvent.REMOVE, favoriteHeaderRemoved);
	}

}
}