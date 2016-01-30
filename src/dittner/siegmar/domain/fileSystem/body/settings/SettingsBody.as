package dittner.siegmar.domain.fileSystem.body.settings {
import dittner.siegmar.domain.fileSystem.body.*;

import flash.utils.ByteArray;

public class SettingsBody extends FileBody {
	public function SettingsBody() {
		super();
	}

	//--------------------------------------
	//  settings
	//--------------------------------------
	private var _settings:Settings = new Settings();
	public function get settings():Settings {return _settings;}

	//----------------------------------------------------------------------------------------------
	//
	//  Methods
	//
	//----------------------------------------------------------------------------------------------

	override public function serialize():ByteArray {
		if (!settings) _settings = new Settings();

		var byteArray:ByteArray = new ByteArray();
		byteArray.writeObject(settings);
		byteArray.position = 0;
		return byteArray;
	}

	override public function deserialize(ba:ByteArray):void {
		var res:* = ba.readObject();
		_settings = res as Settings || new Settings();
	}

}
}
