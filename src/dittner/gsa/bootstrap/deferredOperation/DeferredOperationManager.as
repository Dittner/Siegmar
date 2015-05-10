package dittner.gsa.bootstrap.deferredOperation {
import dittner.gsa.utils.pendingInvoke.clearDelay;
import dittner.gsa.utils.pendingInvoke.doLaterInMSec;
import dittner.walter.WalterModel;

import flash.utils.getQualifiedClassName;

public class DeferredOperationManager extends WalterModel implements IDeferredOperationManager {
	public static const START_EXECUTION_MSG:String = "startExecutionMsg";
	public static const END_EXECUTION_MSG:String = "endExecutionMsg";

	private static const TIME_OUT:Number = 60 * 1000;//ms

	public function DeferredOperationManager() {}

	private var processingCmd:IDeferredOperation;
	private var commandsQueue:Array = [];
	private var timeOutFuncIndex:Number;

	public function add(op:IDeferredOperation):void {
		commandsQueue.push(op);
		executeNextCommand();
	}

	private function executeNextCommand():void {
		if (!processingCmd && hasDeferredCmd()) {
			sendMessage(START_EXECUTION_MSG);
			processingCmd = commandsQueue.shift();
			trace("deferred deferredOperation: " + getQualifiedClassName(processingCmd) + ", start processing...");
			processingCmd.addCompleteCallback(commandCompleteHandler);
			timeOutFuncIndex = doLaterInMSec(timeOutHandler, TIME_OUT);
			processingCmd.process();
		}
	}

	private function hasDeferredCmd():Boolean {
		return commandsQueue.length > 0;
	}

	private function commandCompleteHandler(res:* = null):void {
		trace("deferred deferredOperation complete");
		destroyProcessingCmd();
		executeNextCommand();
		sendMessage(END_EXECUTION_MSG);
	}

	private function destroyProcessingCmd():void {
		processingCmd = null;
		clearDelay(timeOutFuncIndex);
		timeOutFuncIndex = NaN;
	}

	private function timeOutHandler():void {
		trace("time out");
		commandCompleteHandler();
	}
}
}
