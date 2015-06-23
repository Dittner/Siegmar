package dittner.gsa.backend.sqlOperation {
import com.probertson.data.SQLRunner;

import dittner.gsa.backend.encryption.IEncryptionService;
import dittner.gsa.domain.fileSystem.FileHeader;
import dittner.gsa.domain.fileSystem.body.FileBody;

public class FileSQLWrapper {
	public var header:FileHeader;
	public var body:FileBody;
	public var encryptionService:IEncryptionService;
	public var sqlFactory:SQLFactory;
	public var sqlRunner:SQLRunner;
	public var removingFileIDs:Array = [];

	public function headerToSQLObj():Object {
		var res:Object = {};
		res.parentID = header.parentID;
		res.fileType = header.fileType;
		res.title = header.title;
		res.password = header.password;
		res.options = header.options;
		return res;
	}
}
}
