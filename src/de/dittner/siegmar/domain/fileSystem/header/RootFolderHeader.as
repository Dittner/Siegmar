package de.dittner.siegmar.domain.fileSystem.header {
import de.dittner.async.AsyncOperation;
import de.dittner.async.IAsyncOperation;

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
