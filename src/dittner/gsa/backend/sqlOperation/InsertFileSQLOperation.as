package dittner.gsa.backend.sqlOperation {
import dittner.gsa.backend.command.CommandResult;
import dittner.gsa.backend.encryption.IEncryptionService;
import dittner.gsa.backend.phaseOperation.PhaseRunner;
import dittner.gsa.backend.sqlOperation.phase.FileBodyEncryptingPhase;
import dittner.gsa.backend.sqlOperation.phase.FileBodyInsertOperationPhase;
import dittner.gsa.backend.sqlOperation.phase.FileHeaderInsertOperationPhase;
import dittner.gsa.bootstrap.deferredOperation.DeferredOperation;
import dittner.gsa.domain.fileSystem.ISystemFile;
import dittner.gsa.domain.store.FileStorage;

public class InsertFileSQLOperation extends DeferredOperation {

	public function InsertFileSQLOperation(storage:FileStorage, file:ISystemFile, encryptionService:IEncryptionService) {
		suite = new SQLOperationSuite();
		suite.sqlRunner = storage.sqlRunner;
		suite.sqlFactory = storage.sqlFactory;
		suite.file = file;
		suite.encryptionService = encryptionService;
	}

	private var suite:SQLOperationSuite;

	override public function process():void {
		var phaseRunner:PhaseRunner = new PhaseRunner();
		phaseRunner.completeCallback = phaseRunnerCompleteSuccessHandler;

		try {
			phaseRunner.addPhase(FileHeaderInsertOperationPhase, suite);
			phaseRunner.addPhase(FileBodyEncryptingPhase, suite);
			phaseRunner.addPhase(FileBodyInsertOperationPhase, suite);

			phaseRunner.execute();
		}
		catch (exc:Error) {
			phaseRunner.destroy();
			dispatchComplete(new CommandResult(suite, exc.details, false));
		}
	}

	private function phaseRunnerCompleteSuccessHandler():void {
		dispatchComplete(new CommandResult(suite));
		suite = null;
	}
}
}