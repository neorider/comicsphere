package me.evis.lab.imagestack
{
import flash.events.Event;

import me.evis.lab.imagestack.supportClasses.BitmapImageRenderer;
import me.evis.lab.imagestack.supportClasses.HorizontalPagesLayout;
import me.evis.lab.imagestack.supportClasses.ImageArrayList;

import mx.collections.IList;
import mx.core.ClassFactory;
import mx.events.FlexEvent;

import spark.components.DataGroup;
import spark.events.IndexChangeEvent;

public class ImageStack extends DataGroup
{
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
    
    public function ImageStack()
    {
        super();
        
        this.layout = new HorizontalPagesLayout();
        //bitmapImage.properties = {source : data};
        this.itemRenderer = new ClassFactory(BitmapImageRenderer);
    }
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    override public function set dataProvider(value:IList):void
    {
        if (dataProvider)
        {
            dataProvider.removeEventListener(IndexChangeEvent.CHANGE, selectedIndexChangeHandler);
        }
        super.dataProvider = value;
        if (dataProvider)
        {
            dataProvider.addEventListener(IndexChangeEvent.CHANGE, selectedIndexChangeHandler);
            ImageArrayList(dataProvider).selectedIndex = 0;
        }
    }
    
    private function selectedIndexChangeHandler(event:IndexChangeEvent):void
    {
        this.dispatchEvent(event);
    }
    
    //--------------------------------------------------------------------------
    //
    //  Class methods
    //
    //--------------------------------------------------------------------------
    
//    override protected function commitProperties():void
//    {
//        this.removeAllElements();
//        
//        for each (var image:Object in _images)
//        {
//            image.filters = [new DropShadowFilter()];
//            this.addElement(IVisualElement(image));
//        }
//        
//        super.commitProperties();
//    }


    public function previous(event:Event = null):void
    {
        //			this.horizontalScrollPosition -= this.width;
//        Tweensy.to(this, {horizontalScrollPosition:horizontalScrollPosition - width});
        if (selectedIndex > 0)
            selectedIndex --;
    }
    
    public function next(event:Event = null):void
    {
        //            this.horizontalScrollPosition += this.width;
//        Tweensy.to(this, {horizontalScrollPosition:horizontalScrollPosition + width});
        if (selectedIndex < dataProvider.length - 1)
            selectedIndex ++;
    }
    
    
    
    //----------------------------------
    //  size [Readonly]
    //----------------------------------

    public function get size():int
    {
        if (dataProvider)
            return dataProvider.length;
        else
            return 0;
    }
    
    //----------------------------------
    //  page
    //----------------------------------
    
    [Bindable("change")]
    public function get page():int
    {
        return selectedIndex + 1;
    }
    
    public function set page(value:int):void
    {
        selectedIndex = value - 1;
    }
    
    //----------------------------------
    //  selectedIndex
    //----------------------------------
    
    [Bindable("change")]
    public function get selectedIndex():int
    {
        return ImageArrayList(dataProvider).selectedIndex;
    }
    public function set selectedIndex(value:int):void
    {
        ImageArrayList(dataProvider).selectedIndex = value;
    }
}
}