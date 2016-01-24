package dittner.gsa.view.fileList.toolbar {
import dittner.gsa.bootstrap.navigator.ViewNavigator;
import dittner.gsa.bootstrap.viewFactory.ViewID;
import dittner.gsa.bootstrap.walter.WalterMediator;
import dittner.gsa.bootstrap.walter.message.WalterMessage;
import dittner.gsa.domain.fileSystem.GSAFileSystem;
import dittner.gsa.domain.user.User;
import dittner.gsa.message.MediatorMsg;

public class ToolbarMediator extends WalterMediator {

	[Inject]
	public var view:Toolbar;
	[Inject]
	public var viewNavigator:ViewNavigator;
	[Inject]
	public var user:User;
	[Inject]
	public var system:GSAFileSystem;

	public static const FAVORITE_FILES_CHANGED_KEY:String = "FAVORITE_FILES_CHANGED_KEY";

	override protected function activate():void {
		listenProxy(system, GSAFileSystem.FILE_SELECTED, fileSelected);
		listenMediator(MediatorMsg.NOTE_SELECTED, noteSelected);
		view.selectedOpCallBack = actionHandler;
	}

	private function fileSelected(msg:WalterMessage):void {
		view.editBtn.enabled = view.removeBtn.enabled = system.selectedFileHeader != null && !system.selectedFileHeader.isReserved;
		view.favoriteBtn.enabled = system.selectedFileHeader != null && !system.selectedFileHeader.isFavorite;
	}

	private function noteSelected(msg:WalterMessage):void {
		view.editBtn.enabled = view.removeBtn.enabled = system.openedFile && system.openedFile.selectedNote;
	}

	private function actionHandler(action:String):void {
		switch (action) {
			case ToolAction.CREATE:
			case ToolAction.EDIT:
			case ToolAction.REMOVE:
				sendMessage(MediatorMsg.START_EDIT, action);
				break;
			case ToolAction.ADD_TO_FAVORITE:
				system.selectedFileHeader.isFavorite = true;
				system.selectedFileHeader.store();
				sendMessage(FAVORITE_FILES_CHANGED_KEY, system.selectedFileHeader);
				break;
			case ToolAction.CLOSE:
				system.closeOpenedFile();
				viewNavigator.navigate(ViewID.FILE_LIST);
				break;
			case ToolAction.SETTINGS:
				system.closeOpenedFile();
				viewNavigator.navigate(ViewID.SETTINGS);
				break;
			case ToolAction.LOGOUT:
				user.logout();
				viewNavigator.navigate(ViewID.LOGIN);
				break;
		}
	}

	override protected function deactivate():void {
		view.selectedOpCallBack = null;
	}

}
}