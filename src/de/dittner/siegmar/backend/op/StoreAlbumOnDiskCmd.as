package de.dittner.siegmar.backend.op {
import de.dittner.async.IAsyncCommand;
import de.dittner.siegmar.backend.SQLLib;
import de.dittner.siegmar.model.Device;
import de.dittner.siegmar.model.domain.fileSystem.body.album.AlbumBody;
import de.dittner.siegmar.model.domain.fileSystem.file.SiegmarFile;

import flash.data.SQLConnection;
import flash.data.SQLResult;
import flash.data.SQLStatement;
import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;
import flash.net.Responder;
import flash.utils.ByteArray;

public class StoreAlbumOnDiskCmd extends StorageOperation implements IAsyncCommand {
	public function StoreAlbumOnDiskCmd(photoDBConnection:SQLConnection, albumFile:SiegmarFile) {
		this.albumTitle = albumFile.header.title;
		this.photos = (albumFile.body as AlbumBody).photoColl.source;
		this.photoDBConnection = photoDBConnection;
		totalPhotos = photos.length;
		destDir = File.documentsDirectory.resolvePath(Device.dbAlbumFolderPath + File.separator + albumTitle + File.separator);
		if (!destDir.exists)
			destDir.createDirectory();
	}

	private var albumTitle:String = "";
	private var photos:Array;
	private var totalPhotos:int = 0;
	private var curPhotoInd:int = 0;
	private var curPhotoTitle:String = "";
	private var photoDBConnection:SQLConnection;
	private var sql:String = SQLLib.SELECT_PHOTO;
	private var destDir:File;

	public function execute():void {
		storeNext();
	}

	public function storeNext():void {
		if (curPhotoInd < totalPhotos) {
			var item:Object = photos[curPhotoInd];
			var id:int = item.id;
			curPhotoTitle = item.title;
			var statement:SQLStatement = SQLUtils.createSQLStatement(sql, {id: id});
			statement.sqlConnection = photoDBConnection;
			statement.execute(-1, new Responder(resultHandler, executeError));
			curPhotoInd++;
		}
		else {
			dispatchSuccess();
		}
	}

	private function resultHandler(result:SQLResult):void {
		var photoBytes:ByteArray = result.data && result.data.length > 0 ? result.data[0].bytes || result.data[0].preview : null;
		if (photoBytes) store(photoBytes, curPhotoTitle);
		else dispatchError("StoreAlbumOnDiskOperation: photoBytes are empty!");
	}

	private function store(bytes:ByteArray, title:String):void {
		var fileStream:FileStream = new FileStream();
		var file:File = new File(destDir.nativePath + File.separator + title + ".jpg");
		fileStream.open(file, FileMode.WRITE);
		fileStream.writeBytes(bytes, 0, bytes.length);
		fileStream.close();
		bytes.clear();
		storeNext();
	}

}
}
