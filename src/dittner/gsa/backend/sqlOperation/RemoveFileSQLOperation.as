package dittner.gsa.backend.sqlOperation {
import dittner.gsa.backend.sqlOperation.phase.RemoveFileHeadersAndBodiesPhaseOperation;
import dittner.gsa.backend.sqlOperation.phase.SelectHeaderIDsToRemoveOperation;
import dittner.gsa.bootstrap.async.AsyncCommand;
import dittner.gsa.bootstrap.async.CompositeOperation;
import dittner.gsa.bootstrap.async.IAsyncOperation;

public class RemoveFileSQLOperation extends AsyncCommand {

	public function RemoveFileSQLOperation(fileWrapper:FileSQLWrapper) {
		this.headerWrapper = fileWrapper;
	}

	private var headerWrapper:FileSQLWrapper;

	override public function execute():void {
		var compositeOp:CompositeOperation = new CompositeOperation();
		compositeOp.addCompleteCallback(compositeOpHandler);

		try {
			compositeOp.addOperation(SelectHeaderIDsToRemoveOperation, headerWrapper);
			compositeOp.addOperation(RemoveFileHeadersAndBodiesPhaseOperation, headerWrapper);

			compositeOp.execute();
		}
		catch (exc:Error) {
			compositeOp.destroy();
			dispatchError(exc.message);
		}
	}

	private function compositeOpHandler(op:IAsyncOperation):void {
		dispatchSuccess();
		headerWrapper = null;
	}

}
}