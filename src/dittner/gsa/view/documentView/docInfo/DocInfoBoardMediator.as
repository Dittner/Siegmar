package dittner.gsa.view.documentView.docInfo {
import dittner.gsa.bootstrap.navigator.ViewNavigator;
import dittner.gsa.bootstrap.viewFactory.ViewID;
import dittner.gsa.bootstrap.walter.WalterMediator;
import dittner.gsa.bootstrap.walter.message.WalterMessage;
import dittner.gsa.domain.fileSystem.GSAFileSystem;

import flash.events.MouseEvent;

public class DocInfoBoardMediator extends WalterMediator {

	[Inject]
	public var view:DocInfoBoard;
	[Inject]
	public var system:GSAFileSystem;
	[Inject]
	public var viewNavigator:ViewNavigator;

	override protected function activate():void {
		if (system.openedFile) view.file = system.openedFile;
		else listenProxy(system, GSAFileSystem.FILE_OPENED, fileOpened);
		view.closeBtn.addEventListener(MouseEvent.CLICK, closeBtnClicked);
	}

	private function fileOpened(msg:WalterMessage):void {
		if (system.openedFile) view.file = system.openedFile;
	}

	private function closeBtnClicked(event:MouseEvent):void {
		system.closeOpenedFile();
		viewNavigator.navigate(ViewID.DOCUMENT_LIST);
	}

	override protected function deactivate():void {
		view.closeBtn.removeEventListener(MouseEvent.CLICK, closeBtnClicked);

	}

}
}