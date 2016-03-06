package dittner.siegmar.backend.sqlOperation {
import dittner.async.AsyncCommand;

import flash.data.SQLConnection;
import flash.data.SQLResult;
import flash.data.SQLStatement;
import flash.errors.SQLError;
import flash.net.Responder;

public class RemovePhotoByFileIDSQLOperation extends AsyncCommand {

	public function RemovePhotoByFileIDSQLOperation(sqlConnection:SQLConnection, fileID:int) {
		this.sqlConnection = sqlConnection;
		this.fileID = fileID;
	}

	private var sqlConnection:SQLConnection;
	private var fileID:int;

	override public function execute():void {
		var deleteStmt:SQLStatement = SQLUtils.createSQLStatement(SQLLib.DELETE_PHOTO_BY_FILE_ID, {fileID: fileID});
		deleteStmt.sqlConnection = sqlConnection;
		deleteStmt.execute(-1, new Responder(resultHandler, errorHandler));
	}

	private function resultHandler(result:SQLResult):void {
		dispatchSuccess();
	}

	private function errorHandler(error:SQLError):void {
		dispatchError(error.details);
	}
}
}
