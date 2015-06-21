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

	//--------------------------------------
	//  delete
	//--------------------------------------

	//--------------------------------------
	//  select
	//--------------------------------------

	[Embed(source="/dittner/gsa/backend/sqlOperation/sql/SelectFilesHeaders.sql", mimeType="application/octet-stream")]
	private static const SelectFilesHeadersClass:Class;
	private static const SELECT_FILES_HEADERS_SQL:String = new SelectFilesHeadersClass();
	public function get selectFilesHeaders():String {
		return SELECT_FILES_HEADERS_SQL;
	}
}
}
