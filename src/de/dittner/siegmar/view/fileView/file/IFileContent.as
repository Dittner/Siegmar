package de.dittner.siegmar.view.fileView.file {
import de.dittner.siegmar.domain.fileSystem.file.SiegmarFile;
import de.dittner.siegmar.domain.fileSystem.body.links.BookLinksBody;
import de.dittner.siegmar.view.common.list.FileBodyList;

import mx.core.IUIComponent;

public interface IFileContent extends IUIComponent {
	function get file():SiegmarFile;
	function set file(value:SiegmarFile):void;

	function get fileBodyList():FileBodyList;
	function filterNotes(txt:String):void;

}
}
