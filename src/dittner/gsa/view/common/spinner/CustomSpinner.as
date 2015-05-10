package dittner.gsa.view.common.spinner {

import flash.events.Event;

import mx.events.FlexEvent;

import spark.components.Button;
import spark.components.SkinnableContainer;

[Event(name="change", type="flash.events.Event")]

public class CustomSpinner extends SkinnableContainer {

	public function CustomSpinner():void {
		super();
	}

	[SkinPart(required="false")]
	public var decrementButton:Button;

	[SkinPart(required="false")]
	public var incrementButton:Button;

	//--------------------------------------------------------------------------
	//
	// Properties
	//
	//--------------------------------------------------------------------------

	//----------------------------------
	//  minimum
	//----------------------------------
	private var _minimum:Number = 0;
	public function get minimum():Number {return _minimum;}
	public function set minimum(value:Number):void {
		if (_minimum != value) {
			_minimum = value;
			invalidateProperties();
		}

		if (_minimum > _maximum) _maximum = _minimum;
	}

	//----------------------------------
	//  maximum
	//----------------------------------
	private var _maximum:Number = 10;
	public function get maximum():Number {return _maximum;}
	public function set maximum(value:Number):void {
		if (_maximum != value) {
			_maximum = value;
		}
	}

	//----------------------------------
	//  precision
	//----------------------------------
	private var _precision:uint = 0;
	public function set precision(value:uint):void {
		_precision = value;
	}
	[Bindable]
	public function get precision():uint {
		return _precision;
	}

	//----------------------------------
	//  value
	//----------------------------------
	private var valueChanged:Boolean = false;
	[Bindable('change')]
	public function get value():Number {
		var prec:Number = Math.pow(10, precision);
		return Math.round(_value * prec) / prec;
	}
	private var _value:Number = 0;
	public function set value(newValue:Number):void {
		if (_value != newValue) {
			_value = newValue;
			valueChanged = true;
			invalidateProperties();
		}
	}

	//----------------------------------
	//  step
	//----------------------------------
	private var _step:Number = 1.0;
	public function set step(value:Number):void {
		if (value <= 0) return;
		if (value < 1) {
			var v:Number = value;
			var numDigitsAfterDot:uint = 0;
			while (Math.floor(v) <= 1) {
				numDigitsAfterDot++;
				v *= 10;
			}
			precision = numDigitsAfterDot;
		}
		_step = value;
	}
	public function get step():Number {
		return _step;
	}

	override protected function commitProperties():void {
		super.commitProperties();
		if (minimum > maximum) _minimum = maximum;
		if (value < minimum) {
			_value = minimum;
			valueChanged = true;
		}
		if (value > maximum) {
			_value = maximum;
			valueChanged = true;
		}
		if (valueChanged) {
			valueChanged = false;
			dispatchEvent(new Event('change'));
		}
	}

	override protected function partAdded(partName:String, instance:Object):void {
		super.partAdded(partName, instance);

		if (instance == incrementButton) {
			incrementButton.focusEnabled = false;
			incrementButton.addEventListener(FlexEvent.BUTTON_DOWN, incrementButton_buttonDownHandler);
			incrementButton.autoRepeat = true;
		}
		else if (instance == decrementButton) {
			decrementButton.focusEnabled = false;
			decrementButton.addEventListener(FlexEvent.BUTTON_DOWN, decrementButton_buttonDownHandler);
			decrementButton.autoRepeat = true;
		}
	}

	override protected function partRemoved(partName:String, instance:Object):void {
		super.partRemoved(partName, instance);

		if (instance == incrementButton) {
			incrementButton.removeEventListener(FlexEvent.BUTTON_DOWN, incrementButton_buttonDownHandler);
		}
		else if (instance == decrementButton) {
			decrementButton.removeEventListener(FlexEvent.BUTTON_DOWN, decrementButton_buttonDownHandler);
		}
	}

	override protected function getCurrentSkinState():String {
		return enabled ? "normal" : "disabled";
	}

	protected function incrementButton_buttonDownHandler(event:Event):void {
		value += step;
	}

	protected function decrementButton_buttonDownHandler(event:Event):void {
		value -= step;
	}

}

}
