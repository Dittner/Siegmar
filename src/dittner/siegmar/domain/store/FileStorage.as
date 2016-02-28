package dittner.siegmar.domain.store {
import dittner.async.IAsyncCommand;
import dittner.async.IAsyncOperation;
import dittner.async.AsyncOperation;
import dittner.siegmar.backend.encryption.EncryptionService;
import dittner.siegmar.backend.sqlOperation.FileSQLWrapper;
import dittner.siegmar.backend.sqlOperation.RemoveFileSQLOperation;
import dittner.siegmar.backend.sqlOperation.RunDataBaseSQLOperation;
import dittner.siegmar.backend.sqlOperation.SQLLib;
import dittner.siegmar.backend.sqlOperation.SelectFavoriteFileHeadersSQLOperation;
import dittner.siegmar.backend.sqlOperation.SelectFileBodySQLOperation;
import dittner.siegmar.backend.sqlOperation.SelectFileHeadersByTypeSQLOperation;
import dittner.siegmar.backend.sqlOperation.SelectFileHeadersSQLOperation;
import dittner.siegmar.backend.sqlOperation.StoreFileBodySQLOperation;
import dittner.siegmar.backend.sqlOperation.StoreFileHeaderSQLOperation;
import dittner.siegmar.bootstrap.async.SQLCommandManager;
import dittner.siegmar.bootstrap.walter.WalterProxy;
import dittner.siegmar.domain.fileSystem.SiegmarFileSystem;
import dittner.siegmar.domain.fileSystem.body.FileBody;
import dittner.siegmar.domain.fileSystem.header.FileHeader;

import flash.data.SQLConnection;

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

	private var sqlCmdManager:SQLCommandManager;

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
		sqlCmdManager = new SQLCommandManager();

		cmd = new RunDataBaseSQLOperation(dataBasePwd, [SQLLib.CREATE_FILE_HEADER_TBL, SQLLib.CREATE_FILE_BODY_TBL]);
		cmd.addCompleteCallback(dataBaseOpened);
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
}
}