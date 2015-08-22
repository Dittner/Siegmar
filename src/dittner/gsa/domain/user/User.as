package dittner.gsa.domain.user {
import dittner.gsa.backend.SharedObjectStorage;
import dittner.gsa.backend.encryption.IEncryptionService;
import dittner.gsa.bootstrap.async.AsyncOperation;
import dittner.gsa.bootstrap.async.IAsyncOperation;
import dittner.gsa.bootstrap.walter.WalterProxy;
import dittner.gsa.domain.fileSystem.GSAFileSystem;

public class User extends WalterProxy implements IUser {
	public function User() {
		localStorage = new SharedObjectStorage();
		localStorage.init("userCredentials");
		_userName = localStorage.getField("userName") || "";
		encryptedPassword = localStorage.getField("encryptedPassword") || "";
	}

	[Inject]
	public var encryptionService:IEncryptionService;
	[Inject]
	public var system:GSAFileSystem;

	//----------------------------------------------------------------------------------------------
	//
	//  Variables
	//
	//----------------------------------------------------------------------------------------------

	private var localStorage:SharedObjectStorage;
	private var encryptedPassword:String;
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
	//  isRegistered
	//--------------------------------------
	public function get isRegistered():Boolean {return userName;}

	//----------------------------------------------------------------------------------------------
	//
	//  Methods
	//
	//----------------------------------------------------------------------------------------------

	public function register(userName:String, password:String, privacyLevel:uint):IAsyncOperation {
		var op:IAsyncOperation = new AsyncOperation();
		if (isRegistered) {
			op.dispatchSuccess();
		}
		else {
			_userName = userName;
			encryptionService.createEncryptionKey(password, privacyLevel, function ():void {
				encryptedPassword = encryptionService.encryptRandomText();
				localStorage.writeField("userName", userName);
				localStorage.writeField("encryptedPassword", encryptedPassword);
				login(password, privacyLevel);
				op.dispatchSuccess();
			});
		}
		return op;
	}

	public function login(enteredPwd:String, privacyLevel:uint):IAsyncOperation {
		var op:IAsyncOperation = new AsyncOperation();
		if (isAuthorized) {
			op.dispatchError("Agent has been already authorized!");
		}
		else if (!isRegistered) {
			op.dispatchError("Agent can not login for unregistered user!");
		}
		else {
			encryptionService.createEncryptionKey(enteredPwd, privacyLevel, function ():void {
				var encryptedEnteredPwd:String = encryptionService.encryptRandomText();
				if (encryptedPassword == encryptedEnteredPwd) {
					isAuthorized = true;
					op.dispatchSuccess();
				}
				else {
					op.dispatchError("Invalid password");
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
