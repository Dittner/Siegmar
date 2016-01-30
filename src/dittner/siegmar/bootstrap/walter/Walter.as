package dittner.siegmar.bootstrap.walter {
import dittner.siegmar.bootstrap.walter.injector.Injector;
import dittner.siegmar.bootstrap.walter.message.IMessageSender;
import dittner.siegmar.bootstrap.walter.message.MessageSender;

use namespace walter_namespace;

public class Walter {

	private static var _instance:Walter;
	walter_namespace static function get instance():Walter {return _instance;}

	public function Walter() {
		if (_instance) throw new Error("Duplicate Walter!");
		_instance = this;
		injector = new Injector(this);
		proxyMessageSender = new MessageSender();
		mediatorMessageSender = new MessageSender();
		rootMediator = new WalterMediator();
	}

	//----------------------------------------------------------------------------------------------
	//
	//  Variables
	//
	//----------------------------------------------------------------------------------------------

	walter_namespace var injector:Injector;
	walter_namespace var proxyHash:Object = {};
	walter_namespace var pendingInjectProxies:Array = [];
	walter_namespace var proxyMessageSender:IMessageSender;
	walter_namespace var mediatorMessageSender:IMessageSender;
	walter_namespace var rootMediator:WalterMediator;

	//----------------------------------------------------------------------------------------------
	//
	//  Properties
	//
	//----------------------------------------------------------------------------------------------

	//--------------------------------------
	//  hasProxy
	//--------------------------------------
	public function hasProxy(id:String):Boolean {return proxyHash[id] != null;}

	//--------------------------------------
	//  getProxy
	//--------------------------------------
	public function getProxy(id:String):WalterProxy {return proxyHash[id];}

	//----------------------------------------------------------------------------------------------
	//
	//  Methods
	//
	//----------------------------------------------------------------------------------------------

	public function registerProxy(proxyName:String, proxy:WalterProxy):void {
		if (proxyHash[proxyName]) throw new Error("duplicate proxy with name: " + proxyName);
		proxyHash[proxyName] = proxy;
		pendingInjectProxies.push(proxy);
		injector.injectPendingProxies();
	}

	public function registerMediator(view:Object, mediator:WalterMediator):void {
		rootMediator.registerMediator(view, mediator);
	}

	public function unregisterMediator(mediator:WalterMediator):void {
		rootMediator.unregisterMediator(mediator);
	}

	public function destroy():void {
		for (var proxyName:String in proxyHash) proxyHash[proxyName].deactivating();
		rootMediator.deactivating();
		proxyHash = null;
		pendingInjectProxies.length = 0;
		pendingInjectProxies = null;
	}

}
}
