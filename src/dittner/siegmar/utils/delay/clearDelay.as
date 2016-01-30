package dittner.siegmar.utils.delay {
public function clearDelay(index:int):int {
	FTimer.removeTask(index);
	return -1;
}
}