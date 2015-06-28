package dittner.gsa.backend.sqlOperation {
import dittner.gsa.bootstrap.async.AsyncOperationResult;
import dittner.gsa.bootstrap.deferredOperation.DeferredOperation;
import dittner.gsa.domain.fileSystem.GSAFileSystem;
import dittner.gsa.domain.fileSystem.body.FileBody;

import flash.data.SQLResult;
import flash.utils.ByteArray;

public class SelectFileBodySQLOperation extends DeferredOperation {

	public function SelectFileBodySQLOperation(fileWrapper:FileSQLWrapper, system:GSAFileSystem) {
		this.headerWrapper = fileWrapper;
		this.system = system;
	}

	private var headerWrapper:FileSQLWrapper;
	private var system:GSAFileSystem;

	override public function process():void {
		headerWrapper.sqlRunner.execute(headerWrapper.sqlFactory.selectFileBody, {fileID: headerWrapper.header.fileID}, loadCompleteHandler);
	}

	private function loadCompleteHandler(result:SQLResult):void {
		var fileBody:FileBody = system.createFileBody(headerWrapper.header);
		var data:Object = result.data ? result.data[0] : null;
		if (data) {
			fileBody.id = data.id;
			fileBody.fileID = data.fileID;
			var decryptedBytes:ByteArray = decrypt(data.bytes);
			decryptedBytes.position = 0;
			fileBody.deserialize(decryptedBytes);
		}
		dispatchComplete(new AsyncOperationResult(fileBody));
	}

	private function decrypt(ba:ByteArray):ByteArray {
		return headerWrapper.encryptionService.decrypt(ba);
	}
}
}