package dittner.walter {
import dittner.walter.injector.Injector;
import dittner.walter.message.MessageSender;
import dittner.walter.utils.WalterExceptionMsg;

use namespace walter_namespace;

public class Walter extends WalterController {
	public function Walter() {
		walter = this;
		injector = new Injector(this);
		modelMessageSender = new MessageSender();
		controllerMessageSender = new MessageSender();
	}

	//----------------------------------------------------------------------------------------------
	//
	//  Variables
	//
	//----------------------------------------------------------------------------------------------

	walter_namespace var injector:Injector;
	walter_namespace var modelHash:Object = {};
	walter_namespace var pendingInjectModels:Array = [];

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
		model.modelMessageSender = modelMessageSender;
		model.walter = this;
		injector.injectPendingModels();
	}

	public function destroy():void {
		super.deactivating();
		for (var modelName:String in modelHash) modelHash[modelName].deactivating();
		modelHash = null;
		pendingInjectModels.length = 0;
		pendingInjectModels = null;
	}

}
}
