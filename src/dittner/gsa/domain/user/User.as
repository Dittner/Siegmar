package dittner.gsa.domain.user {
import dittner.gsa.backend.SharedObjectStorage;
import dittner.gsa.backend.encryption.IEncryptionService;
import dittner.gsa.domain.fileSystem.GSAFileSystem;
import dittner.gsa.utils.async.AsyncOperation;
import dittner.gsa.utils.async.AsyncOperationResult;
import dittner.gsa.utils.async.IAsyncOperation;
import dittner.walter.WalterModel;

public class User extends WalterModel implements IUser {
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
			op.dispatchComplete();
		}
		else {
			_userName = userName;
			encryptionService.createEncryptionKey(password, privacyLevel, function ():void {
				encryptedPassword = encryptionService.encryptText(password);
				localStorage.writeField("userName", userName);
				localStorage.writeField("encryptedPassword", encryptedPassword);
				login(password, privacyLevel);
				op.dispatchComplete();
			});
		}
		return op;
	}

	public function login(enteredPwd:String, privacyLevel:uint):IAsyncOperation {
		var op:IAsyncOperation = new AsyncOperation();
		if (isAuthorized) {
			op.dispatchComplete(new AsyncOperationResult("Agent has been already authorize!", false));
		}
		else if (!isRegistered) {
			op.dispatchComplete(new AsyncOperationResult("Agent can not login for unregistered user!", false));
		}
		else {
			encryptionService.createEncryptionKey(enteredPwd, privacyLevel, function ():void {
				if (encryptedPassword == encryptionService.encryptText(enteredPwd)) {
					isAuthorized = true;
					op.dispatchComplete();
				}
				else {
					op.dispatchComplete(new AsyncOperationResult("Invalid password", false));
				}

			});
		}
		return op;
	}

	public function logout():void {
		if (isAuthorized) {
			isAuthorized = false;
			encryptionService.deleteEncryptionKey();
		}
	}

}
}
