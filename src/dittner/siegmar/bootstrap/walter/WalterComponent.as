package dittner.siegmar.bootstrap.walter {
import dittner.siegmar.bootstrap.walter.message.IMessageSender;

use namespace walter_namespace;

public class WalterComponent {
	private static var componentsNum:uint = 0;
	public function WalterComponent() {
		_uid = "walter" + (componentsNum++);
	}

	private var _uid:String;
	walter_namespace function get uid():String {return _uid;}
	walter_namespace var proxyHandlersHash:Object = {};

	walter_namespace static function get walter():Walter {return Walter.instance;}
	walter_namespace static function get proxyMessageSender():IMessageSender {return walter.proxyMessageSender;}
	walter_namespace static function get mediatorMessageSender():IMessageSender {return walter.mediatorMessageSender;}

	public function listenProxy(proxy:WalterProxy, msgKey:String, handler:Function):void {
		if (!proxyHandlersHash[proxy.uid]) proxyHandlersHash[proxy.uid] = {};
		var handlerHash:Object = proxyHandlersHash[proxy.uid];
		handlerHash[msgKey] = handler;
		proxyMessageSender.listen(proxy.uid, msgKey, handler);
	}

	public function removeProxyListener(proxy:WalterProxy, msgKey:String):void {
		if (proxyHandlersHash[proxy.uid]) {
			var handlerHash:Object = proxyHandlersHash[proxy.uid];
			if (handlerHash[msgKey] != null) {
				proxyMessageSender.removeListener(proxy.uid, msgKey, handlerHash[msgKey]);
				delete handlerHash[msgKey];
			}
		}
	}

	public function removeAllListeners():void {
		for (var proxyUID:String in proxyHandlersHash) {
			var handlerHash:Object = proxyHandlersHash[proxyUID];
			for (var msgKey:String in handlerHash)
				proxyMessageSender.removeListener(proxyUID, msgKey, handlerHash[msgKey]);
		}
		proxyHandlersHash = {};
	}

	//abstract
	walter_namespace function activating():void {}
	//abstract
	walter_namespace function deactivating():void {}

	//abstract
	protected function activate():void {}
	//abstract
	protected function deactivate():void {}

}
}