package dittner.siegmar.backend.ftpClient {
public class FtpCmdState {
	public function FtpCmdState() {}

	public var isConnectionClosed:Boolean = false;
	public var isAborted:Boolean = false;
	public var isAuthenticated:Boolean = false;
	public var isUploadComplete:Boolean = false;
}
}
