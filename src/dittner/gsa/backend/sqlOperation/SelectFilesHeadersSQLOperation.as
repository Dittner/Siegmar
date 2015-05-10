package dittner.gsa.backend.sqlOperation {
import dittner.gsa.backend.command.CommandResult;
import dittner.gsa.bootstrap.deferredOperation.DeferredOperation;
import dittner.gsa.domain.fileSystem.FileType;
import dittner.gsa.domain.fileSystem.GSAFileSystem;
import dittner.gsa.domain.fileSystem.IFolder;
import dittner.gsa.domain.fileSystem.ISystemFile;
import dittner.gsa.domain.store.FileStorage;

import flash.data.SQLResult;

public class SelectFilesHeadersSQLOperation extends DeferredOperation {

	public function SelectFilesHeadersSQLOperation(storage:FileStorage, parentFolder:IFolder, system:GSAFileSystem) {
		this.parentFolder = parentFolder;
		this.storage = storage;
		this.system = system;
	}

	private var parentFolder:IFolder;
	private var storage:FileStorage;
	private var system:GSAFileSystem;

	override public function process():void {
		if (parentFolder) {
			storage.sqlRunner.execute(storage.sqlFactory.selectFilesHeaders, {parentFolderID: parentFolder.id}, loadCompleteHandler);
		}
		else {
			dispatchComplete(new CommandResult(null, "Parent folder == null, can not to load files!", false));
		}
	}

	private function loadCompleteHandler(result:SQLResult):void {
		var files:Array = [];
		var file:ISystemFile;
		for each(var item:Object in result.data) {
			file = item.fileType == FileType.FOLDER ? system.createFolder(parentFolder.id) : system.createDocument(item.fileType, parentFolder.id);
			file.setFromHeaderInfo(item);
			files.push(file);
		}
		dispatchComplete(new CommandResult(files));
	}
}
}