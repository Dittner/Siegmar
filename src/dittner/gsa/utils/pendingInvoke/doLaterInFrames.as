package dittner.gsa.utils.pendingInvoke {

public function doLaterInFrames(method:Function, delayFrames:int = 1):int {
	return FTimer.addTask(method, delayFrames);
}
}