package dittner.siegmar.domain.fileSystem.body.settings {
[RemoteClass(alias="dittner.siegmar.domain.fileSystem.body.settings.ServerInfo")]

public class ServerInfo {
	public function ServerInfo() {}

	public var host:String = "server.de";
	public var port:int = 21;
	public var user:String = "";
	public var password:String = "";
	public var remoteDirPath:String = "server.de/public_html/Siegmar";
}
}
