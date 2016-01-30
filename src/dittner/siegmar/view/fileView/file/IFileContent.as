package dittner.siegmar.view.fileView.file {
import dittner.siegmar.domain.fileSystem.file.SiegmarFile;
import dittner.siegmar.domain.fileSystem.body.links.BookLinksBody;
import dittner.siegmar.view.common.list.FileBodyList;

import mx.core.IUIComponent;

public interface IFileContent extends IUIComponent {
	function get file():SiegmarFile;
	function set file(value:SiegmarFile):void;
	function set bookLinksBody(value:BookLinksBody):void;

	function get fileBodyList():FileBodyList;
	function filterNotes(txt:String):void;

}
}
