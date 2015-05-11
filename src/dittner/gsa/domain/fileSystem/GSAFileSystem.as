package dittner.gsa.domain.fileSystem {
import dittner.gsa.domain.fileSystem.body.DictionaryBody;
import dittner.gsa.domain.store.FileStorage;
import dittner.walter.WalterModel;
import dittner.walter.walter_namespace;

use namespace walter_namespace;

public class GSAFileSystem extends WalterModel {

	public static const FILE_SELECTED:String = "fileSelected";
	public static const FOLDER_OPENED:String = "folderOpened";

	[Inject]
	public var fileStorage:FileStorage;

	//----------------------------------------------------------------------------------------------
	//
	//  Properties
	//
	//----------------------------------------------------------------------------------------------

	//--------------------------------------
	//  rootFolder
	//--------------------------------------
	private var _rootFolder:IGSAFile;
	private function get rootFolder():IGSAFile {return _rootFolder;}

	//--------------------------------------
	//  openedFolder
	//--------------------------------------
	private var _openedFolder:IGSAFile;
	public function get openedFolder():IGSAFile {return _openedFolder;}
	public function set openedFolder(value:IGSAFile):void {
		if (_openedFolder != value) {
			_openedFolder = value;
			sendMessage(FOLDER_OPENED, _openedFolder);
		}
	}
	//--------------------------------------
	//  selectedFile
	//--------------------------------------
	private var _selectedFile:IGSAFile;
	public function get selectedFile():IGSAFile {return _selectedFile;}
	public function set selectedFile(value:IGSAFile):void {
		if (_selectedFile != value) {
			_selectedFile = value;
			sendMessage(FILE_SELECTED, _selectedFile);
		}
	}

	//----------------------------------------------------------------------------------------------
	//
	//  Methods
	//
	//----------------------------------------------------------------------------------------------

	override protected function activate():void {
		_rootFolder = createRootFolder();
		_openedFolder = _selectedFile = _rootFolder;
	}

	private function createRootFolder():IGSAFile {
		var f:RootFolder = new RootFolder();
		f.header = new GSAFileHeader();
		f.header.fileType = FileType.FOLDER;
		return f;
	}

	public function createDocument(fileType:int):IGSAFile {
		var doc:GSAFile = new GSAFile();
		doc.header = new GSAFileHeader();
		doc.header.parentID = openedFolder.header.id;
		doc.header.fileType = fileType;

		switch (fileType) {
			case FileType.DICTIONARY :
				doc.body = new DictionaryBody();
				break;
			default :
				throw new Error("Unknown doc type:" + fileType);
		}
		return doc;
	}

	public function createFolder():IGSAFile {
		var f:GSAFile = new GSAFile();
		f.header = new GSAFileHeader();
		f.header.parentID = openedFolder.header.id;
		f.header.fileType = FileType.FOLDER;
		return f;
	}

}
}
