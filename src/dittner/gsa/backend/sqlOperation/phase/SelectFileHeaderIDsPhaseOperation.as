package dittner.gsa.backend.sqlOperation.phase {
import dittner.gsa.backend.phaseOperation.PhaseOperation;
import dittner.gsa.backend.sqlOperation.FileSQLWrapper;
import dittner.gsa.domain.fileSystem.FileType;

import flash.data.SQLResult;

public class SelectFileHeaderIDsPhaseOperation extends PhaseOperation {

	public function SelectFileHeaderIDsPhaseOperation(fileWrapper:FileSQLWrapper) {
		this.headerWrapper = fileWrapper;
	}

	private var headerWrapper:FileSQLWrapper;

	override public function execute():void {
		headerWrapper.removingFileIDs.push(headerWrapper.header.fileID);

		if (headerWrapper.header.isFolder) {
			headerWrapper.sqlRunner.execute(headerWrapper.sqlFactory.selectAllFileHeaders, null, loadCompleteHandler);
		}
		else {
			dispatchComplete();
		}
	}

	private function loadCompleteHandler(result:SQLResult):void {
		fileHeaders = result.data;
		addChildrenFrom(headerWrapper.header.fileID);
		dispatchComplete();
	}

	private var fileHeaders:Array;
	private function addChildrenFrom(parentID:int):void {
		for each(var header:Object in fileHeaders)
			if (header.parentID == parentID) {
				headerWrapper.removingFileIDs.push(header.fileID);
				if(header.fileType == FileType.FOLDER) addChildrenFrom(header.fileID);
			}
	}

	override public function destroy():void {
		super.destroy();
		headerWrapper = null;
	}
}
}
