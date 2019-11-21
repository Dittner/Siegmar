package de.dittner.siegmar.utils {
public class InputUtils {
	public static const DIGITS:RegExp = /[0-9]/;
	public static const NO_DIGITS:RegExp = /[^0-9]/;
	public static const LETTERS:RegExp = /[a-zA-ZÄäÖöÜüß]+/;
	public static const LETTERS_AND_SYMBOLS:RegExp = /[a-zA-ZÄäÖöÜüß *\/-]+/;

	public static function removeSpaces(str:String):String {
		if (str) {
			while (str.length > 0 && (str.charAt(0) == " " || str.charAt(0) == "\n" || str.charAt(0) == "\r")) {
				str = str.substring(1, str.length);
			}
			while (str.length > 0 && (str.charAt(str.length - 1) == " " || str.charAt(str.length - 1) == "\n" || str.charAt(str.length - 1) == "\r")) {
				str = str.substring(0, str.length - 1);
			}
		}
		return str;
	}

	public static function capitalize(str:String):String {
		if (str) {
			var temp:String = str.charAt(0);
			temp = temp.toUpperCase();
			temp += str.substring(1, str.length);
			str = temp;
		}
		return str;
	}

}
}
