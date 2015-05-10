package dittner.gsa.utils.pendingInvoke {

public function clearDelay(index:int):int {
	FTimer.removeTask(index);
	return -1;
}
}