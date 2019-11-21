package de.dittner.siegmar.backend.op {
import de.dittner.async.IAsyncCommand;
import de.dittner.siegmar.backend.SQLLib;

import flash.data.SQLResult;
import flash.data.SQLStatement;
import flash.net.Responder;

public class StoreFileHeaderSQLOperation extends StorageOperation implements IAsyncCommand {

	public function StoreFileHeaderSQLOperation(fileWrapper:FileSQLWrapper) {
		this.headerWrapper = fileWrapper;
	}

	private var headerWrapper:FileSQLWrapper;

	public function execute():void {
		try {
			var sqlParams:Object = headerWrapper.headerToSQLObj();
			var sqlText:String;
			if (headerWrapper.header.isNewFile) {
				sqlText = SQLLib.INSERT_FILE_HEADER
			}
			else {
				sqlParams.fileID = headerWrapper.header.fileID;
				sqlText = SQLLib.UPDATE_FILE_HEADER;
			}

			var insertStmt:SQLStatement = SQLUtils.createSQLStatement(sqlText, sqlParams);
			insertStmt.sqlConnection = headerWrapper.textDBConnection;
			insertStmt.execute(-1, new Responder(resultHandler, executeError));
		}
		catch (exc:Error) {
			dispatchError(exc.message);
		}
	}

	private function resultHandler(result:SQLResult):void {
		if (headerWrapper.header.isNewFile)
			if (result.rowsAffected > 0) headerWrapper.header.fileID = result.lastInsertRowID;
		dispatchSuccess();
	}

}
}