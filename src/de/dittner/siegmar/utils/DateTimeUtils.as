package de.dittner.siegmar.utils {
import flash.utils.getTimer;

import spark.formatters.DateTimeFormatter;

public class DateTimeUtils {
	private static var dateTimeFormatter:DateTimeFormatter;

	public static const DD_MM_YYYY:String = "dd.MM.yyyy";

	public static function getDate(date:Date, format:String = DD_MM_YYYY):String {
		if (!date) return "";
		if (!dateTimeFormatter) {
			dateTimeFormatter = new DateTimeFormatter();
		}

		dateTimeFormatter.dateTimePattern = format;
		return dateTimeFormatter.format(date);
	}

	private static var hours:String = "";
	private static var minutes:String = "";
	private static var seconds:String = "";
	private static var ms:String = "";
	private static const START_APP_TIME:Number = (new Date()).time;
	private static var tempDate:Date = new Date();

	public static function getTime():String {
		tempDate.setTime(START_APP_TIME + getTimer());

		hours = tempDate.hours.toString();
		if (hours.length == 1) hours = "0" + hours;

		minutes = tempDate.minutes.toString();
		if (minutes.length == 1) minutes = "0" + minutes;

		seconds = tempDate.seconds.toString();
		if (seconds.length == 1) seconds = "0" + seconds;

		ms = tempDate.milliseconds.toString();
		if (ms.length == 1) ms = "00" + ms;
		else if (ms.length == 2) ms = "0" + ms;

		return hours + ":" + minutes + ":" + seconds + ":" + ms;
	}

	public static const MONTH_DEFAULT_ENG:Array = ['jun', 'feb', 'mar', 'apr', 'may', 'jun', 'jul', 'aug', 'sep', 'oct', 'nov', 'dec'];
	public static const MONTH_DEFAULT:Array = ['января', 'февраля', 'марта', 'апреля', 'мая', 'июня', 'июля', 'августа', 'сентября', 'октября', 'ноября', 'декабря'];
	public static function monthNumToRuName(num:uint):String {
		return num < MONTH_DEFAULT.length ? MONTH_DEFAULT[num] : "";
	}

	public static function monthNumToEnName(num:uint):String {
		return num < MONTH_DEFAULT.length ? MONTH_DEFAULT_ENG[num] : "";
	}
}
}
