package dittner.gsa.utils.async {
public class AsyncOperationResult {
	public function AsyncOperationResult(data:Object = null, isSuccess:Boolean = true) {
		this.data = data;
		this.isSuccess = isSuccess;
	}

	public var data:Object;
	public var isSuccess:Boolean;

}
}
