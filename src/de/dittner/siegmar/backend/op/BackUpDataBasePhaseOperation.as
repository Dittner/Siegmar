package de.dittner.siegmar.backend.op {
import de.dittner.async.IAsyncCommand;
import de.dittner.siegmar.utils.AppInfo;

import flash.filesystem.File;

import mx.formatters.DateFormatter;

public class BackUpDataBasePhaseOperation extends StorageOperation implements IAsyncCommand {
	private static var dateFormatter:DateFormatter;

	public function BackUpDataBasePhaseOperation() {
		if (!dateFormatter) {
			dateFormatter = new DateFormatter();
			dateFormatter.formatString = 'MM-DD-YYYY JJ-NN-SS';
		}
	}

	public function execute():void {
		var dbRootFile:File = File.documentsDirectory.resolvePath(AppInfo.dbRootPath);
		if (!dbRootFile.exists) {
			var appDBDir:File = File.applicationDirectory.resolvePath(AppInfo.applicationDBPath);
			if (appDBDir.exists) {
				var destDir:File = File.documentsDirectory.resolvePath(AppInfo.APP_NAME);
				appDBDir.copyTo(destDir);
			}
			else {
				dbRootFile.createDirectory();
			}
		}

		var dbFile:File = File.documentsDirectory.resolvePath(AppInfo.dbRootPath + AppInfo.TEXT_DB_NAME);
		var backUpFileName:String = "Kopie-" + dateFormatter.format(new Date) + ".db";
		dbFile.copyTo(File.documentsDirectory.resolvePath(AppInfo.dbRootPath + backUpFileName), true);
		dispatchSuccess();
	}

}
}
