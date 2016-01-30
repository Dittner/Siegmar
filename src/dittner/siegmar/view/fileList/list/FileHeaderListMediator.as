package dittner.siegmar.view.fileList.list {
import dittner.siegmar.bootstrap.navigator.ViewNavigator;
import dittner.siegmar.bootstrap.viewFactory.ViewID;
import dittner.siegmar.bootstrap.walter.WalterMediator;
import dittner.siegmar.bootstrap.walter.message.WalterMessage;
import dittner.siegmar.domain.fileSystem.SiegmarFileSystem;
import dittner.siegmar.domain.fileSystem.file.FileType;
import dittner.siegmar.domain.fileSystem.header.FileHeader;
import dittner.siegmar.domain.store.FileStorage;
import dittner.siegmar.view.common.list.SelectableDataGroupEvent;

import flash.events.MouseEvent;

import mx.collections.ArrayCollection;

public class FileHeaderListMediator extends WalterMediator {

	[Inject]
	public var view:FileHeaderList;
	[Inject]
	public var system:SiegmarFileSystem;
	[Inject]
	public var viewNavigator:ViewNavigator;
	[Inject]
	public var fileStorage:FileStorage;

	override protected function activate():void {
		listenProxy(system, SiegmarFileSystem.HEADERS_UPDATED, headersUpdated);
		listenProxy(system, SiegmarFileSystem.FOLDER_OPENED, folderOpened);
		listenProxy(system, SiegmarFileSystem.FILE_SELECTED, systemFileSelected);

		view.list.addEventListener(SelectableDataGroupEvent.SELECTED, viewListItemSelectedHandler);
		view.list.addEventListener(SelectableDataGroupEvent.DOUBLE_CLICKED, viewListDoubleClicked);
		view.backBtn.addEventListener(MouseEvent.CLICK, backBtnClicked);
		view.linksFileHeaderRenderer.data = system.bookLinksFileHeader;
		view.linksFileHeaderRenderer.addEventListener(MouseEvent.DOUBLE_CLICK, linksDoubleClicked);
		system.openFolder(system.openedFolderHeader ? system.openedFolderHeader : system.rootFolderHeader);
	}

	private function viewListItemSelectedHandler(event:SelectableDataGroupEvent):void {
		if(event.data is FileHeader) system.selectedFileHeader = event.data as FileHeader;
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

	private function linksDoubleClicked(event:MouseEvent):void {
		system.selectedFileHeader = system.bookLinksFileHeader;
		var viewID:String = ViewID.FILE_VIEW;
		viewNavigator.navigate(viewID);
	}

	private function headersUpdated(msg:WalterMessage):void {
		view.list.dataProvider = new ArrayCollection(msg.data as Array || []);
		view.backBtn.enabled = system.openedFolderHeader != system.rootFolderHeader;
	}

	private function folderOpened(msg:WalterMessage):void {
		view.pathLbl.text = system.openedFolderStackToString();
	}

	private function backBtnClicked(event:MouseEvent):void {
		system.openPrevFolder();
	}

	private function systemFileSelected(msg:WalterMessage):void {
		if (view.list.selectedItem && view.list.selectedItem != msg.data)
			view.list.selectedItem = null;
	}

	override protected function deactivate():void {
		view.list.removeEventListener(SelectableDataGroupEvent.SELECTED, viewListItemSelectedHandler);
		view.list.removeEventListener(SelectableDataGroupEvent.DOUBLE_CLICKED, viewListDoubleClicked);
		view.backBtn.removeEventListener(MouseEvent.CLICK, backBtnClicked);
		view.linksFileHeaderRenderer.removeEventListener(MouseEvent.DOUBLE_CLICK, linksDoubleClicked);
	}

}
}