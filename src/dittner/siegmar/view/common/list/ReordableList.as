package dittner.siegmar.view.common.list {
import dittner.siegmar.utils.delay.doLaterInMSec;
import dittner.siegmar.view.common.utils.TapEventKit;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.BlendMode;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Point;

import mx.collections.ArrayCollection;
import mx.core.IUIComponent;
import mx.core.IVisualElement;

import spark.components.IItemRenderer;
import spark.events.RendererExistenceEvent;
import spark.layouts.VerticalLayout;
import spark.layouts.supportClasses.LayoutBase;

[Event(name="orderChanged", type="flash.events.Event")]

public class ReordableList extends SelectableDataGroup {

	public function ReordableList() {
		super();
		addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
	}

	protected function addedToStageHandler(event:Event):void {
		removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
		addEventListener(MouseEvent.RELEASE_OUTSIDE, outsideHandler);
		TapEventKit.registerLongTapListener(this, longTapPressed)
	}

	protected function outsideHandler(event:MouseEvent):void {
		destroyDragProxy();
	}

	protected function removedFromStageHandler(event:Event):void {
		addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		stage.removeEventListener(MouseEvent.MOUSE_UP, outsideHandler);
		removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
		TapEventKit.unregisterLongTapListener(this);
	}

	protected function longTapPressed():void {
		if (pressedRenderer) startItemDrag();
	}

	//----------------------------------------------------------------------------------------------
	//
	//  Variables
	//
	//----------------------------------------------------------------------------------------------

	private var pressedRenderer:IUIComponent;
	private var dragItemInfo:DragItemInfo = new DragItemInfo();
	private var dragProxyBitmap:Bitmap;

	//----------------------------------------------------------------------------------------------
	//
	//  Properties
	//
	//----------------------------------------------------------------------------------------------

	//--------------------------------------
	//  layout
	//--------------------------------------
	override public function set layout(value:LayoutBase):void {
		if (!(value is VerticalLayout)) throw new Error("I can work only with vertical layouts!");
		super.layout = value;
	}

	//--------------------------------------
	//  dragEnabled
	//--------------------------------------
	private var _dragEnabled:Boolean = true;
	[Bindable("dragEnabledChanged")]
	public function get dragEnabled():Boolean {return _dragEnabled;}
	public function set dragEnabled(value:Boolean):void {
		if (_dragEnabled != value) {
			_dragEnabled = value;
			if (!dragEnabled) destroyDragProxy();
			dispatchEvent(new Event("dragEnabledChanged"));
		}
	}

	//----------------------------------------------------------------------------------------------
	//
	//  Methods
	//
	//----------------------------------------------------------------------------------------------

	override protected function rendererAddHandler(event:RendererExistenceEvent):void {
		super.rendererAddHandler(event);
		var renderer:IVisualElement = event.renderer;
		renderer.addEventListener(MouseEvent.MOUSE_DOWN, renderer_mouseDownHandler, false, 0, true);
		renderer.addEventListener(MouseEvent.MOUSE_UP, renderer_upHandler, false, 0, true);
	}

	override protected function rendererRemoveHandler(event:RendererExistenceEvent):void {
		super.rendererRemoveHandler(event);
		var renderer:IVisualElement = event.renderer;
		renderer.removeEventListener(MouseEvent.MOUSE_DOWN, renderer_mouseDownHandler);
		renderer.removeEventListener(MouseEvent.MOUSE_UP, renderer_upHandler, false);
	}

	private function renderer_mouseDownHandler(event:MouseEvent):void {
		var ren:IUIComponent = event.currentTarget as IUIComponent;
		if (ren && dragEnabled) {
			pressedRenderer = ren;
		}
		else {
			pressedRenderer = null;
		}
	}

	private var mouseOffset:Number = 0;
	private function startItemDrag():void {
		if (pressedRenderer && dragEnabled) {
			dragItemInfo.isActive = true;
			dragItemInfo.data = (pressedRenderer as IItemRenderer).data;
			dragItemInfo.index = (pressedRenderer as IItemRenderer).itemIndex;
			dragItemInfo.srcItemInd = itemToSrcIndex((pressedRenderer as IItemRenderer).data);

			createDragProxy(pressedRenderer);
			var pos:Point = pressedRenderer.localToGlobal(new Point(0, 0));
			mouseOffset = pressedRenderer.mouseY;
			dragProxyBitmap.x = pos.x;
			dragProxyBitmap.y = stage.mouseY - mouseOffset;
			stage.addChild(dragProxyBitmap);
			pressedRenderer = null;

			for each(var renderer:* in renderers)
				if (renderer is IDraggable)(renderer as IDraggable).dragItemInfo = dragItemInfo;
		}
	}

	private function itemToSrcIndex(item:*):int {
		var src:Array = dataProvider is ArrayCollection ? (dataProvider as ArrayCollection).source : [];
		for (var i:int = 0; i < src.length; i++)
			if (item == src[i]) {
				return i;
			}
		return -1;
	}

	private function createDragProxy(renderer:IUIComponent):void {
		var dragImg:BitmapData = new BitmapData(renderer.width + 1, renderer.height + 1, false, 0);
		dragImg.draw(renderer, null, null, BlendMode.INVERT);
		dragProxyBitmap = new Bitmap(dragImg);
		dragProxyBitmap.alpha = .25;
		stage.addEventListener(MouseEvent.MOUSE_MOVE, stage_mouseMoveHandler);
	}

	private function stage_mouseMoveHandler(event:MouseEvent):void {
		if (dragProxyBitmap) {
			dragProxyBitmap.y = stage.mouseY - mouseOffset;
			event.preventDefault();
		}
	}

	private var droppedItemIndex:int;
	private function renderer_upHandler(event:MouseEvent):void {
		pressedRenderer = null;
		var renderer:IItemRenderer = event.currentTarget as IItemRenderer;
		var coll:ArrayCollection = dataProvider as ArrayCollection;
		if (coll && dragItemInfo.isActive && renderer && renderer.data != dragItemInfo.data) {
			var newIndex:int = itemToSrcIndex((renderer as IItemRenderer).data);
			var src:Array = coll.source;
			if(src[dragItemInfo.srcItemInd] == dragItemInfo.data) {
				src.splice(dragItemInfo.srcItemInd, 1);
				src.splice(newIndex, 0, dragItemInfo.data);
			}
			else throw new Error("Drag-n-drop is failed. Item's index matches wrong item's data");


			droppedItemIndex = (renderer as IItemRenderer).itemIndex;
			var filterFunc:Function = coll.filterFunction;
			coll = new ArrayCollection(src);
			coll.filterFunction = filterFunc;
			coll.refresh();
			dataProvider = coll;
			doLaterInMSec(scrollToDroppedItem, 500);

			dispatchEvent(new Event('orderChanged', true));
		}

		destroyDragProxy();
	}

	private function scrollToDroppedItem():void {
		if (droppedItemIndex >= 0) {
			var spDelta:Point = layout.getScrollPositionDeltaToElement(droppedItemIndex);
			if (spDelta) verticalScrollPosition += spDelta.y;
		}
	}

	private function destroyDragProxy():void {
		dragItemInfo.isActive = false;
		if (pressedRenderer) pressedRenderer = null;
		if (dragProxyBitmap) {
			if (stage) stage.removeChild(dragProxyBitmap);
			if (dragProxyBitmap.bitmapData) dragProxyBitmap.bitmapData.dispose();
			dragProxyBitmap = null;
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, stage_mouseMoveHandler);
			for each(var renderer:* in renderers)
				if (renderer is IDraggable)(renderer as IDraggable).dragItemInfo = null;
		}
	}

}
}