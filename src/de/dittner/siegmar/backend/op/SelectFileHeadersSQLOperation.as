package de.dittner.siegmar.backend.op {
import de.dittner.async.AsyncCommand;
import de.dittner.siegmar.backend.FileStorage;
import de.dittner.siegmar.backend.SQLLib;
import de.dittner.siegmar.model.domain.fileSystem.header.FileHeader;

import flash.data.SQLResult;
import flash.data.SQLStatement;
import flash.errors.SQLError;
import flash.net.Responder;

public class SelectFileHeadersSQLOperation extends AsyncCommand {

	public function SelectFileHeadersSQLOperation(storage:FileStorage, parentFolderID:int) {
		this.parentFolderID = parentFolderID;
		this.storage = storage;
	}

	private var parentFolderID:int;
	private var storage:FileStorage;

	override public function execute():void {
		var insertStmt:SQLStatement = SQLUtils.createSQLStatement(SQLLib.SELECT_FILE_HEADERS_SQL, {parentFolderID: parentFolderID}, FileHeader);
		insertStmt.sqlConnection = storage.sqlConnection;
		insertStmt.execute(-1, new Responder(resultHandler, errorHandler));
	}

	private function resultHandler(result:SQLResult):void {
		dispatchSuccess(result.data || []);
	}

	private function errorHandler(error:SQLError):void {
		dispatchError(error.details);
	}
}
}