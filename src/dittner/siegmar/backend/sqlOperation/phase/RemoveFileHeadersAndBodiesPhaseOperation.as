package dittner.siegmar.backend.sqlOperation.phase {
import dittner.async.AsyncCommand;
import dittner.async.CompositeCommand;
import dittner.async.IAsyncOperation;
import dittner.siegmar.backend.sqlOperation.FileSQLWrapper;
import dittner.siegmar.backend.sqlOperation.RemovePhotoByFileIDSQLOperation;

public class RemoveFileHeadersAndBodiesPhaseOperation extends AsyncCommand {

	public function RemoveFileHeadersAndBodiesPhaseOperation(headerWrapper:FileSQLWrapper) {
		this.headerWrapper = headerWrapper;
	}

	private var headerWrapper:FileSQLWrapper;

	override public function execute():void {
		var compositeOp:CompositeCommand = new CompositeCommand();
		compositeOp.addCompleteCallback(compositeOpHandler);

		try {
			if (headerWrapper.removingFileIDs.length > 0)
				compositeOp.addOperation(BackUpDataBasePhaseOperation);

			for each(var fileID:int in headerWrapper.removingFileIDs) {
				compositeOp.addOperation(RemoveFileHeaderByFileIDPhaseOperation, headerWrapper, fileID);
				compositeOp.addOperation(RemoveFileBodyByFileIDPhaseOperation, headerWrapper, fileID);
				compositeOp.addOperation(RemovePhotoByFileIDSQLOperation, headerWrapper.sqlConnection, fileID);
			}
			compositeOp.execute();
		}
		catch (exc:Error) {
			compositeOp.destroy();
			dispatchError(exc.message);
		}
	}

	private function compositeOpHandler(op:IAsyncOperation):void {
		if (op.isSuccess) dispatchSuccess(op.result);
		else dispatchError(op.error);
	}

	override public function destroy():void {
		super.destroy();
		headerWrapper = null;
	}
}
}
