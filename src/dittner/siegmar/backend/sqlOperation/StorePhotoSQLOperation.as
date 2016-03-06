package dittner.siegmar.backend.sqlOperation {
import dittner.async.AsyncCommand;
import dittner.siegmar.utils.BitmapUtils;

import flash.data.SQLConnection;
import flash.data.SQLResult;
import flash.data.SQLStatement;
import flash.display.BitmapData;
import flash.display.JPEGEncoderOptions;
import flash.errors.SQLError;
import flash.net.Responder;
import flash.utils.ByteArray;

public class StorePhotoSQLOperation extends AsyncCommand {

	public function StorePhotoSQLOperation(sqlConnection:SQLConnection, bitmap:BitmapData, title:String, fileID:int) {
		this.sqlConnection = sqlConnection;
		this.bitmap = bitmap;
		this.title = title;
		this.fileID = fileID;
		this.preview = BitmapUtils.scaleToSize(bitmap, 150);
	}

	private var sqlConnection:SQLConnection;
	private var bitmap:BitmapData;
	private var title:String;
	private var fileID:int;
	private var bytes:ByteArray;
	private var preview:BitmapData;
	private var previewBytes:ByteArray;

	override public function execute():void {
		var error:String = "";
		if (!bitmap) error = "No bitmap!";
		if (!title) error = "No title!";
		if (!fileID) error = "No fileID!";
		if (error) {
			dispatchError(error);
			return;
		}

		var sqlText:String = SQLLib.INSERT_PHOTO;
		var sqlParams:Object = {};
		bytes = bitmap.encode(bitmap.rect, new JPEGEncoderOptions(100));
		previewBytes = preview.encode(preview.rect, new JPEGEncoderOptions(100));

		sqlParams.title = title;
		sqlParams.fileID = fileID;
		sqlParams.bytes = bytes;
		sqlParams.preview = previewBytes;

		var insertStmt:SQLStatement = SQLUtils.createSQLStatement(sqlText, sqlParams);
		insertStmt.sqlConnection = sqlConnection;
		insertStmt.execute(-1, new Responder(resultHandler, errorHandler));
	}

	private function resultHandler(result:SQLResult):void {
		dispatchSuccess({id: result.lastInsertRowID, title: title});
	}

	private function errorHandler(error:SQLError):void {
		dispatchError(error.details);
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