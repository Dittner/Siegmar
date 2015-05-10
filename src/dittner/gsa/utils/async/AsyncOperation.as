package dittner.gsa.utils.async {
import dittner.gsa.utils.pendingInvalidation.invalidateOf;

public class AsyncOperation implements IAsyncOperation {
	public function AsyncOperation() {
	}

	private var completeCallbackQueue:Array = [];
	public function addCompleteCallback(handler:Function):void {
		completeCallbackQueue.push(handler);
	}

	private var asyncOpRes:AsyncOperationResult;
	private var handled:Boolean = false;
	public function dispatchComplete(result:AsyncOperationResult = null):void {
		if (!handled) {
			handled = true;
			asyncOpRes = result || new AsyncOperationResult();
			invalidateOf(completeExecute);
		}
	}

	private function completeExecute():void {
		for each(var handler:Function in completeCallbackQueue) handler(asyncOpRes);
	}

}
}
