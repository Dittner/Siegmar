package de.dittner.siegmar.backend.sqlOperation {
import de.dittner.siegmar.backend.encryption.EncryptionService;
import de.dittner.siegmar.domain.fileSystem.header.FileHeader;
import de.dittner.siegmar.domain.fileSystem.body.FileBody;

import flash.data.SQLConnection;

public class FileSQLWrapper {
	public var header:FileHeader;
	public var body:FileBody;
	public var encryptionService:EncryptionService;
	public var sqlConnection:SQLConnection;
	public var removingFileIDs:Array = [];

	public function headerToSQLObj():Object {
		var res:Object = {};
		res.parentID = header.parentID;
		res.fileType = header.fileType;
		res.title = header.title;
		res.isReserved = header.isReserved ? 1 : 0;
		res.isFavorite = header.isFavorite ? 1 : 0;
		res.options = header.options;
		return res;
	}
}
}
