package dittner.siegmar.bootstrap.async {
import dittner.siegmar.utils.delay.clearDelay;
import dittner.siegmar.utils.delay.doLaterInSec;
import dittner.siegmar.utils.delay.invalidateOf;

public class AsyncOperation implements IAsyncOperation {
	public function AsyncOperation() {}

	private static var totalOperations:Number = 0;
	public var _uid:Number = totalOperations++;
	public function get uid():Number {return _uid;}

	//----------------------------------------------------------------------------------------------
	//
	//  Properties
	//
	//----------------------------------------------------------------------------------------------

	//--------------------------------------
	//  timeoutInSec
	//--------------------------------------
	private var _timeoutInSec:Number = 0;
	public function get timeoutInSec():Number {return _timeoutInSec;}
	public function set timeoutInSec(value:Number):void {
		if (_timeoutInSec != value) {
			_timeoutInSec = value;
			startTimeout();
		}
	}

	//--------------------------------------
	//  result
	//--------------------------------------
	protected var _result:*;
	public function get result():* {return _result;}

	//--------------------------------------
	//  isSuccess
	//--------------------------------------
	protected var _isSuccess:Boolean;
	public function get isSuccess():Boolean {return _isSuccess;}

	//--------------------------------------
	//  isProcessing
	//--------------------------------------
	protected var _isProcessing:Boolean = true;
	public function get isProcessing():Boolean {return _isProcessing;}

	//--------------------------------------
	//  isTimeout
	//--------------------------------------
	protected var _isTimeout:Boolean = false;
	public function get isTimeout():Boolean {return _isTimeout;}

	//--------------------------------------
	//  error
	//--------------------------------------
	protected var _error:* = "";
	public function get error():* {return _error;}

	//----------------------------------------------------------------------------------------------
	//
	//  Methods
	//
	//----------------------------------------------------------------------------------------------

	private var timeoutInd:Number = NaN;
	protected function startTimeout():void {
		stopTimeout();
		if (timeoutInSec > 0) timeoutInd = doLaterInSec(timeoutHandler, timeoutInSec);
	}

	protected function stopTimeout():void {
		if (!isNaN(timeoutInd)) {
			clearDelay(timeoutInd);
			timeoutInd = NaN;
		}
	}

	protected function timeoutHandler():void {
		timeoutInd = NaN;
		_isTimeout = true;
		dispatchError("Timeout!");
	}

	private var completeCallbackQueue:Array = [];
	public function addCompleteCallback(handler:Function):void {
		completeCallbackQueue.push(handler);
	}

	public function dispatchSuccess(result:* = null):void {
		_result = result;
		_isSuccess = true;
		invalidateOf(completeExecute);
	}

	public function dispatchError(error:* = null):void {
		_error = error;
		_isSuccess = false;
		invalidateOf(completeExecute);
	}

	protected function completeExecute():void {
		_isProcessing = false;
		for each(var handler:Function in completeCallbackQueue) handler(this);
		stopTimeout();
		destroy();
	}

	public function destroy():void {
		removeAllCallbacks();
	}

	protected function removeAllCallbacks():void {
		completeCallbackQueue.length = 0;
	}
}
}