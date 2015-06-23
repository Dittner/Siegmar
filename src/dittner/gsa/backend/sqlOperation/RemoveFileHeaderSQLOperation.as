package dittner.gsa.backend.sqlOperation {
import dittner.gsa.backend.phaseOperation.PhaseRunner;
import dittner.gsa.backend.sqlOperation.phase.RemoveFileHeadersAndBodiesPhaseOperation;
import dittner.gsa.backend.sqlOperation.phase.SelectFileHeaderIDsPhaseOperation;
import dittner.gsa.bootstrap.async.AsyncOperationResult;
import dittner.gsa.bootstrap.deferredOperation.DeferredOperation;

public class RemoveFileHeaderSQLOperation extends DeferredOperation {

	public function RemoveFileHeaderSQLOperation(fileWrapper:FileSQLWrapper) {
		this.headerWrapper = fileWrapper;
	}

	private var headerWrapper:FileSQLWrapper;

	override public function process():void {
		var phaseRunner:PhaseRunner = new PhaseRunner();
		phaseRunner.completeCallback = phaseRunnerCompleteSuccessHandler;

		try {
			phaseRunner.addPhase(SelectFileHeaderIDsPhaseOperation, headerWrapper);
			phaseRunner.addPhase(RemoveFileHeadersAndBodiesPhaseOperation, headerWrapper);

			phaseRunner.execute();
		}
		catch (exc:Error) {
			phaseRunner.destroy();
			dispatchComplete(new AsyncOperationResult(exc.message, false));
		}
	}

	private function phaseRunnerCompleteSuccessHandler():void {
		dispatchComplete(new AsyncOperationResult());
		headerWrapper = null;
	}

}
}