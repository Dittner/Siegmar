package dittner.gsa.bootstrap.walter {
import dittner.gsa.bootstrap.walter.message.WalterMessage;

use namespace walter_namespace;

public class WalterProxy extends WalterComponent {
	public function WalterProxy() {}

	public function sendMessage(msgKey:String, data:Object = null):void {
		proxyMessageSender.sendMessage(uid, new WalterMessage(msgKey, data));
	}

	override walter_namespace function activating():void {
		activate();
	}

	override walter_namespace function deactivating():void {
		proxyMessageSender.removeDispatcher(uid);
		removeAllListeners();
		deactivate();
		walter.injector.uninject(this);
	}
}
}
