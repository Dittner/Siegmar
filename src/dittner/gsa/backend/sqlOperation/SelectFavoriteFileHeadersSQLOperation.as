package dittner.gsa.backend.sqlOperation {
import dittner.gsa.bootstrap.async.AsyncCommand;
import dittner.gsa.domain.fileSystem.header.FileHeader;
import dittner.gsa.domain.store.FileStorage;

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