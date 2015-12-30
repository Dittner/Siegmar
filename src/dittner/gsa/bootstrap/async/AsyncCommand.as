package dittner.gsa.bootstrap.async {
public class AsyncCommand extends AsyncOperation implements IAsyncCommand {
	public function AsyncCommand() {
		super();
	}

	public function execute():void {
		throw new Error("Функция должна быть переопределена");
	}

	override public function dispatchSuccess(result:* = null):void {
		_result = result;
		_isSuccess = true;
		completeExecute();
	}

	override public function dispatchError(error:* = null):void {
		_error = error;
		_isSuccess = false;
		completeExecute();
	}

}
}
