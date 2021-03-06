package de.dittner.siegmar.backend.op {
import de.dittner.async.IAsyncCommand;
import de.dittner.siegmar.backend.FileStorage;
import de.dittner.siegmar.backend.SQLLib;
import de.dittner.siegmar.model.domain.fileSystem.header.FileHeader;

import flash.data.SQLResult;
import flash.data.SQLStatement;
import flash.net.Responder;

public class SelectFileHeadersByTypeSQLOperation extends StorageOperation implements IAsyncCommand {

	public function SelectFileHeadersByTypeSQLOperation(storage:FileStorage, fileType:uint) {
		this.fileType = fileType;
		this.storage = storage;
	}

	private var fileType:uint;
	private var storage:FileStorage;

	public function execute():void {
		var insertStmt:SQLStatement = SQLUtils.createSQLStatement(SQLLib.SELECT_FILE_HEADERS_BY_TYPE_SQL, {fileType: fileType}, FileHeader);
		insertStmt.sqlConnection = storage.textDBConnection;
		insertStmt.execute(-1, new Responder(resultHandler, executeError));
	}

	private function resultHandler(result:SQLResult):void {
		var fileHeaders:Array = [];
		for each(var header:FileHeader in result.data)
			fileHeaders.push(header);
		dispatchSuccess(fileHeaders);
	}
}
}