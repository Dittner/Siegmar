package de.dittner.siegmar.backend {
import de.dittner.async.IAsyncCommand;
import de.dittner.siegmar.backend.op.SQLUtils;
import de.dittner.siegmar.backend.op.StorageOperation;

import flash.data.SQLResult;
import flash.data.SQLStatement;
import flash.net.Responder;

public class TransferPhotoToOtherTblCmd extends StorageOperation implements IAsyncCommand {

	public function TransferPhotoToOtherTblCmd(storage:FileStorage) {
		super();
		this.storage = storage;
	}

	private var storage:FileStorage;
	private var photoIDs:Array = [];

	public function execute():void {
		compactDB();
	}

	private function compactDB():void {
		storage.textDBConnection.compact(new Responder(compactComplete, executeError));
	}

	private function compactComplete(result:SQLResult):void {
		dispatchSuccess();
	}

	private function selectAllPhotoIDs():void {
		var sql:String = "SELECT id FROM photo";

		var statement:SQLStatement = SQLUtils.createSQLStatement(sql);
		statement.sqlConnection = storage.textDBConnection;
		statement.execute(-1, new Responder(photoIDsLoaded, executeError));
	}

	private function photoIDsLoaded(result:SQLResult):void {
		for each(var obj:Object in result.data)
			photoIDs.push(obj.id)
		transferNextPhoto();
	}

	private function transferNextPhoto(result:SQLResult = null):void {
		if (photoIDs.length > 0) {
			var curPhotoID:int = photoIDs.pop();
			loadPhoto(curPhotoID);
		}
		else {
			deletePhotoTbl();
		}
	}

	private function loadPhoto(id:int):void {
		var sql:String = "SELECT * FROM photo WHERE id = " + id;

		var statement:SQLStatement = SQLUtils.createSQLStatement(sql);
		statement.sqlConnection = storage.textDBConnection;
		statement.execute(-1, new Responder(photoLoaded, executeError));
	}

	private function photoLoaded(result:SQLResult):void {
		var photoData:Object;
		if (result.data is Array && (result.data as Array).length > 0) {
			photoData = (result.data as Array)[0];
			storePhoto(photoData);
		}
		else {
			trace("No data loaded");
			transferNextPhoto();
		}
	}

	private function storePhoto(photoData:Object):void {
		var sql:String = SQLLib.INSERT_PHOTO;
		var sqlParams:Object = {};
		sqlParams.bytes = photoData.bytes;
		sqlParams.preview = photoData.preview;
		sqlParams.fileID = photoData.fileID;
		sqlParams.title = photoData.title;

		var statement:SQLStatement = SQLUtils.createSQLStatement(sql, sqlParams);
		statement.sqlConnection = storage.photoDBConnection;
		statement.execute(-1, new Responder(transferNextPhoto, executeError));
	}

	private function deletePhotoTbl():void {
		var sql:String = "DROP TABLE photo";

		var statement:SQLStatement = SQLUtils.createSQLStatement(sql);
		statement.sqlConnection = storage.textDBConnection;
		statement.execute(-1, new Responder(photoTblRemoved, executeError));
	}

	private function photoTblRemoved(result:SQLResult):void {
		dispatchSuccess();
	}
}
}
