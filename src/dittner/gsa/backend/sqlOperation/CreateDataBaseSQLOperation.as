package dittner.gsa.backend.sqlOperation {
import com.probertson.data.QueuedStatement;
import com.probertson.data.SQLRunner;

import dittner.gsa.bootstrap.deferredOperation.DeferredOperation;
import dittner.gsa.domain.store.FileStorage;
import dittner.gsa.utils.AppInfo;

import flash.data.SQLResult;
import flash.errors.SQLError;
import flash.filesystem.File;

public class CreateDataBaseSQLOperation extends DeferredOperation {

	public function CreateDataBaseSQLOperation(storage:FileStorage, sqlFactory:SQLFactory) {
		super();
		this.storage = storage;
		this.sqlFactory = sqlFactory;
	}

	private var storage:FileStorage;
	private var sqlFactory:SQLFactory;

	override public function process():void {
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

		var dbFile:File = File.documentsDirectory.resolvePath(AppInfo.dbRootPath + "user.db");
		storage.sqlRunner = new SQLRunner(dbFile);

		if (!dbFile.exists) {
			var statements:Vector.<QueuedStatement> = new Vector.<QueuedStatement>();
			statements.push(new QueuedStatement(sqlFactory.createFileHeaderTbl));
			statements.push(new QueuedStatement(sqlFactory.createFileBodyTbl));

			storage.sqlRunner.executeModify(statements, executeComplete, executeError, null);
		}
		else dispatchComplete();
	}

	private function executeComplete(results:Vector.<SQLResult>):void {
		dispatchComplete();
	}

	private function executeError(error:SQLError):void {
		throw new Error("Ошибка при создании БД: " + error.toString());
	}

}
}
