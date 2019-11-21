package de.dittner.siegmar.utils {
import de.dittner.async.ProgressOperation;

import flash.display.Loader;
import flash.events.ErrorEvent;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.SecurityErrorEvent;
import flash.filesystem.File;
import flash.net.URLRequest;
import flash.system.ApplicationDomain;
import flash.system.LoaderContext;

public class FileLoader extends ProgressOperation {

	public function FileLoader() {
		super();
	}

	private var loader:Loader;
	private var loaderContext:LoaderContext;
	private var fileLoadedCallback:Function;
	private var totalFiles:int = 0;
	private var files:Array;
	private var processingFile:File;

	public function loadFiles(files:Array, fileLoadedCallback:Function):void {
		if (!loader) {
			this.files = files;
			this.totalFiles = files.length;
			this.fileLoadedCallback = fileLoadedCallback;
			loader = new Loader();
			loaderContext = new LoaderContext(false, ApplicationDomain.currentDomain, null);
			loaderContext.allowLoadBytesCodeExecution = true;
			addListeners(loader);
			loadNextFile();
		}
	}

	private function loadNextFile():void {
		if (files.length == 0) {
			_progress = 1;
			notifyProgressChanged();
			dispatchSuccess();
			removeListeners(loader);
		}
		else {
			_progress = 1 - files.length / totalFiles;
			notifyProgressChanged();
			processingFile = files.shift();
			var request:URLRequest = new URLRequest(processingFile.url);
			request.cacheResponse = false;
			request.useCache = false;
			loader.load(request, loaderContext);
		}
	}

	private function fileLoadFailed(event:ErrorEvent):void {
		removeListeners(loader);
		dispatchError("Load file is failed: " + event.toString());
	}

	private function fileLoaded(event:Event):void {
		fileLoadedCallback(event.target.content, processingFile);
		loadNextFile();
	}

	private function addListeners(ldr:Loader):void {
		ldr.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, fileLoadFailed);
		ldr.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, fileLoadFailed);
		ldr.contentLoaderInfo.addEventListener(Event.COMPLETE, fileLoaded);
	}

	private function removeListeners(ldr:Loader):void {
		ldr.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, fileLoadFailed);
		ldr.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, fileLoadFailed);
		ldr.contentLoaderInfo.removeEventListener(Event.COMPLETE, fileLoaded);
	}

}
}
