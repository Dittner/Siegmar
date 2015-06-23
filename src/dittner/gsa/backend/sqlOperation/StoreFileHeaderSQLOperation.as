package dittner.gsa.backend.sqlOperation {
import com.probertson.data.QueuedStatement;

import dittner.gsa.bootstrap.async.AsyncOperationResult;
import dittner.gsa.bootstrap.deferredOperation.DeferredOperation;

import flash.data.SQLResult;
import flash.errors.SQLError;

public class StoreFileHeaderSQLOperation extends DeferredOperation {

	public function StoreFileHeaderSQLOperation(fileWrapper:FileSQLWrapper) {
		this.headerWrapper = fileWrapper;
	}

	private var headerWrapper:FileSQLWrapper;

	override public function process():void {
		try {
			var sqlParams:Object = headerWrapper.headerToSQLObj();
			var statement:QueuedStatement;
			if (headerWrapper.header.isNewFile) {
				statement = new QueuedStatement(headerWrapper.sqlFactory.insertFileHeader, sqlParams);
			}
			else {
				sqlParams.fileID = headerWrapper.header.fileID;
				statement = new QueuedStatement(headerWrapper.sqlFactory.updateFileHeader, sqlParams);
			}

			headerWrapper.sqlRunner.executeModify(Vector.<QueuedStatement>([statement]), executeComplete, executeError);
		}
		catch (exc:Error) {
			dispatchComplete(new AsyncOperationResult(exc.message, false));
		}
	}

	private function executeComplete(results:Vector.<SQLResult>):void {
		if (headerWrapper.header.isNewFile) {
			var result:SQLResult = results[0];
			if (result.rowsAffected > 0) headerWrapper.header.fileID = result.lastInsertRowID;
		}
		dispatchComplete();
	}

	private function executeError(error:SQLError):void {
		dispatchComplete(new AsyncOperationResult(error.message, false));
	}

}
}