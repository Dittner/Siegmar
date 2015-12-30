package dittner.gsa.bootstrap.async {
public class CompositeOperation extends AsyncOperation implements IAsyncCommand {
	public function CompositeOperation() {
		super();
	}

	protected var executing:Boolean = false;

	protected var opClassInfoQueue:Vector.<ClassInfo> = new <ClassInfo>[];

	public function addOperation(opClass:Class, ...args):void {
		if (executing) throw new Error("addOperation is disabled when CompositeOperation is executing!");
		else opClassInfoQueue.push(new ClassInfo(opClass, args));
	}

	public function execute():void {
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
		removeAllCallbacks();
	}

	internal function executeNextOperation(op:IAsyncOperation = null):void {
		if (!op || op.isSuccess) {
			if (opClassInfoQueue.length == 0) {
				dispatchSuccess(op ? op.result : null);
			}
			else {
				var info:ClassInfo = opClassInfoQueue.shift();
				var childOp:IAsyncOperation = ClassUtils.instantiate(info.clazz, info.args);
				childOp.addCompleteCallback(executeNextOperation);
				if (childOp is IAsyncCommand) (childOp as IAsyncCommand).execute();
			}
		}
		else {
			dispatchError(op.error);
		}
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