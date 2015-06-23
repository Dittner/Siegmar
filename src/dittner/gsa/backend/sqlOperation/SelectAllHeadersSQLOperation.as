package dittner.gsa.backend.sqlOperation {
import dittner.gsa.bootstrap.async.AsyncOperationResult;
import dittner.gsa.bootstrap.deferredOperation.DeferredOperation;
import dittner.gsa.domain.fileSystem.FileHeader;
import dittner.gsa.domain.fileSystem.GSAFileSystem;
import dittner.gsa.domain.store.FileStorage;

import flash.data.SQLResult;

public class SelectAllHeadersSQLOperation extends DeferredOperation {

	public function SelectAllHeadersSQLOperation(storage:FileStorage, parentFolderID:int, system:GSAFileSystem) {
		this.parentFolderID = parentFolderID;
		this.storage = storage;
		this.system = system;
	}

	private var parentFolderID:int;
	private var storage:FileStorage;
	private var system:GSAFileSystem;

	override public function process():void {
		storage.sqlRunner.execute(storage.sqlFactory.selectAllFileHeaders, null, loadCompleteHandler, FileHeader);
	}

	private function loadCompleteHandler(result:SQLResult):void {
		var fileHeaders:Array = [];
		for each(var header:FileHeader in result.data) {
			fileHeaders.push(header);
		}
		dispatchComplete(new AsyncOperationResult(fileHeaders));
	}
}
}