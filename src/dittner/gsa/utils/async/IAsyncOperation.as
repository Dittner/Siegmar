package dittner.gsa.utils.async {
public interface IAsyncOperation {
	function addCompleteCallback(handler:Function):void;
	function dispatchComplete(result:AsyncOperationResult = null):void;
}
}
