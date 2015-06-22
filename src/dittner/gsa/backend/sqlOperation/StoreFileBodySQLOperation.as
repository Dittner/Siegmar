package dittner.gsa.backend.sqlOperation {
import com.probertson.data.QueuedStatement;

import dittner.gsa.bootstrap.async.AsyncOperationResult;
import dittner.gsa.bootstrap.deferredOperation.DeferredOperation;
import dittner.gsa.domain.fileSystem.body.FileBody;

import flash.data.SQLResult;
import flash.errors.SQLError;
import flash.utils.ByteArray;

public class StoreFileBodySQLOperation extends DeferredOperation {

	public function StoreFileBodySQLOperation(fileWrapper:FileSQLWrapper) {
		this.bodyWrapper = fileWrapper;
	}

	private var bodyWrapper:FileSQLWrapper;

	override public function process():void {
		try {
			var sqlParams:Object = {};
			sqlParams.fileID = bodyWrapper.body.fileID;
			sqlParams.bytes = encrypt(bodyWrapper.body);
			var statement:QueuedStatement;

			if (isNewFile) {
				statement = new QueuedStatement(bodyWrapper.sqlFactory.insertFileBody, sqlParams);
			}
			else {
				statement = new QueuedStatement(bodyWrapper.sqlFactory.updateFileBody, sqlParams);
			}

			bodyWrapper.sqlRunner.executeModify(Vector.<QueuedStatement>([statement]), executeComplete, executeError);
		}
		catch (exc:Error) {
			dispatchComplete(new AsyncOperationResult(exc.message, false));
		}
	}

	private function encrypt(body:FileBody):ByteArray {
		var bytes:ByteArray = body.serialize();
		return bodyWrapper.encryptionService.encrypt(bytes);
	}

	private function get isNewFile():Boolean {
		return bodyWrapper.body.id == -1;
	}

	private function executeComplete(results:Vector.<SQLResult>):void {
		if (isNewFile) {
			var result:SQLResult = results[0];
			if (result.rowsAffected > 0) bodyWrapper.body.id = result.lastInsertRowID;
		}
		dispatchComplete();
	}

	private function executeError(error:SQLError):void {
		dispatchComplete(new AsyncOperationResult(error.message, false));
	}

}
}