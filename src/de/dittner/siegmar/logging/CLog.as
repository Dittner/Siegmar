package de.dittner.siegmar.logging {
import de.dittner.siegmar.model.Device;
import de.dittner.siegmar.utils.DateTimeUtils;

import flash.desktop.NativeApplication;
import flash.events.Event;
import flash.events.TimerEvent;
import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;
import flash.system.Capabilities;
import flash.system.System;
import flash.utils.Timer;

public class CLog {
	public function CLog() {}

	private static const MAX_LOG_NOTES:int = 500;
	private static const SESSION_DELAY:int = 2000;
	private static const LOG_KEEP_DAYS:uint = 2;
	private static const MAX_MEMORY:uint = 250;
	private static const LOGS_DIR:String = "SiegmarLogs";

	//----------------------------------------------------------------------------------------------
	//
	//  Variables
	//
	//----------------------------------------------------------------------------------------------

	private static var logDate:Date = new Date();
	public static var logBank:Array = [];
	private static var timer:Timer = new Timer(SESSION_DELAY);
	private static var fileStream:FileStream;

	private static var isLaunched:Boolean = false;

	public static var traceEnabled:Boolean = true;
	public static var changeCallback:Function;

	//----------------------------------------------------------------------------------------------
	//
	//  Methods
	//
	//----------------------------------------------------------------------------------------------

	public static function run():void {
		if (!isLaunched) {
			isLaunched = true;

			removeExpiredFileLogs();
			createFile();
			logAboutApp();
			timer.addEventListener(TimerEvent.TIMER, timerHandler);
			timer.start();
			Device.stage.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}
		if (!timer.running) {
			timer.start();
		}
	}

	private static function removeExpiredFileLogs():void {
		var logFolder:File = File.documentsDirectory.resolvePath(LOGS_DIR + File.separator);
		if (logFolder.exists) {
			var expireDate:Date = new Date();
			expireDate.date -= LOG_KEEP_DAYS;
			var logFiles:Array = logFolder.getDirectoryListing();
			for each(var logFile:File in logFiles) {
				if (logFile.creationDate.time < expireDate.time)
					logFile.deleteFileAsync();
			}
		}
	}

	private static function createFile():void {
		var now:Date = new Date();
		var mins:String = now.minutes < 10 ? "0" + now.minutes : now.minutes.toString();
		var secs:String = now.seconds < 10 ? "0" + now.seconds : now.seconds.toString();
		var month:String = DateTimeUtils.monthNumToEnName(now.month);
		var timestamp:String = now.date + " " + month + " " + now.fullYear + " " + now.hours + "-" + mins + "-" + secs;
		var file:File = File.documentsDirectory.resolvePath(LOGS_DIR + File.separator + timestamp + ".clientLog");
		fileStream = new FileStream();
		fileStream.open(file, FileMode.WRITE);
	}

	private static function logAboutApp():void {
		var appDescriptor:XML = NativeApplication.nativeApplication.applicationDescriptor;
		var ns:Namespace = appDescriptor.namespace();
		var appCopyright:String = appDescriptor.ns::filename;
		var appVersion:String = appDescriptor.ns::versionNumber;

		var logTxt:String = "";
		logTxt += "Siegmar client's log\n";
		logTxt += Capabilities.os + "\n";
		logTxt += Capabilities.version + "\n";
		logTxt += "pixelAspectRatio: " + Capabilities.pixelAspectRatio + "\n";
		logTxt += "screenDPI: " + Capabilities.screenDPI + "\n";
		logTxt += Capabilities.cpuArchitecture + "\n";
		logTxt += "Debugger: " + Capabilities.isDebugger + "\n";
		logTxt += logDate.date + " " + DateTimeUtils.monthNumToRuName(logDate.month) + " " + logDate.fullYear + "\n";
		logTxt += "appID: " + appCopyright + "\n";
		logTxt += "version: " + appVersion + "\n";
		info(LogCategory.SYSTEM, logTxt);
	}

	private static var framesInSession:Number = 0;
	private static var totalFrames:Number = 0;
	private static var lastMem:Number = 0;
	private static var lastFps:Number = 0;
	private static function timerHandler(e:TimerEvent):void {
		logMemoryAndFPS();
	}

	public static function logMemoryAndFPS(force:Boolean = false):void {
		var mem:int = System.privateMemory / 1024 / 1024;
		var fps:int = framesInSession * 1000 / SESSION_DELAY;
		if (force || 10 + mem < lastMem || mem - 10 > lastMem || 3 + fps < lastFps || fps - 3 > lastFps) {
			if (mem < MAX_MEMORY && fps > 10)
				info(LogCategory.MEMORY, mem + "Mb, fps:" + fps);
			else
				warn(LogCategory.MEMORY, mem + "Mb, fps:" + fps);

			lastMem = mem;
			lastFps = fps;
		}
		framesInSession = 0;
	}

	private static function enterFrameHandler(event:Event):void {
		framesInSession++;
		totalFrames++;
	}

	public static function info(category:String, text:String):void {
		var note:LogNote = createLogNote();
		note.logType = LogNoteType.INFO;
		note.time = DateTimeUtils.getTime();
		note.category = category;
		note.text = text;
		note.symbol = "i";
		addNote(note);
	}

	public static function warn(category:String, text:String):void {
		var note:LogNote = createLogNote();
		note.logType = LogNoteType.WARN;
		note.time = DateTimeUtils.getTime();
		note.category = category;
		note.text = text;
		note.symbol = "w";
		addNote(note);
	}

	public static function err(category:String, text:String):void {
		var note:LogNote = createLogNote();
		note.logType = LogNoteType.ERROR;
		note.time = DateTimeUtils.getTime();
		note.category = category;
		note.text = text;
		note.symbol = "e";
		addNote(note);
	}

	private static function createLogNote():LogNote {
		return logBank.length > MAX_LOG_NOTES ? logBank.pop() : new LogNote();
	}

	private static function addNote(note:LogNote):void {
		fileStream.writeUTFBytes(note.toString());
		logBank.unshift(note);
		if (traceEnabled) trace(note.toString());
		if (changeCallback != null) changeCallback();
	}

}
}
