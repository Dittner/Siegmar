package dittner.siegmar.backend.sqlOperation.phase {
import dittner.async.AsyncCommand;
import dittner.siegmar.backend.sqlOperation.FileSQLWrapper;
import dittner.siegmar.backend.sqlOperation.SQLLib;
import dittner.siegmar.backend.sqlOperation.SQLUtils;

import flash.data.SQLResult;
import flash.data.SQLStatement;
import flash.errors.SQLError;
import flash.net.Responder;

public class RemoveFileHeaderByFileIDPhaseOperation extends AsyncCommand {

	public function RemoveFileHeaderByFileIDPhaseOperation(headerWrapper:FileSQLWrapper, fileID:int) {
		this.headerWrapper = headerWrapper;
		this.fileID = fileID;
	}

	private var headerWrapper:FileSQLWrapper;
	private var fileID:int;

	override public function execute():void {
		var deleteStmt:SQLStatement = SQLUtils.createSQLStatement(SQLLib.DELETE_FILE_HEADER_BY_FILE_ID, {fileID: fileID});
		deleteStmt.sqlConnection = headerWrapper.sqlConnection;
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
