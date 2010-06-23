package me.evis.lab.imagestack
{
import flash.events.Event;

import me.evis.lab.imagestack.supportClasses.BitmapImageRenderer;
import me.evis.lab.imagestack.supportClasses.HorizontalPagesLayout;

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
    //  page
    //----------------------------------
    
    private var _page:int = 1;
    
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
    
    private var _selectedIndex:int = 0;
    
    [Bindable("change")]
    public function get selectedIndex():int
    {
        return _selectedIndex;
    }
    public function set selectedIndex(value:int):void
    {
        if (_selectedIndex == value)
            return;
        
        var oldIndex:int = _selectedIndex;
        
        if (value < 0)
            _selectedIndex = 0;
        else if (value >= dataProvider.length)
            _selectedIndex = dataProvider.length - 1;
        else
            _selectedIndex = value;
        
        var changeEvent:IndexChangeEvent = new IndexChangeEvent(IndexChangeEvent.CHANGE);
        changeEvent.oldIndex = oldIndex;
        changeEvent.newIndex = _selectedIndex;
        dispatchEvent(changeEvent);
    }
}
}