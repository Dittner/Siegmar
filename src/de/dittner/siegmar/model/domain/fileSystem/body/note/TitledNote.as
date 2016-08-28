package de.dittner.siegmar.model.domain.fileSystem.body.note {
[RemoteClass(alias="dittner.siegmar.domain.fileSystem.body.note.TitledNote")]
public class TitledNote extends Note {
	public function TitledNote() {}

	public var title:String = "";

	override public function copyFrom(src:Note):void {
		text = src.text;
		if (src is TitledNote) title = (src as TitledNote).title;
	}
}
}
