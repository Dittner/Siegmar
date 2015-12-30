package dittner.gsa.backend.sqlOperation {
import com.adobe.crypto.MD5;

import dittner.gsa.bootstrap.async.AsyncCommand;
import dittner.gsa.utils.AppInfo;

import flash.data.SQLConnection;
import flash.data.SQLMode;
import flash.data.SQLStatement;
import flash.events.SQLErrorEvent;
import flash.events.SQLEvent;
import flash.filesystem.File;
import flash.utils.ByteArray;

public class RunDataBaseSQLOperation extends AsyncCommand {

	public function RunDataBaseSQLOperation(dbPwd:String, createTableStatements:Array) {
		super();
		this.password = dbPwd;
		this.createTableStatements = createTableStatements;
	}

	private var password:String;
	private var createTableStatements:Array;
	private var conn:SQLConnection = new SQLConnection();

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

		conn.addEventListener(SQLEvent.OPEN, openHandler);
		conn.addEventListener(SQLErrorEvent.ERROR, errorHandler);
		if (password) {
			var encryptionKey:ByteArray = new ByteArray();
			var encryptedPwd:String = MD5.hash(MD5.hash(MD5.hash(password))).substr(0, 16);
			encryptionKey.writeUTFBytes(encryptedPwd);
			try {
				conn.openAsync(dbFile, SQLMode.CREATE, null, false, 1024, encryptionKey);
			}
			catch (e:Error) {
				dispatchError("SQL DB encryption is failed, details: " + e.toString());
			}
		}
		else {
			conn.openAsync(dbFile);
		}
	}

	private function openHandler(event:SQLEvent):void {
		createTables();
	}

	private function createTables():void {
		var createStmt:SQLStatement;

		for (var i:int = 0; i < createTableStatements.length; i++) {
			var statement:String = createTableStatements[i];
			createStmt = new SQLStatement();
			createStmt.sqlConnection = conn;
			createStmt.text = statement;
			if (i == createTableStatements.length - 1) {
				createStmt.addEventListener(SQLEvent.RESULT, createResult);
				createStmt.addEventListener(SQLErrorEvent.ERROR, errorHandler);
			}
			createStmt.execute();
		}
	}

	private function createResult(event:SQLEvent):void {
		dispatchSuccess(conn);
	}

	private function errorHandler(event:SQLErrorEvent):void {
		var errDetails:String = event.error.details;
		dispatchError(errDetails);
	}

}
}
