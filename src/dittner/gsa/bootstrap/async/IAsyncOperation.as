package dittner.gsa.bootstrap.async {
public interface IAsyncOperation {
	function addCompleteCallback(handler:Function):void;
	function dispatchSuccess(result:* = null):void;
	function dispatchError(error:* = null):void;
	function destroy():void;

	function get isSuccess():Boolean;
	function get isTimeout():Boolean;
	function get error():*;
	function get result():*;
	function get uid():Number;

	function get timeoutInSec():Number;
	function set timeoutInSec(value:Number):void;
}
}
