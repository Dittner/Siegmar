package de.dittner.siegmar.backend.op {
import de.dittner.async.IAsyncCommand;
import de.dittner.siegmar.backend.SQLLib;

import flash.data.SQLConnection;
import flash.data.SQLResult;
import flash.data.SQLStatement;
import flash.net.Responder;

public class RemovePhotoSQLOperation extends StorageOperation implements IAsyncCommand {

	public function RemovePhotoSQLOperation(photoDBConnection:SQLConnection, photoID:int) {
		this.photoDBConnection = photoDBConnection;
		this.photoID = photoID;
	}

	private var photoDBConnection:SQLConnection;
	private var photoID:int;

	public function execute():void {
		if (!photoID) {
			dispatchError("No photoID!");
			return;
		}

		var sqlText:String = SQLLib.DELETE_PHOTO_BY_ID;
		var sqlParams:Object = {};
		sqlParams.id = photoID;

		var insertStmt:SQLStatement = SQLUtils.createSQLStatement(sqlText, sqlParams);
		insertStmt.sqlConnection = photoDBConnection;
		insertStmt.execute(-1, new Responder(resultHandler, executeError));
	}

	private function resultHandler(result:SQLResult):void {
		dispatchSuccess(result.lastInsertRowID);
	}

}
}