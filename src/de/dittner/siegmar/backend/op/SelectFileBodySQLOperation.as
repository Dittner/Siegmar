package de.dittner.siegmar.backend.op {
import de.dittner.async.IAsyncCommand;
import de.dittner.siegmar.backend.SQLLib;
import de.dittner.siegmar.model.domain.fileSystem.SiegmarFileSystem;
import de.dittner.siegmar.model.domain.fileSystem.body.FileBody;

import flash.data.SQLResult;
import flash.data.SQLStatement;
import flash.net.Responder;
import flash.utils.ByteArray;

public class SelectFileBodySQLOperation extends StorageOperation implements IAsyncCommand {

	public function SelectFileBodySQLOperation(fileWrapper:FileSQLWrapper, system:SiegmarFileSystem) {
		this.headerWrapper = fileWrapper;
		this.system = system;
	}

	private var headerWrapper:FileSQLWrapper;
	private var system:SiegmarFileSystem;

	public function execute():void {
		var insertStmt:SQLStatement = SQLUtils.createSQLStatement(SQLLib.SELECT_FILE_BODY, {fileID: headerWrapper.header.fileID});
		insertStmt.sqlConnection = headerWrapper.textDBConnection;
		insertStmt.execute(-1, new Responder(resultHandler, executeError));
	}

	private function resultHandler(result:SQLResult):void {
		var fileBody:FileBody = system.createFileBody(headerWrapper.header);
		var data:Object = result.data ? result.data[0] : null;
		if (data) {
			fileBody.id = data.id;
			fileBody.fileID = data.fileID;
			var decryptedBytes:ByteArray = fileBody.encryptEnabled ? decrypt(data.bytes) : data.bytes;
			decryptedBytes.position = 0;
			fileBody.deserialize(decryptedBytes);
		}
		dispatchSuccess(fileBody);
	}

	private function decrypt(ba:ByteArray):ByteArray {
		return headerWrapper.encryptionService.decrypt(ba);
	}

}
}