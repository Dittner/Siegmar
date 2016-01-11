package dittner.gsa.view.fileView.file {
import dittner.gsa.domain.fileSystem.GSAFile;
import dittner.gsa.domain.fileSystem.body.links.BookLinksBody;
import dittner.gsa.view.common.list.FileBodyList;

import mx.core.IUIComponent;

public interface IFileContent extends IUIComponent {
	function get file():GSAFile;
	function set file(value:GSAFile):void;
	function set bookLinksBody(value:BookLinksBody):void;

	function get fileBodyList():FileBodyList;

}
}
