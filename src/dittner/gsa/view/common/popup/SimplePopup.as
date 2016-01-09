package dittner.gsa.view.common.popup {
import flash.display.DisplayObject;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.MouseEvent;
import flash.geom.Point;

import mx.core.IVisualElement;
import mx.core.UIComponent;

import spark.components.Group;

public class SimplePopup extends EventDispatcher {

	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------

	public function SimplePopup() {
		if (instance) throw Error('Singleton error in SimplePopup');
		modalWindowBg = new UIComponent();
		modalWindowBg.visible = false;
		modalWindowBg.addEventListener(MouseEvent.MOUSE_DOWN, function (event:Event):void {event.stopImmediatePropagation()});
	}

	//--------------------------------------------------------------------------
	//
	//  Variables
	//
	//--------------------------------------------------------------------------

	public static var modalWindowColor:uint = 0;
	public static var container:Group = new Group();
	public static var modalWindowAlpha:Number = 0.5;

	private static var content:IVisualElement;
	private static var closeCallbackFunc:Function = null;
	private static var modalWindowBg:UIComponent;

	//----------------------------------------------------------------------------------------------
	//
	//  Properties
	//
	//----------------------------------------------------------------------------------------------

	//--------------------------------------
	//  instance
	//--------------------------------------
	private static var _instance:SimplePopup = new SimplePopup();
	[Bindable("instanceChanged")]
	public static function get instance():SimplePopup {return _instance;}

	//--------------------------------------
	//  isShown
	//--------------------------------------
	private var _isShown:Boolean = false;
	[Bindable("isShownChanged")]
	public function get isShown():Boolean {return _isShown;}
	public function set isShown(value:Boolean):void {
		if (_isShown != value) {
			_isShown = value;
			dispatchEvent(new Event("isShownChanged"));
		}
	}

	//--------------------------------------
	//  isModalWindowShown
	//--------------------------------------
	[Bindable("isShownChanged")]
	public function get isModalWindowShown():Boolean {return isShown && modalWindowBg.visible;}

	//--------------------------------------
	//  content
	//--------------------------------------
	public static function get curContent():IVisualElement {
		return content;
	}

	//----------------------------------------------------------------------------------------------
	//
	//  Methods
	//
	//----------------------------------------------------------------------------------------------

	public static function show(element:IVisualElement, modal:Boolean = false, closeCallback:Function = null):void {
		if (instance.isShown) close();
		content = element;
		closeCallbackFunc = closeCallback;
		modalWindowBg.graphics.clear();
		if (modal) {
			modalWindowBg.graphics.beginFill(modalWindowColor, modalWindowAlpha);
			modalWindowBg.graphics.drawRect(0, 0, container.stage.width, container.stage.height);
			modalWindowBg.graphics.endFill();
			modalWindowBg.visible = true;
			if (!modalWindowBg.parent) {
				modalWindowBg.percentHeight = 100;
				modalWindowBg.percentWidth = 100;
				container.addElement(modalWindowBg);
			}
		}
		else {
			container.stage.addEventListener(MouseEvent.MOUSE_DOWN, container_mouseDownHandler, true);
		}
		container.addElement(content);
		instance.isShown = true;
	}

	public static function isShownInPopup(element:IVisualElement):Boolean {
		return (instance.isShown && content == element);
	}

	public static function close():void {
		if (instance.isShown) {
			instance.isShown = false;
			container.removeElement(content);
			container.stage.removeEventListener(MouseEvent.MOUSE_DOWN, container_mouseDownHandler, true);
			content = null;
			modalWindowBg.visible = false;
			if (closeCallbackFunc != null) closeCallbackFunc();
			closeCallbackFunc = null;
		}
	}

	private static var leftTopPos:Point = new Point(0, 0);
	private static function container_mouseDownHandler(event:MouseEvent):void {
		var leftTop:Point = (content as DisplayObject).localToGlobal(leftTopPos);
		var rightBottom:Point = (content as DisplayObject).localToGlobal(new Point(content.width, content.height));
		if (event.stageX < leftTop.x || event.stageX > rightBottom.x || event.stageY < leftTop.y || event.stageY > rightBottom.y) {
			close();
			event.stopImmediatePropagation();
		}

	}
}
}