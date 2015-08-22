package dittner.gsa.domain.fileSystem.body {
import dittner.gsa.domain.fileSystem.body.note.Note;

import flash.utils.ByteArray;

public class NotebookBody extends FileBody {
	public function NotebookBody() {}

	public var items:Array = [];

	override public function addNote(note:Note):void {
		if (note) {
			items.unshift(note);
			store();
		}
	}

	override public function replaceNote(oldNote:Note, newNote:Note):void {
		if (oldNote && newNote) {
			oldNote.text = newNote.text;
			store();
		}
	}

	override public function removeNote(note:Note):void {
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
