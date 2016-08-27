package de.dittner.siegmar.domain.fileSystem.file {
import de.dittner.siegmar.domain.fileSystem.file.*;

public class FileTypeName {

	public static const FOLDER:String = "Ordner";
	public static const ARTICLE:String = "Artikel";
	public static const DICTIONARY:String = "Wörterbuch";
	public static const NOTEBOOK:String = "Notizbuch";
	public static const ALBUM:String = "Fotoalbum";
	public static const PICTURE:String = "Bild";
	public static const BOOK_LINK:String = "Literaturhinweise";
	public static const SETTINGS:String = "Einstellungen";

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
			case FileType.BOOK_LINKS:
				return BOOK_LINK;
			case FileType.SETTINGS:
				return SETTINGS;
			default:
				throw new Error("Unknown file type number: " + fileType);
		}
	}
}
}
