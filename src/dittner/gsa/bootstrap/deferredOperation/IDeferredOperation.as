package dittner.gsa.bootstrap.deferredOperation {
import dittner.gsa.bootstrap.async.IAsyncOperation;

public interface IDeferredOperation extends IAsyncOperation {
	function process():void;
}
}
