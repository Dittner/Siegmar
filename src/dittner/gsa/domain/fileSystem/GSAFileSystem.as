package dittner.gsa.domain.fileSystem {
import dittner.gsa.domain.fileSystem.body.DictionaryBody;
import dittner.gsa.message.ModelMsg;
import dittner.walter.WalterModel;
import dittner.walter.walter_namespace;

use namespace walter_namespace;

public class GSAFileSystem extends WalterModel {

	//----------------------------------------------------------------------------------------------
	//
	//  Properties
	//
	//----------------------------------------------------------------------------------------------

	//--------------------------------------
	//  rootFolder
	//--------------------------------------
	private var _rootFolder:IFolder;
	public function get rootFolder():IFolder {return _rootFolder;}

	//--------------------------------------
	//  selectedFile
	//--------------------------------------
	private var _selectedFile:IFolder;
	public function get selectedFile():IFolder {return _selectedFile;}
	public function set selectedFile(value:IFolder):void {
		if (_selectedFile != value) {
			_selectedFile = value;
			sendMessage(ModelMsg.SELECTED_FILE_CHANGED, selectedFile);
		}
	}

	//--------------------------------------
	//  openedDoc
	//--------------------------------------
	private var _openedDoc:IDocument;
	public function get openedDoc():IDocument {return _openedDoc;}
	public function set openedDoc(value:IDocument):void {
		if (_openedDoc != value) {
			_openedDoc = value;
			sendMessage(ModelMsg.OPENED_DOC_CHANGED, openedDoc);
		}
	}

	//--------------------------------------
	//  openedFolder
	//--------------------------------------
	private var _openedFolder:IFolder;
	public function get openedFolder():IFolder {return _openedFolder;}
	public function set openedFolder(value:IFolder):void {
		if (_openedFolder != value) {
			_openedFolder = value;
			sendMessage(ModelMsg.OPENED_FOLDER_CHANGED, openedFolder);
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

	public function createDocument(fileType:int, parentID:int):IDocument {
		var doc:Document = new Document();
		switch (fileType) {
			case FileType.DICTIONARY :
				doc.body = new DictionaryBody();
				break;
			default :
				throw new Error("Unknown doc type:" + fileType);
		}

		doc.parentID = parentID;
		doc.fileType = fileType;
		walter.injector.injectModels(doc);
		return doc;
	}

	public function createRootFolder():IFolder {
		var f:RootFolder = new RootFolder();
		f.fileType = FileType.FOLDER;
		walter.injector.injectModels(f);
		return f;
	}

	public function createFolder(parentID:int):IFolder {
		var f:Folder = new Folder();
		f.parentID = parentID;
		f.fileType = FileType.FOLDER;
		walter.injector.injectModels(f);
		return f;
	}

}
}
