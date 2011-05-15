package me.evis.lab.util
{
import flash.net.FileReference;

public final class FileTypeUtil
{
    public static const FILE_TYPE_IMAGE:String = "image";
    public static const FILE_TYPE_ZIP:String = "zip";
    public static const FILE_TYPE_OTHERS:String = "others";
    
    public static function getFileType(fileRef:FileReference):String
    {
        if (!fileRef)
            return null;
        
        return getFileTypeFromExtention(fileRef.type.replace(".", ""));
    }
    
    public static function getFileTypeFromFilename(filename:String):String
    {
        var extentionIndex:int = filename.lastIndexOf(".");
        return getFileTypeFromExtention(filename.substring(extentionIndex + 1));
    }
    
    public static function getFileTypeFromExtention(extention:String):String
    {
        switch (extention)
        {
            case "jpg":
            case "jpeg":
            case "png":
            case "gif":
                return FILE_TYPE_IMAGE;
                
            case "zip":
                return FILE_TYPE_ZIP;
                
            default:
                return FILE_TYPE_OTHERS;
        }
    }
}
}