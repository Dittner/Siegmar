package dittner.gsa.domain.store {
import com.probertson.data.SQLRunner;

import dittner.gsa.backend.encryption.IEncryptionService;
import dittner.gsa.backend.sqlOperation.CreateDataBaseSQLOperation;
import dittner.gsa.backend.sqlOperation.InsertFileSQLOperation;
import dittner.gsa.backend.sqlOperation.SQLFactory;
import dittner.gsa.backend.sqlOperation.SelectFilesSQLOperation;
import dittner.gsa.bootstrap.async.AsyncOperation;
import dittner.gsa.bootstrap.async.AsyncOperationResult;
import dittner.gsa.bootstrap.async.IAsyncOperation;
import dittner.gsa.bootstrap.deferredOperation.DeferredOperationManager;
import dittner.gsa.bootstrap.deferredOperation.IDeferredOperation;
import dittner.gsa.bootstrap.walter.WalterProxy;
import dittner.gsa.domain.fileSystem.GSAFileSystem;
import dittner.gsa.domain.fileSystem.IGSAFile;
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

	public function store(entity:IStoreEntity):IAsyncOperation {
		var file:IGSAFile = entity as IGSAFile;
		return file.header.id == -1 ? insert(file) : update(file);
	}

	private function insert(entity:IStoreEntity):IAsyncOperation {
		var file:IGSAFile = entity as IGSAFile;
		var op:IDeferredOperation = new InsertFileSQLOperation(this, file, encryptionService);
		op.addCompleteCallback(function (res:AsyncOperationResult):void { sendMessage(FILE_STORED); });
		deferredOperationManager.add(op);
		return op;
	}

	private function update(entity:IStoreEntity):IAsyncOperation {
		var file:IGSAFile = entity as IGSAFile;
		var op:IAsyncOperation = new AsyncOperation();
		return op;
	}

	public function remove(entity:IStoreEntity):IAsyncOperation {
		var file:IGSAFile = entity as IGSAFile;
		var op:IAsyncOperation = new AsyncOperation();
		return op;
	}

	public function loadFiles(parentFolderID:int):IAsyncOperation {
		var op:IDeferredOperation = new SelectFilesSQLOperation(this, parentFolderID, system);
		deferredOperationManager.add(op);
		return op;
	}

}
}