package dittner.siegmar.backend.sqlOperation {
import dittner.async.AsyncCommand;

import flash.data.SQLConnection;
import flash.data.SQLResult;
import flash.data.SQLStatement;
import flash.errors.SQLError;
import flash.net.Responder;

public class RemovePhotoSQLOperation extends AsyncCommand {

	public function RemovePhotoSQLOperation(sqlConnection:SQLConnection, photoID:int) {
		this.sqlConnection = sqlConnection;
		this.photoID = photoID;
	}

	private var sqlConnection:SQLConnection;
	private var photoID:int;

	override public function execute():void {
		if (!photoID) {
			dispatchError("No photoID!");
			return;
		}

		var sqlText:String = SQLLib.DELETE_PHOTO_BY_ID;
		var sqlParams:Object = {};
		sqlParams.id = photoID;

		var insertStmt:SQLStatement = SQLUtils.createSQLStatement(sqlText, sqlParams);
		insertStmt.sqlConnection = sqlConnection;
		insertStmt.execute(-1, new Responder(resultHandler, errorHandler));
	}

	private function resultHandler(result:SQLResult):void {
		dispatchSuccess(result.lastInsertRowID);
	}

	private function errorHandler(error:SQLError):void {
		dispatchError(error.details);
	}

}
}