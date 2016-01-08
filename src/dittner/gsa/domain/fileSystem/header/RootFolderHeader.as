package dittner.gsa.domain.fileSystem.header {
import dittner.gsa.bootstrap.async.AsyncOperation;
import dittner.gsa.bootstrap.async.IAsyncOperation;

public class RootFolderHeader extends FileHeader {
	public function RootFolderHeader() {
		super();
		title = "..."
	}

	override public function store():IAsyncOperation {
		var op:IAsyncOperation = new AsyncOperation();
		op.dispatchSuccess();
		return op;
	}

	override public function remove():IAsyncOperation {
		var op:IAsyncOperation = new AsyncOperation();
		op.dispatchError("It's impossible to remove the root folder!");
		return op;
	}
}
}
