package me.evis.lab.imagestack.supportClasses
{
import deng.fzip.FZip;
import deng.fzip.FZipEvent;
import deng.fzip.FZipFile;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Loader;
import flash.display.LoaderInfo;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.net.URLRequest;

import me.evis.lab.util.FileTypeUtil;

[Bindable]
public class ImageBuffer extends EventDispatcher
{
    public function ImageBuffer(url:String = null)
    {
        this.url = url;
    }
    
    public var url:String = null;

    public var bitmapData:BitmapData;
    
    public function get loaded():Boolean
    {
        return bitmapData != null;
    }
    
    private var _loading:Boolean = false;

    public function get loading():Boolean
    {
        return _loading;
    }
    
    public var bytesLoaded:uint;
    
    public var bytesTotal:uint;
    
    public function load():void
    {
        if (loading)
        {
            return;
        }
        
        _loading = true;
        
        if (isInArchive()) 
        {
            loadInArchive();
        }
        else
        {
            var loader:Loader = new Loader();
            loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, loadProgressHandler);
            loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadCompleteHandler);
            loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loadCompleteHandler);
            var request:URLRequest = new URLRequest(url);
            loader.load(request);
        }
    }
    
    /**
     * Free up memory and ready for GC. 
     */
    public function unload():void
    {
        bitmapData = null;
        // instead of setting null, bitmapData.dispose() is not 
        // applicable here, exceptions would occur.
    }
    
    internal function isInArchive():String
    {
        // TODO implement using RegExp
        //var archiveUrlPattern:RegExp = /([w]+)\.zip\/([w]+)/i;
        //var matches:Array = url.match(archiveUrlPattern);
        if (url.toLocaleLowerCase().indexOf(".zip/") != -1)
        {
            return "zip";
        }
        return null;
    }
    
    internal function loadInArchive():void
    {
        var zipUrlLastIndex:int = url.toLocaleLowerCase().indexOf(".zip/") + 4;
        var zipUrl:String = url.substring(0, zipUrlLastIndex);
        var innerUrl:String = url.substring(zipUrlLastIndex + 1);
        
        var zip:FZip = new FZip();
        zip.addEventListener(Event.COMPLETE, function(event:Event):void {
            var zFile:FZipFile = zip.getFileByName(innerUrl);
            var fileType:String = FileTypeUtil.getFileTypeFromFilename(zFile.filename);
            switch (fileType)
            {
                case FileTypeUtil.FILE_TYPE_IMAGE:
                    var loader:Loader = new Loader();
                    loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, loadProgressHandler);
                    loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadCompleteHandler);
                    loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loadCompleteHandler);
                    loader.loadBytes(zFile.content);
                    break;
                case FileTypeUtil.FILE_TYPE_ZIP:
                    // TODO
                    break;
                case FileTypeUtil.FILE_TYPE_OTHERS:
                    //log.info("Skipped", file);
                    break;
            }
        });
        zip.load(new URLRequest(zipUrl));
    }
    
    private function loadProgressHandler(event:ProgressEvent):void
    {
        bytesLoaded = event.bytesLoaded;
        bytesTotal = event.bytesTotal;
    }
    
    private function loadCompleteHandler(event:Event):void
    {
        _loading = false;
        var loaderInfo:LoaderInfo = event.target as LoaderInfo;
        // In case of no progress event during entire loading progress
        this.dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS, false, false,
            loaderInfo.bytesLoaded, loaderInfo.bytesTotal));
        if (loaderInfo.content is Bitmap)
        {
            bitmapData = Bitmap(loaderInfo.content).bitmapData;
        }
        else
        {
            // TODO find out the detail of the error
//            throw new Error("Loaded resource other than images");
            trace("Loaded resource other than images");
        }
    }
}
}