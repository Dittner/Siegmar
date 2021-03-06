package de.dittner.siegmar.view.common.input {
import flash.events.Event;
import flash.events.EventDispatcher;

public class TextHistory extends EventDispatcher {
	public static const DEFAULT_CAPACITY:int = 50;

	public function TextHistory() {}

	//----------------------------------------------------------------------------------------------
	//
	//  Variables
	//
	//----------------------------------------------------------------------------------------------

	private var textRows:Array = [];

	//----------------------------------------------------------------------------------------------
	//
	//  Properties
	//
	//----------------------------------------------------------------------------------------------

	//--------------------------------------
	//  capacity
	//--------------------------------------
	protected var _capacity:int = DEFAULT_CAPACITY;
	[Bindable("capacityChanged")]
	public function get capacity():int {
		return _capacity;
	}
	public function set capacity(value:int):void {
		if (_capacity != value) {
			_capacity = value;
			dispatchEvent(new Event("capacityChanged"));
			normalizeQueue();
		}
	}

	//--------------------------------------
	//  rollbackDepth
	//--------------------------------------
	private var _rollbackDepth:int = 0;
	[Bindable("rollbackDepthChanged")]
	public function get rollbackDepth():int {
		return _rollbackDepth;
	}

	protected function setRollbackDepth(value:int):void {
		if (rollbackDepth != value) {
			_rollbackDepth = value;
			dispatchEvent(new Event("rollbackDepthChanged"));
		}
	}

	//--------------------------------------
	//  currentLength
	//--------------------------------------
	[Bindable("changed")]
	public function get currentLength():int {
		return textRows.length;
	}

	[Bindable("changed")]
	public function get canRedo():Boolean {
		return rollbackDepth > 0;
	}

	[Bindable("changed")]
	public function get canUndo():Boolean {
		return rollbackDepth < currentLength - 1;
	}

	[Bindable("changed")]
	public function get row():String {
		return textRows.length > 0 ? textRows[textRows.length - 1 - rollbackDepth] : "";
	}

	//----------------------------------------------------------------------------------------------
	//
	//  Methods
	//
	//----------------------------------------------------------------------------------------------
	public function undo():void {
		if (canUndo) {
			setRollbackDepth(rollbackDepth + 1);
			dispatchEvent(new Event("changed"));
		}
	}

	public function redo():void {
		if (canRedo) {
			setRollbackDepth(rollbackDepth - 1);
			dispatchEvent(new Event("changed"));
		}
	}

	public function push(row:String):void {
		if (this.row == row) return;
		textRows.length = textRows.length - rollbackDepth;
		textRows.push(row);
		setRollbackDepth(0);
		normalizeQueue();
		dispatchEvent(new Event("changed"));
	}

	public function clear():void {
		setRollbackDepth(0);
		textRows.length = 0;
		dispatchEvent(new Event("changed"));
	}

	protected function normalizeQueue():void {
		if (rollbackDepth > textRows.length) setRollbackDepth(textRows.length);
	}

}
}
