package dittner.siegmar.domain.fileSystem {
import dittner.async.AsyncOperation;
import dittner.async.IAsyncOperation;
import dittner.siegmar.domain.fileSystem.file.FileType;
import dittner.siegmar.domain.fileSystem.file.FileTypeName;
import dittner.siegmar.domain.fileSystem.header.FileHeader;

public class SiegmarFileSystemInitializeOp extends AsyncOperation {
	public function SiegmarFileSystemInitializeOp(system:SiegmarFileSystem) {
		super();
		this.system = system;
		execute();
	}

	private var system:SiegmarFileSystem;

	//----------------------------------------------------------------------------------------------
	//
	//  Properties
	//
	//----------------------------------------------------------------------------------------------

	//--------------------------------------
	//  bookLinksFileHeader
	//--------------------------------------
	private var _bookLinksFileHeader:FileHeader;
	public function get bookLinksFileHeader():FileHeader {return _bookLinksFileHeader;}

	//--------------------------------------
	//  settingsFileHeader
	//--------------------------------------
	private var _settingsFileHeader:FileHeader;
	public function get settingsFileHeader():FileHeader {return _settingsFileHeader;}

	//----------------------------------------------------------------------------------------------
	//
	//  Methods
	//
	//----------------------------------------------------------------------------------------------

	private function execute():void {
		openDataBase();
	}

	private function openDataBase():void {
		var op:IAsyncOperation = system.fileStorage.open(system.user.dataBasePwd);
		op.addCompleteCallback(dataBaseOpened);
	}

	private function dataBaseOpened(op:IAsyncOperation):void {
		if (op.isSuccess) loadBookLinksFileHeader();
		else dispatchError(op.error);
	}

	private function loadBookLinksFileHeader():void {
		var op:IAsyncOperation = system.fileStorage.loadFileHeadersByType(FileType.BOOK_LINKS);
		op.addCompleteCallback(function (op:IAsyncOperation):void {
			if (op.isSuccess && op.result && op.result.length > 0)
				_bookLinksFileHeader = op.result[0];
			else
				createBookLinksFileHeader();

			loadSettingsFileHeader();
		});
	}

	private function createBookLinksFileHeader():void {
		_bookLinksFileHeader = system.createFileHeader(FileType.BOOK_LINKS, true);
		_bookLinksFileHeader.title = FileTypeName.BOOK_LINK;
		_bookLinksFileHeader.store();
	}

	private function loadSettingsFileHeader():void {
		var op:IAsyncOperation = system.fileStorage.loadFileHeadersByType(FileType.SETTINGS);
		op.addCompleteCallback(function (op:IAsyncOperation):void {
			if (op.isSuccess && op.result && op.result.length > 0)
				_settingsFileHeader = op.result[0];
			else
				createSettingsFileHeader();

			dispatchSuccess();
		});
	}

	private function createSettingsFileHeader():void {
		_settingsFileHeader = system.createFileHeader(FileType.SETTINGS, true);
		_settingsFileHeader.title = FileTypeName.SETTINGS;
		_settingsFileHeader.store();
	}
}
}
