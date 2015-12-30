package dittner.gsa.domain.user {

import com.adobe.crypto.MD5;

import dittner.gsa.backend.encryption.EncryptionService;
import dittner.gsa.bootstrap.async.AsyncOperation;
import dittner.gsa.bootstrap.async.IAsyncOperation;
import dittner.gsa.bootstrap.walter.WalterProxy;
import dittner.gsa.domain.fileSystem.GSAFileSystem;
import dittner.gsa.utils.LocalStorage;

public class User extends WalterProxy {
	private static const USER_NAME:String = "USER_NAME";
	private static const ENCRYPTED_RANDOM_TEXT:String = "ENCRYPTED_RANDOM_TEXT";
	private static const ENCRYPTED_DB_PWD:String = "ENCRYPTED_DB_PWD";

	public function User() {
		_userName = LocalStorage.read(USER_NAME) || "";
		encryptedRandomText = LocalStorage.read(ENCRYPTED_RANDOM_TEXT) || "";
		encryptedDataBasePwd = LocalStorage.read(ENCRYPTED_DB_PWD) || "";
	}

	[Inject]
	public var encryptionService:EncryptionService;
	[Inject]
	public var system:GSAFileSystem;

	//----------------------------------------------------------------------------------------------
	//
	//  Variables
	//
	//----------------------------------------------------------------------------------------------

	private var encryptedRandomText:String;
	private var encryptedDataBasePwd:String;
	private var isAuthorized:Boolean = false;

	//----------------------------------------------------------------------------------------------
	//
	//  Properties
	//
	//----------------------------------------------------------------------------------------------

	//--------------------------------------
	//  userName
	//--------------------------------------
	private var _userName:String = "";
	public function get userName():String {return _userName;}

	//--------------------------------------
	//  dataBasePwd
	//--------------------------------------
	private var _dataBasePwd:String = "";
	public function get dataBasePwd():String {return _dataBasePwd;}

	//--------------------------------------
	//  isRegistered
	//--------------------------------------
	public function get isRegistered():Boolean {return userName;}

	//----------------------------------------------------------------------------------------------
	//
	//  Methods
	//
	//----------------------------------------------------------------------------------------------

	public function register(userName:String, enteredPwd:String, privacyLevel:uint, enteredDataBasePwd:String):IAsyncOperation {
		var op:IAsyncOperation = new AsyncOperation();
		if (isRegistered) {
			op.dispatchSuccess();
		}
		else {
			_userName = userName;
			isAuthorized = true;
			_dataBasePwd = enteredDataBasePwd;

			op = encryptionService.createEncryptionKey(enteredPwd, privacyLevel);
			op.addCompleteCallback(function (op:IAsyncOperation):void {
				encryptedRandomText = encryptionService.encryptRandomText();
				encryptedDataBasePwd = MD5.hash(MD5.hash(enteredDataBasePwd));
				LocalStorage.write(USER_NAME, userName);
				LocalStorage.write(ENCRYPTED_RANDOM_TEXT, encryptedRandomText);
				LocalStorage.write(ENCRYPTED_DB_PWD, MD5.hash(MD5.hash(enteredDataBasePwd)));
			});
		}
		return op;
	}

	public function login(enteredPwd:String, privacyLevel:uint, enteredDataBasePwd:String):IAsyncOperation {
		var op:IAsyncOperation = new AsyncOperation();
		if (isAuthorized) {
			op.dispatchError("Agent has been already authorized!");
		}
		else if (!isRegistered) {
			op.dispatchError("Agent can not login for unregistered user!");
		}
		else {
			op = encryptionService.createEncryptionKey(enteredPwd, privacyLevel);
			op.addCompleteCallback(function (op:IAsyncOperation):void {
				if (encryptedRandomText == encryptionService.encryptRandomText()) {
					if (encryptedDataBasePwd == MD5.hash(MD5.hash(enteredDataBasePwd))) {
						isAuthorized = true;
						_dataBasePwd = enteredDataBasePwd;
						op.dispatchSuccess();
					}
					else {
						op.dispatchError("Der Datenbankschlüssel ist ungültig!");
					}
				}
				else {
					op.dispatchError("Der Schlüssel ist ungültig!");
				}

			});
		}
		return op;
	}

	public function logout():void {
		if (isAuthorized) {
			isAuthorized = false;
			system.logout();
			encryptionService.deleteEncryptionKey();
		}
	}

}
}
