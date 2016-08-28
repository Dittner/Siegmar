package de.dittner.siegmar.backend.op {
import com.adobe.crypto.MD5;

import de.dittner.async.IAsyncCommand;
import de.dittner.siegmar.utils.AppInfo;

import flash.data.SQLConnection;
import flash.data.SQLMode;
import flash.data.SQLStatement;
import flash.events.SQLErrorEvent;
import flash.events.SQLEvent;
import flash.filesystem.File;
import flash.utils.ByteArray;

public class RunDataBaseSQLOperation extends StorageOperation implements IAsyncCommand {

	public function RunDataBaseSQLOperation(dbPwd:String, dbName:String, createTableStatements:Array) {
		super();
		this.password = dbPwd;
		this.dbName = dbName;
		this.createTableStatements = createTableStatements;
	}

	private var password:String;
	private var dbName:String;
	private var createTableStatements:Array;
	private var conn:SQLConnection = new SQLConnection();

	public function execute():void {
		var dbRootFile:File = File.documentsDirectory.resolvePath(AppInfo.dbRootPath);
		if (!dbRootFile.exists) {
			dbRootFile.createDirectory();
		}

		var dbFile:File = File.documentsDirectory.resolvePath(AppInfo.dbRootPath + dbName);

		conn.addEventListener(SQLEvent.OPEN, openHandler);
		conn.addEventListener(SQLErrorEvent.ERROR, executeError);
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

	public static function existsDataBaseFile():Boolean {
		return File.documentsDirectory.resolvePath(AppInfo.dbRootPath).exists;
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
				createStmt.addEventListener(SQLErrorEvent.ERROR, executeError);
			}
			createStmt.execute();
		}
	}

	private function createResult(event:SQLEvent):void {
		dispatchSuccess(conn);
	}

}
}
