package dittner.gsa.domain.fileSystem {
import dittner.gsa.utils.async.AsyncOperation;
import dittner.gsa.utils.async.AsyncOperationResult;
import dittner.gsa.utils.async.IAsyncOperation;

public class RootFolder extends Folder {
	public function RootFolder() {
		super();
	}

	override public function store():IAsyncOperation {
		var op:IAsyncOperation = new AsyncOperation();
		op.dispatchComplete();
		return op;
	}

	override public function remove():IAsyncOperation {
		var op:IAsyncOperation = new AsyncOperation();
		op.dispatchComplete(new AsyncOperationResult("It's impossible to remove the root folder!", false));
		return op;
	}
}
}
