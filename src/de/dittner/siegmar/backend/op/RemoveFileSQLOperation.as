package de.dittner.siegmar.backend.op {
import de.dittner.async.AsyncCommand;
import de.dittner.async.CompositeCommand;
import de.dittner.async.IAsyncOperation;
import de.dittner.siegmar.backend.op.RemoveFileHeadersAndBodiesPhaseOperation;
import de.dittner.siegmar.backend.op.SelectHeaderIDsToRemoveOperation;

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