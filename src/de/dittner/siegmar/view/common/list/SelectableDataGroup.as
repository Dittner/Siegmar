package de.dittner.siegmar.view.common.list {
import flash.events.Event;
import flash.events.MouseEvent;

import mx.collections.ICollectionView;
import mx.collections.ListCollectionView;
import mx.core.IDataRenderer;
import mx.core.IVisualElement;

import spark.components.DataGroup;
import spark.components.IItemRenderer;
import spark.events.RendererExistenceEvent;

[Event(name="selectedItemChange", type="de.dittner.siegmar.view.common.list.SelectableDataGroupEvent")]
[Event(name="itemDoubleClicked", type="de.dittner.siegmar.view.common.list.SelectableDataGroupEvent")]
[Event(name="itemRemoved", type="de.dittner.siegmar.view.common.list.SelectableDataGroupEvent")]
public class SelectableDataGroup extends DataGroup {

	public function SelectableDataGroup() {
		super();
		doubleClickEnabled = true;
		addEventListener(RendererExistenceEvent.RENDERER_ADD, rendererAddHandler);
		addEventListener(RendererExistenceEvent.RENDERER_REMOVE, rendererRemoveHandler);
	}

	protected var renderers:Array = [];

	//--------------------------------------------------------------------------
	//
	//  Getter/setter
	//
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------------
	//  selectedIndex
	//--------------------------------------------------------------------------------
	[Bindable("selected")]
	public function get selectedIndex():int {
		if (!_selectedItem || !dataProvider) return -1;
		return dataProvider.getItemIndex(_selectedItem);
	}
	public function set selectedIndex(value:int):void {
		if (dataProvider) selectedItem = dataProvider.getItemAt(value);
	}

	//--------------------------------------------------------------------------------
	//  selectedItem
	//--------------------------------------------------------------------------------
	private var _selectedItem:*;
	[Bindable("selectedItemChange")]
	public function get selectedItem():* {return _selectedItem;}
	public function set selectedItem(value:*):void {
		if (value == _selectedItem) {
			if (allowSelectLastItem)
				dispatchEvent(new SelectableDataGroupEvent(SelectableDataGroupEvent.ITEM_SELECTED, selectedItem));
			return;
		}

		_selectedItem = value;
		var n:int = numElements;
		for (var i:int = 0; i < n; i++) {
			var renderer:IItemRenderer = getElementAt(i) as IItemRenderer;
			if (renderer) renderer.selected = (renderer.data == value);
		}
		dispatchEvent(new SelectableDataGroupEvent(SelectableDataGroupEvent.ITEM_SELECTED, selectedItem));
	}

	//--------------------------------------------------------------------------------
	//  allowSelectByClick
	//--------------------------------------------------------------------------------
	private var _allowSelectByClickChanged:Boolean = false;
	private var _haveRenderersClickListeners:Boolean = true;
	private var _allowSelectByClick:Boolean = true;
	[Bindable("allowSelectByClickChange")]
	public function get allowSelectByClick():Boolean {return _allowSelectByClick;}
	public function set allowSelectByClick(value:Boolean):void {
		if (value == _allowSelectByClick)return;
		_allowSelectByClick = value;
		_allowSelectByClickChanged = true;
		invalidateProperties();
	}

	//--------------------------------------------------------------------------------
	//  allowSelectLastItem
	//--------------------------------------------------------------------------------
	private var _allowSelectLastItem:Boolean = false;
	public function get allowSelectLastItem():Boolean {return _allowSelectLastItem;}
	public function set allowSelectLastItem(value:Boolean):void {
		_allowSelectLastItem = value;
	}

	//--------------------------------------
	//  deselectEnabled
	//--------------------------------------
	private var _deselectEnabled:Boolean = false;
	[Bindable("deselectEnabledChanged")]
	public function get deselectEnabled():Boolean {return _deselectEnabled;}
	public function set deselectEnabled(value:Boolean):void {
		if (_deselectEnabled != value) {
			_deselectEnabled = value;
			dispatchEvent(new Event("deselectEnabledChanged"));
		}
	}

	//--------------------------------------
	//  renderData
	//--------------------------------------
	private var _renderData:*;
	[Bindable("renderDataChanged")]
	public function get renderData():* {return _renderData;}
	public function set renderData(value:*):void {
		if (_renderData != value) {
			_renderData = value;
			dispatchEvent(new Event("renderDataChanged"));
		}
	}

	//--------------------------------------------------------------------------
	//
	//  Overriden
	//
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------------
	//  commitProperties
	//--------------------------------------------------------------------------------
	override protected function commitProperties():void {
		super.commitProperties();
		if (_allowSelectByClickChanged) {
			_allowSelectByClickChanged = false;
			if (allowSelectByClick) {
				addEventListener(RendererExistenceEvent.RENDERER_ADD, rendererAddHandler);
				if (!_haveRenderersClickListeners) addClickListeners();
				_haveRenderersClickListeners = true;
			}
			else {
				removeEventListener(RendererExistenceEvent.RENDERER_ADD, rendererAddHandler);
				if (_haveRenderersClickListeners) removeClickListeners();
				_haveRenderersClickListeners = false;
			}
		}
	}

	//--------------------------------------------------------------------------------
	//  updateRenderer
	//--------------------------------------------------------------------------------
	override public function updateRenderer(renderer:IVisualElement, itemIndex:int, data:Object):void {
		super.updateRenderer(renderer, itemIndex, data);
		if (!allowSelectLastItem && renderer is IItemRenderer)
			IItemRenderer(renderer).selected = (data == _selectedItem);
	}

	public function getSelectedRenderer():IItemRenderer {
		if (selectedItem) {
			for each(var renderer:IItemRenderer in renderers) {
				if (renderer.data == selectedItem) return renderer;
			}
		}
		return null;
	}

	public function refresh():void {
		if (dataProvider) {
			selectedItem = null;
			if (dataProvider is ICollectionView) (dataProvider as ICollectionView).refresh();
			for (var i:int = 0; i < numElements; i++) {
				var renderer:IItemRenderer = getElementAt(i) as IItemRenderer;
				if (renderer) {
					var renData:Object = renderer.data;
					renderer.data = null;
					renderer.data = renData;
				}
			}
		}
	}

	//--------------------------------------------------------------------------
	//
	//  Protected methods
	//
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------------
	//  addClickListeners
	//--------------------------------------------------------------------------------
	protected function addClickListeners():void {
		for (var i:int = 0; i < numElements; i++) {
			var renderer:IItemRenderer = getElementAt(i) as IItemRenderer;
			renderer.addEventListener(MouseEvent.CLICK, renderer_clickHandler);
			renderer.addEventListener(MouseEvent.DOUBLE_CLICK, renderer_double_clickHandler);
		}
	}

	//--------------------------------------------------------------------------------
	//  removeClickListeners
	//--------------------------------------------------------------------------------
	protected function removeClickListeners():void {
		for (var i:int = 0; i < numElements; i++) {
			var renderer:IItemRenderer = getElementAt(i) as IItemRenderer;
			renderer.removeEventListener(MouseEvent.CLICK, renderer_clickHandler);
			renderer.addEventListener(MouseEvent.DOUBLE_CLICK, renderer_double_clickHandler);
		}
	}

	//--------------------------------------------------------------------------
	//
	//  Handlers
	//
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------------
	//  rendererAddHandler
	//--------------------------------------------------------------------------------
	protected function rendererAddHandler(event:RendererExistenceEvent):void {
		renderers.push(event.renderer);
		event.renderer.addEventListener(MouseEvent.CLICK, renderer_clickHandler);
		event.renderer.addEventListener(MouseEvent.DOUBLE_CLICK, renderer_double_clickHandler);
	}

	//--------------------------------------------------------------------------------
	//  rendererRemoveHandler
	//--------------------------------------------------------------------------------
	protected function rendererRemoveHandler(event:RendererExistenceEvent):void {
		var ind:int = renderers.indexOf(event.renderer);
		if (ind != -1) renderers.splice(ind, 1);
		event.renderer.removeEventListener(MouseEvent.CLICK, renderer_clickHandler);
		if (dataProvider is ListCollectionView)(dataProvider as ListCollectionView).refresh();
	}

	//--------------------------------------------------------------------------------
	//  renderer_clickHandler
	//--------------------------------------------------------------------------------
	protected function renderer_clickHandler(event:MouseEvent):void {
		var dataRenderer:IDataRenderer = event.currentTarget as IDataRenderer;
		var selectedData:Object = dataRenderer ? dataRenderer.data : null;
		if (deselectEnabled && selectedData && selectedData == selectedItem) selectedItem = null;
		else selectedItem = selectedData;
	}

	//--------------------------------------------------------------------------------
	//  renderer_double_clickHandler
	//--------------------------------------------------------------------------------
	protected function renderer_double_clickHandler(event:MouseEvent):void {
		var dataRenderer:IDataRenderer = event.currentTarget as IDataRenderer;
		dispatchEvent(new SelectableDataGroupEvent(SelectableDataGroupEvent.ITEM_DOUBLE_CLICKED, dataRenderer.data));
	}
}
}