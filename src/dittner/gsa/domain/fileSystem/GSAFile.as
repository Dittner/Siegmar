package dittner.gsa.domain.fileSystem {
import dittner.gsa.domain.fileSystem.body.GSAFileBody;
import dittner.gsa.domain.store.StoreEntity;

public class GSAFile extends StoreEntity implements IGSAFile {
	public function GSAFile() {
		super();
	}

	public function get isFolder():Boolean {return header && header.fileType == FileType.FOLDER;}

	//--------------------------------------
	//  header
	//--------------------------------------
	private var _header:GSAFileHeader;
	public function get header():GSAFileHeader {return _header;}
	public function set header(value:GSAFileHeader):void {
		if (_header != value) {
			_header = value;
		}
	}

	//--------------------------------------
	//  body
	//--------------------------------------
	private var _body:GSAFileBody;
	public function get body():GSAFileBody {return _body;}
	public function set body(value:GSAFileBody):void {
		if (_body != value) {
			_body = value;
		}
	}
}
}
