package de.dittner.siegmar.backend.sqlOperation {
import flash.data.SQLStatement;

public class SQLUtils {
	public function SQLUtils() {}

	public static function createSQLStatement(sqlText:String, params:Object = null, itemClass:Class = null):SQLStatement {
		var stmt:SQLStatement = new SQLStatement();
		stmt.text = sqlText;
		stmt.itemClass = itemClass;
		if (params)
			for (var prop:String in params) stmt.parameters[":" + prop] = params[prop];
		return stmt;
	}
}
}
