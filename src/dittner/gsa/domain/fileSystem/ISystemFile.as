package dittner.gsa.domain.fileSystem {
import dittner.gsa.utils.async.IAsyncOperation;

public interface ISystemFile {

	function get id():int;
	function get parentID():int;
	function get fileType():uint;
	function get title():String;
	function get password():String;
	function get options():Object;
	function getHeaderInfo():Object;
	function setFromHeaderInfo(data:Object):void;
	function store():IAsyncOperation;
	function remove():IAsyncOperation;

}
}
