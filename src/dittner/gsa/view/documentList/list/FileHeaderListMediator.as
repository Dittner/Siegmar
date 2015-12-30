package dittner.gsa.view.documentList.list {
import dittner.gsa.bootstrap.navigator.ViewNavigator;
import dittner.gsa.bootstrap.viewFactory.ViewID;
import dittner.gsa.bootstrap.walter.WalterMediator;
import dittner.gsa.bootstrap.walter.message.WalterMessage;
import dittner.gsa.domain.fileSystem.FileHeader;
import dittner.gsa.domain.fileSystem.FileType;
import dittner.gsa.domain.fileSystem.GSAFileSystem;
import dittner.gsa.message.MediatorMsg;
import dittner.gsa.view.common.list.SelectableDataGroupEvent;

import flash.events.MouseEvent;

import mx.collections.ArrayCollection;

public class FileHeaderListMediator extends WalterMediator {

	[Inject]
	public var view:FileHeaderList;
	[Inject]
	public var system:GSAFileSystem;
	[Inject]
	public var viewNavigator:ViewNavigator;

	override protected function activate():void {
		listenProxy(system, GSAFileSystem.HEADERS_UPDATED, headersUpdated);
		listenProxy(system, GSAFileSystem.FOLDER_OPENED, folderOpened);
		view.list.addEventListener(SelectableDataGroupEvent.SELECTED, viewListItemSelectedHandler);
		view.list.addEventListener(SelectableDataGroupEvent.DOUBLE_CLICKED, viewListDoubleClicked);
		view.backBtn.addEventListener(MouseEvent.CLICK, backBtnClicked);

		listenMediator(MediatorMsg.START_EDIT, startEditing);
		listenMediator(MediatorMsg.END_EDIT, endEditing);

		system.openFolder(system.rootFolderHeader);
	}

	private function startEditing(msg:WalterMessage):void {
		view.enabled = false;
	}
	private function endEditing(msg:WalterMessage):void {
		view.enabled = true;
	}

	private function viewListItemSelectedHandler(event:SelectableDataGroupEvent):void {
		system.selectedFileHeader = event.data as FileHeader;
	}

	private function viewListDoubleClicked(event:SelectableDataGroupEvent):void {
		if (!event.data is FileHeader) return;

		if ((event.data as FileHeader).isFolder) {
			system.openFolder(event.data as FileHeader);
		}
		else {
			system.selectedFileHeader = event.data as FileHeader;
			var viewID:String = system.selectedFileHeader.fileType == FileType.PICTURE ? ViewID.PAINTING_VIEW : ViewID.DOCUMENT_VIEW;
			viewNavigator.navigate(viewID);
		}
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

	override protected function deactivate():void {
		view.list.removeEventListener(SelectableDataGroupEvent.SELECTED, viewListItemSelectedHandler);
		view.list.removeEventListener(SelectableDataGroupEvent.DOUBLE_CLICKED, viewListDoubleClicked);
		view.backBtn.removeEventListener(MouseEvent.CLICK, backBtnClicked);
	}

}
}