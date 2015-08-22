package dittner.gsa.utils.delay {
public function invalidateOf(validateFunc:Function):void {
	Invalidator.add(validateFunc);
}
}