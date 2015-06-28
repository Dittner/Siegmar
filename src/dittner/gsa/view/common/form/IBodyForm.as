package dittner.gsa.view.common.form {
import dittner.gsa.bootstrap.async.IAsyncOperation;
import dittner.gsa.domain.fileSystem.GSAFile;

public interface IBodyForm {
	function createNote(file:GSAFile):IAsyncOperation;
	function editNoteFrom(file:GSAFile):IAsyncOperation;
	function removeNoteFrom(file:GSAFile):IAsyncOperation;
	function clear():void;
}
}
