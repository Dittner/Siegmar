package dittner.walter {
import dittner.walter.injector.Injector;
import dittner.walter.message.IMessageSender;
import dittner.walter.message.MessageSender;
import dittner.walter.utils.WalterExceptionMsg;

use namespace walter_namespace;

public class Walter {

	private static var _instance:Walter;
	walter_namespace static function get instance():Walter {return _instance;}

	public function Walter() {
		if (_instance) throw new Error("Duplicate Walter!");
		_instance = this;
		injector = new Injector(this);
		modelMessageSender = new MessageSender();
		controllerMessageSender = new MessageSender();
		rootController = new WalterController();
	}

	//----------------------------------------------------------------------------------------------
	//
	//  Variables
	//
	//----------------------------------------------------------------------------------------------

	walter_namespace var injector:Injector;
	walter_namespace var modelHash:Object = {};
	walter_namespace var pendingInjectModels:Array = [];
	walter_namespace var modelMessageSender:IMessageSender;
	walter_namespace var controllerMessageSender:IMessageSender;
	walter_namespace var rootController:WalterController;

	//----------------------------------------------------------------------------------------------
	//
	//  Properties
	//
	//----------------------------------------------------------------------------------------------

	//--------------------------------------
	//  hasModel
	//--------------------------------------
	public function hasModel(id:String):Boolean {return modelHash[id] != null;}

	//--------------------------------------
	//  getModel
	//--------------------------------------
	public function getModel(id:String):WalterModel {return modelHash[id];}

	//----------------------------------------------------------------------------------------------
	//
	//  Methods
	//
	//----------------------------------------------------------------------------------------------

	public function registerModel(modelName:String, model:WalterModel):void {
		if (modelHash[modelName]) throw new Error(WalterExceptionMsg.DUPLICATE_MODEL + "; model name: " + modelName);
		modelHash[modelName] = model;
		pendingInjectModels.push(model);
		injector.injectPendingModels();
	}

	public function registerController(view:Object, controller:WalterController):void {
		rootController.registerController(view, controller);
	}

	public function unregisterController(controller:WalterController):void {
		rootController.unregisterController(controller);
	}

	public function destroy():void {
		for (var modelName:String in modelHash) modelHash[modelName].deactivating();
		rootController.deactivating();
		modelHash = null;
		pendingInjectModels.length = 0;
		pendingInjectModels = null;
	}

}
}
