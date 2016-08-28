package de.dittner.siegmar.backend {
import de.dittner.async.IAsyncCommand;
import de.dittner.async.IAsyncOperation;
import de.dittner.async.utils.clearDelay;
import de.dittner.async.utils.doLaterInMSec;
import de.dittner.siegmar.view.main.MainVM;
import de.dittner.walter.WalterProxy;

import flash.events.Event;

public class DeferredCommandManager extends WalterProxy {

	private static const TIME_OUT:Number = 60 * 1000;//ms

	public function DeferredCommandManager() {
		super();
	}

	[Inject]
	public var mainVM:MainVM;

	//--------------------------------------
	//  isRunning
	//--------------------------------------
	private var _isRunning:Boolean = false;
	[Bindable("isRunningChanged")]
	public function get isRunning():Boolean {return _isRunning;}
	private function setIsRunning(value:Boolean):void {
		if (_isRunning != value) {
			_isRunning = value;
			dispatchEvent(new Event("isRunningChanged"));
		}
	}

	public function start():void {
		setIsRunning(true);
		executeNextCommand();
	}

	public function stop():void {
		setIsRunning(false);
	}

	private var processingCmd:IAsyncCommand;
	private var commandsQueue:Array = [];
	private var timeOutFuncIndex:Number;

	public function add(cmd:IAsyncCommand):void {
		commandsQueue.push(cmd);
		if (isRunning) executeNextCommand();
	}

	private function executeNextCommand():void {
		if (!processingCmd && hasDeferredCmd()) {
			mainVM.viewLocked = true;
			processingCmd = commandsQueue.shift();
			//trace("deferred deferredOperation: " + getQualifiedClassName(processingCmd) + ", start processing...");
			processingCmd.addCompleteCallback(commandCompleteHandler);
			timeOutFuncIndex = doLaterInMSec(timeOutHandler, TIME_OUT);
			processingCmd.execute();
		}
	}

	private function hasDeferredCmd():Boolean {
		return commandsQueue.length > 0;
	}

	private function commandCompleteHandler(op:IAsyncOperation):void {
		mainVM.viewLocked = false;
		destroyProcessingCmd();
		executeNextCommand();
	}

	private function destroyProcessingCmd():void {
		processingCmd = null;
		clearDelay(timeOutFuncIndex);
		timeOutFuncIndex = NaN;
	}

	private function timeOutHandler():void {
		trace("time out");
		commandCompleteHandler(processingCmd);
	}
}
}
