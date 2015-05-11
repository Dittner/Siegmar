package dittner.gsa.domain.store {
import dittner.gsa.bootstrap.async.IAsyncOperation;
import dittner.walter.Walter;
import dittner.walter.walter_namespace;

use namespace walter_namespace;

public class StoreEntity implements IStoreEntity {
	public function StoreEntity() {
		Walter.instance.injector.inject(this);
	}

	[Inject]
	public var fileStorage:FileStorage;

	public function store():IAsyncOperation {
		return fileStorage.store(this);
	}

	public function remove():IAsyncOperation {
		return fileStorage.remove(this);
	}
}
}
