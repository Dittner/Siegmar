package de.dittner.siegmar.bootstrap.walter {
import de.dittner.siegmar.bootstrap.walter.message.WalterMessage;

use namespace walter_namespace;

public class WalterMediator extends WalterComponent {
	public function WalterMediator() {}

	private static const MEDIATOR_DISPATCHER_UID:String = "mediator";
	private static const VIEW_INJECT_NAME:String = "view";

	walter_namespace var mediatorHandlerHash:Object = {};
	walter_namespace var children:Array = [];

	public function registerMediator(view:Object, mediator:WalterMediator):void {
		children.push(mediator);
		if (walter.injector.hasInjectDeclaration(mediator, VIEW_INJECT_NAME)) {
			mediator[VIEW_INJECT_NAME] = view;
		}
		mediator.activating();
	}

	public function unregisterMediator(mediator:WalterMediator):void {
		for (var i:int = 0; i < children.length; i++)
			if (children[i] == mediator) {
				children.splice(i, 1);
				mediator.deactivating();
				break;
			}
	}

	public function listenMediator(msgKey:String, handler:Function):void {
		mediatorHandlerHash[msgKey] = handler;
		mediatorMessageSender.listen(MEDIATOR_DISPATCHER_UID, msgKey, handler);
	}

	public function removeMediatorListener(msgKey:String, handler:Function):void {
		delete mediatorHandlerHash[msgKey];
		mediatorMessageSender.removeListener(MEDIATOR_DISPATCHER_UID, msgKey, handler);
	}

	public function sendMessage(msgKey:String, data:Object = null):void {
		mediatorMessageSender.sendMessage(MEDIATOR_DISPATCHER_UID, new WalterMessage(msgKey, data));
	}

	override public function removeAllListeners():void {
		super.removeAllListeners();
		for (var msgKey:String in mediatorHandlerHash)
			mediatorMessageSender.removeListener(MEDIATOR_DISPATCHER_UID, msgKey, mediatorHandlerHash[msgKey]);
		mediatorHandlerHash = {};
	}

	override walter_namespace function activating():void {
		walter.injector.inject(this);
		activate();
	}

	override walter_namespace function deactivating():void {
		for each(var m:WalterMediator in children) m.deactivating();
		children.length = 0;
		removeAllListeners();
		deactivate();
		walter.injector.uninject(this);
	}

}
}
