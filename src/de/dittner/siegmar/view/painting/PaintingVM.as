package de.dittner.siegmar.view.painting {
import de.dittner.async.IAsyncOperation;
import de.dittner.siegmar.domain.fileSystem.SiegmarFileSystem;
import de.dittner.siegmar.domain.fileSystem.body.picture.PictureBody;
import de.dittner.siegmar.domain.fileSystem.body.picture.action.DrawLinesAction;
import de.dittner.siegmar.domain.fileSystem.body.picture.action.LinesDisplacementAction;
import de.dittner.siegmar.domain.fileSystem.body.picture.action.PaintingAction;
import de.dittner.siegmar.domain.fileSystem.file.SiegmarFile;
import de.dittner.siegmar.domain.user.User;
import de.dittner.siegmar.utils.BitmapLocalSaver;
import de.dittner.siegmar.utils.FileChooser;
import de.dittner.siegmar.view.common.view.ViewID;
import de.dittner.siegmar.view.common.view.ViewModel;
import de.dittner.siegmar.view.common.view.ViewNavigator;
import de.dittner.siegmar.view.painting.components.PictureShowMode;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.events.Event;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.net.FileFilter;

import mx.collections.ArrayCollection;

public class PaintingVM extends ViewModel {
	public function PaintingVM() {
		super();
	}

	[Bindable]
	[Inject]
	public var system:SiegmarFileSystem;

	[Bindable]
	[Inject]
	public var user:User;

	[Bindable]
	[Inject]
	public var viewNavigator:ViewNavigator;

	//--------------------------------------
	//  openedFile
	//--------------------------------------
	private var _openedFile:SiegmarFile;
	[Bindable("openedFileChanged")]
	public function get openedFile():SiegmarFile {return _openedFile;}
	private function setOpenedFile(value:SiegmarFile):void {
		if (_openedFile != value) {
			_openedFile = value;
			dispatchEvent(new Event("openedFileChanged"));
		}
	}

	//--------------------------------------
	//  picture
	//--------------------------------------
	[Bindable("openedFileChanged")]
	public function get picture():PictureBody {return openedFile.body as PictureBody;}

	//--------------------------------------
	//  actionColl
	//--------------------------------------
	private var _actionColl:ArrayCollection;
	[Bindable("actionCollChanged")]
	public function get actionColl():ArrayCollection {return _actionColl;}
	private function setActionColl(value:ArrayCollection):void {
		if (_actionColl != value) {
			_actionColl = value;
			dispatchEvent(new Event("actionCollChanged"));
		}
	}

	//--------------------------------------
	//  showModes
	//--------------------------------------
	private var _showModes:Array = [PictureShowMode.IMAGE, PictureShowMode.BG, PictureShowMode.COMBINATION];
	public function get showModes():Array {return _showModes;}

	private static const BROWSE_FILE_FILTERS:Array = [new FileFilter("PNG-file", "*.png"), new FileFilter("JPG-file", "*.jpg"), new FileFilter("JPEG-file", "*.jpeg")];

	//--------------------------------------
	//  pictureBitmapData
	//--------------------------------------
	private var _pictureBitmapData:BitmapData;
	[Bindable("pictureBitmapDataChanged")]
	public function get pictureBitmapData():BitmapData {return _pictureBitmapData;}
	public function set pictureBitmapData(value:BitmapData):void {
		if (_pictureBitmapData != value) {
			_pictureBitmapData = value;
			dispatchEvent(new Event("pictureBitmapDataChanged"));
		}
	}

	//--------------------------------------
	//  pictureBitmapDataScale
	//--------------------------------------
	private var _pictureBitmapDataScale:Number = 1;
	[Bindable("pictureBitmapDataScaleChanged")]
	public function get pictureBitmapDataScale():Number {return _pictureBitmapDataScale;}
	private function setPictureBitmapDataScale(value:Number):void {
		if (_pictureBitmapDataScale != value) {
			_pictureBitmapDataScale = value;
			dispatchEvent(new Event("pictureBitmapDataScaleChanged"));
		}
	}

	//--------------------------------------
	//  selectedShowMode
	//--------------------------------------
	private var _selectedShowMode:String = PictureShowMode.IMAGE;
	[Bindable("selectedShowModeChanged")]
	public function get selectedShowMode():String {return _selectedShowMode;}
	public function set selectedShowMode(value:String):void {
		if (_selectedShowMode != value) {
			_selectedShowMode = value;
			dispatchEvent(new Event("selectedShowModeChanged"));
			updatePicture();
		}
	}

	//----------------------------------------------------------------------------------------------
	//
	//  Methods
	//
	//----------------------------------------------------------------------------------------------

	override public function viewActivated():void {
		super.viewActivated();
		var op:IAsyncOperation = system.openSelectedFile();
		op.addCompleteCallback(fileLoaded);
		if (system.openedFile)
			updatePicture();
	}

	private function fileLoaded(op:IAsyncOperation):void {
		if (op.isSuccess) {
			setOpenedFile(op.result);
			updatePicture();
			if (openedFile)
				setActionColl(new ArrayCollection(picture.actions));
		}
		else setOpenedFile(null);
	}

	public function addImage():void {
		var op:IAsyncOperation = FileChooser.browse(BROWSE_FILE_FILTERS);
		op.addCompleteCallback(imageBrowsed);
	}

	public function storeChanges():void {
		picture.store();
		updatePicture();
	}

	public function saveResultLocally():void {
		if (selectedShowMode == PictureShowMode.COMBINATION && pictureBitmapData) {
			BitmapLocalSaver.save(pictureBitmapData, system.openedFile.header.title + ".png");
		}
		else {
			BitmapLocalSaver.save(picture.render(), system.openedFile.header.title + ".png");
		}
	}

	private function imageBrowsed(op:IAsyncOperation):void {
		var loadedBd:BitmapData = op.isSuccess ? (op.result[0] as Bitmap).bitmapData : null;
		if (loadedBd) {
			var res:BitmapData = new BitmapData(loadedBd.width, loadedBd.height, true, 0);
			res.copyPixels(loadedBd, new Rectangle(0, 0, loadedBd.width, loadedBd.height), new Point());
			loadedBd.dispose();
			picture.image = res;
		}
		updatePicture();
	}

	public function addBg():void {
		var op:IAsyncOperation = FileChooser.browse(BROWSE_FILE_FILTERS);
		op.addCompleteCallback(bgBrowsed);
	}

	public function incPictureScale():void {
		if (picture.image) {
			var updatedScale:Number = pictureBitmapDataScale;
			switch (updatedScale) {
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
					updatedScale = updatedScale + 1;
					break;
			}

			setPictureBitmapDataScale(updatedScale);
		}
	}

	public function decPictureScale():void {
		if (picture.image) {
			var updatedScale:Number = pictureBitmapDataScale;
			switch (updatedScale) {
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
					updatedScale = updatedScale - 1;
					break;
			}

			setPictureBitmapDataScale(updatedScale);
		}
	}

	private function bgBrowsed(op:IAsyncOperation):void {
		picture.bg = op.isSuccess ? (op.result[0] as Bitmap).bitmapData : null;
		updatePicture();
	}

	public function updatePicture():void {
		switch (selectedShowMode) {
			case PictureShowMode.IMAGE :
				pictureBitmapData = picture.image;
				break;
			case PictureShowMode.BG :
				pictureBitmapData = picture.bg;
				break;
			case PictureShowMode.COMBINATION :
				if (pictureBitmapData && pictureBitmapData != picture.image && pictureBitmapData != picture.bg)
					pictureBitmapData.dispose();
				pictureBitmapData = picture.render();
				break;
			default :
				pictureBitmapData = null;
		}
	}

	public function addAction(actionKey:String):void {
		if (actionKey) {
			picture.actions.push(createActionByKey(actionKey));
			actionColl.refresh();
			picture.store();
			updatePicture();
		}
	}

	public function removeAction(action:PaintingAction):void {
		actionColl.removeItem(action);
		picture.store();
		updatePicture();
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

	public function closeFile():void {
		system.closeOpenedFile();
		viewNavigator.navigate(ViewID.FILE_LIST);
	}

	public function logout():void {
		system.logout();
		viewNavigator.navigate(ViewID.LOGIN);
	}

}
}