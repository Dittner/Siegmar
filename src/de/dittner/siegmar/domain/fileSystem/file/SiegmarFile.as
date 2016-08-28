package de.dittner.siegmar.domain.fileSystem.file {
import de.dittner.siegmar.domain.fileSystem.body.FileBody;
import de.dittner.siegmar.domain.fileSystem.header.FileHeader;

import flash.events.EventDispatcher;

public class SiegmarFile extends EventDispatcher{
	public function SiegmarFile() {
		super();
	}

	[Bindable]
	public var header:FileHeader;
	[Bindable]
	public var body:FileBody;
	[Bindable]
	public var selectedNote:*;
}
}
