package dittner.gsa.domain.fileSystem {
import dittner.gsa.domain.fileSystem.body.DocBody;

internal class Document extends SystemFile implements IDocument {
	public function Document() {
	}

	//--------------------------------------
	//  body
	//--------------------------------------
	private var _body:DocBody;
	public function get body():DocBody {return _body;}
	public function set body(value:DocBody):void {
		if (_body != value) {
			_body = value;
		}
	}

}
}
