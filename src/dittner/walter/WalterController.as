package dittner.walter {
import dittner.walter.message.IMessageSender;
import dittner.walter.message.WalterMessage;
import dittner.walter.utils.WalterConstants;

use namespace walter_namespace;

public class WalterController extends WalterComponent {
	public function WalterController() {}

	private static const CONTROLLER_DISPATCHER_UID:String = "controller";

	walter_namespace var controllerMessageSender:IMessageSender;
	walter_namespace var controllerHandlerHash:Object = {};
	private var children:Array = [];

	public function registerController(view:Object, controller:WalterController):void {
		children.push(controller);
		if (walter.injector.hasInjectDeclaration(controller, WalterConstants.VIEW_INJECT_NAME)) {
			controller[WalterConstants.VIEW_INJECT_NAME] = view;
		}
		controller.controllerMessageSender = controllerMessageSender;
		controller.modelMessageSender = modelMessageSender;
		controller.walter = walter;
		walter.injector.injectModels(controller);
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

	override walter_namespace function deactivating():void {
		removeAllListeners();
		walter = null;
		controllerMessageSender = null;
		modelMessageSender = null;
		for each(var m:WalterController in children) m.deactivating();
		children.length = 0;
		deactivate();
	}

}
}
