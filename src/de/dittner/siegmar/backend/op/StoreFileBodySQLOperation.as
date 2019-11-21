package de.dittner.siegmar.backend.op {
import de.dittner.async.IAsyncCommand;
import de.dittner.siegmar.backend.SQLLib;

import flash.data.SQLResult;
import flash.data.SQLStatement;
import flash.net.Responder;
import flash.utils.ByteArray;

public class StoreFileBodySQLOperation extends StorageOperation implements IAsyncCommand {

	public function StoreFileBodySQLOperation(fileWrapper:FileSQLWrapper) {
		this.bodyWrapper = fileWrapper;
	}

	private var bodyWrapper:FileSQLWrapper;

	public function execute():void {
		try {
			var bytes:ByteArray = bodyWrapper.body.serialize();
			var sqlParams:Object = {};
			sqlParams.fileID = bodyWrapper.body.fileID;
			sqlParams.bytes = bodyWrapper.body.encryptEnabled ? bodyWrapper.encryptionService.encrypt(bytes) : bytes;
			var sqlText:String = isNewFile ? SQLLib.INSERT_FILE_BODY : SQLLib.UPDATE_FILE_BODY;

			var insertStmt:SQLStatement = SQLUtils.createSQLStatement(sqlText, sqlParams);
			insertStmt.sqlConnection = bodyWrapper.textDBConnection;
			insertStmt.execute(-1, new Responder(resultHandler, executeError));
		}
		catch (exc:Error) {
			dispatchError(exc.message);
		}
	}

	private function get isNewFile():Boolean {
		return bodyWrapper.body.id == -1;
	}

	private function resultHandler(result:SQLResult):void {
		if (isNewFile)
			if (result.rowsAffected > 0) bodyWrapper.body.id = result.lastInsertRowID;
		dispatchSuccess();
	}

}
}