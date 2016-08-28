package de.dittner.siegmar.backend.op {
import de.dittner.async.IAsyncCommand;
import de.dittner.siegmar.backend.SQLLib;

import flash.data.SQLConnection;
import flash.data.SQLResult;
import flash.data.SQLStatement;
import flash.net.Responder;

public class RemovePhotoByFileIDSQLOperation extends StorageOperation implements IAsyncCommand {

	public function RemovePhotoByFileIDSQLOperation(photoDBConnection:SQLConnection, fileID:int) {
		this.photoDBConnection = photoDBConnection;
		this.fileID = fileID;
	}

	private var photoDBConnection:SQLConnection;
	private var fileID:int;

	public function execute():void {
		var deleteStmt:SQLStatement = SQLUtils.createSQLStatement(SQLLib.DELETE_PHOTO_BY_FILE_ID, {fileID: fileID});
		deleteStmt.sqlConnection = photoDBConnection;
		deleteStmt.execute(-1, new Responder(resultHandler, executeError));
	}

	private function resultHandler(result:SQLResult):void {
		dispatchSuccess();
	}
}
}
