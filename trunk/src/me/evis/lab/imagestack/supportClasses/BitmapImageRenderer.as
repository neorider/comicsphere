package me.evis.lab.imagestack.supportClasses
{
import flash.events.Event;

import mx.controls.ProgressBar;
import mx.controls.ProgressBarMode;
import mx.events.FlexEvent;

import spark.components.supportClasses.ItemRenderer;
import spark.filters.DropShadowFilter;
import spark.primitives.BitmapImage;

[Event(name="dataChange", type="mx.events.FlexEvent")]

public class BitmapImageRenderer extends ItemRenderer
{
    private var bitmapImage:BitmapImage = new BitmapImage();
    private var loadProgressBar:ProgressBar = new ProgressBar();
    
    public function BitmapImageRenderer()
    {
        super();
//        this.percentWidth = 100;
//        this.percentHeight = 100;
        this.autoDrawBackground = false;
        
        bitmapImage.filters = [new DropShadowFilter(5.0, 90)];
        bitmapImage.horizontalCenter = 0;
        bitmapImage.verticalCenter = 0;
        this.addElement(bitmapImage);
        
        loadProgressBar.mode = ProgressBarMode.POLLED;
        loadProgressBar.width = 160;
        loadProgressBar.horizontalCenter = 0;
        loadProgressBar.verticalCenter = 0;
        loadProgressBar.visible = true;
        loadProgressBar.addEventListener(Event.COMPLETE, function(event:Event):void {
            loadProgressBar.visible = false;
        });
        this.addElement(loadProgressBar);
    }
    
    [Bindable("dataChange")]
    override public function set data(value:Object):void
    {
        loadProgressBar.source = data;
        bitmapImage.source = ImageBuffer(value).bitmapData;
        super.data = value;
    }
    
    override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
    {
        super.updateDisplayList(unscaledWidth, unscaledHeight);
        
        if (unscaledWidth > 0 && unscaledHeight > 0
            && (bitmapImage.width > unscaledWidth || bitmapImage.height > unscaledHeight))
        {
            var scaleRate:Number = 
                Math.min(unscaledWidth / bitmapImage.width, unscaledHeight / bitmapImage.height);
            bitmapImage.scaleX = scaleRate;
            bitmapImage.scaleY = scaleRate;
            bitmapImage.scaleZ = scaleRate;
//            Tweensy.to(bitmapImage, {scaleX:scaleRate, scaleY:scaleRate, scaleZ:scaleRate});
        }
    }
}
}