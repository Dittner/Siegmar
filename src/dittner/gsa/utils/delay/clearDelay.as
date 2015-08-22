package dittner.gsa.utils.delay {
public function clearDelay(index:int):int {
	FTimer.removeTask(index);
	return -1;
}
}