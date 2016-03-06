package dittner.siegmar.backend.sqlOperation {
import dittner.async.AsyncCommand;

import flash.data.SQLConnection;
import flash.data.SQLResult;
import flash.data.SQLStatement;
import flash.errors.SQLError;
import flash.net.Responder;

public class SelectPhotosInfoSQLOperation extends AsyncCommand {

	public function SelectPhotosInfoSQLOperation(sqlConnection:SQLConnection, fileID:int) {
		this.fileID = fileID;
		this.sqlConnection = sqlConnection;
	}

	private var fileID:int;
	private var sqlConnection:SQLConnection;

	override public function execute():void {
		var insertStmt:SQLStatement = SQLUtils.createSQLStatement(SQLLib.SELECT_PHOTOS_INFO, {fileID: fileID});
		insertStmt.sqlConnection = sqlConnection;
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