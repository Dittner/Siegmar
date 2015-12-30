package dittner.gsa.bootstrap.async {

public class RunProgressOperationCmd extends ProgressOperation implements IAsyncCommand {
	public function RunProgressOperationCmd(operationGenerator:Function, argArray:Array = null) {
		super();
		this.operationGenerator = operationGenerator;
		this.argArray = argArray;
	}

	protected var operationGenerator:Function;
	protected var argArray:Array;
	protected var operation:IAsyncOperation;

	public function execute():void {
		startTimeout();
		operation = operationGenerator.apply(null, argArray) as IAsyncOperation;
		operation.addCompleteCallback(operationComplete);
		if (operation is ProgressOperation) ProgressOperation(operation).addProgressCallback(operationProgress);
	}

	protected function operationComplete(op:IAsyncOperation):void {
		if (op.isSuccess) dispatchSuccess(op.result);
		else dispatchError(op.error);
	}

	protected function operationProgress(op:ProgressOperation):void {
		_progress = op.progress;
		_total = op.total;
		notifyProgressChanged();
	}

}
}
