package de.dittner.siegmar.backend {
import de.dittner.siegmar.bootstrap.walter.WalterProxy;

public class SQLLib extends WalterProxy {
	public function SQLLib() {}

	//--------------------------------------
	//  create
	//--------------------------------------

	[Embed(source="/de/dittner/siegmar/backend/sql/CreateFileHeaderTbl.sql", mimeType="application/octet-stream")]
	private static const CreateFileHeaderTblClass:Class;
	public static const CREATE_FILE_HEADER_TBL:String = new CreateFileHeaderTblClass();

	[Embed(source="/de/dittner/siegmar/backend/sql/CreateFileBodyTbl.sql", mimeType="application/octet-stream")]
	private static const CreateFileBodyTblClass:Class;
	public static const CREATE_FILE_BODY_TBL:String = new CreateFileBodyTblClass();

	[Embed(source="/de/dittner/siegmar/backend/sql/CreatePhotoTbl.sql", mimeType="application/octet-stream")]
	private static const CreatePhotoTblClass:Class;
	public static const CREATE_PHOTO_TBL:String = new CreatePhotoTblClass();

	//--------------------------------------
	//  insert
	//--------------------------------------

	[Embed(source="/de/dittner/siegmar/backend/sql/InsertFileHeader.sql", mimeType="application/octet-stream")]
	private static const InsertFileHeaderClass:Class;
	public static const INSERT_FILE_HEADER:String = new InsertFileHeaderClass();

	[Embed(source="/de/dittner/siegmar/backend/sql/InsertFileBody.sql", mimeType="application/octet-stream")]
	private static const InsertFileBodyClass:Class;
	public static const INSERT_FILE_BODY:String = new InsertFileBodyClass();

	[Embed(source="/de/dittner/siegmar/backend/sql/InsertPhoto.sql", mimeType="application/octet-stream")]
	private static const InsertPhotoClass:Class;
	public static const INSERT_PHOTO:String = new InsertPhotoClass();

	//--------------------------------------
	//  update
	//--------------------------------------

	[Embed(source="/de/dittner/siegmar/backend/sql/UpdateFileHeader.sql", mimeType="application/octet-stream")]
	private static const UpdateFileHeaderClass:Class;
	public static const UPDATE_FILE_HEADER:String = new UpdateFileHeaderClass();

	[Embed(source="/de/dittner/siegmar/backend/sql/UpdateFileBody.sql", mimeType="application/octet-stream")]
	private static const UpdateFileBodyClass:Class;
	public static const UPDATE_FILE_BODY:String = new UpdateFileBodyClass();

	[Embed(source="/de/dittner/siegmar/backend/sql/UpdatePhoto.sql", mimeType="application/octet-stream")]
	private static const UpdatePhotoClass:Class;
	public static const UPDATE_PHOTO_BODY:String = new UpdatePhotoClass();

	//--------------------------------------
	//  delete
	//--------------------------------------

	[Embed(source="/de/dittner/siegmar/backend/sql/DeleteFileHeaderByFileID.sql", mimeType="application/octet-stream")]
	private static const DeleteFileHeaderByFileIDClass:Class;
	public static const DELETE_FILE_HEADER_BY_FILE_ID:String = new DeleteFileHeaderByFileIDClass();

	[Embed(source="/de/dittner/siegmar/backend/sql/DeleteFileBodyByFileID.sql", mimeType="application/octet-stream")]
	private static const DeleteFileBodyByFileIDClass:Class;
	public static const DELETE_FILE_BODY_BY_FILE_ID:String = new DeleteFileBodyByFileIDClass();

	[Embed(source="/de/dittner/siegmar/backend/sql/DeletePhotoByID.sql", mimeType="application/octet-stream")]
	private static const DeletePhotoByIDClass:Class;
	public static const DELETE_PHOTO_BY_ID:String = new DeletePhotoByIDClass();

	[Embed(source="/de/dittner/siegmar/backend/sql/DeletePhotoByFileID.sql", mimeType="application/octet-stream")]
	private static const DeletePhotoByFileIDClass:Class;
	public static const DELETE_PHOTO_BY_FILE_ID:String = new DeletePhotoByFileIDClass();

	//--------------------------------------
	//  select
	//--------------------------------------

	[Embed(source="/de/dittner/siegmar/backend/sql/SelectFileHeaders.sql", mimeType="application/octet-stream")]
	private static const SelectFileHeadersClass:Class;
	public static const SELECT_FILE_HEADERS_SQL:String = new SelectFileHeadersClass();

	[Embed(source="/de/dittner/siegmar/backend/sql/SelectFileHeadersByType.sql", mimeType="application/octet-stream")]
	private static const SelectFileHeadersByTypeClass:Class;
	public static const SELECT_FILE_HEADERS_BY_TYPE_SQL:String = new SelectFileHeadersByTypeClass();

	[Embed(source="/de/dittner/siegmar/backend/sql/SelectFavoriteFileHeaders.sql", mimeType="application/octet-stream")]
	private static const SelectFavoriteFileHeadersClass:Class;
	public static const SELECT_FAVORITE_FILE_HEADERS_SQL:String = new SelectFavoriteFileHeadersClass();

	[Embed(source="/de/dittner/siegmar/backend/sql/SelectAllFileHeaders.sql", mimeType="application/octet-stream")]
	private static const SelectAllFilesHeadersClass:Class;
	public static const SELECT_ALL_FILES_HEADERS:String = new SelectAllFilesHeadersClass();

	[Embed(source="/de/dittner/siegmar/backend/sql/SelectFileBody.sql", mimeType="application/octet-stream")]
	private static const SelectFileBodyClass:Class;
	public static const SELECT_FILE_BODY:String = new SelectFileBodyClass();

	[Embed(source="/de/dittner/siegmar/backend/sql/SelectPhotoBytes.sql", mimeType="application/octet-stream")]
	private static const SelectPhotoClass:Class;
	public static const SELECT_PHOTO:String = new SelectPhotoClass();

	[Embed(source="/de/dittner/siegmar/backend/sql/SelectPhotoPreview.sql", mimeType="application/octet-stream")]
	private static const SelectPhotoPreviewClass:Class;
	public static const SELECT_PHOTO_PREVIEW:String = new SelectPhotoPreviewClass();

	[Embed(source="/de/dittner/siegmar/backend/sql/SelectPhotosInfo.sql", mimeType="application/octet-stream")]
	private static const SelectPhotosInfoClass:Class;
	public static const SELECT_PHOTOS_INFO:String = new SelectPhotosInfoClass();

}
}
