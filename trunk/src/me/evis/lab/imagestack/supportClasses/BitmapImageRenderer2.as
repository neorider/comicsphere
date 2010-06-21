package me.evis.lab.imagestack.supportClasses
{
import mx.controls.Image;
import mx.core.IDataRenderer;
import mx.events.FlexEvent;

import spark.primitives.BitmapImage;

public class BitmapImageRenderer extends Image
{
    public function BitmapImageRenderer()
    {
        super();
    }
    
    [Bindable("dataChange")]
    override public function get data():Object
    {
        return this.source;
    }

    override public function set data(value:Object):void
    {
        this.source = value;
        dispatchEvent(new FlexEvent(FlexEvent.DATA_CHANGE));
    }
}
}