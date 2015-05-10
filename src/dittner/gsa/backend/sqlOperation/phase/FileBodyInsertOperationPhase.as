package dittner.gsa.backend.sqlOperation.phase {
import com.probertson.data.QueuedStatement;

import dittner.gsa.backend.phaseOperation.PhaseOperation;
import dittner.gsa.backend.sqlOperation.*;
import dittner.gsa.domain.fileSystem.IDocument;

import flash.data.SQLResult;
import flash.errors.SQLError;

public class FileBodyInsertOperationPhase extends PhaseOperation {

	public function FileBodyInsertOperationPhase(sqlSuite:SQLOperationSuite) {
		this.sqlSuite = sqlSuite;
	}

	private var sqlSuite:SQLOperationSuite;

	override public function execute():void {
		if (sqlSuite.file is IDocument && sqlSuite.encryptedFileBody) {
			var sqlParams:Object = {};
			sqlParams.fileID = sqlSuite.file.id;
			sqlParams.bytes = sqlSuite.encryptedFileBody;
			sqlSuite.sqlRunner.executeModify(Vector.<QueuedStatement>([new QueuedStatement(sqlSuite.sqlFactory.insertFileBody, sqlParams)]), executeComplete, executeError);
		}
		else dispatchComplete();
	}

	private function executeComplete(results:Vector.<SQLResult>):void {
		//var result:SQLResult = results[0];
		//if (result.rowsAffected > 0) file.id = result.lastInsertRowID;
		dispatchComplete();
	}

	private function executeError(error:SQLError):void {
		throw new Error(error.message);
	}

	override public function destroy():void {
		super.destroy();
		sqlSuite = null;
	}
}
}
