package de.dittner.siegmar.view.fileList {
import de.dittner.async.IAsyncOperation;
import de.dittner.siegmar.backend.FileStorage;
import de.dittner.siegmar.domain.fileSystem.SiegmarFileSystem;
import de.dittner.siegmar.domain.fileSystem.file.FileType;
import de.dittner.siegmar.domain.fileSystem.header.FileHeader;
import de.dittner.siegmar.domain.user.User;
import de.dittner.siegmar.view.common.view.ViewID;
import de.dittner.siegmar.view.common.view.ViewModel;
import de.dittner.siegmar.view.common.view.ViewModelFactory;
import de.dittner.siegmar.view.common.view.ViewNavigator;
import de.dittner.siegmar.view.fileList.form.FileHeaderFormVM;
import de.dittner.siegmar.view.fileList.toolbar.ToolAction;
import de.dittner.walter.message.WalterMessage;

import flash.events.Event;

import mx.collections.ArrayCollection;

public class FileListVM extends ViewModel {
	public function FileListVM() {
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
	public var fileStorage:FileStorage;

	[Bindable]
	[Inject]
	public var user:User;

	[Bindable]
	[Inject]
	public var vmFactory:ViewModelFactory;

	[Bindable]
	public var headerFormVM:FileHeaderFormVM;

	//----------------------------------------------------------------------------------------------
	//
	//  Properties
	//
	//----------------------------------------------------------------------------------------------

	//--------------------------------------
	//  favoriteHeaderColl
	//--------------------------------------
	private var _favoriteHeaderColl:ArrayCollection;
	[Bindable("favoriteHeaderCollChanged")]
	public function get favoriteHeaderColl():ArrayCollection {return _favoriteHeaderColl;}
	public function set favoriteHeaderColl(value:ArrayCollection):void {
		if (_favoriteHeaderColl != value) {
			_favoriteHeaderColl = value;
			dispatchEvent(new Event("favoriteHeaderCollChanged"));
		}
	}

	override public function viewActivated():void {
		super.viewActivated();
		headerFormVM = vmFactory.fileHeaderFormVM;

		system.openFolder(system.openedFolderHeader ? system.openedFolderHeader : system.rootFolderHeader);
		listenProxy(fileStorage, FileStorage.FILE_REMOVED, fileRemoved);
		loadFavoriteFileHeaders();
	}

	private function fileRemoved(msg:WalterMessage):void {
		loadFavoriteFileHeaders();
	}

	private function loadFavoriteFileHeaders():void {
		var op:IAsyncOperation = fileStorage.loadFavoriteFileHeaders();
		op.addCompleteCallback(favoriteHeadersLoaded);
	}

	private function favoriteHeadersLoaded(op:IAsyncOperation):void {
		var favoriteHeaders:Array = op.isSuccess ? op.result as Array : [];
		favoriteHeaders.sortOn(["fileType", "title"], [Array.NUMERIC, Array.CASEINSENSITIVE]);
		favoriteHeaderColl = new ArrayCollection(favoriteHeaders);
	}

	public function openFile(fileHeader:FileHeader):void {
		if (!fileHeader) return;

		if (fileHeader.isFolder) {
			system.openFolder(fileHeader);
		}
		else {
			system.selectedFileHeader = fileHeader;
			var viewID:String = system.selectedFileHeader.fileType == FileType.PICTURE ? ViewID.PAINTING : ViewID.FILE_VIEW;
			viewNavigator.navigate(viewID);
		}
	}

	public function removeFileFromFavoriteList(fileHeader:FileHeader):void {
		if (fileHeader) {
			favoriteHeaderColl.removeItem(fileHeader);
			favoriteHeaderColl.refresh();
			fileHeader.isFavorite = false;
			fileHeader.store();
		}
	}

	public function handleToolbarAction(toolAction:String):void {
		switch (toolAction) {
			case ToolAction.CREATE:
				headerFormVM.add();
				break;
			case ToolAction.EDIT:
				headerFormVM.edit(system.selectedFileHeader);
				break;
			case ToolAction.REMOVE:
				headerFormVM.remove(system.selectedFileHeader);
				break;
			case ToolAction.ADD_TO_FAVORITE:
				addHeaderToFavorites(system.selectedFileHeader);
				break;
			case ToolAction.CLOSE:
				system.closeOpenedFile();
				viewNavigator.navigate(ViewID.FILE_LIST);
				break;
			case ToolAction.SETTINGS:
				system.closeOpenedFile();
				viewNavigator.navigate(ViewID.SETTINGS);
				break;
			case ToolAction.LOGOUT:
				system.logout();
				viewNavigator.navigate(ViewID.LOGIN);
				break;
		}
	}

	private function addHeaderToFavorites(header:FileHeader):void {
		header.isFavorite = true;
		header.store();

		if (header) {
			var hasSuchHeader:Boolean = false;
			for each(var h:FileHeader in favoriteHeaderColl)
				if (h.fileID == header.fileID) {
					hasSuchHeader = true;
					break;
				}
			if (header.isFavorite && !hasSuchHeader) {
				favoriteHeaderColl.addItem(header);
				favoriteHeaderColl.refresh();
			}
		}
	}

	public function openLinksFile():void {
		system.selectedFileHeader = system.bookLinksFileHeader;
		var viewID:String = ViewID.FILE_VIEW;
		viewNavigator.navigate(viewID);
	}

}
}