package dittner.walter {
import dittner.walter.message.WalterMessage;

use namespace walter_namespace;

public class WalterModel extends WalterComponent {
	public function WalterModel() {}

	public function sendMessage(msgKey:String, data:Object = null):void {
		modelMessageSender.sendMessage(uid, new WalterMessage(msgKey, data));
	}

	override walter_namespace function deactivating():void {
		modelMessageSender.removeDispatcher(uid);
		removeAllListeners();
		deactivate();
	}
}
}
