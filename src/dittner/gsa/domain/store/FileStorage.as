package dittner.gsa.domain.store {
import com.probertson.data.SQLRunner;

import dittner.gsa.backend.command.CommandResult;
import dittner.gsa.backend.encryption.IEncryptionService;
import dittner.gsa.backend.sqlOperation.CreateDataBaseSQLOperation;
import dittner.gsa.backend.sqlOperation.InsertFileSQLOperation;
import dittner.gsa.backend.sqlOperation.SQLFactory;
import dittner.gsa.backend.sqlOperation.SelectFilesHeadersSQLOperation;
import dittner.gsa.bootstrap.deferredOperation.DeferredOperationManager;
import dittner.gsa.bootstrap.deferredOperation.IDeferredOperation;
import dittner.gsa.domain.fileSystem.GSAFileSystem;
import dittner.gsa.domain.fileSystem.IFolder;
import dittner.gsa.domain.fileSystem.ISystemFile;
import dittner.gsa.domain.user.IUser;
import dittner.gsa.utils.async.AsyncOperation;
import dittner.gsa.utils.async.AsyncOperationResult;
import dittner.gsa.utils.async.IAsyncOperation;
import dittner.walter.WalterModel;

public class FileStorage extends WalterModel {

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

	public function store(entity:ISystemFile):IAsyncOperation {
		return entity.id == -1 ? insert(entity) : update(entity);
	}

	private function insert(entity:ISystemFile):IAsyncOperation {
		var asyncOp:IAsyncOperation = new AsyncOperation();
		var op:IDeferredOperation = new InsertFileSQLOperation(this, entity, encryptionService);
		//op.addCompleteCallback(notify);
		requestHandler(asyncOp, op);
		deferredOperationManager.add(op);
		return asyncOp;
	}

	private function update(entity:ISystemFile):IAsyncOperation {
		var op:IAsyncOperation = new AsyncOperation();
		return op;
	}

	public function remove(entity:ISystemFile):IAsyncOperation {
		var op:IAsyncOperation = new AsyncOperation();
		return op;
	}

	public function loadFilesHeaders(parentFolder:IFolder):IAsyncOperation {
		var asyncOp:IAsyncOperation = new AsyncOperation();
		var op:IDeferredOperation = new SelectFilesHeadersSQLOperation(this, parentFolder, system);
		requestHandler(asyncOp, op);
		deferredOperationManager.add(op);
		return asyncOp;
	}

	//----------------------------------------------------------------------------------------------
	//
	//  Handlers
	//
	//----------------------------------------------------------------------------------------------

	private function requestHandler(asyncOp:IAsyncOperation, op:IDeferredOperation):void {
		op.addCompleteCallback(function (res:CommandResult):void {
			asyncOp.dispatchComplete(res.isSuccess ? new AsyncOperationResult(res.data) : new AsyncOperationResult(res.details, false));
		});
	}

}
}