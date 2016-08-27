package de.dittner.siegmar.backend.op {
import de.dittner.async.AsyncCommand;
import de.dittner.siegmar.backend.FileStorage;

import flash.data.SQLResult;
import flash.data.SQLStatement;
import flash.errors.SQLError;
import flash.net.Responder;

public class CalcFilesAndPhotosSQLOperation extends AsyncCommand {

	public function CalcFilesAndPhotosSQLOperation(fileStorage:FileStorage) {
		this.fileStorage = fileStorage;
	}

	private var fileStorage:FileStorage;

	override public function execute():void {
		var stmt:SQLStatement = SQLUtils.createSQLStatement("SELECT COUNT(fileID) FROM header", {});
		stmt.sqlConnection = fileStorage.sqlConnection;
		stmt.execute(-1, new Responder(filesResultHandler, filesErrorHandler));
	}

	private function filesResultHandler(result:SQLResult):void {
		if (result.data && result.data.length > 0) {
			var countData:Object = result.data[0];
			for (var prop:String in countData) {
				trace("Files num: " + countData[prop]);
				break;
			}
		}
		var stmt:SQLStatement = SQLUtils.createSQLStatement("SELECT COUNT(id) FROM photo", {});
		stmt.sqlConnection = fileStorage.sqlConnection;
		stmt.execute(-1, new Responder(photosResultHandler, photosErrorHandler));
	}

	private function filesErrorHandler(error:SQLError):void {
		dispatchError(error.details);
	}

	private function photosResultHandler(result:SQLResult):void {
		if (result.data && result.data.length > 0) {
			var countData:Object = result.data[0];
			for (var prop:String in countData) {
				trace("Photos num: " + countData[prop]);
				break;
			}
		}
		dispatchSuccess();
	}

	private function photosErrorHandler(error:SQLError):void {
		dispatchError();
	}
}
}