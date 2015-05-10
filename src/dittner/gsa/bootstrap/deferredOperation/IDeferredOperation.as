package dittner.gsa.bootstrap.deferredOperation {

public interface IDeferredOperation {
	function addCompleteCallback(handler:Function):void;
	function process():void;
}
}
