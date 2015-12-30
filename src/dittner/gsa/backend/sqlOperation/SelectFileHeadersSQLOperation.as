package dittner.gsa.backend.sqlOperation {
import dittner.gsa.bootstrap.async.AsyncCommand;
import dittner.gsa.domain.fileSystem.FileHeader;
import dittner.gsa.domain.fileSystem.GSAFileSystem;
import dittner.gsa.domain.store.FileStorage;

import flash.data.SQLResult;
import flash.data.SQLStatement;
import flash.errors.SQLError;
import flash.net.Responder;

public class SelectFileHeadersSQLOperation extends AsyncCommand {

	public function SelectFileHeadersSQLOperation(storage:FileStorage, parentFolderID:int, system:GSAFileSystem) {
		this.parentFolderID = parentFolderID;
		this.storage = storage;
		this.system = system;
	}

	private var parentFolderID:int;
	private var storage:FileStorage;
	private var system:GSAFileSystem;

	override public function execute():void {
		var insertStmt:SQLStatement = SQLUtils.createSQLStatement(SQLLib.SELECT_FILE_HEADERS_SQL, {parentFolderID: parentFolderID}, FileHeader);
		insertStmt.sqlConnection = storage.sqlConnection;
		insertStmt.execute(-1, new Responder(resultHandler, errorHandler));
	}

	private function resultHandler(result:SQLResult):void {
		var fileHeaders:Array = [];
		for each(var header:FileHeader in result.data)
			fileHeaders.push(header);
		dispatchSuccess(fileHeaders);
	}

	private function errorHandler(error:SQLError):void {
		dispatchError(error.details);
	}
}
}