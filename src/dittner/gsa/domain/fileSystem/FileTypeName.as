package dittner.gsa.domain.fileSystem {
public class FileTypeName {

	public static const FOLDER:String = "Ordner";
	public static const ARTICLE:String = "Artikel";
	public static const DICTIONARY:String = "Wörterbuch";
	public static const NOTEBOOK:String = "Notizbuch";
	public static const ALBUM:String = "Album";
	public static const PICTURE:String = "Bild";

	public static function getNameByType(fileType:uint):String {
		switch (fileType) {
			case FileType.FOLDER:
				return FOLDER;
			case FileType.ARTICLE:
				return ARTICLE;
			case FileType.DICTIONARY:
				return DICTIONARY;
			case FileType.NOTEBOOK:
				return NOTEBOOK;
			case FileType.ALBUM:
				return ALBUM;
			case FileType.PICTURE:
				return PICTURE;
			default:
				throw new Error("Unknown file type number: " + fileType);
		}
	}
}
}
