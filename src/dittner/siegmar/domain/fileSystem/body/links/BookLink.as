package dittner.siegmar.domain.fileSystem.body.links {
import mx.utils.UIDUtil;

[RemoteClass(alias="dittner.siegmar.domain.fileSystem.body.links.BookLink")]
public class BookLink {
	public function BookLink() {
		id = UIDUtil.createUID();
	}

	public var id:String = "";
	public var authorName:String = "";
	public var bookName:String = "";
	public var publicationPlace:String = "";
	public var publisherName:String = "";
	public var publicationYear:String = "";
	public var pagesNum:String = "";

	public function toString():String {
		return authorName + ", " + bookName + ", " + publicationYear;
	}

	public function toHtmlText():String {
		var txt:String = "";
		txt += "<i>" + authorName + "</i> ";
		txt += bookName + ". – ";
		if (publicationPlace && publisherName) {
			txt += publicationPlace + ": ";
			txt += publisherName + ", ";
		}
		txt += publicationYear + ". – ";
		txt += pagesNum + " с.";
		return txt;
	}

}
}
