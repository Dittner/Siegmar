package de.dittner.siegmar.backend.op {
import de.dittner.async.AsyncCommand;
import de.dittner.siegmar.backend.FileStorage;
import de.dittner.siegmar.backend.SQLLib;
import de.dittner.siegmar.domain.fileSystem.header.FileHeader;

import flash.data.SQLResult;
import flash.data.SQLStatement;
import flash.errors.SQLError;
import flash.net.Responder;

public class SelectFavoriteFileHeadersSQLOperation extends AsyncCommand {

	public function SelectFavoriteFileHeadersSQLOperation(storage:FileStorage) {
		this.storage = storage;
	}

	private var storage:FileStorage;

	override public function execute():void {
		var insertStmt:SQLStatement = SQLUtils.createSQLStatement(SQLLib.SELECT_FAVORITE_FILE_HEADERS_SQL, {}, FileHeader);
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