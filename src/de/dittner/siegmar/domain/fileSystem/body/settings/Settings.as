package de.dittner.siegmar.domain.fileSystem.body.settings {
import dittner.ftpClient.utils.ServerInfo;

[RemoteClass(alias="dittner.siegmar.domain.fileSystem.body.settings.Settings")]
public class Settings {
	public function Settings() {}

	public var serverInfo:ServerInfo = new ServerInfo();
}
}
