package de.dittner.siegmar.view.common.progressBar {
import de.dittner.siegmar.view.common.utils.FontName;
import de.dittner.siegmar.view.common.utils.TextFieldFactory;

import flash.display.Graphics;
import flash.text.TextField;
import flash.text.TextFormat;

import flashx.textLayout.formats.TextAlign;

import mx.core.UIComponent;

public class ProgressBar extends UIComponent {
	private static const TITTLE_FORMAT:TextFormat = new TextFormat(FontName.MYRIAD_MX, 16, 0xffFFff);
	private static const PROGRESS_FORMAT:TextFormat = new TextFormat(FontName.MYRIAD_MX, 16, 0xffFFff);
	private static const VGAP:uint = 10;
	private static const BAR_HEI:uint = 10;

	public function ProgressBar() {
		super();
		PROGRESS_FORMAT.align = TextAlign.CENTER;
		TITTLE_FORMAT.align = TextAlign.CENTER;
	}

	private var progressTF:TextField;
	private var titleTF:TextField;

	//--------------------------------------
	//  title
	//--------------------------------------
	private var _title:String = "";
	public function get title():String {return _title;}
	public function set title(value:String):void {
		if (_title != value) {
			_title = value;
			invalidateDisplayList();
		}
	}

	//--------------------------------------
	//  progress
	//--------------------------------------
	private var _progress:Number = 0;
	[Bindable("progressChanged")]
	public function get progress():Number {return _progress;}
	public function set progress(value:Number):void {
		if (progress < 0) progress = 0;
		else if (progress > 1) progress = 1;
		if (_progress != value) {
			_progress = value;
			invalidateDisplayList();
		}
	}

	override protected function createChildren():void {
		super.createChildren();
		progressTF = TextFieldFactory.create(PROGRESS_FORMAT, false);
		progressTF.text = "0%";
		addChild(progressTF);

		titleTF = TextFieldFactory.create(TITTLE_FORMAT, false);
		addChild(titleTF);
	}

	override protected function measure():void {
		measuredWidth = 100;
		measuredHeight = 2 * (progressTF.textHeight + VGAP) + BAR_HEI;
	}

	override protected function updateDisplayList(w:Number, h:Number):void {
		super.updateDisplayList(w, h);
		var g:Graphics = graphics;
		g.clear();

		titleTF.text = title;
		titleTF.width = w;

		g.lineStyle(1, 0xffFFff);
		g.drawRoundRect(0, titleTF.textHeight + VGAP, w, BAR_HEI, BAR_HEI, BAR_HEI);

		if (w * progress > BAR_HEI) {
			g.beginFill(0xffFFff);
			g.drawRoundRect(0, titleTF.textHeight + VGAP, w * progress, BAR_HEI, BAR_HEI, BAR_HEI);
			g.endFill();
		}

		progressTF.text = Math.round(progress * 100) + "%";
		progressTF.width = w;
		progressTF.y = h - progressTF.textHeight;
	}

}
}
