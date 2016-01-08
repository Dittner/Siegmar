package dittner.gsa.domain.fileSystem {
import dittner.gsa.domain.fileSystem.body.FileBody;
import dittner.gsa.domain.fileSystem.header.FileHeader;

public class GSAFile {
	public function GSAFile() {}

	public var header:FileHeader;
	public var body:FileBody;
	public var selectedNote:*;
}
}
