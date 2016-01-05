package dittner.gsa.view.paintingView {
import dittner.gsa.bootstrap.async.IAsyncOperation;
import dittner.gsa.bootstrap.navigator.ViewNavigator;
import dittner.gsa.bootstrap.viewFactory.ViewID;
import dittner.gsa.bootstrap.walter.WalterMediator;
import dittner.gsa.bootstrap.walter.message.WalterMessage;
import dittner.gsa.domain.fileSystem.GSAFile;
import dittner.gsa.domain.fileSystem.GSAFileSystem;
import dittner.gsa.domain.fileSystem.body.PictureBody;
import dittner.gsa.utils.BitmapLocalSaver;
import dittner.gsa.utils.FileChooser;
import dittner.gsa.view.common.colorChooser.SelectColorEvent;
import dittner.gsa.view.common.list.SelectableDataGroupEvent;
import dittner.gsa.view.fileList.toolbar.ToolbarMediator;
import dittner.gsa.view.paintingView.action.DrawLinesAction;
import dittner.gsa.view.paintingView.action.LinesDisplacementAction;
import dittner.gsa.view.paintingView.action.PaintingAction;

import flash.display.Bitmap;
import flash.events.MouseEvent;
import flash.net.FileFilter;

import mx.collections.ArrayCollection;

import spark.events.IndexChangeEvent;

public class PaintingViewMediator extends WalterMediator {

	[Inject]
	public var view:PaintingView;
	[Inject]
	public var system:GSAFileSystem;
	[Inject]
	public var viewNavigator:ViewNavigator;

	private var openedFile:GSAFile;
	private var openedFileBody:PictureBody;

	private static const SHOW_MODES:Array = [PictureShowMode.IMAGE, PictureShowMode.BG, PictureShowMode.COMBINATION];
	private static const BROWSE_FILE_FILTERS:Array = [new FileFilter("PNG-file", "*.png"), new FileFilter("JPG-file", "*.jpg"), new FileFilter("JPEG-file", "*.jpeg")];

	override protected function activate():void {
		listenProxy(system, GSAFileSystem.FILE_OPENED, fileOpened);
		system.openSelectedFile();
	}

	private function fileOpened(msg:WalterMessage):void {
		if (system.openedFile) {
			openedFile = system.openedFile;
			openedFileBody = openedFile.body as PictureBody;

			registerMediator(view.toolbar, new ToolbarMediator());
			view.pictureInfo.title = openedFile.header.title;
			view.pictureInfo.picture = openedFileBody;

			view.actionTools.addImageBtn.addEventListener(MouseEvent.CLICK, addImage);
			view.actionTools.addBgBtn.addEventListener(MouseEvent.CLICK, addBg);
			view.actionTools.showModeChooser.dataProvider = new ArrayCollection(SHOW_MODES);
			view.actionTools.showModeChooser.selectedIndex = 0;
			view.actionTools.showModeChooser.addEventListener(IndexChangeEvent.CHANGE, showModeChanged);
			view.actionTools.availableActionList.addEventListener(SelectableDataGroupEvent.SELECTED, actionAddedHandler);
			view.actionTools.actionList.dataProvider = new ArrayCollection(openedFileBody.actions);
			view.actionTools.actionList.addEventListener(SelectableDataGroupEvent.REMOVE, removeAction);
			view.actionTools.actionForm.colorChooser.addEventListener(SelectColorEvent.COLOR_SELECTED, bgColorSelected);
			view.actionTools.actionForm.applyBtn.addEventListener(MouseEvent.CLICK, applyChanges);
			view.actionTools.saveResultBtn.addEventListener(MouseEvent.CLICK, saveResult);
			view.pictureInfo.incScaleBtn.addEventListener(MouseEvent.CLICK, incPictureScale);
			view.pictureInfo.decScaleBtn.addEventListener(MouseEvent.CLICK, decPictureScale);
			updatePicture();
		}
		else {
			system.closeOpenedFile();
			viewNavigator.navigate(ViewID.FILE_LIST);
		}
	}

	private function addImage(e:MouseEvent):void {
		var op:IAsyncOperation = FileChooser.browse(BROWSE_FILE_FILTERS);
		op.addCompleteCallback(imageBrowsed);
	}

	private function applyChanges(e:MouseEvent):void {
		view.actionTools.actionForm.storeChanges();
		openedFileBody.store();
		updatePicture();
	}

	private function saveResult(e:MouseEvent):void {
		if (view.actionTools.showModeChooser.selectedItem == PictureShowMode.COMBINATION && view.picturePanel.source) {
			BitmapLocalSaver.save(view.picturePanel.source, openedFile.header.title + ".png");
		}
		else {
			BitmapLocalSaver.save(openedFileBody.render(), openedFile.header.title + ".png");
		}
	}

	private function imageBrowsed(op:IAsyncOperation):void {
		openedFileBody.image = op.isSuccess ? (op.result as Bitmap).bitmapData : null;
		updatePicture();
	}

	private function addBg(e:MouseEvent):void {
		var op:IAsyncOperation = FileChooser.browse(BROWSE_FILE_FILTERS);
		op.addCompleteCallback(bgBrowsed);
	}

	private function incPictureScale(e:MouseEvent):void {
		if (openedFileBody.image) {
			var updatedScale:Number = view.picturePanel.pictureScale;
			switch (view.picturePanel.pictureScale) {
				case 0.1 :
					updatedScale = 0.15;
					break;
				case 0.15 :
					updatedScale = 0.25;
					break;
				case 0.25 :
					updatedScale = 0.5;
					break;
				case 0.5 :
					updatedScale = 0.75;
					break;
				case 0.75 :
					updatedScale = 1;
					break;
				case 1 :
				case 2 :
				case 3 :
				case 4 :
					updatedScale = view.picturePanel.pictureScale + 1;
					break;
			}

			view.picturePanel.pictureScale = updatedScale;
		}
	}

	private function decPictureScale(e:MouseEvent):void {
		if (openedFileBody.image) {
			var updatedScale:Number = view.picturePanel.pictureScale;
			switch (view.picturePanel.pictureScale) {
				case 0.15 :
					updatedScale = 0.1;
					break;
				case 0.25 :
					updatedScale = 0.15;
					break;
				case 0.5 :
					updatedScale = 0.25;
					break;
				case 0.75 :
					updatedScale = 0.5;
					break;
				case 1 :
					updatedScale = 0.75;
					break;
				case 2 :
				case 3 :
				case 4 :
				case 5 :
					updatedScale = view.picturePanel.pictureScale - 1;
					break;
			}

			view.picturePanel.pictureScale = updatedScale;
		}
	}

	private function bgBrowsed(op:IAsyncOperation):void {
		openedFileBody.bg = op.isSuccess ? (op.result as Bitmap).bitmapData : null;
		updatePicture();
	}

	private function updatePicture():void {
		switch (view.actionTools.showModeChooser.selectedItem) {
			case PictureShowMode.IMAGE :
				view.picturePanel.source = openedFileBody.image;
				break;
			case PictureShowMode.BG :
				view.picturePanel.source = openedFileBody.bg;
				break;
			case PictureShowMode.COMBINATION :
				if (view.picturePanel.source && view.picturePanel.source != openedFileBody.image && view.picturePanel.source != openedFileBody.bg)
					view.picturePanel.source.dispose();
				view.picturePanel.source = openedFileBody.render();
				break;
			default :
				view.picturePanel.source = null;
		}
	}

	private function showModeChanged(e:IndexChangeEvent):void {
		updatePicture();
	}

	private function actionAddedHandler(e:SelectableDataGroupEvent):void {
		if (e.data) {
			openedFileBody.actions.push(createActionByKey(e.data));
			view.actionTools.actionList.dataProvider = new ArrayCollection(openedFileBody.actions);
			openedFileBody.store();
			updatePicture();
		}
	}

	private function removeAction(e:SelectableDataGroupEvent):void {
		if (e.index >= 0 && e.index < openedFileBody.actions.length) {
			openedFileBody.actions.splice(e.index, 1);
			openedFileBody.store();
			view.actionTools.actionList.dataProvider = new ArrayCollection(openedFileBody.actions);
			updatePicture();
		}
	}

	private function createActionByKey(key:String):PaintingAction {
		switch (key) {
			case PaintingAction.LINES_DISPLACEMENT :
				return new LinesDisplacementAction();
			case PaintingAction.DRAW_LINES :
				return new DrawLinesAction();
			default :
				throw new Error("Unknown action key: " + key);
		}
	}

	override protected function deactivate():void {
		view.actionTools.addImageBtn.removeEventListener(MouseEvent.CLICK, addImage);
		view.actionTools.addBgBtn.removeEventListener(MouseEvent.CLICK, addBg);
		view.actionTools.showModeChooser.removeEventListener(IndexChangeEvent.CHANGE, showModeChanged);
		view.actionTools.availableActionList.removeEventListener(SelectableDataGroupEvent.SELECTED, actionAddedHandler);
		view.actionTools.actionList.removeEventListener(SelectableDataGroupEvent.REMOVE, removeAction);
		view.actionTools.actionForm.colorChooser.removeEventListener(SelectColorEvent.COLOR_SELECTED, bgColorSelected);
		view.actionTools.actionForm.applyBtn.removeEventListener(MouseEvent.CLICK, applyChanges);
		view.actionTools.saveResultBtn.removeEventListener(MouseEvent.CLICK, saveResult);
		view.pictureInfo.incScaleBtn.removeEventListener(MouseEvent.CLICK, incPictureScale);
		view.pictureInfo.decScaleBtn.removeEventListener(MouseEvent.CLICK, decPictureScale);
	}

	private function bgColorSelected(event:SelectColorEvent):void {
		if (view.actionTools.actionForm.action) view.actionTools.actionForm.action.bgColor = event.color;
		openedFileBody.store();
	}
}
}