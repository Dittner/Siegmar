package dittner.siegmar.backend.sqlOperation {
import dittner.siegmar.bootstrap.async.AsyncCommand;

import flash.data.SQLResult;
import flash.data.SQLStatement;
import flash.errors.SQLError;
import flash.net.Responder;
import flash.utils.ByteArray;

public class StoreFileBodySQLOperation extends AsyncCommand {

	public function StoreFileBodySQLOperation(fileWrapper:FileSQLWrapper) {
		this.bodyWrapper = fileWrapper;
	}

	private var bodyWrapper:FileSQLWrapper;

	override public function execute():void {
		try {
			var bytes:ByteArray = bodyWrapper.body.serialize();
			var sqlParams:Object = {};
			sqlParams.fileID = bodyWrapper.body.fileID;
			sqlParams.bytes = bodyWrapper.body.encryptEnabled ? bodyWrapper.encryptionService.encrypt(bytes) : bytes;
			var sqlText:String = isNewFile ? SQLLib.INSERT_FILE_BODY : SQLLib.UPDATE_FILE_BODY;

			var insertStmt:SQLStatement = SQLUtils.createSQLStatement(sqlText, sqlParams);
			insertStmt.sqlConnection = bodyWrapper.sqlConnection;
			insertStmt.execute(-1, new Responder(resultHandler, errorHandler));
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

	private function errorHandler(error:SQLError):void {
		dispatchError(error.details);
	}

}
}