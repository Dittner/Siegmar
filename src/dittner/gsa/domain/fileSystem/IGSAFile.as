package dittner.gsa.domain.fileSystem {
import dittner.gsa.domain.fileSystem.body.GSAFileBody;
import dittner.gsa.domain.store.IStoreEntity;

public interface IGSAFile extends IStoreEntity {
	function get header():GSAFileHeader;
	function get body():GSAFileBody;
	function get isFolder():Boolean;
}
}
