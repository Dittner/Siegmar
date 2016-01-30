package dittner.siegmar.domain.fileSystem.file {
import dittner.siegmar.domain.fileSystem.body.FileBody;
import dittner.siegmar.domain.fileSystem.header.FileHeader;

public class SiegmarFile {
	public function SiegmarFile() {}

	public var header:FileHeader;
	public var body:FileBody;
	public var selectedNote:*;
}
}
