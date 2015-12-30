package dittner.gsa.view.paintingView {
import dittner.gsa.bootstrap.async.IAsyncOperation;
import dittner.gsa.bootstrap.navigator.ViewNavigator;
import dittner.gsa.bootstrap.viewFactory.ViewID;
import dittner.gsa.bootstrap.walter.WalterMediator;
import dittner.gsa.bootstrap.walter.message.WalterMessage;
import dittner.gsa.domain.fileSystem.GSAFile;
import dittner.gsa.domain.fileSystem.GSAFileSystem;
import dittner.gsa.domain.fileSystem.body.PictureBody;
import dittner.gsa.utils.FileChooser;
import dittner.gsa.view.documentList.toolbar.ToolbarMediator;
import dittner.gsa.view.documentView.docInfo.DocInfoBoardMediator;

import flash.display.Bitmap;
import flash.events.MouseEvent;
import flash.net.FileFilter;

public class PaintingViewMediator extends WalterMediator {

	[Inject]
	public var view:PaintingView;
	[Inject]
	public var system:GSAFileSystem;
	[Inject]
	public var viewNavigator:ViewNavigator;

	private var openedFile:GSAFile;

	private static const BROWSE_FILE_FILTERS:Array = [new FileFilter("PNG-file", "*.png"), new FileFilter("JPG-file", "*.jpg"), new FileFilter("JPEG-file", "*.jpeg")];
	override protected function activate():void {

		listenProxy(system, GSAFileSystem.FILE_OPENED, fileOpened);
		system.openSelectedFile();
	}

	private function fileOpened(msg:WalterMessage):void {
		if (system.openedFile) {
			openedFile = system.openedFile;
			registerMediator(view.toolbar, new ToolbarMediator());
			registerMediator(view.fileInfoBoard, new DocInfoBoardMediator());
			view.picturePanel.addPictureBtn.addEventListener(MouseEvent.CLICK, addPicture);
			view.picture = openedFile.body as PictureBody;
		}
		else {
			system.closeOpenedFile();
			viewNavigator.navigate(ViewID.DOCUMENT_LIST);
		}
	}

	private function addPicture(e:MouseEvent):void {
		var op:IAsyncOperation = FileChooser.browse(BROWSE_FILE_FILTERS);
		op.addCompleteCallback(pictureBrowsed);
	}

	private function pictureBrowsed(op:IAsyncOperation):void {
		(openedFile.body as PictureBody).image = op.isSuccess ? (op.result as Bitmap).bitmapData : null;
		view.picturePanel.invalidateDisplayList();
	}

	override protected function deactivate():void {
		view.picturePanel.addPictureBtn.removeEventListener(MouseEvent.CLICK, addPicture);
	}

}
}