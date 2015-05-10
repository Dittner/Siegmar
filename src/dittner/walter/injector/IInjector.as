package dittner.walter.injector {
public interface IInjector {
	function injectPendingModels():void;
	function injectModels(obj:Object):void;
	function hasInjectDeclaration(obj:Object, injectedProp:String):Boolean;
}
}
