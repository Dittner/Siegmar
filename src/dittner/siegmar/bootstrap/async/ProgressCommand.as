package dittner.siegmar.bootstrap.async {
public class ProgressCommand extends AsyncCommand {
	public function ProgressCommand() {
		super();
	}

	//--------------------------------------
	//  progressCallback
	//--------------------------------------
	private var _progressCallback:Function;
	protected function get progressCallback():Function {return _progressCallback;}
	public function addProgressCallback(value:Function):void {
		if (_progressCallback != value) {
			_progressCallback = value;
		}
	}

	protected function setProgress(value:Number):void {
		if (progressCallback != null && value > 0) {
			if (value > 1) value = 1;
			progressCallback(value);
		}
	}
}
}
