package dittner.gsa.bootstrap.deferredOperation {
import dittner.gsa.backend.command.CommandResult;

public class DeferredOperation implements IDeferredOperation {
	public function DeferredOperation() {}

	private var completeCallbackQueue:Array = [];
	public function addCompleteCallback(handler:Function):void {
		completeCallbackQueue.push(handler);
	}

	/*abstract*/
	public function process():void {}

	/*abstract*/
	protected function destroy():void {}

	final protected function dispatchComplete(result:CommandResult):void {
		for each(var handler:Function in completeCallbackQueue) handler(result);
		completeCallbackQueue = null;
		destroy();
	}

}
}
