package de.dittner.siegmar.domain.fileSystem.body.links {
import de.dittner.siegmar.domain.fileSystem.body.FileBody;

import de.dittner.siegmar.domain.fileSystem.body.*;

import flash.utils.ByteArray;

public class BookLinksBody extends FileBody {
	public function BookLinksBody() {
		super();
	}

	public var bookLinks:Array = [];
	private var bookLinkHash:Object = {};

	public function addLink(link:BookLink):void {
		bookLinks.push(link);
		bookLinkHash[link.id] = link;
		store();
	}

	public function hasLink(linkID:String):Boolean {
		return bookLinkHash[linkID] != null;
	}

	public function getLink(linkID:String):BookLink {
		return bookLinkHash[linkID];
	}

	public function replaceLink(srcLink:BookLink, newLink:BookLink):void {
		for each(var b:BookLink in bookLinks)
			if (b.id == srcLink.id) {
				b.authorName = newLink.authorName;
				b.bookName = newLink.bookName;
				b.publicationPlace = newLink.publicationPlace;
				b.publicationYear = newLink.publicationYear;
				b.publisherName = newLink.publisherName;
				b.pagesNum = newLink.pagesNum;
				store();
				break;
			}
	}

	public function removeLink(link:BookLink):void {
		if (!bookLinkHash[link.id]) return;
		for (var i:int = 0; i < bookLinks.length; i++) {
			var b:BookLink = bookLinks[i];
			if (b.id == link.id) {
				bookLinks.splice(i, 1);
				delete bookLinkHash[b.id];
				store();
				break;
			}
		}
	}

	//----------------------------------------------------------------------------------------------
	//
	//  Methods
	//
	//----------------------------------------------------------------------------------------------

	override public function serialize():ByteArray {
		var byteArray:ByteArray = new ByteArray();
		byteArray.writeObject(bookLinks);
		byteArray.position = 0;
		return byteArray;
	}

	override public function deserialize(ba:ByteArray):void {
		bookLinks = ba.readObject() as Array || [];
		bookLinks.sortOn("authorName");
		for each(var b:BookLink in bookLinks)
			bookLinkHash[b.id] = b;
	}

}
}
