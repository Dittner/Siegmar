package dittner.siegmar.backend.ftpClient {

import dittner.siegmar.backend.ftpClient.cmd.AuthFtpCommand;
import dittner.siegmar.backend.ftpClient.cmd.QuitFtpCommand;
import dittner.siegmar.backend.ftpClient.cmd.UploadFtpCommand;
import dittner.siegmar.bootstrap.async.CompositeCommand;
import dittner.siegmar.domain.fileSystem.body.settings.ServerInfo;

import flash.filesystem.File;
import flash.net.Socket;

public class FtpClient {

	public function FtpClient():void {
		cmdSocket = new Socket();
	}

	private var cmdSocket:Socket;

	//----------------------------------------------------------------------------------------------
	//
	//  Methods
	//
	//----------------------------------------------------------------------------------------------

	private var uploadOp:CompositeCommand;
	private var uploadCmdState:FtpCmdState;
	public function upload(file:File, serverInfo:ServerInfo):CompositeCommand {
		if (uploadOp && uploadOp.isProcessing) throw new Error("Upload is processing!");
		uploadCmdState = new FtpCmdState();
		uploadOp = new CompositeCommand();
		uploadOp.addProgressOperation(AuthFtpCommand, 0.05, cmdSocket, serverInfo, uploadCmdState);
		uploadOp.addProgressOperation(UploadFtpCommand, 0.99, file, cmdSocket, serverInfo, uploadCmdState);
		uploadOp.addProgressOperation(QuitFtpCommand, 1, cmdSocket, serverInfo, uploadCmdState);

		if (!file.exists)
			uploadOp.dispatchError("Uploading file does not exist!");
		else if (!serverInfo.host || !serverInfo.port || !serverInfo.user || !serverInfo.password)
			uploadOp.dispatchError("Server info is not fill!");
		else
			uploadOp.execute();

		return uploadOp;
	}

	public function close():void {
		if (uploadOp && uploadOp.isProcessing)
			uploadOp.dispatchError();
		if (uploadCmdState)
			uploadCmdState.isAborted = true;
		if (cmdSocket.connected)
			cmdSocket.close();
	}

}
}