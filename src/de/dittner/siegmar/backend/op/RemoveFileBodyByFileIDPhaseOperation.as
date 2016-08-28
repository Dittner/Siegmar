package de.dittner.siegmar.backend.op {
import de.dittner.async.IAsyncCommand;
import de.dittner.siegmar.backend.SQLLib;

import flash.data.SQLResult;
import flash.data.SQLStatement;
import flash.net.Responder;

public class RemoveFileBodyByFileIDPhaseOperation extends StorageOperation implements IAsyncCommand {

	public function RemoveFileBodyByFileIDPhaseOperation(headerWrapper:FileSQLWrapper, fileID:int) {
		this.headerWrapper = headerWrapper;
		this.fileID = fileID;
	}

	private var headerWrapper:FileSQLWrapper;
	private var fileID:int;

	public function execute():void {
		var deleteStmt:SQLStatement = SQLUtils.createSQLStatement(SQLLib.DELETE_FILE_BODY_BY_FILE_ID, {fileID: fileID});
		deleteStmt.sqlConnection = headerWrapper.textDBConnection;
		deleteStmt.execute(-1, new Responder(resultHandler, executeError));
	}

	private function resultHandler(result:SQLResult):void {
		dispatchSuccess();
	}

}
}
