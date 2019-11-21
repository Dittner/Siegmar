package de.dittner.siegmar.model.domain.fileSystem.body {
import de.dittner.siegmar.model.domain.fileSystem.body.note.ArticleNote;
import de.dittner.siegmar.model.domain.fileSystem.body.note.Note;
import de.dittner.walter.walter_namespace;

import flash.events.Event;
import flash.utils.ByteArray;

import mx.collections.ArrayCollection;

use namespace walter_namespace;

public class NoteListBody extends FileBody {
	public function NoteListBody() {
		super();
	}

	//--------------------------------------
	//  noteColl
	//--------------------------------------
	private var _noteColl:ArrayCollection = new ArrayCollection();
	[Bindable("noteCollChanged")]
	public function get noteColl():ArrayCollection {return _noteColl;}
	private function setNoteColl(value:ArrayCollection):void {
		if (_noteColl != value) {
			_noteColl = value;
			dispatchEvent(new Event("noteCollChanged"));
		}
	}

	public function addNote(note:Note):void {
		if (note) {
			if (note is ArticleNote)
				noteColl.addItem(note);
			else
				noteColl.addItemAt(note, 0);
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
		if (noteColl.removeItem(note))
			store();
	}

	override public function serialize():ByteArray {
		var byteArray:ByteArray = new ByteArray();
		byteArray.writeObject(noteColl.source);
		byteArray.position = 0;
		return byteArray;
	}

	override public function deserialize(ba:ByteArray):void {
		setNoteColl(new ArrayCollection(ba.readObject() as Array || []));
	}

}
}
