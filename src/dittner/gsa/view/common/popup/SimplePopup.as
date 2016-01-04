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
		interactiveLayer = new UIComponent();
		interactiveLayer.visible = false;
		interactiveLayer.addEventListener(MouseEvent.MOUSE_DOWN, interactiveLayerMouseDownHandler);
	}

	//--------------------------------------------------------------------------
	//
	//  Variables
	//
	//--------------------------------------------------------------------------

	public static var modalWindowColor:uint = 0;
	public static var container:Group = new Group();
	public static var modalWindowAlpha:Number = 0.5;
	public static var isModal:Boolean = false;

	private static var content:IVisualElement;
	private static var closeCallbackFunc:Function = null;
	private static var interactiveLayer:UIComponent;

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
	public function get isModalWindowShown():Boolean {return isShown && isModal;}

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
		isModal = modal;

		interactiveLayer.graphics.clear();
		interactiveLayer.graphics.beginFill(modalWindowColor, modal ? modalWindowAlpha : 0);
		interactiveLayer.graphics.drawRect(0, 0, container.stage.width, container.stage.height);
		interactiveLayer.graphics.endFill();
		interactiveLayer.visible = true;
		if (!interactiveLayer.parent) {
			interactiveLayer.percentHeight = 100;
			interactiveLayer.percentWidth = 100;
			container.addElement(interactiveLayer);
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
			content = null;
			isModal = false;
			interactiveLayer.visible = false;
			if (closeCallbackFunc != null) closeCallbackFunc();
			closeCallbackFunc = null;
		}
	}

	private static var leftTopPos:Point = new Point(0, 0);
	private static function interactiveLayerMouseDownHandler(event:MouseEvent):void {
		var leftTop:Point = (content as DisplayObject).localToGlobal(leftTopPos);
		var rightBottom:Point = (content as DisplayObject).localToGlobal(new Point(content.width, content.height));
		if (event.stageX < leftTop.x || event.stageX > rightBottom.x || event.stageY < leftTop.y || event.stageY > rightBottom.y) {
			close();
			event.stopImmediatePropagation();
		}
	}
}
}