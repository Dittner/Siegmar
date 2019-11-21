package de.dittner.siegmar.view.common.utils {
public class NoteFormUtils {
	public static const LETTERS:RegExp = /[a-zA-ZÄäÖöÜüß-]+/;
	public static const LETTERS_AND_SYMBOLS:RegExp = /[a-zA-ZÄäÖöÜüß *\/-]+/;

	public static function capitalizeAndFormatText(text:String):String {
		return addDot(capitalize(changeSymbols(removeSpaces(text))));
	}

	public static function removeSpaces(str:String):String {
		if (str) {
			str = str.replace(/(  )/gi, " ");
			str = str.replace(/(  )/gi, " ");
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

	public static function changeSymbols(txt:String):String {
		if (txt) {
			txt = txt.replace(/(\[)/gi, "(");
			txt = txt.replace(/(\])/gi, ")");
			txt = txt.replace(/(„)/gi, '"');
			txt = txt.replace(/(“)/gi, '"');
			txt = txt.replace(/( - )/gi, " – ");
		}
		return txt;
	}

	public static function addDot(str:String):String {
		if (str) {
			var endChar:String = str.charAt(str.length - 1);
			if (endChar != "." && endChar != "!" && endChar != "?" && endChar != '"')
				str += ".";
		}
		return str;
	}

	public static function formatText(txt:String, removeWordWrap:Boolean = false):String {
		var res:String = txt;
		if (res) {
			res = res.replace(/( - )/gi, " – ");
			res = res.replace(/(„)/gi, '"');
			res = res.replace(/(“)/gi, '"');
			res = res.replace(/(«)/gi, '"');
			res = res.replace(/(»)/gi, '"');
			res = res.replace(/(—)/gi, '–');
			res = res.replace(/(,–)/gi, ', –');
			res = res.replace(/(–")/gi, '– "');

			res = res.replace(/(\r)/gi, "\n");
			res = res.replace(/(\t)/gi, "\n");
			res = res.replace(/(;;)/gi, ";");
			res = res.replace(/(,,)/gi, ",");
			res = res.replace(/(,;|;;)/gi, ";");
			res = res.replace(/(, ;)/gi, ";");

			if(removeWordWrap) {
				res = res.replace(/(\n\n)/gi, "\n");
				res = res.replace(/(\n\n)/gi, "\n");
				res = res.replace(/(\n)/gi, " ");
			}

			res = removeSpaces(res);
			res = addDot(res);
		}
		return res;
	}


}
}
