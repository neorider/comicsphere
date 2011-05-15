package me.evis.lab.imagestack.supportClasses
{

import mx.collections.ArrayList;
import mx.collections.IList;
import mx.events.CollectionEvent;
import mx.events.CollectionEventKind;
import mx.events.PropertyChangeEvent;
import mx.events.PropertyChangeEventKind;

import spark.events.IndexChangeEvent;

[Event(name="change", type="spark.events.IndexChangeEvent")]

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
        this.addEventListener(CollectionEvent.COLLECTION_CHANGE, monitorLength);
    }
    
    private function monitorLength(event:CollectionEvent):void
    {
        switch (event.kind)
        {
            case CollectionEventKind.ADD:
            case CollectionEventKind.REMOVE:
            case CollectionEventKind.RESET:
                var list:IList = event.target as IList;
                var lengthChangeEvent:PropertyChangeEvent =
                    PropertyChangeEvent.createUpdateEvent(list, "length", null, list.length);   
                dispatchEvent(lengthChangeEvent);
                
                break;
            default:
                return;
        }
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
        
        var changeEvent:IndexChangeEvent = 
            new IndexChangeEvent(IndexChangeEvent.CHANGE);
        changeEvent.oldIndex = oldIndex;
        changeEvent.newIndex = _selectedIndex;
        dispatchEvent(changeEvent);
        
        preloadNext();
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
    
    protected function preloadNext(event:IndexChangeEvent = null):void
    {
        for (var i:int = 0; i <= preloadSize; i++)
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
            
            // TODO fix optimize this. Won't release the memory 
            // when backward navigation.
            var unloadIndex:int = selectedIndex - 2;
            if (unloadIndex >= 0)
            {
                var imageToUnload:ImageBuffer = 
                    getItemAt(unloadIndex) as ImageBuffer;
                imageToUnload.unload();
            }
        }
    }

}
}