package dittner.gsa.backend.sqlOperation {
import com.probertson.data.SQLRunner;

import dittner.gsa.backend.encryption.IEncryptionService;
import dittner.gsa.domain.fileSystem.IGSAFile;

import flash.utils.ByteArray;

public class SQLOperationSuite {
	public var file:IGSAFile;
	public var encryptionService:IEncryptionService;
	public var encryptedFileBody:ByteArray;
	public var sqlFactory:SQLFactory;
	public var sqlRunner:SQLRunner;
}
}
