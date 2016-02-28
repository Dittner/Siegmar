package dittner.siegmar.bootstrap.async {
import dittner.async.IAsyncCommand;
import dittner.async.utils.clearDelay;
import dittner.async.utils.doLaterInSec;

public class SQLCommandManager {

	private static const TIME_OUT_IN_SEC:Number = 180;

	public function SQLCommandManager() {}

	private var processingCmd:IAsyncCommand;
	private var commandsQueue:Array = [];
	private var urgentCommandsQueue:Array = [];
	private var timeOutFuncIndex:Number;

	//--------------------------------------
	//  isStopped
	//--------------------------------------
	private var _isStopped:Boolean = false;
	public function get isStopped():Boolean {return _isStopped;}
	public function set isStopped(value:Boolean):void {
		if (_isStopped != value) {
			_isStopped = value;
			executeNextCmd();
		}
	}

	public function add(cmd:IAsyncCommand):void {
		commandsQueue.push(cmd);
		executeNextCmd();
	}

	public function addAsUrgent(cmd:IAsyncCommand):void {
		urgentCommandsQueue.push(cmd);
		executeNextCmd();
	}

	private function executeNextCmd():void {
		if (!processingCmd && !isStopped && hasDeferredCmd()) {
			processingCmd = urgentCommandsQueue.length > 0 ? urgentCommandsQueue.shift() : commandsQueue.shift();
			processingCmd.addCompleteCallback(cmdCompleteHandler);
			timeOutFuncIndex = doLaterInSec(timeOutHandler, TIME_OUT_IN_SEC);
			processingCmd.execute();
		}
	}

	private function hasDeferredCmd():Boolean {
		return commandsQueue.length > 0 || urgentCommandsQueue.length > 0;
	}

	private function cmdCompleteHandler(cmd:IAsyncCommand):void {
		destroyProcessingCmd();
		executeNextCmd();
	}

	private function destroyProcessingCmd():void {
		processingCmd = null;
		clearDelay(timeOutFuncIndex);
		timeOutFuncIndex = NaN;
	}

	private function timeOutHandler():void {
		cmdCompleteHandler(processingCmd);
	}
}
}
