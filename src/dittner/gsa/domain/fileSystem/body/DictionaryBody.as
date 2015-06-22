package dittner.gsa.domain.fileSystem.body {
import flash.utils.ByteArray;

public class DictionaryBody extends FileBody {
	public function DictionaryBody() {}

	public var items:Array = [];

	override public function serialize():ByteArray {
		var byteArray:ByteArray = new ByteArray();
		byteArray.writeObject(items);
		byteArray.position = 0;
		return byteArray;
	}

	override public function deserialize(ba:ByteArray):void {
		items = ba.readObject() as Array || [];
	}
}
}
