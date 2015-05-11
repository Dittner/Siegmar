package dittner.gsa.backend.sqlOperation.phase {
import com.probertson.data.QueuedStatement;

import dittner.gsa.backend.phaseOperation.PhaseOperation;
import dittner.gsa.backend.sqlOperation.SQLOperationSuite;
import dittner.gsa.domain.fileSystem.GSAFileHeader;

import flash.data.SQLResult;
import flash.errors.SQLError;

public class FileHeaderInsertOperationPhase extends PhaseOperation {

	public function FileHeaderInsertOperationPhase(sqlSuite:SQLOperationSuite) {
		this.sqlSuite = sqlSuite;
	}

	private var sqlSuite:SQLOperationSuite;

	override public function execute():void {
		var sqlParams:Object = fileHeaderToSQLObj(sqlSuite.file.header);
		sqlSuite.sqlRunner.executeModify(Vector.<QueuedStatement>([new QueuedStatement(sqlSuite.sqlFactory.insertFileHeader, sqlParams)]), executeComplete, executeError);
	}

	public function fileHeaderToSQLObj(header:GSAFileHeader):Object {
		var res:Object = {};
		res.parentID = header.parentID;
		res.fileType = header.fileType;
		res.title = header.title;
		res.password = header.password;
		res.options = header.options;
		return res;
	}

	private function executeComplete(results:Vector.<SQLResult>):void {
		var result:SQLResult = results[0];
		if (result.rowsAffected > 0) sqlSuite.file.header.id = result.lastInsertRowID;
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
