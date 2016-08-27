package de.dittner.siegmar.backend.sqlOperation {
import de.dittner.siegmar.backend.sqlOperation.*;
import dittner.async.AsyncCommand;
import de.dittner.siegmar.domain.fileSystem.header.FileHeader;
import de.dittner.siegmar.domain.store.FileStorage;

import flash.data.SQLResult;
import flash.data.SQLStatement;
import flash.errors.SQLError;
import flash.net.Responder;

public class SelectFileHeadersByTypeSQLOperation extends AsyncCommand {

	public function SelectFileHeadersByTypeSQLOperation(storage:FileStorage, fileType:uint) {
		this.fileType = fileType;
		this.storage = storage;
	}

	private var fileType:uint;
	private var storage:FileStorage;

	override public function execute():void {
		var insertStmt:SQLStatement = SQLUtils.createSQLStatement(SQLLib.SELECT_FILE_HEADERS_BY_TYPE_SQL, {fileType: fileType}, FileHeader);
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