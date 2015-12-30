package dittner.gsa.backend.sqlOperation.phase {
import dittner.gsa.backend.sqlOperation.FileSQLWrapper;
import dittner.gsa.backend.sqlOperation.SQLLib;
import dittner.gsa.backend.sqlOperation.SQLUtils;
import dittner.gsa.bootstrap.async.AsyncCommand;
import dittner.gsa.domain.fileSystem.FileType;

import flash.data.SQLResult;
import flash.data.SQLStatement;
import flash.errors.SQLError;
import flash.net.Responder;

public class SelectHeaderIDsToRemoveOperation extends AsyncCommand {

	public function SelectHeaderIDsToRemoveOperation(fileWrapper:FileSQLWrapper) {
		this.headerWrapper = fileWrapper;
	}

	private var headerWrapper:FileSQLWrapper;

	override public function execute():void {
		headerWrapper.removingFileIDs.push(headerWrapper.header.fileID);

		if (headerWrapper.header.isFolder) {
			var stmt:SQLStatement = SQLUtils.createSQLStatement(SQLLib.SELECT_ALL_FILES_HEADERS, {});
			stmt.sqlConnection = headerWrapper.sqlConnection;
			stmt.execute(-1, new Responder(resultHandler, errorHandler));
		}
		else {
			dispatchSuccess();
		}
	}

	private function resultHandler(result:SQLResult):void {
		fileHeaders = result.data;
		getChildrenFrom(headerWrapper.header.fileID);
		dispatchSuccess();
	}

	private var fileHeaders:Array;
	private function getChildrenFrom(parentID:int):void {
		for each(var header:Object in fileHeaders)
			if (header.parentID == parentID) {
				headerWrapper.removingFileIDs.push(header.fileID);
				if (header.fileType == FileType.FOLDER) getChildrenFrom(header.fileID);
			}
	}

	private function errorHandler(error:SQLError):void {
		dispatchError(error.details);
	}

	override public function destroy():void {
		super.destroy();
		headerWrapper = null;
	}
}
}
