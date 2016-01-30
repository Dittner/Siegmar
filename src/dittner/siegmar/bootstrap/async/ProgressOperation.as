package dittner.siegmar.bootstrap.async {
public class ProgressOperation extends AsyncOperation {
	public function ProgressOperation() {
		super();
	}

	//--------------------------------------
	//  total
	//--------------------------------------
	protected var _total:Number;
	public function get total():Number {return _total;}

	//--------------------------------------
	//  progress
	//--------------------------------------
	protected var _progress:Number;
	public function get progress():Number {return _progress;}

	protected var addProgressCallbackQueue:Array = [];
	public function addProgressCallback(handler:Function):void {
		addProgressCallbackQueue.push(handler);
	}

	override protected function removeAllCallbacks():void {
		super.removeAllCallbacks();
		addProgressCallbackQueue.length = 0;
	}

	protected function notifyProgressChanged():void {
		for each(var handler:Function in addProgressCallbackQueue) handler(this);
	}
}
}
