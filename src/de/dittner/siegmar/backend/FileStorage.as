package de.dittner.siegmar.backend {
import de.dittner.async.AsyncOperation;
import de.dittner.async.IAsyncCommand;
import de.dittner.async.IAsyncOperation;
import de.dittner.siegmar.backend.op.CalcFilesAndPhotosSQLOperation;
import de.dittner.siegmar.backend.op.FileSQLWrapper;
import de.dittner.siegmar.backend.op.RemoveFileSQLOperation;
import de.dittner.siegmar.backend.op.RemovePhotoSQLOperation;
import de.dittner.siegmar.backend.op.RunDataBaseSQLOperation;
import de.dittner.siegmar.backend.op.SelectFavoriteFileHeadersSQLOperation;
import de.dittner.siegmar.backend.op.SelectFileBodySQLOperation;
import de.dittner.siegmar.backend.op.SelectFileHeadersByTypeSQLOperation;
import de.dittner.siegmar.backend.op.SelectFileHeadersSQLOperation;
import de.dittner.siegmar.backend.op.SelectPhotoSQLOperation;
import de.dittner.siegmar.backend.op.SelectPhotosInfoSQLOperation;
import de.dittner.siegmar.backend.op.StoreFileBodySQLOperation;
import de.dittner.siegmar.backend.op.StoreFileHeaderSQLOperation;
import de.dittner.siegmar.backend.op.StorePhotoSQLOperation;
import de.dittner.siegmar.backend.op.UpdatePhotoSQLOperation;
import de.dittner.siegmar.model.domain.fileSystem.SiegmarFileSystem;
import de.dittner.siegmar.model.domain.fileSystem.body.FileBody;
import de.dittner.siegmar.model.domain.fileSystem.header.FileHeader;
import de.dittner.siegmar.utils.AppInfo;
import de.dittner.walter.WalterProxy;

import flash.data.SQLConnection;
import flash.display.BitmapData;

public class FileStorage extends WalterProxy {

	public static const FILE_STORED:String = "stored";
	public static const FILE_REMOVED:String = "removed";

	public function FileStorage() {
		_isEmpty = !RunDataBaseSQLOperation.existsDataBaseFile();
	}

	[Inject]
	public var encryptionService:EncryptionService;
	[Inject]
	public var system:SiegmarFileSystem;
	[Inject]
	public var deferredCommandManager:DeferredCommandManager;

	private var _textDBConnection:SQLConnection;
	public function get textDBConnection():SQLConnection {return _textDBConnection;}

	private var _photoDBConnection:SQLConnection;
	public function get photoDBConnection():SQLConnection {return _photoDBConnection;}

	private var _isEmpty:Boolean = true;
	public function get isEmpty():Boolean {return _isEmpty;}

	//----------------------------------------------------------------------------------------------
	//
	//  Methods
	//
	//----------------------------------------------------------------------------------------------

	override protected function activate():void {}

	private var isOpened:Boolean = false;
	public function open(dataBasePwd:String):IAsyncOperation {
		if (isOpened) {
			var op:IAsyncOperation = new AsyncOperation();
			op.dispatchSuccess();
			return op;
		}
		isOpened = true;

		var cmd:IAsyncCommand;
		deferredCommandManager.start();

		cmd = new RunDataBaseSQLOperation(dataBasePwd, AppInfo.TEXT_DB_NAME, [SQLLib.CREATE_FILE_HEADER_TBL, SQLLib.CREATE_FILE_BODY_TBL]);
		cmd.addCompleteCallback(textDBOpened);
		deferredCommandManager.add(cmd);

		cmd = new RunDataBaseSQLOperation(dataBasePwd, AppInfo.PHOTO_DB_NAME, [SQLLib.CREATE_PHOTO_TBL]);
		cmd.addCompleteCallback(photoDBOpened);
		deferredCommandManager.add(cmd);

		cmd = new CalcFilesAndPhotosSQLOperation(this);
		deferredCommandManager.add(cmd);

		return cmd;
	}

	private function textDBOpened(opEvent:*):void {
		_textDBConnection = opEvent.result as SQLConnection;
	}

	private function photoDBOpened(opEvent:*):void {
		_photoDBConnection = opEvent.result as SQLConnection;
	}

	//--------------------------------------
	//  header
	//--------------------------------------

	public function storeHeader(header:FileHeader):IAsyncOperation {
		if (isEmpty) _isEmpty = false;

		var cmd:IAsyncCommand = new StoreFileHeaderSQLOperation(wrapFileHeader(header));
		cmd.addCompleteCallback(notifyFileStored);
		deferredCommandManager.add(cmd);
		return cmd;
	}

	public function removeFile(header:FileHeader):IAsyncOperation {
		var cmd:IAsyncCommand = new RemoveFileSQLOperation(wrapFileHeader(header));
		cmd.addCompleteCallback(notifyFileRemoved);
		deferredCommandManager.add(cmd);
		return cmd;
	}

	public function loadFileHeaders(parentFolderID:int):IAsyncOperation {
		var cmd:IAsyncCommand = new SelectFileHeadersSQLOperation(this, parentFolderID);
		deferredCommandManager.add(cmd);
		return cmd;
	}

	public function loadFileHeadersByType(fileType:uint):IAsyncOperation {
		var cmd:IAsyncCommand = new SelectFileHeadersByTypeSQLOperation(this, fileType);
		deferredCommandManager.add(cmd);
		return cmd;
	}

	public function loadFavoriteFileHeaders():IAsyncOperation {
		var cmd:IAsyncCommand = new SelectFavoriteFileHeadersSQLOperation(this);
		deferredCommandManager.add(cmd);
		return cmd;
	}

	//--------------------------------------
	//  body
	//--------------------------------------

	public function storeBody(body:FileBody):IAsyncOperation {
		var cmd:IAsyncCommand = new StoreFileBodySQLOperation(wrapFileBody(body));
		deferredCommandManager.add(cmd);
		return cmd;
	}

	public function loadFileBody(header:FileHeader):IAsyncOperation {
		var cmd:IAsyncCommand = new SelectFileBodySQLOperation(wrapFileHeader(header), system);
		deferredCommandManager.add(cmd);
		return cmd;
	}

	//--------------------------------------
	//  wrap
	//--------------------------------------

	private function wrapFileHeader(header:FileHeader):FileSQLWrapper {
		var wrapper:FileSQLWrapper = new FileSQLWrapper();
		wrapper.header = header;
		wrapper.textDBConnection = textDBConnection;
		wrapper.encryptionService = encryptionService;
		return wrapper;
	}

	private function wrapFileBody(body:FileBody):FileSQLWrapper {
		var wrapper:FileSQLWrapper = new FileSQLWrapper();
		wrapper.body = body;
		wrapper.textDBConnection = textDBConnection;
		wrapper.photoDBConnection = photoDBConnection;
		wrapper.encryptionService = encryptionService;
		return wrapper;
	}

	private function notifyFileStored(op:IAsyncOperation):void {
		if (op.isSuccess) sendMessage(FILE_STORED);
	}
	private function notifyFileRemoved(op:IAsyncOperation):void {
		if (op.isSuccess) sendMessage(FILE_REMOVED);
	}

	//--------------------------------------
	//  photo
	//--------------------------------------

	public function storePhoto(bitmap:BitmapData, title:String, fileID:int):IAsyncOperation {
		if (isEmpty) _isEmpty = false;

		var cmd:IAsyncCommand = new StorePhotoSQLOperation(photoDBConnection, bitmap, title, fileID);
		deferredCommandManager.add(cmd);
		return cmd;
	}

	public function updatePhoto(photoId:int, bitmap:BitmapData, title:String, fileID:int):IAsyncOperation {
		var cmd:IAsyncCommand = new UpdatePhotoSQLOperation(photoDBConnection, photoId, bitmap, title, fileID);
		deferredCommandManager.add(cmd);
		return cmd;
	}

	public function removePhoto(photoId:int):IAsyncOperation {
		var cmd:IAsyncCommand = new RemovePhotoSQLOperation(photoDBConnection, photoId);
		deferredCommandManager.add(cmd);
		return cmd;
	}

	public function loadPhotosInfo(fileID:int):IAsyncOperation {
		var cmd:IAsyncCommand = new SelectPhotosInfoSQLOperation(photoDBConnection, fileID);
		deferredCommandManager.add(cmd);
		return cmd;
	}

	public function loadPhotoBitmap(photoID:int):IAsyncOperation {
		var cmd:IAsyncCommand = new SelectPhotoSQLOperation(photoDBConnection, photoID);
		deferredCommandManager.add(cmd);
		return cmd;
	}

	public function loadPhotoPreview(photoID:int):IAsyncOperation {
		var cmd:IAsyncCommand = new SelectPhotoSQLOperation(photoDBConnection, photoID, true);
		deferredCommandManager.add(cmd);
		return cmd;
	}

}
}