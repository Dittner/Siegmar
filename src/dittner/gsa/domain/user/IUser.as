package dittner.gsa.domain.user {
import dittner.gsa.utils.async.IAsyncOperation;

public interface IUser {
	function get userName():String;
	function get isRegistered():Boolean;

	function register(userName:String, password:String, privacyLevel:uint):IAsyncOperation;
	function login(enteredPwd:String, privacyLevel:uint):IAsyncOperation;
	function logout():void;

}
}
