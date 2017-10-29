package de.dittner.siegmar.view.settings {
import de.dittner.async.IAsyncOperation;
import de.dittner.async.ProgressCommand;
import de.dittner.ftpClient.FtpClient;
import de.dittner.siegmar.model.Device;
import de.dittner.siegmar.model.domain.fileSystem.SiegmarFileSystem;
import de.dittner.siegmar.model.domain.fileSystem.body.settings.Settings;
import de.dittner.siegmar.model.domain.fileSystem.body.settings.SettingsBody;
import de.dittner.siegmar.view.common.view.ViewID;
import de.dittner.siegmar.view.common.view.ViewModel;
import de.dittner.siegmar.view.common.view.ViewNavigator;

import flash.events.Event;
import flash.filesystem.File;

public class SettingsVM extends ViewModel {
	public function SettingsVM() {
		super();
	}

	[Inject]
	public var system:SiegmarFileSystem;
	[Inject]
	public var viewNavigator:ViewNavigator;

	private static var ftp:FtpClient;

	private var settingsBody:SettingsBody;

	//--------------------------------------
	//  settings
	//--------------------------------------
	private var _settings:Settings;
	[Bindable("settingsChanged")]
	public function get settings():Settings {return _settings;}
	private function setSettings(value:Settings):void {
		if (_settings != value) {
			_settings = value;
			dispatchEvent(new Event("settingsChanged"));
		}
	}

	//--------------------------------------
	//  uploadProgress
	//--------------------------------------
	private var _uploadProgress:Number = 0;
	[Bindable("uploadProgressChanged")]
	public function get uploadProgress():Number {return _uploadProgress;}
	public function set uploadProgress(value:Number):void {
		if (_uploadProgress != value) {
			_uploadProgress = value;
			dispatchEvent(new Event("uploadProgressChanged"));
		}
	}

	//--------------------------------------
	//  isUploading
	//--------------------------------------
	private var _isUploading:Boolean = false;
	[Bindable("isUploadingChanged")]
	public function get isUploading():Boolean {return _isUploading;}
	public function set isUploading(value:Boolean):void {
		if (_isUploading != value) {
			_isUploading = value;
			dispatchEvent(new Event("isUploadingChanged"));
		}
	}

	//--------------------------------------
	//  uploadErrorText
	//--------------------------------------
	private var _uploadErrorText:String;
	[Bindable("uploadErrorTextChanged")]
	public function get uploadErrorText():String {return _uploadErrorText;}
	public function set uploadErrorText(value:String):void {
		if (_uploadErrorText != value) {
			_uploadErrorText = value;
			dispatchEvent(new Event("uploadErrorTextChanged"));
		}
	}

	//--------------------------------------
	//  isUploadSuccess
	//--------------------------------------
	private var _isUploadSuccess:Boolean = false;
	[Bindable("isUploadSuccessChanged")]
	public function get isUploadSuccess():Boolean {return _isUploadSuccess;}
	public function set isUploadSuccess(value:Boolean):void {
		if (_isUploadSuccess != value) {
			_isUploadSuccess = value;
			dispatchEvent(new Event("isUploadSuccessChanged"));
		}
	}

	//----------------------------------------------------------------------------------------------
	//
	//  Methods
	//
	//----------------------------------------------------------------------------------------------

	override public function viewActivated():void {
		super.viewActivated();
		if (!ftp) ftp = new FtpClient(Device.stage);
		var op:IAsyncOperation = system.fileStorage.loadFileBody(system.settingsFileHeader);
		op.addCompleteCallback(settingsLoaded);
	}

	private function settingsLoaded(op:IAsyncOperation):void {
		if (op.isSuccess) {
			settingsBody = op.result;
			setSettings(settingsBody.settings);
		}
	}

	public function sendCopyToServer():void {
		if (settings) {
			isUploading = true;
			uploadErrorText = "";
			isUploadSuccess = false;
			settingsBody.store();
			uploadDataBase();
		}
	}

	private function uploadDataBase():void {
		var dbFile:File = File.documentsDirectory.resolvePath(Device.dbRootPath + Device.TEXT_DB_NAME);
		var uploadCmd:ProgressCommand = ftp.upload([dbFile], settings.serverInfo);
		uploadCmd.addCompleteCallback(uploadComplete);
		uploadCmd.addProgressCallback(uploadProgressHandler);
	}

	private function uploadProgressHandler(value:Number):void {
		uploadProgress = value;
	}

	private function uploadComplete(op:IAsyncOperation):void {
		if (op.isSuccess) {
			isUploadSuccess = true;
		}
		else {
			uploadErrorText = "Error: " + op.error;
			isUploadSuccess = false;
		}
		isUploading = false;
	}

	public function closeFile():void {
		system.closeOpenedFile();
		viewNavigator.navigate(ViewID.FILE_LIST);
	}

	public function logout():void {
		system.logout();
		viewNavigator.navigate(ViewID.LOGIN);
	}

	override public function viewDeactivated():void {
		super.viewDeactivated();
		ftp.close();
	}
}
}