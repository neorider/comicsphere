package me.evis.lab.util
{
import deng.fzip.FZip;
import deng.fzip.FZipEvent;
import deng.fzip.FZipFile;

import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.FileListEvent;
import flash.filesystem.File;
import flash.net.FileReference;
import flash.net.FileReferenceList;
import flash.net.URLRequest;
import flash.utils.Dictionary;

import me.evis.lab.imagestack.supportClasses.ImageArrayList;
import me.evis.lab.imagestack.supportClasses.ImageBuffer;

[Event(name="complete", type="flash.events.Event")]

public class FileLoader extends EventDispatcher
{
    public static const URL_SEPARATOR:String = "/";
    
    // TODO logger
    //private const log:ILogger = Log.getLogger("FileLoader");

    private var filesToLoad:Array = [];
    private var loadComplete:Boolean = false;
    
    private var _images:ImageArrayList = new ImageArrayList();

    /**
     * Better invoke this getter after complete event.
     * TODO refine this.
     */
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
        // record to loading status
        filesToLoad = files.slice();
        files.sortOn("name");
        images.removeAll();
        for each (var item:Object in files)
        {
            var file:File = item as File;
            var fileType:String = FileTypeUtil.getFileType(file);
            switch (fileType)
            {
                case FileTypeUtil.FILE_TYPE_IMAGE:
                    handleImage(file);
                    break;
                case FileTypeUtil.FILE_TYPE_ZIP:
                    handleZip(file);
                    break;
                case FileTypeUtil.FILE_TYPE_OTHERS:
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
        completeFile(file);
    }
    
    private function completeFile(file:File):void
    {
        filesToLoad.splice(filesToLoad.lastIndexOf(file), 1);
        if (filesToLoad.length == 0)
        {
            dispatchEvent(new Event(Event.COMPLETE));
        }
    }
    
    private function handleZip(file:File):void
    {
        var zip:FZip = new FZip();
        zip.addEventListener(FZipEvent.FILE_LOADED, function(event:FZipEvent):void {
            var zFile:FZipFile = event.file;
            var fileType:String = FileTypeUtil.getFileTypeFromFilename(zFile.filename);
            switch (fileType)
            {
                case FileTypeUtil.FILE_TYPE_IMAGE:
                    var mixedUrl:String = file.url + URL_SEPARATOR + zFile.filename;
                    var image:ImageBuffer = new ImageBuffer(mixedUrl);
                    images.addItem(image);
                    break;
                case FileTypeUtil.FILE_TYPE_ZIP:
                    // TODO 
                    break;
                case FileTypeUtil.FILE_TYPE_OTHERS:
                    //log.info("Skipped", file);
                    break;
            }
        });
        zip.addEventListener(Event.COMPLETE, function(event:Event):void {
            completeFile(file);
        });
        zip.load(new URLRequest(file.url));
    }
}
}