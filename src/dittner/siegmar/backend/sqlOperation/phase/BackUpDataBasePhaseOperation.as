package dittner.siegmar.backend.sqlOperation.phase {
import dittner.siegmar.bootstrap.async.AsyncCommand;
import dittner.siegmar.utils.AppInfo;

import flash.errors.SQLError;
import flash.filesystem.File;

import mx.formatters.DateFormatter;

public class BackUpDataBasePhaseOperation extends AsyncCommand {
	private static var dateFormatter:DateFormatter;

	public function BackUpDataBasePhaseOperation() {
		if (!dateFormatter) {
			dateFormatter = new DateFormatter();
			dateFormatter.formatString = 'MM-DD-YYYY JJ-NN-SS';
		}
	}

	override public function execute():void {
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

		var dbFile:File = File.documentsDirectory.resolvePath(AppInfo.dbRootPath + AppInfo.DB_NAME);
		var backUpFileName:String = "Kopie-" + dateFormatter.format(new Date) + ".db";
		dbFile.copyTo(File.documentsDirectory.resolvePath(AppInfo.dbRootPath + backUpFileName), true);
		dispatchSuccess();
	}

	private function executeError(error:SQLError):void {
		dispatchError(error.message);
	}
}
}
