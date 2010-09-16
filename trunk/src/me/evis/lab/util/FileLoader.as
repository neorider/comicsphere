package me.evis.lab.util
{
import flash.events.Event;
import flash.events.FileListEvent;
import flash.filesystem.File;
import flash.net.FileReference;
import flash.net.FileReferenceList;

import me.evis.lab.imagestack.supportClasses.ImageArrayList;
import me.evis.lab.imagestack.supportClasses.ImageBuffer;

import mx.logging.ILogger;
import mx.logging.Log;

public class FileLoader
{
    // TODO logger
    //private const log:ILogger = Log.getLogger("FileLoader");
    
    private var _images:ImageArrayList = new ImageArrayList();

    public function get images():ImageArrayList
    {
        return _images;
    }
    
    public function FileLoader()
    {
    }
    
    public function openFiles():void
    {
        if (RuntimeUtil.isAIR())
        {
            var file:File = new File();
            file.addEventListener(FileListEvent.SELECT_MULTIPLE, onNativeFileSelected);
            file.browseForOpenMultiple("Browse");
        }
        else
        {
            var fileRefList:FileReferenceList = new FileReferenceList();
            fileRefList.addEventListener(Event.SELECT, onFileSelected);
            fileRefList.browse();
        }
    }
    
    private function onNativeFileSelected(fileListEvent:FileListEvent):void
    {
        var files:Array = fileListEvent.files;
        files.sortOn("name");
        images.removeAll();
        for each (var item:Object in files)
        {
            var file:File = item as File;
            var fileType:String = getFileType(file);
            switch (fileType)
            {
                case FILE_TYPE_IMAGE:
                    handleImage(file);
                    break;
                case FILE_TYPE_ZIP:
                    handleZip(file);
                    break;
                case FILE_TYPE_OTHERS:
                    //log.info("Skipped", file);
                    break;
            }
            
        }
    }
    
    private function onFileSelected(event:Event):void
    {
        var fileRefList:FileReferenceList = event.target as FileReferenceList;
        for each (var fileRef:FileReference in fileRefList)
        {
            fileRef.load();
            // TODO
        }
    }
    
    private function handleImage(file:File):void
    {
        var image:ImageBuffer = new ImageBuffer(file.url);
        images.addItem(image);
    }
    
    private function handleZip(file:File):void
    {
        // TODO handles zip file using FZIP
    }
    
    public static const FILE_TYPE_IMAGE:String = "image";
    public static const FILE_TYPE_ZIP:String = "zip";
    public static const FILE_TYPE_OTHERS:String = "others";
    
    public static function getFileType(fileRef:FileReference):String
    {
        if (!fileRef)
            return null;
        
        switch (fileRef.type)
        {
            case ".jpg":
            case ".jpeg":
            case ".png":
            case ".gif":
                return FILE_TYPE_IMAGE;
                
            case ".zip":
                return FILE_TYPE_ZIP;
                
            default:
                return FILE_TYPE_OTHERS;
        }
    }
}
}