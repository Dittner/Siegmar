package dittner.siegmar.bootstrap.async {
public class CompositeCommand extends ProgressCommand {
	public function CompositeCommand() {
		super();
	}

	private var executing:Boolean = false;

	private var opClassInfoQueue:Vector.<ClassInfo> = new <ClassInfo>[];
	private var opProgressAfterCompleteQueue:Vector.<Number> = new <Number>[];
	private var curProgress:Number = 0;
	private var pendingProgress:Number = 0;

	public function addOperation(opClass:Class, ...args):void {
		if (executing) throw new Error("addOperation is disabled when CompositeOperation is executing!");

		opClassInfoQueue.push(new ClassInfo(opClass, args));
		opProgressAfterCompleteQueue.push(0);
	}

	public function addProgressOperation(opClass:Class, progressAfterComplete:Number, ...args):void {
		if (executing) throw new Error("addOperation is disabled when CompositeOperation is processing!");

		opClassInfoQueue.push(new ClassInfo(opClass, args));
		opProgressAfterCompleteQueue.push(progressAfterComplete);
	}

	override public function execute():void {
		if (executing) {
			throw new Error("CompositeOperation is processing and method 'process' has not been more than 1 time invoked!");
		}
		else {
			executing = true;
			executeNextOperation();
		}
	}

	override public function destroy():void {
		executing = false;
		opClassInfoQueue.length = 0;
		opProgressAfterCompleteQueue.length = 0;
		removeAllCallbacks();
	}

	internal function executeNextOperation(op:IAsyncOperation = null):void {
		curProgress = pendingProgress;
		setProgress(curProgress);

		if (!op || op.isSuccess) {
			if (opClassInfoQueue.length == 0) {
				dispatchSuccess(op ? op.result : null);
			}
			else {
				var info:ClassInfo = opClassInfoQueue.shift();
				var progressAfterComplete:Number = opProgressAfterCompleteQueue.shift();
				pendingProgress = progressAfterComplete > 0 ? progressAfterComplete : curProgress;

				var childOp:IAsyncOperation = ClassUtils.instantiate(info.clazz, info.args);
				childOp.addCompleteCallback(executeNextOperation);
				if (childOp is ProgressOperation)
					(childOp as ProgressOperation).addProgressCallback(curOpProgressCallback);
				else if (childOp is ProgressCommand)
					(childOp as ProgressCommand).addProgressCallback(curOpProgressCallback);
				if (childOp is IAsyncCommand) (childOp as IAsyncCommand).execute();
			}
		}
		else {
			dispatchError(op.error);
		}
	}

	protected function curOpProgressCallback(value:Number):void {
		setProgress(curProgress + (pendingProgress - curProgress) * value);
	}
}
}
class ClassInfo {
	public function ClassInfo(clazz:Class, args:Array) {
		this.clazz = clazz;
		this.args = args;
	}

	public var clazz:Class;
	public var args:Array;
}