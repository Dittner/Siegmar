package dittner.gsa.domain.store {
import dittner.gsa.backend.encryption.EncryptionService;
import dittner.gsa.backend.sqlOperation.FileSQLWrapper;
import dittner.gsa.backend.sqlOperation.RemoveFileSQLOperation;
import dittner.gsa.backend.sqlOperation.RunDataBaseSQLOperation;
import dittner.gsa.backend.sqlOperation.SQLLib;
import dittner.gsa.backend.sqlOperation.SelectFileBodySQLOperation;
import dittner.gsa.backend.sqlOperation.SelectFileHeadersSQLOperation;
import dittner.gsa.backend.sqlOperation.StoreFileBodySQLOperation;
import dittner.gsa.backend.sqlOperation.StoreFileHeaderSQLOperation;
import dittner.gsa.bootstrap.async.AsyncOperation;
import dittner.gsa.bootstrap.async.IAsyncCommand;
import dittner.gsa.bootstrap.async.IAsyncOperation;
import dittner.gsa.bootstrap.async.SQLCommandManager;
import dittner.gsa.bootstrap.walter.WalterProxy;
import dittner.gsa.domain.fileSystem.FileHeader;
import dittner.gsa.domain.fileSystem.GSAFileSystem;
import dittner.gsa.domain.fileSystem.body.FileBody;

import flash.data.SQLConnection;

public class FileStorage extends WalterProxy {

	public static const FILE_STORED:String = "stored";

	public function FileStorage() {}

	[Inject]
	public var encryptionService:EncryptionService;
	[Inject]
	public var system:GSAFileSystem;

	private var sqlCmdManager:SQLCommandManager;

	private var _sqlConnection:SQLConnection;
	public function get sqlConnection():SQLConnection {return _sqlConnection;}

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
		var cmd:IAsyncCommand = new StoreFileHeaderSQLOperation(wrapFileHeader(header));
		cmd.addCompleteCallback(notifyFileStored);
		sqlCmdManager.add(cmd);
		return cmd;
	}

	public function removeHeader(header:FileHeader):IAsyncOperation {
		var cmd:IAsyncCommand = new RemoveFileSQLOperation(wrapFileHeader(header));
		cmd.addCompleteCallback(notifyFileStored);
		sqlCmdManager.add(cmd);
		return cmd;
	}

	public function loadFileHeaders(parentFolderID:int):IAsyncOperation {
		var cmd:IAsyncCommand = new SelectFileHeadersSQLOperation(this, parentFolderID, system);
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

	public function removeBody(body:FileBody):IAsyncOperation {
		var op:IAsyncOperation = new AsyncOperation();
		return op;
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
}
}