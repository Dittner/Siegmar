package de.dittner.siegmar.view.common.view {
import de.dittner.async.utils.doLaterInFrames;
import de.dittner.siegmar.logging.CLog;
import de.dittner.siegmar.logging.LogCategory;

import flash.events.Event;
import flash.utils.getQualifiedClassName;

import mx.core.mx_internal;
import mx.events.FlexEvent;

import spark.components.SkinnableContainer;

use namespace mx_internal;

public class ViewBase extends SkinnableContainer {

	//----------------------------------------------------------------------------------------------
	//
	//  Constructor
	//
	//----------------------------------------------------------------------------------------------

	public function ViewBase() {
		super();
		fullName = getQualifiedClassName(this);
		addEventListener(FlexEvent.CREATION_COMPLETE, creationCompleteHandler);
	}

	//----------------------------------------------------------------------------------------------
	//
	//  Variables
	//
	//----------------------------------------------------------------------------------------------

	protected var fullName:String;
	protected var isActivateWaiting:Boolean = false;

	public var data:Object;

	//--------------------------------------
	//  viewID
	//--------------------------------------
	private var _viewID:String = "";
	[Bindable("viewIDChanged")]
	public function get viewID():String {return _viewID;}
	public function set viewID(value:String):void {
		if (_viewID != value) {
			_viewID = value;
			dispatchEvent(new Event("viewIDChanged"));
		}
	}

	//----------------------------------------------------------------------------------------------
	//
	//  Properties
	//
	//----------------------------------------------------------------------------------------------

	private var _isActive:Boolean = false;
	[Bindable("isActiveChange")]
	public function get isActive():Boolean {return _isActive;}

	//----------------------------------------------------------------------------------------------
	//
	//  Methods
	//
	//----------------------------------------------------------------------------------------------

	/*
	 *  Life cycle abstract methods
	 * */
	protected function activating():void {}
	protected function activate():void {}
	protected function deactivate():void {}
	protected function destroy():void {}

	/*
	 * invoke by navigator
	 * */

	internal function invalidate(navigationPhase:String):void {
		switch (navigationPhase) {
			case NavigationPhase.VIEW_ACTIVATE:
				activating();
				isActivateWaiting = true;
				if (initialized)
					doLaterInFrames(startActivation, 20);
				break;
			case NavigationPhase.VIEW_REMOVE:
				_isActive = false;
				isActivateWaiting = false;
				CLog.info(LogCategory.UI, "View: " + fullName + " is deactivated");
				dispatchEvent(new Event("isActiveChange"));
				deactivate();
				break;
		}
	}

	protected function creationCompleteHandler(event:FlexEvent):void {
		if (isActivateWaiting) startActivation();
	}

	private function startActivation():void {
		if (isActivateWaiting) {
			isActivateWaiting = false;
			_isActive = true;
			CLog.info(LogCategory.UI, "View: " + fullName + " is activated");
			dispatchEvent(new Event("isActiveChange"));
			activate();
		}
	}

}
}
