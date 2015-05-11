package dittner.gsa.backend.sqlOperation.phase {
import dittner.gsa.backend.phaseOperation.PhaseOperation;
import dittner.gsa.backend.sqlOperation.*;

import flash.utils.ByteArray;

public class FileBodyEncryptingPhase extends PhaseOperation {
	public function FileBodyEncryptingPhase(sqlSuite:SQLOperationSuite) {
		this.sqlSuite = sqlSuite;
	}

	private var sqlSuite:SQLOperationSuite;

	override public function execute():void {
		if (!sqlSuite.file.isFolder) {
			var bytes:ByteArray = sqlSuite.file.body.serialize();
			sqlSuite.encryptedFileBody = sqlSuite.encryptionService.encrypt(bytes);
		}
		else dispatchComplete();
	}

	/*private function saveLocally():void {
	 var fileStream:FileStream = new FileStream();
	 var file:File = File.documentsDirectory.resolvePath(AppConfig.dbRootPath + "record.mp3");
	 fileStream.open(file, FileMode.WRITE);
	 fileStream.writeBytes(note.audioRecord, 0, note.audioRecord.length);
	 fileStream.close();
	 }*/

	override public function destroy():void {
		super.destroy();
		sqlSuite = null;
	}
}
}
