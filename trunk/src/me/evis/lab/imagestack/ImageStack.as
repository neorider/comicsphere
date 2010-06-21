package me.evis.lab.imagestack
{
import flash.events.Event;

import me.evis.lab.imagestack.supportClasses.BitmapImageRenderer;
import me.evis.lab.imagestack.supportClasses.HorizontalPagesLayout;

import mx.collections.ArrayCollection;
import mx.core.ClassFactory;
import mx.core.IVisualElement;
import mx.events.CollectionEvent;

import spark.components.DataGroup;
import spark.filters.DropShadowFilter;
import spark.primitives.BitmapImage;

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
        
        _images.addEventListener(CollectionEvent.COLLECTION_CHANGE, function(event:CollectionEvent):void {
            invalidateProperties();
        });
        
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
        horizontalScrollPosition --;
    }
    
    public function next(event:Event = null):void
    {
        //            this.horizontalScrollPosition += this.width;
//        Tweensy.to(this, {horizontalScrollPosition:horizontalScrollPosition + width});
        if (selectedIndex < length - 1)
            selectedIndex ++;
        horizontalScrollPosition ++;
    }
    
    //--------------------------------------------------------------------------
    //
    //  Implements ISelectableList
    //
    //--------------------------------------------------------------------------

    private var _images:ArrayCollection = new ArrayCollection();
    
    //----------------------------------
    //  selectedIndex
    //----------------------------------
    
    private var _selectedIndex:int = 0;
    
    public function get selectedIndex():int
    {
        return _selectedIndex;
    }
    public function set selectedIndex(value:int):void
    {
        _selectedIndex = value;
    }
    
    public function get length():int
    {
        return _images.length;
    }
    
    public function addItem(item:Object):void
    {
        _images.addItem(item);
    }
    
    public function addItemAt(item:Object, index:int):void
    {
        _images.addItemAt(item, index);
    }
    
    public function getItemAt(index:int, prefetch:int=0):Object
    {
        return _images.getItemAt(index, prefetch);
    }
    
    public function getItemIndex(item:Object):int
    {
        return _images.getItemIndex(item);
    }
    
    public function itemUpdated(item:Object, property:Object=null, oldValue:Object=null, newValue:Object=null):void
    {
        _images.itemUpdated(item, property, oldValue, newValue);
    }
    
    public function removeAll():void
    {
        _images.removeAll();
    }
    
    public function removeItemAt(index:int):Object
    {
        return _images.removeItemAt(index);
    }
    
    public function setItemAt(item:Object, index:int):Object
    {
        return _images.setItemAt(item, index);
    }
    
    public function toArray():Array
    {
        return _images.toArray();
    }
}
}