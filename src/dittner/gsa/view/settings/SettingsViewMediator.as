package dittner.gsa.view.settings {
import dittner.gsa.backend.ftpClient.FtpClient;
import dittner.gsa.bootstrap.async.IAsyncOperation;
import dittner.gsa.bootstrap.async.ProgressCommand;
import dittner.gsa.bootstrap.navigator.ViewNavigator;
import dittner.gsa.bootstrap.walter.WalterMediator;
import dittner.gsa.domain.fileSystem.GSAFileSystem;
import dittner.gsa.domain.fileSystem.body.settings.Settings;
import dittner.gsa.domain.fileSystem.body.settings.SettingsBody;
import dittner.gsa.utils.AppInfo;
import dittner.gsa.view.fileList.toolbar.ToolbarMediator;

import flash.events.MouseEvent;
import flash.filesystem.File;

public class SettingsViewMediator extends WalterMediator {

	[Inject]
	public var view:SettingsView;
	[Inject]
	public var system:GSAFileSystem;
	[Inject]
	public var viewNavigator:ViewNavigator;

	private static var ftp:FtpClient;

	private var settingsBody:SettingsBody;
	private function get settings():Settings {return settingsBody.settings;}

	override protected function activate():void {
		if (!ftp) ftp = new FtpClient();
		var op:IAsyncOperation = system.fileStorage.loadFileBody(system.settingsFileHeader);
		op.addCompleteCallback(settingsLoaded);
	}

	private function settingsLoaded(op:IAsyncOperation):void {
		if (op.isSuccess) settingsBody = op.result;

		view.hostInput.text = settings.serverInfo.host;
		view.portInput.text = settings.serverInfo.port.toString();
		view.userNameInput.text = settings.serverInfo.user;
		view.pwdInput.text = settings.serverInfo.password;
		view.remoteDirInput.text = settings.serverInfo.remoteDirPath;

		registerMediator(view.toolbar, new ToolbarMediator());
		view.copySendBtn.addEventListener(MouseEvent.CLICK, sendCopyClicked);
	}

	private function sendCopyClicked(event:MouseEvent):void {
		view.progressBar.visible = true;
		view.errorText = "";
		view.isUploadSuccess = false;
		settings.serverInfo.host = view.hostInput.text;
		settings.serverInfo.port = int(view.portInput.text);
		settings.serverInfo.user = view.userNameInput.text;
		settings.serverInfo.password = view.pwdInput.text;
		settings.serverInfo.remoteDirPath = view.remoteDirInput.text;
		settingsBody.store();
		uploadDataBase();
	}

	private function uploadDataBase():void {
		var dbFile:File = File.documentsDirectory.resolvePath(AppInfo.dbRootPath + AppInfo.DB_NAME);
		var uploadCmd:ProgressCommand = ftp.upload(dbFile, settings.serverInfo);
		uploadCmd.addCompleteCallback(uploadComplete);
		uploadCmd.addProgressCallback(uploadProgress);
	}

	private function uploadProgress(value:Number):void {
		view.progressBar.progress = value;
	}

	private function uploadComplete(op:IAsyncOperation):void {
		if (op.isSuccess) {
			view.isUploadSuccess = true;
		}
		else {
			view.errorText = "Error: " + op.error;
			view.isUploadSuccess = false;
		}
		view.progressBar.visible = false;
	}

	override protected function deactivate():void {
		ftp.close();
		view.copySendBtn.removeEventListener(MouseEvent.CLICK, sendCopyClicked);
	}
}
}