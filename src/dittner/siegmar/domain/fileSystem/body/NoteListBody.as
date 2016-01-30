package dittner.siegmar.domain.fileSystem.body {
import dittner.siegmar.bootstrap.walter.walter_namespace;
import dittner.siegmar.domain.fileSystem.body.note.Note;

import flash.utils.ByteArray;

use namespace walter_namespace;

public class NoteListBody extends FileBody {
	public function NoteListBody() {
		super();
	}

	public var items:Array = [];

	public function addNote(note:Note):void {
		if (note) {
			items.push(note);
			store();
		}
	}

	public function replaceNote(oldNote:Note, newNote:Note):void {
		if (oldNote && newNote) {
			oldNote.copyFrom(newNote);
			store();
		}
	}

	public function removeNote(note:Note):void {
		for (var i:int = 0; i < items.length; i++)
			if (items[i] == note) {
				items.splice(i, 1);
				store();
				break;
			}
	}

	override public function serialize():ByteArray {
		var byteArray:ByteArray = new ByteArray();
		byteArray.writeObject(items);
		byteArray.position = 0;
		return byteArray;
	}

	override public function deserialize(ba:ByteArray):void {
		items = ba.readObject() as Array || [];
	}

}
}
