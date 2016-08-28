package de.dittner.siegmar.backend.op {
import de.dittner.async.IAsyncCommand;
import de.dittner.siegmar.backend.FileStorage;

import flash.data.SQLResult;
import flash.data.SQLStatement;
import flash.net.Responder;

public class CalcFilesAndPhotosSQLOperation extends StorageOperation implements IAsyncCommand {

	public function CalcFilesAndPhotosSQLOperation(fileStorage:FileStorage) {
		this.fileStorage = fileStorage;
	}

	private var fileStorage:FileStorage;

	public function execute():void {
		var stmt:SQLStatement = SQLUtils.createSQLStatement("SELECT COUNT(fileID) FROM header", {});
		stmt.sqlConnection = fileStorage.textDBConnection;
		stmt.execute(-1, new Responder(filesResultHandler, executeError));
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
		stmt.sqlConnection = fileStorage.photoDBConnection;
		stmt.execute(-1, new Responder(photosResultHandler, executeError));
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

}
}