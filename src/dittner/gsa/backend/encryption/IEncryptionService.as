package dittner.gsa.backend.encryption {
import flash.utils.ByteArray;

public interface IEncryptionService {

	function encryptText(text:String):String;
	function encrypt(bytes:ByteArray):ByteArray;
	function encryptRandomText():String;

	function decryptText(encryptedText:String):String;
	function decrypt(encryptedBytes:ByteArray):ByteArray;

	function createEncryptionKey(pwd:String, privacyLevel:uint, completeCallback:Function):void;
	function deleteEncryptionKey():void
}
}
