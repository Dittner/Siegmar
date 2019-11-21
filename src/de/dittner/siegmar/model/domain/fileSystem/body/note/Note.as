package de.dittner.siegmar.model.domain.fileSystem.body.note {
[RemoteClass(alias="dittner.siegmar.domain.fileSystem.body.note.Note")]
public class Note {
	public var text:String = "";

	public function copyFrom(src:Note):void {
		text = src.text;
	}
}
}