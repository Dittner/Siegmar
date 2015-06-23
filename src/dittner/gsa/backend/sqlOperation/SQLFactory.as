package dittner.gsa.backend.sqlOperation {
import dittner.gsa.bootstrap.walter.WalterProxy;

public class SQLFactory extends WalterProxy {
	public function SQLFactory() {}

	//--------------------------------------
	//  create
	//--------------------------------------

	[Embed(source="/dittner/gsa/backend/sqlOperation/sql/CreateFileHeaderTbl.sql", mimeType="application/octet-stream")]
	private static const CreateFileHeaderTblClass:Class;
	private static const CREATE_FILE_HEADER_TBL_SQL:String = new CreateFileHeaderTblClass();
	public function get createFileHeaderTbl():String {
		return CREATE_FILE_HEADER_TBL_SQL;
	}

	[Embed(source="/dittner/gsa/backend/sqlOperation/sql/CreateFileBodyTbl.sql", mimeType="application/octet-stream")]
	private static const CreateFileBodyTblClass:Class;
	private static const CREATE_FILE_BODY_TBL_SQL:String = new CreateFileBodyTblClass();
	public function get createFileBodyTbl():String {
		return CREATE_FILE_BODY_TBL_SQL;
	}

	//--------------------------------------
	//  insert
	//--------------------------------------

	[Embed(source="/dittner/gsa/backend/sqlOperation/sql/InsertFileHeader.sql", mimeType="application/octet-stream")]
	private static const InsertFileHeaderClass:Class;
	private static const INSERT_FILE_HEADER_SQL:String = new InsertFileHeaderClass();
	public function get insertFileHeader():String {
		return INSERT_FILE_HEADER_SQL;
	}

	[Embed(source="/dittner/gsa/backend/sqlOperation/sql/InsertFileBody.sql", mimeType="application/octet-stream")]
	private static const InsertFileBodyClass:Class;
	private static const INSERT_FILE_BODY_SQL:String = new InsertFileBodyClass();
	public function get insertFileBody():String {
		return INSERT_FILE_BODY_SQL;
	}

	//--------------------------------------
	//  update
	//--------------------------------------

	[Embed(source="/dittner/gsa/backend/sqlOperation/sql/UpdateFileHeader.sql", mimeType="application/octet-stream")]
	private static const UpdateFileHeaderClass:Class;
	private static const UPDATE_FILE_HEADER_SQL:String = new UpdateFileHeaderClass();
	public function get updateFileHeader():String {
		return UPDATE_FILE_HEADER_SQL;
	}

	[Embed(source="/dittner/gsa/backend/sqlOperation/sql/UpdateFileBody.sql", mimeType="application/octet-stream")]
	private static const UpdateFileBodyClass:Class;
	private static const UPDATE_FILE_BODY_SQL:String = new UpdateFileBodyClass();
	public function get updateFileBody():String {
		return UPDATE_FILE_BODY_SQL;
	}

	//--------------------------------------
	//  delete
	//--------------------------------------

	[Embed(source="/dittner/gsa/backend/sqlOperation/sql/DeleteFileHeaderByFileID.sql", mimeType="application/octet-stream")]
	private static const DeleteFileHeaderByFileIDClass:Class;
	private static const DELETE_FILE_HEADER_BY_FILE_ID_SQL:String = new DeleteFileHeaderByFileIDClass();
	public function get deleteFileHeaderByFileID():String {
		return DELETE_FILE_HEADER_BY_FILE_ID_SQL;
	}

	[Embed(source="/dittner/gsa/backend/sqlOperation/sql/DeleteFileBodyByFileID.sql", mimeType="application/octet-stream")]
	private static const DeleteFileBodyByFileIDClass:Class;
	private static const DELETE_FILE_BODY_BY_FILE_ID_SQL:String = new DeleteFileBodyByFileIDClass();
	public function get deleteFileBodyByFileID():String {
		return DELETE_FILE_BODY_BY_FILE_ID_SQL;
	}

	//--------------------------------------
	//  select
	//--------------------------------------

	[Embed(source="/dittner/gsa/backend/sqlOperation/sql/SelectFileHeaders.sql", mimeType="application/octet-stream")]
	private static const SelectFileHeadersClass:Class;
	private static const SELECT_FILE_HEADERS_SQL:String = new SelectFileHeadersClass();
	public function get selectFileHeaders():String {
		return SELECT_FILE_HEADERS_SQL;
	}

	[Embed(source="/dittner/gsa/backend/sqlOperation/sql/SelectAllFileHeaders.sql", mimeType="application/octet-stream")]
	private static const SelectAllFilesHeadersClass:Class;
	private static const SELECT_ALL_FILES_HEADERS_SQL:String = new SelectAllFilesHeadersClass();
	public function get selectAllFileHeaders():String {
		return SELECT_ALL_FILES_HEADERS_SQL;
	}
}
}
