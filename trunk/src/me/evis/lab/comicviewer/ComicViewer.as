package me.evis.lab.comicviewer
{
import flash.events.Event;
import flash.events.FocusEvent;
import flash.events.MouseEvent;

import me.evis.lab.imagestack.ImageStack;

import mx.binding.utils.BindingUtils;
import mx.core.FlexGlobals;
import mx.events.FlexEvent;
import mx.styles.CSSStyleDeclaration;
import mx.utils.ObjectUtil;

import spark.components.Button;
import spark.components.Group;
import spark.components.HScrollBar;
import spark.components.Label;
import spark.components.SkinnableContainer;
import spark.components.TextInput;
import spark.events.TextOperationEvent;

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
//        
//        var hScrollBar:HScrollBar = new HScrollBar();
////        hScrollBar.visible = false;
//        hScrollBar.viewport = _imageStack;
//        this.addElement(hScrollBar);
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
    
    [SkinPart(required="false")]
    public var sizeLabel:Label;
    
    [SkinPart(required="false")]
    public var pageText:TextInput;
    
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
        else if (instance == sizeLabel)
        {
            BindingUtils.bindProperty(sizeLabel, "text", _imageStack, "size");
        }
        else if (instance == pageText)
        {
            BindingUtils.bindProperty(pageText, "text", _imageStack, "page");
            pageText.addEventListener(FlexEvent.ENTER, onPageTextChanged);
            pageText.addEventListener(FocusEvent.FOCUS_OUT, onPageTextChanged);
        }
    }
    
    private function onPageTextChanged(event:Event):void
    {
        var text:String = event.target.text;
        if (text && !isNaN(parseInt(text)))
        {
            _imageStack.page = parseInt(text);
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