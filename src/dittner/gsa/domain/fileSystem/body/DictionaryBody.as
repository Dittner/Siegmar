package dittner.gsa.domain.fileSystem.body {
import dittner.gsa.domain.fileSystem.body.note.Note;
import dittner.gsa.domain.fileSystem.body.note.TitledNote;

import flash.utils.ByteArray;

public class DictionaryBody extends FileBody {
	public function DictionaryBody() {}

	public var items:Array = [];

	override public function addNote(note:Note):void {
		if (note) {
			items.unshift(note);
			store();
		}
	}

	override public function replaceNote(oldNote:Note, newNote:Note):void {
		var oldTN:TitledNote = oldNote as TitledNote;
		var newTN:TitledNote = newNote as TitledNote;
		if (oldTN && newTN) {
			oldTN.title = newTN.title;
			oldTN.text = newTN.text;
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
