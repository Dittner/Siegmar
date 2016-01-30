package dittner.siegmar.domain.fileSystem.body.note {
[RemoteClass(alias="dittner.siegmar.domain.fileSystem.body.note.ArticleNote")]
public class ArticleNote extends Note {

	public var noteType:String = NoteType.TEXT;
	public var bookLinkId:String = "";
	public var author:String = "";

	override public function copyFrom(src:Note):void {
		text = src.text;
		if (src is ArticleNote) {
			var note:ArticleNote = src as ArticleNote;
			noteType = note.noteType;
			bookLinkId = note.bookLinkId;
			author = note.author;
		}
	}
}
}