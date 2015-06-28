package dittner.gsa.view.documentView.docInfo {
import dittner.gsa.bootstrap.walter.WalterMediator;
import dittner.gsa.bootstrap.walter.message.WalterMessage;
import dittner.gsa.domain.fileSystem.GSAFileSystem;

public class DocInfoBoardMediator extends WalterMediator {

	[Inject]
	public var view:DocInfoBoard;
	[Inject]
	public var system:GSAFileSystem;

	override protected function activate():void {
		if (system.openedFile) view.file = system.openedFile;
		else listenProxy(system, GSAFileSystem.FILE_OPENED, fileOpened);
	}

	private function fileOpened(msg:WalterMessage):void {
		if (system.openedFile) view.file = system.openedFile;
	}

	override protected function deactivate():void {}

}
}