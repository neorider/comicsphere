package me.evis.lab.imagestack.supportClasses
{
import mx.controls.Image;
import mx.core.IDataRenderer;
import mx.events.FlexEvent;

import spark.components.supportClasses.ItemRenderer;
import spark.filters.DropShadowFilter;
import spark.primitives.BitmapImage;

public class BitmapImageRenderer extends ItemRenderer
{
    private var bitmapImage:BitmapImage = new BitmapImage();
    
    public function BitmapImageRenderer()
    {
        super();
        bitmapImage.filters = [new DropShadowFilter(5.0, 90)];
        this.addElement(bitmapImage);
    }
    
    [Bindable("dataChange")]
    override public function get data():Object
    {
        return bitmapImage.source;
    }

    override public function set data(value:Object):void
    {
        bitmapImage.source = value;
        dispatchEvent(new FlexEvent(FlexEvent.DATA_CHANGE));
    }
}
}