package dittner.gsa.backend.phaseOperation {
public class PhaseOperation {
	public function PhaseOperation() {}

	internal var completeCallback:Function;

	//abstract
	public function execute():void {}

	final protected function dispatchComplete():void {
		completeCallback();
		destroy();
	}

	public function destroy():void {
		completeCallback = null;
	}

}
}
