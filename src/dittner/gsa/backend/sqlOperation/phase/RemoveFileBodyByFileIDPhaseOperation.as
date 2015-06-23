package dittner.gsa.backend.sqlOperation.phase {
import com.probertson.data.QueuedStatement;

import dittner.gsa.backend.phaseOperation.PhaseOperation;
import dittner.gsa.backend.sqlOperation.FileSQLWrapper;

import flash.data.SQLResult;
import flash.errors.SQLError;

public class RemoveFileBodyByFileIDPhaseOperation extends PhaseOperation {

	public function RemoveFileBodyByFileIDPhaseOperation(headerWrapper:FileSQLWrapper, fileID:int) {
		this.headerWrapper = headerWrapper;
		this.fileID = fileID;
	}

	private var headerWrapper:FileSQLWrapper;
	private var fileID:int;

	override public function execute():void {
		var sqlParams:Object = {};
		sqlParams.fileID = fileID;
		var statement:QueuedStatement = new QueuedStatement(headerWrapper.sqlFactory.deleteFileBodyByFileID, sqlParams);
		headerWrapper.sqlRunner.executeModify(Vector.<QueuedStatement>([statement]), executeComplete, executeError);
	}

	private function executeComplete(results:Vector.<SQLResult>):void {
		dispatchComplete();
	}

	private function executeError(error:SQLError):void {
		throw new Error(error.message);
	}
}
}
