package dittner.walter {
import dittner.walter.message.IMessageSender;

use namespace walter_namespace;

public class WalterComponent {
	private static var componentsNum:int = 0;
	public function WalterComponent() {
		_uid = "model" + (componentsNum++);
	}

	private var _uid:String;
	walter_namespace function get uid():String {return _uid;}
	walter_namespace var modelHandlersHash:Object = {};

	walter_namespace static function get walter():Walter {return Walter.instance;}
	walter_namespace static function get modelMessageSender():IMessageSender {return walter.modelMessageSender;}
	walter_namespace static function get controllerMessageSender():IMessageSender {return walter.controllerMessageSender;}

	public function listenModel(model:WalterModel, msgKey:String, handler:Function):void {
		if (!modelHandlersHash[model.uid]) modelHandlersHash[model.uid] = {};
		var handlerHash:Object = modelHandlersHash[model.uid];
		handlerHash[msgKey] = handler;
		modelMessageSender.listen(model.uid, msgKey, handler);
	}

	public function removeModelListener(model:WalterModel, msgKey:String):void {
		if (modelHandlersHash[model.uid]) {
			var handlerHash:Object = modelHandlersHash[model.uid];
			if (handlerHash[msgKey] != null) {
				modelMessageSender.removeListener(model.uid, msgKey, handlerHash[msgKey]);
				delete handlerHash[msgKey];
			}
		}
	}

	public function removeAllListeners():void {
		for (var modelUID:String in modelHandlersHash) {
			var handlerHash:Object = modelHandlersHash[modelUID];
			for (var msgKey:String in handlerHash)
				modelMessageSender.removeListener(modelUID, msgKey, handlerHash[msgKey]);
		}
		modelHandlersHash = {};
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