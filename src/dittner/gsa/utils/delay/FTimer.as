package dittner.gsa.utils.delay {
public class FTimer {
	public function FTimer() {}

	private var index:int = 0;
	private var functions:Object;
	private var indexes:Vector.<int>;
	private var runDelays:Vector.<int>;
	private var totalFrames:uint = 0;
	private var inited:Boolean = false;

	private function add(func:Function, delayFrames:uint):int {
		if (!inited) {
			inited = true;
			invalidateOf(timerHandler);
			functions = {};
			indexes = new Vector.<int>();
			runDelays = new Vector.<int>();
		}

		if (index == int.MAX_VALUE) resetIndexes();
		index++;
		functions[index] = func;
		runDelays.push(delayFrames / 2 + totalFrames);
		indexes.push(index);
		return index;
	}

	private function resetIndexes():void {
		var i:int = indexes.length;
		var newDelays:Vector.<int> = new Vector.<int>();
		var newIndexes:Vector.<int> = new Vector.<int>();
		while (i--) {
			newDelays.push(runDelays[i]);
			newIndexes.push(indexes[i]);
		}
		indexes = newIndexes;
		runDelays = newDelays;
		index = 0;
	}

	private function timerHandler():void {
		totalFrames++;
		var i:int = indexes.length;
		while (i--) {
			if (totalFrames > runDelays[i]) {
				var n:int = indexes[i];

				if (functions[n] is Function)
					functions[n]();
				delete  functions[n];
				runDelays.splice(i, 1);
				indexes.splice(i, 1);
			}
		}
		invalidateOf(timerHandler);
	}

	private function remove(index:int):void {
		var i:int = indexes.length;
		while (i--) {
			if (indexes[i] == index) {
				delete  functions[indexes[i]];
				runDelays.splice(i, 1);
				indexes.splice(i, 1);
				break;
			}
		}
	}

	private static var instance:FTimer = new FTimer();
	public static function addTask(testFunc:Function, delayFrames:uint):int {
		return instance.add(testFunc, delayFrames);
	}

	public static function removeTask(index:int):void {
		instance.remove(index);
	}

}
}
