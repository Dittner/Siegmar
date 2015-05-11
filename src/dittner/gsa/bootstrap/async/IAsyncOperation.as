package dittner.gsa.bootstrap.async {
public interface IAsyncOperation {
	function addCompleteCallback(handler:Function):void;
	function dispatchComplete(result:AsyncOperationResult = null):void;
}
}
