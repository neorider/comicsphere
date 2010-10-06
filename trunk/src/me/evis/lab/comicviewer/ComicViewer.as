package me.evis.lab.comicviewer
{
import flash.display.Stage;
import flash.display.StageDisplayState;
import flash.events.Event;
import flash.events.FocusEvent;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.ui.Keyboard;

import me.evis.lab.imagestack.ImageStack;
import me.evis.lab.util.FileLoader;

import mx.binding.utils.BindingUtils;
import mx.core.FlexGlobals;
import mx.events.FlexEvent;
import mx.styles.CSSStyleDeclaration;

import spark.components.Application;
import spark.components.Button;
import spark.components.Label;
import spark.components.SkinnableContainer;
import spark.components.TextInput;

[SkinState("viewer")]
public class ComicViewer extends SkinnableContainer
{
    private static const STATE_NORMAL:String = "normal";
    private static const STATE_VIEWER:String = "viewer";
    private static const STATE_DISABLED:String = "disabled";
    
    public function ComicViewer()
    {
        super();
        
        // Initialize the ImageStack before attaching skin. 
        _imageStack = new ImageStack();
        _imageStack.percentWidth = 100;
        _imageStack.percentHeight = 100;
        _imageStack.horizontalCenter = 0;
        _imageStack.verticalCenter = 0;
        
        // Add keypress handler
        FlexGlobals.topLevelApplication.addEventListener(FlexEvent.APPLICATION_COMPLETE, 
            function(event:FlexEvent):void {
                var application:Application = Application(event.target);
                var stage:Stage = application.stage;
                stage.addEventListener(KeyboardEvent.KEY_UP, onGlobalKeyPress);
                stage.focus = application;
        });
    }
    
    private function onGlobalKeyPress(event:KeyboardEvent):void
    {
        // Only works when global focus. TODO fix
//        if (!event.target is TextInput)
//        {
            switch (event.keyCode)
            {
                // Also available when full screen in FP10
                case Keyboard.RIGHT:
                case Keyboard.DOWN:
                case Keyboard.SPACE:
                // Not available when full screen in FP10
                case Keyboard.PAGE_DOWN:
                    imageStack.next();
                    break;
                // Also available when full screen in FP10
                case Keyboard.LEFT:
                case Keyboard.UP:
                // Not available when full screen in FP10
                case Keyboard.BACKSPACE:
                case Keyboard.PAGE_UP:
                    imageStack.previous();
                    break;
                case Keyboard.TAB:
                    // Change State
                    hideControls = !hideControls;
                    break;
            }
//        }
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
    
    private var _hideControls:Boolean = false;

    public function get hideControls():Boolean
    {
        return _hideControls;
    }

    public function set hideControls(value:Boolean):void
    {
        _hideControls = value;
        invalidateSkinState();
    }

    
    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------
    
    override protected function createChildren():void
    {
        super.createChildren();
 
        this.addElement(imageStack);
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
    
    [SkinPart(required="false")]
    public var fullScreenButton:Button;
    
    [SkinPart(required="false")]
    public var browseButton:Button;
    
    override protected function partAdded(partName:String, instance:Object):void
    {
        super.partAdded(partName, instance);
        
        if (instance == previousButton)
        {
            previousButton.addEventListener(MouseEvent.CLICK, imageStack.previous);
        } 
        else if (instance == nextButton)
        {
            nextButton.addEventListener(MouseEvent.CLICK, imageStack.next);
        }
        else if (instance == sizeLabel)
        {
            // FIX cannot response to size change due to underlying Array implementation
            BindingUtils.bindProperty(sizeLabel, "text", imageStack, "size");
        }
        else if (instance == pageText)
        {
            BindingUtils.bindProperty(pageText, "text", imageStack, "page");
            pageText.addEventListener(FlexEvent.ENTER, onPageTextChanged);
            pageText.addEventListener(FocusEvent.FOCUS_OUT, onPageTextChanged);
        }
        else if (instance == fullScreenButton)
        {
            fullScreenButton.addEventListener(MouseEvent.CLICK, onFullScreenButtonClick);
        }
        else if (instance == browseButton)
        {
            browseButton.addEventListener(MouseEvent.CLICK, onBrowseButtonClick);
        }
    }
    
    private function onPageTextChanged(event:Event):void
    {
        var text:String = event.target.text;
        if (text && !isNaN(parseInt(text)))
        {
            imageStack.page = parseInt(text);
        }
    }
    
    private function onFullScreenButtonClick(event:MouseEvent):void
    {
        var stage:Stage = FlexGlobals.topLevelApplication.stage;
        if (stage.displayState == StageDisplayState.NORMAL)
            stage.displayState = StageDisplayState.FULL_SCREEN;
        else
            stage.displayState = StageDisplayState.NORMAL;
    }
    
    private function onBrowseButtonClick(event:MouseEvent):void
    {
        var fileLoader:FileLoader = new FileLoader();
        fileLoader.addEventListener(Event.COMPLETE, function(event:Event):void {
            imageStack.dataProvider = fileLoader.images;
        });
        fileLoader.openFiles();
    }
    
    override protected function partRemoved(partName:String, instance:Object):void {
        super.partRemoved(partName, instance);
        
        if (instance == previousButton)
        {
            previousButton.removeEventListener(MouseEvent.CLICK, imageStack.previous);
        } 
        else if (instance == nextButton)
        {
            nextButton.removeEventListener(MouseEvent.CLICK, imageStack.next);
        }
    }
    
    /**
     *  @private
     */
    override protected function getCurrentSkinState():String
    {
        if (enabled && hideControls)
            return STATE_VIEWER;
        
        return super.getCurrentSkinState();
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