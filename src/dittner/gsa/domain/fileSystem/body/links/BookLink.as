package dittner.gsa.domain.fileSystem.body.links {
import mx.utils.UIDUtil;

[RemoteClass(alias="dittner.gsa.domain.fileSystem.body.links.BookLink")]
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

}
}
