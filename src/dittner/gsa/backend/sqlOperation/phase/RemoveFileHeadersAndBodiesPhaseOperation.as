package dittner.gsa.backend.sqlOperation.phase {
import dittner.gsa.backend.phaseOperation.PhaseOperation;
import dittner.gsa.backend.phaseOperation.PhaseRunner;
import dittner.gsa.backend.sqlOperation.FileSQLWrapper;

public class RemoveFileHeadersAndBodiesPhaseOperation extends PhaseOperation {

	public function RemoveFileHeadersAndBodiesPhaseOperation(headerWrapper:FileSQLWrapper) {
		this.headerWrapper = headerWrapper;
	}

	private var headerWrapper:FileSQLWrapper;

	override public function execute():void {
		var phaseRunner:PhaseRunner = new PhaseRunner();
		phaseRunner.completeCallback = phaseRunnerCompleteSuccessHandler;

		try {
			if (headerWrapper.removingFileIDs.length > 0)
				phaseRunner.addPhase(BackUpDataBasePhaseOperation);

			for each(var fileID:int in headerWrapper.removingFileIDs) {
				phaseRunner.addPhase(RemoveFileHeaderByFileIDPhaseOperation, headerWrapper, fileID);
				phaseRunner.addPhase(RemoveFileBodyByFileIDPhaseOperation, headerWrapper, fileID);
			}
			phaseRunner.execute();
		}
		catch (exc:Error) {
			phaseRunner.destroy();
			dispatchComplete();
		}
	}

	private function phaseRunnerCompleteSuccessHandler():void {
		dispatchComplete();
	}

	override public function destroy():void {
		super.destroy();
		headerWrapper = null;
	}
}
}
