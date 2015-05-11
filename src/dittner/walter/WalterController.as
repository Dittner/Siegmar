package dittner.walter {
import dittner.walter.message.WalterMessage;

use namespace walter_namespace;

public class WalterController extends WalterComponent {
	public function WalterController() {}

	private static const CONTROLLER_DISPATCHER_UID:String = "controller";
	private static const VIEW_INJECT_NAME:String = "view";

	walter_namespace var controllerHandlerHash:Object = {};
	walter_namespace var children:Array = [];

	public function registerController(view:Object, controller:WalterController):void {
		children.push(controller);
		if (walter.injector.hasInjectDeclaration(controller, VIEW_INJECT_NAME)) {
			controller[VIEW_INJECT_NAME] = view;
		}
		controller.activating();
	}

	public function unregisterController(controller:WalterController):void {
		for (var i:int = 0; i < children.length; i++)
			if (children[i] == controller) {
				children.splice(i, 1);
				controller.deactivating();
				break;
			}
	}

	public function listenController(msgKey:String, handler:Function):void {
		controllerHandlerHash[msgKey] = handler;
		controllerMessageSender.listen(CONTROLLER_DISPATCHER_UID, msgKey, handler);
	}

	public function removeControllerListener(msgKey:String, handler:Function):void {
		delete controllerHandlerHash[msgKey];
		controllerMessageSender.removeListener(CONTROLLER_DISPATCHER_UID, msgKey, handler);
	}

	public function sendMessage(msgKey:String, data:Object = null):void {
		controllerMessageSender.sendMessage(CONTROLLER_DISPATCHER_UID, new WalterMessage(msgKey, data));
	}

	override public function removeAllListeners():void {
		super.removeAllListeners();
		for (var msgKey:String in controllerHandlerHash)
			controllerMessageSender.removeListener(CONTROLLER_DISPATCHER_UID, msgKey, controllerHandlerHash[msgKey]);
		controllerHandlerHash = {};
	}

	override walter_namespace function activating():void {
		walter.injector.inject(this);
		activate();
	}

	override walter_namespace function deactivating():void {
		for each(var m:WalterController in children) m.deactivating();
		children.length = 0;
		removeAllListeners();
		deactivate();
		walter.injector.uninject(this);
	}

}
}
