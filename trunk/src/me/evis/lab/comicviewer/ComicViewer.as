package me.evis.lab.comicviewer
{
import flash.events.MouseEvent;

import me.evis.lab.imagestack.ImageStack;

import mx.core.FlexGlobals;
import mx.styles.CSSStyleDeclaration;
import mx.utils.ObjectUtil;

import spark.components.Button;
import spark.components.Group;
import spark.components.SkinnableContainer;

public class ComicViewer extends SkinnableContainer
{
    
    public function ComicViewer()
    {
        super();
        
        // Initialize the ImageStack before attaching skin. 
        _imageStack = new ImageStack();
        _imageStack.percentWidth = 100;
        _imageStack.percentHeight = 100;
        _imageStack.horizontalCenter = 0;
        _imageStack.verticalCenter = 0;
    }

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    private var _imageStack:ImageStack;
    
    public function get imageStack():ImageStack
    {
        return _imageStack;
    }
    
    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------
    
    override protected function createChildren():void
    {
        super.createChildren();
 
        this.addElement(_imageStack);
    }
    
    //--------------------------------------------------------------------------
    //
    //  Skin
    //
    //--------------------------------------------------------------------------

    [SkinPart(required="true")]
    public var previousButton:Button;
    
    [SkinPart(required="true")]
    public var nextButton:Button;
    
    override protected function partAdded(partName:String, instance:Object):void
    {
        super.partAdded(partName, instance);
        
        if (instance == previousButton)
        {
            previousButton.label = "<<";
            previousButton.addEventListener(MouseEvent.CLICK, _imageStack.previous);
        } 
        else if (instance == nextButton)
        {
            nextButton.label = ">>";
            nextButton.addEventListener(MouseEvent.CLICK, _imageStack.next);
        }
    }
    
    override protected function partRemoved(partName:String, instance:Object):void {
        super.partRemoved(partName, instance);
        
        if (instance == previousButton)
        {
            previousButton.removeEventListener(MouseEvent.CLICK, _imageStack.previous);
        } 
        else if (instance == nextButton)
        {
            nextButton.removeEventListener(MouseEvent.CLICK, _imageStack.next);
        }
    }
    
    //--------------------------------------------------------------------------
    //
    //  Default style/skin
    //
    //--------------------------------------------------------------------------

    // Static variable.
    private static var classConstructed:Boolean = classConstruct();
    // Static method. Executed only once.
    private static function classConstruct():Boolean {
        if (!FlexGlobals.topLevelApplication.styleManager.getStyleDeclaration("me.evis.lab.comicviewer.ComicViewer"))
        {
            // If there is no CSS definition for ComicViewer,
            // then create one and set the default value.
            var comicViewerStyles:CSSStyleDeclaration = new CSSStyleDeclaration();
            comicViewerStyles.defaultFactory = function():void {
                this.skinClass = ComicViewerSkin;
            };
            FlexGlobals.topLevelApplication.styleManager.setStyleDeclaration("me.evis.lab.comicviewer.ComicViewer", comicViewerStyles, true);
        }
        return true;
    }
}
}