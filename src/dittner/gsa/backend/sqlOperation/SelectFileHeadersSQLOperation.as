package dittner.gsa.backend.sqlOperation {
import dittner.gsa.bootstrap.deferredOperation.DeferredOperation;
import dittner.gsa.domain.fileSystem.FileHeader;
import dittner.gsa.domain.fileSystem.GSAFileSystem;
import dittner.gsa.domain.store.FileStorage;

import flash.data.SQLResult;

public class SelectFileHeadersSQLOperation extends DeferredOperation {

	public function SelectFileHeadersSQLOperation(storage:FileStorage, parentFolderID:int, system:GSAFileSystem) {
		this.parentFolderID = parentFolderID;
		this.storage = storage;
		this.system = system;
	}

	private var parentFolderID:int;
	private var storage:FileStorage;
	private var system:GSAFileSystem;

	override public function process():void {
		storage.sqlRunner.execute(storage.sqlFactory.selectFileHeaders, {parentFolderID: parentFolderID}, loadCompleteHandler, FileHeader);
	}

	private function loadCompleteHandler(result:SQLResult):void {
		var fileHeaders:Array = [];
		for each(var header:FileHeader in result.data) {
			fileHeaders.push(header);
		}
		dispatchSuccess(fileHeaders);
	}
}
}