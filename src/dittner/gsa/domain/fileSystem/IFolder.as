package dittner.gsa.domain.fileSystem {
import dittner.gsa.utils.async.IAsyncOperation;

public interface IFolder extends ISystemFile {
	function createFolder():IFolder;
	function createDocument(fileType:int):IDocument;
	function loadFilesHeaders():IAsyncOperation;
}
}
