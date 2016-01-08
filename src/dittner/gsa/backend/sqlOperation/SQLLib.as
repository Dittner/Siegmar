package dittner.gsa.backend.sqlOperation {
import dittner.gsa.bootstrap.walter.WalterProxy;

public class SQLLib extends WalterProxy {
	public function SQLLib() {}

	//--------------------------------------
	//  create
	//--------------------------------------

	[Embed(source="/dittner/gsa/backend/sqlOperation/sql/CreateFileHeaderTbl.sql", mimeType="application/octet-stream")]
	private static const CreateFileHeaderTblClass:Class;
	public static const CREATE_FILE_HEADER_TBL:String = new CreateFileHeaderTblClass();

	[Embed(source="/dittner/gsa/backend/sqlOperation/sql/CreateFileBodyTbl.sql", mimeType="application/octet-stream")]
	private static const CreateFileBodyTblClass:Class;
	public static const CREATE_FILE_BODY_TBL:String = new CreateFileBodyTblClass();

	//--------------------------------------
	//  insert
	//--------------------------------------

	[Embed(source="/dittner/gsa/backend/sqlOperation/sql/InsertFileHeader.sql", mimeType="application/octet-stream")]
	private static const InsertFileHeaderClass:Class;
	public static const INSERT_FILE_HEADER:String = new InsertFileHeaderClass();

	[Embed(source="/dittner/gsa/backend/sqlOperation/sql/InsertFileBody.sql", mimeType="application/octet-stream")]
	private static const InsertFileBodyClass:Class;
	public static const INSERT_FILE_BODY:String = new InsertFileBodyClass();

	//--------------------------------------
	//  update
	//--------------------------------------

	[Embed(source="/dittner/gsa/backend/sqlOperation/sql/UpdateFileHeader.sql", mimeType="application/octet-stream")]
	private static const UpdateFileHeaderClass:Class;
	public static const UPDATE_FILE_HEADER:String = new UpdateFileHeaderClass();

	[Embed(source="/dittner/gsa/backend/sqlOperation/sql/UpdateFileBody.sql", mimeType="application/octet-stream")]
	private static const UpdateFileBodyClass:Class;
	public static const UPDATE_FILE_BODY:String = new UpdateFileBodyClass();

	//--------------------------------------
	//  delete
	//--------------------------------------

	[Embed(source="/dittner/gsa/backend/sqlOperation/sql/DeleteFileHeaderByFileID.sql", mimeType="application/octet-stream")]
	private static const DeleteFileHeaderByFileIDClass:Class;
	public static const DELETE_FILE_HEADER_BY_FILE_ID:String = new DeleteFileHeaderByFileIDClass();

	[Embed(source="/dittner/gsa/backend/sqlOperation/sql/DeleteFileBodyByFileID.sql", mimeType="application/octet-stream")]
	private static const DeleteFileBodyByFileIDClass:Class;
	public static const DELETE_FILE_BODY_BY_FILE_ID:String = new DeleteFileBodyByFileIDClass();

	//--------------------------------------
	//  select
	//--------------------------------------

	[Embed(source="/dittner/gsa/backend/sqlOperation/sql/SelectFileHeaders.sql", mimeType="application/octet-stream")]
	private static const SelectFileHeadersClass:Class;
	public static const SELECT_FILE_HEADERS_SQL:String = new SelectFileHeadersClass();

	[Embed(source="/dittner/gsa/backend/sqlOperation/sql/SelectFileHeadersByType.sql", mimeType="application/octet-stream")]
	private static const SelectFileHeadersByTypeClass:Class;
	public static const SELECT_FILE_HEADERS_BY_TYPE_SQL:String = new SelectFileHeadersByTypeClass();

	[Embed(source="/dittner/gsa/backend/sqlOperation/sql/SelectAllFileHeaders.sql", mimeType="application/octet-stream")]
	private static const SelectAllFilesHeadersClass:Class;
	public static const SELECT_ALL_FILES_HEADERS:String = new SelectAllFilesHeadersClass();

	[Embed(source="/dittner/gsa/backend/sqlOperation/sql/SelectFileBody.sql", mimeType="application/octet-stream")]
	private static const SelectFileBodyClass:Class;
	public static const SELECT_FILE_BODY:String = new SelectFileBodyClass();

}
}
