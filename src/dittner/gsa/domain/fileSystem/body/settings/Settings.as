package dittner.gsa.domain.fileSystem.body.settings {
import dittner.gsa.domain.fileSystem.body.settings.ServerInfo;

[RemoteClass(alias="dittner.gsa.domain.fileSystem.body.settings.Settings")]
public class Settings {
	public function Settings() {}

	public var serverInfo:ServerInfo = new ServerInfo();
}
}
