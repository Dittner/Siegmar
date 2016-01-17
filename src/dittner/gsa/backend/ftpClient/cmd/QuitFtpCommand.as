package dittner.gsa.backend.ftpClient.cmd {
import dittner.gsa.backend.ftpClient.FtpCmdState;
import dittner.gsa.domain.fileSystem.body.settings.ServerInfo;

import flash.net.Socket;

public class QuitFtpCommand extends FtpCommand {
	public function QuitFtpCommand(cmdSocket:Socket, serverInfo:ServerInfo, state:FtpCmdState) {
		super(cmdSocket, serverInfo, state);
	}

	override public function execute():void {
		cmdSocket.close();
		setProgress(1);
		dispatchSuccess();
	}

	override protected function cmdFromServer(cmdNum:uint, cmd:String):void {
		switch (cmdNum) {
			default :
				if (cmdNum >= 500) dispatchError("Auth with error: " + cmdNum);
				else dispatchError("Unhandled cmd from server: " + cmdNum);
		}
	}
}
}
