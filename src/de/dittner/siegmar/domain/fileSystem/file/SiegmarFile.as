package de.dittner.siegmar.domain.fileSystem.file {
import de.dittner.siegmar.domain.fileSystem.body.FileBody;
import de.dittner.siegmar.domain.fileSystem.header.FileHeader;

public class SiegmarFile {
	public function SiegmarFile() {}

	public var header:FileHeader;
	public var body:FileBody;
	public var selectedNote:*;
}
}
