package me.evis.lab.imagestack.supportClasses
{
import flash.events.Event;

import mx.collections.ArrayList;

import spark.events.IndexChangeEvent;

public class ImageArrayList extends ArrayList implements IImageList
{
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
    
    public function ImageArrayList(source:Array=null)
    {
        super(source);
        preloadNext();
        this.addEventListener(Event.CHANGE, preloadNext);
    }
    
    //--------------------------------------------------------------------------
    //
    //  Implementation of ISelectableList
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  selectedIndex
    //----------------------------------
    
    private var _selectedIndex:int = -1;
    
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
            _selectedIndex = length - 1;
        else if (value >= length)
            _selectedIndex = 0;
        else
            _selectedIndex = value;
        
        var changeEvent:IndexChangeEvent = new IndexChangeEvent(IndexChangeEvent.CHANGE);
        changeEvent.oldIndex = oldIndex;
        changeEvent.newIndex = _selectedIndex;
        dispatchEvent(changeEvent);
    }
    
    //--------------------------------------------------------------------------
    //
    //  Implementation of IImageList
    //
    //--------------------------------------------------------------------------
    
    public function get first():ImageBuffer
    {
        selectedIndex = 0;
        return current;
    }
    
    public function get previous():ImageBuffer
    {
        selectedIndex--;
        return current;
    }
    
    public function get current():ImageBuffer
    {
        return ImageBuffer(getItemAt(selectedIndex));
    }
    
    public function get next():ImageBuffer
    {
        selectedIndex++;
        return current;
    }
    
    public function get last():ImageBuffer
    {
        selectedIndex = length - 1;
        return current;
    }
    
    //--------------------------------------------------------------------------
    //
    //  Implementation of IImageList
    //
    //--------------------------------------------------------------------------
    
    public var preloadSize:uint = 1;
    
    protected function preloadNext(event:Event = null):void
    {
        for (var i:int = 1; i <= preloadSize; i++)
        {
            var preloadIndex:int = selectedIndex + i;
            if (preloadIndex > length - 1)
            {
                break;
            }
            var image:ImageBuffer = 
                getItemAt(preloadIndex) as ImageBuffer;
            if (!image.loaded && !image.loading)
            {
                image.load();
            }
        }
    }

}
}