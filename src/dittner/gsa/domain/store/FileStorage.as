package dittner.gsa.domain.store {
import com.probertson.data.SQLRunner;

import dittner.gsa.backend.encryption.IEncryptionService;
import dittner.gsa.backend.sqlOperation.CreateDataBaseSQLOperation;
import dittner.gsa.backend.sqlOperation.FileSQLWrapper;
import dittner.gsa.backend.sqlOperation.RemoveFileHeaderSQLOperation;
import dittner.gsa.backend.sqlOperation.SQLFactory;
import dittner.gsa.backend.sqlOperation.SelectFileBodySQLOperation;
import dittner.gsa.backend.sqlOperation.SelectFileHeadersSQLOperation;
import dittner.gsa.backend.sqlOperation.StoreFileBodySQLOperation;
import dittner.gsa.backend.sqlOperation.StoreFileHeaderSQLOperation;
import dittner.gsa.bootstrap.async.AsyncOperation;
import dittner.gsa.bootstrap.async.IAsyncOperation;
import dittner.gsa.bootstrap.deferredOperation.DeferredOperationManager;
import dittner.gsa.bootstrap.deferredOperation.IDeferredOperation;
import dittner.gsa.bootstrap.walter.WalterProxy;
import dittner.gsa.domain.fileSystem.FileHeader;
import dittner.gsa.domain.fileSystem.GSAFileSystem;
import dittner.gsa.domain.fileSystem.body.FileBody;
import dittner.gsa.domain.user.IUser;

public class FileStorage extends WalterProxy {

	public static const FILE_STORED:String = "stored";

	public function FileStorage() {}

	[Inject]
	public var user:IUser;
	[Inject]
	public var sqlFactory:SQLFactory;
	[Inject]
	public var deferredOperationManager:DeferredOperationManager;
	[Inject]
	public var encryptionService:IEncryptionService;
	[Inject]
	public var system:GSAFileSystem;

	public var sqlRunner:SQLRunner;

	//----------------------------------------------------------------------------------------------
	//
	//  Methods
	//
	//----------------------------------------------------------------------------------------------

	override protected function activate():void {
		var op:IDeferredOperation = new CreateDataBaseSQLOperation(this, sqlFactory);
		deferredOperationManager.add(op);
	}

	//--------------------------------------
	//  header
	//--------------------------------------

	public function storeHeader(header:FileHeader):IAsyncOperation {
		var op:IDeferredOperation = new StoreFileHeaderSQLOperation(wrapFileHeader(header));
		op.addCompleteCallback(notifyFileStored);
		deferredOperationManager.add(op);
		return op;
	}

	public function removeHeader(header:FileHeader):IAsyncOperation {
		var op:IDeferredOperation = new RemoveFileHeaderSQLOperation(wrapFileHeader(header));
		op.addCompleteCallback(notifyFileStored);
		deferredOperationManager.add(op);
		return op;
	}

	public function loadFileHeaders(parentFolderID:int):IAsyncOperation {
		var op:IDeferredOperation = new SelectFileHeadersSQLOperation(this, parentFolderID, system);
		deferredOperationManager.add(op);
		return op;
	}

	//--------------------------------------
	//  body
	//--------------------------------------

	public function storeBody(body:FileBody):IAsyncOperation {
		var op:IDeferredOperation = new StoreFileBodySQLOperation(wrapFileBody(body));
		deferredOperationManager.add(op);
		return op;
	}

	public function removeBody(body:FileBody):IAsyncOperation {
		var op:IAsyncOperation = new AsyncOperation();
		return op;
	}

	public function loadFileBody(header:FileHeader):IAsyncOperation {
		var op:IDeferredOperation = new SelectFileBodySQLOperation(wrapFileHeader(header), system);
		deferredOperationManager.add(op);
		return op;
	}

	//--------------------------------------
	//  wrap
	//--------------------------------------

	private function wrapFileHeader(header:FileHeader):FileSQLWrapper {
		var wrapper:FileSQLWrapper = new FileSQLWrapper();
		wrapper.header = header;
		wrapper.sqlRunner = sqlRunner;
		wrapper.sqlFactory = sqlFactory;
		wrapper.encryptionService = encryptionService;
		return wrapper;
	}

	private function wrapFileBody(body:FileBody):FileSQLWrapper {
		var wrapper:FileSQLWrapper = new FileSQLWrapper();
		wrapper.body = body;
		wrapper.sqlRunner = sqlRunner;
		wrapper.sqlFactory = sqlFactory;
		wrapper.encryptionService = encryptionService;
		return wrapper;
	}

	private function notifyFileStored(op:IAsyncOperation):void {
		if (op.isSuccess) sendMessage(FILE_STORED);
	}
}
}