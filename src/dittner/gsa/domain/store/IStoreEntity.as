package dittner.gsa.domain.store {
import dittner.gsa.bootstrap.async.IAsyncOperation;

public interface IStoreEntity {
	function store():IAsyncOperation;
	function remove():IAsyncOperation;

}
}
