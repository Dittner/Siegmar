package de.dittner.siegmar.backend {
import de.dittner.async.AsyncOperation;
import de.dittner.async.IAsyncCommand;
import de.dittner.async.IAsyncOperation;
import de.dittner.siegmar.backend.EncryptionService;
import de.dittner.siegmar.backend.op.CalcFilesAndPhotosSQLOperation;
import de.dittner.siegmar.backend.op.FileSQLWrapper;
import de.dittner.siegmar.backend.op.RemoveFileSQLOperation;
import de.dittner.siegmar.backend.op.RemovePhotoSQLOperation;
import de.dittner.siegmar.backend.op.RunDataBaseSQLOperation;
import de.dittner.siegmar.backend.SQLLib;
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
import de.dittner.siegmar.backend.DeferredCommandManager;
import de.dittner.siegmar.bootstrap.walter.WalterProxy;
import de.dittner.siegmar.domain.fileSystem.SiegmarFileSystem;
import de.dittner.siegmar.domain.fileSystem.body.FileBody;
import de.dittner.siegmar.domain.fileSystem.header.FileHeader;

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

	private var sqlCmdManager:DeferredCommandManager;

	private var _sqlConnection:SQLConnection;
	public function get sqlConnection():SQLConnection {return _sqlConnection;}

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
		sqlCmdManager = new DeferredCommandManager();

		cmd = new RunDataBaseSQLOperation(dataBasePwd, [SQLLib.CREATE_FILE_HEADER_TBL, SQLLib.CREATE_FILE_BODY_TBL, SQLLib.CREATE_PHOTO_TBL]);
		cmd.addCompleteCallback(dataBaseOpened);
		sqlCmdManager.add(cmd);

		cmd = new CalcFilesAndPhotosSQLOperation(this);
		sqlCmdManager.add(cmd);

		return cmd;
	}

	private function dataBaseOpened(opEvent:*):void {
		_sqlConnection = opEvent.result as SQLConnection;
	}

	//--------------------------------------
	//  header
	//--------------------------------------

	public function storeHeader(header:FileHeader):IAsyncOperation {
		if (isEmpty) _isEmpty = false;

		var cmd:IAsyncCommand = new StoreFileHeaderSQLOperation(wrapFileHeader(header));
		cmd.addCompleteCallback(notifyFileStored);
		sqlCmdManager.add(cmd);
		return cmd;
	}

	public function removeFile(header:FileHeader):IAsyncOperation {
		var cmd:IAsyncCommand = new RemoveFileSQLOperation(wrapFileHeader(header));
		cmd.addCompleteCallback(notifyFileRemoved);
		sqlCmdManager.add(cmd);
		return cmd;
	}

	public function loadFileHeaders(parentFolderID:int):IAsyncOperation {
		var cmd:IAsyncCommand = new SelectFileHeadersSQLOperation(this, parentFolderID);
		sqlCmdManager.add(cmd);
		return cmd;
	}

	public function loadFileHeadersByType(fileType:uint):IAsyncOperation {
		var cmd:IAsyncCommand = new SelectFileHeadersByTypeSQLOperation(this, fileType);
		sqlCmdManager.add(cmd);
		return cmd;
	}

	public function loadFavoriteFileHeaders():IAsyncOperation {
		var cmd:IAsyncCommand = new SelectFavoriteFileHeadersSQLOperation(this);
		sqlCmdManager.add(cmd);
		return cmd;
	}

	//--------------------------------------
	//  body
	//--------------------------------------

	public function storeBody(body:FileBody):IAsyncOperation {
		var cmd:IAsyncCommand = new StoreFileBodySQLOperation(wrapFileBody(body));
		sqlCmdManager.add(cmd);
		return cmd;
	}

	public function loadFileBody(header:FileHeader):IAsyncOperation {
		var cmd:IAsyncCommand = new SelectFileBodySQLOperation(wrapFileHeader(header), system);
		sqlCmdManager.add(cmd);
		return cmd;
	}

	//--------------------------------------
	//  wrap
	//--------------------------------------

	private function wrapFileHeader(header:FileHeader):FileSQLWrapper {
		var wrapper:FileSQLWrapper = new FileSQLWrapper();
		wrapper.header = header;
		wrapper.sqlConnection = sqlConnection;
		wrapper.encryptionService = encryptionService;
		return wrapper;
	}

	private function wrapFileBody(body:FileBody):FileSQLWrapper {
		var wrapper:FileSQLWrapper = new FileSQLWrapper();
		wrapper.body = body;
		wrapper.sqlConnection = sqlConnection;
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

		var cmd:IAsyncCommand = new StorePhotoSQLOperation(sqlConnection, bitmap, title, fileID);
		sqlCmdManager.add(cmd);
		return cmd;
	}

	public function updatePhoto(photoId:int, bitmap:BitmapData, title:String, fileID:int):IAsyncOperation {
		var cmd:IAsyncCommand = new UpdatePhotoSQLOperation(sqlConnection, photoId, bitmap, title, fileID);
		sqlCmdManager.add(cmd);
		return cmd;
	}

	public function removePhoto(photoId:int):IAsyncOperation {
		var cmd:IAsyncCommand = new RemovePhotoSQLOperation(sqlConnection, photoId);
		sqlCmdManager.add(cmd);
		return cmd;
	}

	public function loadPhotosInfo(fileID:int):IAsyncOperation {
		var cmd:IAsyncCommand = new SelectPhotosInfoSQLOperation(sqlConnection, fileID);
		sqlCmdManager.add(cmd);
		return cmd;
	}

	public function loadPhotoBitmap(photoID:int):IAsyncOperation {
		var cmd:IAsyncCommand = new SelectPhotoSQLOperation(sqlConnection, photoID);
		sqlCmdManager.add(cmd);
		return cmd;
	}

	public function loadPhotoPreview(photoID:int):IAsyncOperation {
		var cmd:IAsyncCommand = new SelectPhotoSQLOperation(sqlConnection, photoID, true);
		sqlCmdManager.add(cmd);
		return cmd;
	}

}
}