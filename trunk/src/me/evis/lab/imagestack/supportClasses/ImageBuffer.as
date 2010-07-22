package me.evis.lab.imagestack.supportClasses
{
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Loader;
import flash.display.LoaderInfo;
import flash.events.Event;
import flash.net.URLRequest;

public class ImageBuffer
{
    public function ImageBuffer(url:String = null)
    {
        this.url = url;
    }
    
    private var _url:String = null;
    
    public function get url():String
    {
        return _url;
    }

    public function set url(value:String):void
    {
        _url = value;
    }

    private var _bitmapData:BitmapData;
    
    public function get bitmapData():BitmapData
    {
        return _bitmapData;
    }
    
    public function set bitmapData(value:BitmapData):void
    {
        _bitmapData = value;
    }
    
    public function get loaded():Boolean
    {
        return bitmapData != null;
    }
    
    private var _loading:Boolean = false;

    public function get loading():Boolean
    {
        return _loading;
    }
    
    public function load():void
    {
        if (loading)
        {
            return;
        }
        
        _loading = true;
        var loader:Loader = new Loader();
        loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadCompleteHandler);
        var request:URLRequest = new URLRequest(url);
        loader.load(request);
    }
    
    private function loadCompleteHandler(event:Event):void
    {
        _loading = false;
        var loaderInfo:LoaderInfo = event.target as LoaderInfo;
        if (loaderInfo.content is Bitmap)
        {
            bitmapData = Bitmap(loaderInfo.content).bitmapData;
        }
        else
        {
            throw new Error("Loaded resource other than images");
        }
    }
}
}