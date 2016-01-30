package dittner.siegmar.utils.delay {
public function doLaterInSec(method:Function, delaySec:uint = 1):int {
	return FTimer.addTask(method, Math.ceil(delaySec * Fps.rate));
}
}