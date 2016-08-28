package de.dittner.siegmar.backend.op {
import de.dittner.async.IAsyncCommand;
import de.dittner.siegmar.backend.SQLLib;

import flash.data.SQLConnection;
import flash.data.SQLResult;
import flash.data.SQLStatement;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Loader;
import flash.display.LoaderInfo;
import flash.events.ErrorEvent;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.SecurityErrorEvent;
import flash.net.Responder;
import flash.system.ImageDecodingPolicy;
import flash.system.LoaderContext;
import flash.utils.ByteArray;

public class SelectPhotoSQLOperation extends StorageOperation implements IAsyncCommand {

	public function SelectPhotoSQLOperation(photoDBConnection:SQLConnection, photoID:int, isPreview:Boolean = false) {
		this.photoID = photoID;
		this.photoDBConnection = photoDBConnection;
		this.isPreview = isPreview;
	}

	private var photoID:int;
	private var photoDBConnection:SQLConnection;
	private var photoBytes:ByteArray;
	private var isPreview:Boolean = false;

	public function execute():void {
		var sql:String = isPreview ? SQLLib.SELECT_PHOTO_PREVIEW : SQLLib.SELECT_PHOTO;
		var insertStmt:SQLStatement = SQLUtils.createSQLStatement(sql, {id: photoID});
		insertStmt.sqlConnection = photoDBConnection;
		insertStmt.execute(-1, new Responder(resultHandler, executeError));
	}

	private function resultHandler(result:SQLResult):void {
		photoBytes = result.data && result.data.length > 0 ? result.data[0].bytes || result.data[0].preview : null;
		if (photoBytes) convertJPEGToBitmap(photoBytes);
		else dispatchSuccess();
	}

	private var convertLoader:Loader;
	private function convertJPEGToBitmap(byteData:ByteArray):void {
		convertLoader = new Loader();
		var context:LoaderContext = new LoaderContext();
		context.imageDecodingPolicy = ImageDecodingPolicy.ON_LOAD;
		convertLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, convertFailed);
		convertLoader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, convertFailed);
		convertLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, convertComplete);
		convertLoader.loadBytes(byteData, context);
	}

	private function convertComplete(event:Event):void {
		var loaderInfo:LoaderInfo = event.target as LoaderInfo;
		var bd:BitmapData = (loaderInfo.content as Bitmap).bitmapData;
		dispatchSuccess(bd);
	}

	private function convertFailed(event:ErrorEvent):void {
		dispatchError(event.toString());
	}

	override public function destroy():void {
		super.destroy();
		if (photoBytes) {
			photoBytes.clear();
			photoBytes = null;
		}
	}
}
}