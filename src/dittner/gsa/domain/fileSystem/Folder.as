package dittner.gsa.domain.fileSystem {
import dittner.gsa.utils.async.IAsyncOperation;

public class Folder extends SystemFile implements IFolder {
	public function Folder() {
		super();
	}

	[Inject]
	public var system:GSAFileSystem;

	public function createFolder():IFolder {
		var f:IFolder = system.createFolder(id);
		return f;
	}

	public function createDocument(fileType:int):IDocument {
		var d:IDocument = system.createDocument(fileType, id);
		return d;
	}

	public function loadFilesHeaders():IAsyncOperation {
		return fileStorage.loadFilesHeaders(this);
	}

}
}
