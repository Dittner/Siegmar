package dittner.gsa.view.common.form {
import dittner.gsa.bootstrap.async.IAsyncOperation;
import dittner.gsa.domain.fileSystem.GSAFile;

public interface IBodyForm {
	function createNote(file:GSAFile):IAsyncOperation;
	function editNote(file:GSAFile):IAsyncOperation;
	function removeNote(file:GSAFile):IAsyncOperation;
	function clear():void;
}
}
