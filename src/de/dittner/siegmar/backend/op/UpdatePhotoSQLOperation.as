package de.dittner.siegmar.backend.op {
import de.dittner.async.IAsyncCommand;
import de.dittner.siegmar.backend.SQLLib;
import de.dittner.siegmar.utils.BitmapUtils;

import flash.data.SQLConnection;
import flash.data.SQLResult;
import flash.data.SQLStatement;
import flash.display.BitmapData;
import flash.display.JPEGEncoderOptions;
import flash.net.Responder;
import flash.utils.ByteArray;

public class UpdatePhotoSQLOperation extends StorageOperation implements IAsyncCommand {

	public function UpdatePhotoSQLOperation(photoDBConnection:SQLConnection, photoID:int, bitmap:BitmapData, title:String, fileID:int) {
		this.photoDBConnection = photoDBConnection;
		this.bitmap = bitmap;
		this.title = title;
		this.fileID = fileID;
		this.photoID = photoID;
		this.preview = BitmapUtils.scaleToSize(bitmap, 150);
	}

	private var photoDBConnection:SQLConnection;
	private var bitmap:BitmapData;
	private var title:String;
	private var fileID:int;
	private var photoID:int;
	private var bytes:ByteArray;
	private var preview:BitmapData;
	private var previewBytes:ByteArray;

	public function execute():void {
		var error:String = "";
		if (!bitmap) error = "No bitmap!";
		if (!title) error = "No title!";
		if (!fileID) error = "No fileID!";
		if (!photoID) error = "No photoID!";
		if (error) {
			dispatchError(error);
			return;
		}

		var sqlText:String = SQLLib.UPDATE_PHOTO_BODY;
		var sqlParams:Object = {};
		bytes = bitmap.encode(bitmap.rect, new JPEGEncoderOptions(100));
		previewBytes = preview.encode(preview.rect, new JPEGEncoderOptions(100));

		sqlParams.title = title;
		sqlParams.fileID = fileID;
		sqlParams.id = photoID;
		sqlParams.bytes = bytes;
		sqlParams.preview = previewBytes;

		var insertStmt:SQLStatement = SQLUtils.createSQLStatement(sqlText, sqlParams);
		insertStmt.sqlConnection = photoDBConnection;
		insertStmt.execute(-1, new Responder(resultHandler, executeError));
	}

	private function resultHandler(result:SQLResult):void {
		dispatchSuccess(result.lastInsertRowID);
	}

	override public function destroy():void {
		super.destroy();
		if (bytes) {
			bytes.clear();
			bytes = null;
		}
		if (previewBytes) {
			previewBytes.clear();
			previewBytes = null;
		}
		if (bitmap) {
			bitmap.dispose();
			bitmap = null;
		}
		if (preview) {
			preview.dispose();
			preview = null;
		}
	}
}
}