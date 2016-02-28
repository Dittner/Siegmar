package dittner.siegmar.backend.sqlOperation {
import dittner.async.AsyncCommand;
import dittner.async.CompositeCommand;
import dittner.async.IAsyncOperation;
import dittner.siegmar.backend.sqlOperation.phase.RemoveFileHeadersAndBodiesPhaseOperation;
import dittner.siegmar.backend.sqlOperation.phase.SelectHeaderIDsToRemoveOperation;

public class RemoveFileSQLOperation extends AsyncCommand {

	public function RemoveFileSQLOperation(fileWrapper:FileSQLWrapper) {
		this.headerWrapper = fileWrapper;
	}

	private var headerWrapper:FileSQLWrapper;

	override public function execute():void {
		var compositeOp:CompositeCommand = new CompositeCommand();
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