package de.dittner.siegmar.backend.op {
import de.dittner.async.IAsyncCommand;
import de.dittner.siegmar.backend.SQLLib;

import flash.data.SQLConnection;
import flash.data.SQLResult;
import flash.data.SQLStatement;
import flash.net.Responder;

public class SelectPhotosInfoSQLOperation extends StorageOperation implements IAsyncCommand {

	public function SelectPhotosInfoSQLOperation(photoDBConnection:SQLConnection, fileID:int) {
		this.fileID = fileID;
		this.photoDBConnection = photoDBConnection;
	}

	private var fileID:int;
	private var photoDBConnection:SQLConnection;

	public function execute():void {
		var insertStmt:SQLStatement = SQLUtils.createSQLStatement(SQLLib.SELECT_PHOTOS_INFO, {fileID: fileID});
		insertStmt.sqlConnection = photoDBConnection;
		insertStmt.execute(-1, new Responder(resultHandler, executeError));
	}

	private function resultHandler(result:SQLResult):void {
		dispatchSuccess(result.data || []);
	}
}
}