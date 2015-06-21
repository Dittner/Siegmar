package dittner.gsa.backend.encryption {
import com.hurlant.crypto.Crypto;
import com.hurlant.crypto.hash.SHA256;
import com.hurlant.crypto.symmetric.ICipher;
import com.hurlant.crypto.symmetric.IPad;
import com.hurlant.crypto.symmetric.IVMode;
import com.hurlant.crypto.symmetric.NullPad;
import com.hurlant.util.Base64;
import com.hurlant.util.Hex;

import dittner.gsa.bootstrap.walter.WalterProxy;

import flash.events.TimerEvent;
import flash.utils.ByteArray;
import flash.utils.Timer;

public class EncryptionService extends WalterProxy implements IEncryptionService {

	public static const START_ENCRYPTING_MSG:String = "startEncryptingMsg";
	public static const END_ENCRYPTING_MSG:String = "startEncryptingMsg";

	private static const AES_TYPE:String = "aes-256-cbc";
	private static const ADDITIONAL_KEY:String = "geheimnisschutzagent";

	//--------------------------------------
	//  encryptionKey
	//--------------------------------------
	private var _encryptionKey:String;
	public function get encryptionKey():String {return _encryptionKey;}

	public function encryptText(text:String):String {
		if (!text) return "";

		var inputBA:ByteArray = Hex.toArray(Hex.fromString(text));
		inputBA = encrypt(inputBA);
		return Base64.encodeByteArray(inputBA) || "";
	}

	public function encrypt(bytes:ByteArray):ByteArray {
		if (!bytes) return new ByteArray();
		if (!encryptionKey) throw new Error("Empty encryptionKey!");

		var key:ByteArray = Hex.toArray(Hex.fromString(encryptionKey));
		var pad:IPad = new NullPad();
		var aes:ICipher = Crypto.getCipher(AES_TYPE, key, pad);
		var ivmode:IVMode = aes as IVMode;
		ivmode.IV = Hex.toArray(Hex.fromString(ADDITIONAL_KEY));
		aes.encrypt(bytes);
		return bytes;
	}

	public function decryptText(encryptedText:String):String {
		if (!encryptedText) return "";

		var data:ByteArray = Base64.decodeToByteArray(encryptedText);
		data = decrypt(data);
		return Hex.toString(Hex.fromArray(data));
	}

	public function decrypt(encryptedBytes:ByteArray):ByteArray {
		if (!encryptedBytes) return new ByteArray();
		if (!encryptionKey) throw new Error("Empty encryptionKey!");

		var key:ByteArray = Hex.toArray(Hex.fromString(encryptionKey));
		var pad:IPad = new NullPad();
		var aes:ICipher = Crypto.getCipher(AES_TYPE, key, pad);
		var ivmode:IVMode = aes as IVMode;
		ivmode.IV = Hex.toArray(Hex.fromString(ADDITIONAL_KEY));
		aes.decrypt(encryptedBytes);
		return encryptedBytes;
	}

	private var progressTimer:Timer;
	private var encryptedKeyBytes:ByteArray;
	private var encryptIterationNum:uint = 0;
	private var maxIterations:uint = 1;
	private var sha256:SHA256 = new SHA256();
	private var encryptCompleteCallback:Function;
	public function createEncryptionKey(pwd:String, privacyLevel:uint, completeCallback:Function):void {
		if (!progressTimer) {
			progressTimer = new Timer(50);
			progressTimer.addEventListener(TimerEvent.TIMER, encryptIteration);
		}
		if (!progressTimer.running) {
			var input:ByteArray = new ByteArray();
			input.writeUTFBytes(pwd);

			encryptedKeyBytes = sha256.hash(input);
			encryptIterationNum = 1;
			maxIterations = privacyLevel;
			encryptCompleteCallback = completeCallback;
			progressTimer.start();
			sendMessage(START_ENCRYPTING_MSG);
		}
	}

	private function encryptIteration(event:TimerEvent):void {
		if (encryptIterationNum >= maxIterations) {
			progressTimer.stop();
			_encryptionKey = encryptedKeyBytes.toString();
			encryptCompleteCallback();
			sendMessage(END_ENCRYPTING_MSG);
		}
		else {
			var total:int = 0;
			for (encryptIterationNum; encryptIterationNum < maxIterations && total < 200; encryptIterationNum++, total++) {
				encryptedKeyBytes = sha256.hash(encryptedKeyBytes);
			}
		}
	}

	public function deleteEncryptionKey():void {
		_encryptionKey = "";
	}

}
}
