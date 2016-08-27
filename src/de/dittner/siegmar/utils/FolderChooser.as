package de.dittner.siegmar.utils {
import dittner.async.AsyncOperation;
import dittner.async.IAsyncOperation;

import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.filesystem.File;
import flash.net.FileFilter;

public class FolderChooser {
	public static const LAST_OPENED_FOLDER_PATH:String = "LAST_OPENED_FOLDER_PATH";

	public function FolderChooser() {}

	private static var curOp:AsyncOperation;
	private static var filters:Array;

	public static function browse(filters:Array):IAsyncOperation {
		if (curOp && curOp.isProcessing) return curOp;

		FolderChooser.filters = filters;
		curOp = new AsyncOperation();
		var file:File;
		if (LocalStorage.has(LAST_OPENED_FOLDER_PATH)) {
			file = new File(LocalStorage.read(LAST_OPENED_FOLDER_PATH));
			if (!file.exists) file = File.documentsDirectory
		}
		else file = File.documentsDirectory;
		try {
			file.addEventListener(Event.SELECT, dirSelected);
			file.addEventListener(IOErrorEvent.IO_ERROR, ioError);
			file.browseForDirectory("Wählen Sie bitte den Ordner mit Fotos");
		}
		catch (error:Error) {
			curOp.dispatchError("Browse file error: " + error.message);
		}
		return curOp;
	}

	private static function ioError(event:Event):void {
		curOp.dispatchError();
	}

	private static function dirSelected(event:Event):void {
		var dir:File = event.target as File;
		LocalStorage.write(LAST_OPENED_FOLDER_PATH, dir.nativePath);
		var files:Array = dir.getDirectoryListing();
		var res:Array = [];
		for each(var f:File in files) {
			var ext:String = "*." + f.extension.toLocaleLowerCase();
			for each(var filter:FileFilter in filters)
				if (ext == filter.extension) {
					res.push(f);
					break;
				}
		}
		curOp.dispatchSuccess(res);
	}

}
}
