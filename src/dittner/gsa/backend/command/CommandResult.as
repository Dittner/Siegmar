package dittner.gsa.backend.command {
public class CommandResult {
	public function CommandResult(data:Object = null, details:String = "", isSuccess:Boolean = true) {
		this.data = data || {};
		this.details = details;
		this.isSuccess = isSuccess;
	}

	public static const OK:CommandResult = new CommandResult(null, "OK");

	public var data:Object;
	public var details:String = "";
	public var isSuccess:Boolean;
}
}
