package dittner.gsa.domain.fileSystem.body {
import dittner.gsa.bootstrap.walter.walter_namespace;
import dittner.gsa.domain.fileSystem.body.note.Note;

use namespace walter_namespace;

public class NoteListBody extends FileBody {
	public function NoteListBody() {
		super();
	}

	//abstract
	public function addNote(note:Note):void {}
	public function replaceNote(oldNote:Note, newNote:Note):void {}
	public function removeNote(note:Note):void {}

}
}
