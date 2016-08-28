package de.dittner.siegmar.backend.op {
import de.dittner.async.IAsyncCommand;
import de.dittner.siegmar.backend.SQLLib;
import de.dittner.siegmar.model.domain.fileSystem.file.FileType;

import flash.data.SQLResult;
import flash.data.SQLStatement;
import flash.net.Responder;

public class SelectHeaderIDsToRemoveOperation extends StorageOperation implements IAsyncCommand {

	public function SelectHeaderIDsToRemoveOperation(fileWrapper:FileSQLWrapper) {
		this.headerWrapper = fileWrapper;
	}

	private var headerWrapper:FileSQLWrapper;

	public function execute():void {
		headerWrapper.removingFileIDs.push(headerWrapper.header.fileID);

		if (headerWrapper.header.isFolder) {
			var stmt:SQLStatement = SQLUtils.createSQLStatement(SQLLib.SELECT_ALL_FILES_HEADERS, {});
			stmt.sqlConnection = headerWrapper.textDBConnection;
			stmt.execute(-1, new Responder(resultHandler, executeError));
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

	override public function destroy():void {
		super.destroy();
		headerWrapper = null;
	}
}
}
