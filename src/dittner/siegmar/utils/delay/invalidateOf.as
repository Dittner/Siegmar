package dittner.siegmar.utils.delay {
public function invalidateOf(validateFunc:Function):void {
	Invalidator.add(validateFunc);
}
}