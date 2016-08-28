package de.dittner.siegmar.view.fileView {
import de.dittner.async.IAsyncOperation;
import de.dittner.siegmar.model.domain.fileSystem.SiegmarFileSystem;
import de.dittner.siegmar.model.domain.fileSystem.body.links.BookLinksBody;
import de.dittner.siegmar.model.domain.fileSystem.file.SiegmarFile;
import de.dittner.siegmar.model.domain.user.User;
import de.dittner.siegmar.view.common.view.ViewID;
import de.dittner.siegmar.view.common.view.ViewModel;
import de.dittner.siegmar.view.common.view.ViewNavigator;

import flash.events.Event;

public class FileViewVM extends ViewModel {
	public function FileViewVM() {
		super();
	}

	[Bindable]
	[Inject]
	public var system:SiegmarFileSystem;

	[Bindable]
	[Inject]
	public var viewNavigator:ViewNavigator;

	[Bindable]
	[Inject]
	public var user:User;

	//--------------------------------------
	//  bookLinksBody
	//--------------------------------------
	private var _bookLinksBody:BookLinksBody;
	[Bindable("bookLinksBodyChanged")]
	public function get bookLinksBody():BookLinksBody {return _bookLinksBody;}
	private function setBookLinksBody(value:BookLinksBody):void {
		if (_bookLinksBody != value) {
			_bookLinksBody = value;
			dispatchEvent(new Event("bookLinksBodyChanged"));
		}
	}

	//--------------------------------------
	//  openedFile
	//--------------------------------------
	private var _openedFile:SiegmarFile;
	[Bindable("openedFileChanged")]
	public function get openedFile():SiegmarFile {return _openedFile;}
	private function setOpenedFile(value:SiegmarFile):void {
		if (_openedFile != value) {
			_openedFile = value;
			dispatchEvent(new Event("openedFileChanged"));
		}
	}

	//----------------------------------------------------------------------------------------------
	//
	//  Methods
	//
	//----------------------------------------------------------------------------------------------

	override public function viewActivated():void {
		super.viewActivated();
		var op:IAsyncOperation = system.fileStorage.loadFileBody(system.bookLinksFileHeader);
		op.addCompleteCallback(linksLoaded);
	}

	private function linksLoaded(linksOp:IAsyncOperation):void {
		if (linksOp.isSuccess) setBookLinksBody(linksOp.result);
		var op:IAsyncOperation = system.openSelectedFile();
		op.addCompleteCallback(fileLoaded);
	}

	private function fileLoaded(op:IAsyncOperation):void {
		if (op.isSuccess) setOpenedFile(op.result);
		else setOpenedFile(null);
	}

	public function closeFile():void {
		system.closeOpenedFile();
		viewNavigator.navigate(ViewID.FILE_LIST);
	}

	public function logout():void {
		system.logout();
		viewNavigator.navigate(ViewID.LOGIN);
	}

}
}