package de.dittner.siegmar.backend.op {
import de.dittner.async.IAsyncCommand;
import de.dittner.siegmar.backend.FileStorage;
import de.dittner.siegmar.backend.SQLLib;
import de.dittner.siegmar.model.domain.fileSystem.header.FileHeader;

import flash.data.SQLResult;
import flash.data.SQLStatement;
import flash.net.Responder;

public class SelectFavoriteFileHeadersSQLOperation extends StorageOperation implements IAsyncCommand {

	public function SelectFavoriteFileHeadersSQLOperation(storage:FileStorage) {
		this.storage = storage;
	}

	private var storage:FileStorage;

	public function execute():void {
		var insertStmt:SQLStatement = SQLUtils.createSQLStatement(SQLLib.SELECT_FAVORITE_FILE_HEADERS_SQL, {}, FileHeader);
		insertStmt.sqlConnection = storage.textDBConnection;
		insertStmt.execute(-1, new Responder(resultHandler, executeError));
	}

	private function resultHandler(result:SQLResult):void {
		dispatchSuccess(result.data || []);
	}
}
}