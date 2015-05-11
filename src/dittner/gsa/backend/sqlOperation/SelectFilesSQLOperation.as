package dittner.gsa.backend.sqlOperation {
import dittner.gsa.bootstrap.async.AsyncOperationResult;
import dittner.gsa.bootstrap.deferredOperation.DeferredOperation;
import dittner.gsa.domain.fileSystem.GSAFile;
import dittner.gsa.domain.fileSystem.GSAFileHeader;
import dittner.gsa.domain.fileSystem.GSAFileSystem;
import dittner.gsa.domain.store.FileStorage;

import flash.data.SQLResult;

public class SelectFilesSQLOperation extends DeferredOperation {

	public function SelectFilesSQLOperation(storage:FileStorage, parentFolderID:int, system:GSAFileSystem) {
		this.parentFolderID = parentFolderID;
		this.storage = storage;
		this.system = system;
	}

	private var parentFolderID:int;
	private var storage:FileStorage;
	private var system:GSAFileSystem;

	override public function process():void {
		storage.sqlRunner.execute(storage.sqlFactory.selectFilesHeaders, {parentFolderID: parentFolderID}, loadCompleteHandler, GSAFileHeader);
	}

	private function loadCompleteHandler(result:SQLResult):void {
		var files:Array = [];
		var file:GSAFile;
		for each(var header:GSAFileHeader in result.data) {
			file = new GSAFile();
			file.header = header;
			files.push(file);
		}
		dispatchComplete(new AsyncOperationResult(files));
	}
}
}