package me.evis.lab.imagestack
{
import com.flashdynamix.motion.Tweensy;

import flash.display.DisplayObject;
import flash.events.Event;
import flash.events.MouseEvent;

import me.evis.lab.imagestack.supportClasses.HorizontalPagesLayout;

import mx.core.IVisualElement;
import mx.core.IVisualElementContainer;
import mx.events.PropertyChangeEvent;
import mx.managers.IFocusManagerComponent;

import spark.components.Button;
import spark.components.Group;
import spark.components.HScrollBar;
import spark.components.VScrollBar;
import spark.components.supportClasses.SkinnableComponent;
import spark.core.IViewport;
import spark.core.NavigationUnit;

[DefaultProperty("mxmlContent")]

public class _ImageStack2 extends SkinnableComponent
    implements IFocusManagerComponent, IVisualElementContainer
{
    
    //----------------------------------
    // Public Properties
    //----------------------------------
    
    [ArrayElementType("mx.core.IVisualElement")]
    /**
     *  The visual content children for this Group.
     */
    public function set mxmlContent(value:Array):void
    {
        innerGroup.mxmlContent = value;
    }
    
    [Bindable]
    public var horizontalScrollBar:HScrollBar;
    [Bindable]
    public var verticalScrollBar:VScrollBar;
    
    //----------------------------------
    // selectedIndex
    //----------------------------------
    
    private var _selectedIndex:int = -1;
    
    public function get selectedIndex():int
    {
        return _selectedIndex;
    }
    
    public function set selectedIndex(value:int):void
    {
        _selectedIndex = value;
    }
    
    //----------------------------------
    // Private Properties
    //----------------------------------
    
    private var innerGroup:Group;
    
    //----------------------------------
    // Public Methods
    //----------------------------------
    
    public function _ImageStack2()
    {
        super();
        // Needs instance at early stage.
        innerGroup = new Group();
        addEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelHandler);
    }
    
    //--------------------------------------------------------------------------
    //
    //  Methods: IVisualElementContainer
    //
    //--------------------------------------------------------------------------
    
    /**
     *  Returns 1 if there is a viewport, 0 otherwise.
     * 
     *  @return The number of visual elements in this visual container
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function get numElements():int
    {
        return 3;
    }
    
    /**
     *  Returns the viewport if there is a viewport and the 
     *  index passed in is 0.  Otherwise, it throws a RangeError.
     *
     *  @param index The index of the element to retrieve.
     *
     *  @return The element at the specified index.
     * 
     *  @throws RangeError If the index position does not exist in the child list.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */ 
    public function getElementAt(index:int):IVisualElement
    {
        throw new RangeError(resourceManager.getString("components", "indexOutOfRange", [index]));
    }
    
    /**
     *  Returns 0 if the element passed in is the viewport.  
     *  Otherwise, it throws an ArgumentError.
     *
     *  @param element The element to identify.
     *
     *  @return The index position of the element to identify.
     * 
     *  @throws ArgumentError If the element is not a child of this object.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */ 
    public function getElementIndex(element:IVisualElement):int
    {
        throw ArgumentError(resourceManager.getString("components", "elementNotFoundInScroller", [element]));
    }
    
    /**
     * 
     *  This operation is not supported in Scroller.  
     *  A Scroller control has only one child. 
     *  Use the <code>viewport</code> property to manipulate 
     *  it.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function addElement(element:IVisualElement):IVisualElement
    {
        return IVisualElement(addChild(DisplayObject(element)));
    }
    
    /**
     *  This operation is not supported in Scroller.  
     *  A Scroller control has only one child.  Use the <code>viewport</code> property to manipulate 
     *  it.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function addElementAt(element:IVisualElement, index:int):IVisualElement
    {
        throw new ArgumentError(resourceManager.getString("components", "operationNotSupported"));
    }
    
    /**
     * 
     *  This operation is not supported in Scroller.  
     *  A Scroller control has only one child.  Use the <code>viewport</code> property to manipulate 
     *  it.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function removeElement(element:IVisualElement):IVisualElement
    {
        throw new ArgumentError(resourceManager.getString("components", "operationNotSupported"));
    }
    
    /**
     * 
     *  This operation is not supported in Scroller.  
     *  A Scroller control has only one child.  Use the <code>viewport</code> property to manipulate 
     *  it.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function removeElementAt(index:int):IVisualElement
    {
        throw new ArgumentError(resourceManager.getString("components", "operationNotSupported"));
    }
    
    /**
     * 
     *  This operation is not supported in Scroller.  
     *  A Scroller control has only one child. Use the <code>viewport</code> property to manipulate 
     *  it.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function removeAllElements():void
    {
        throw new ArgumentError(resourceManager.getString("components", "operationNotSupported"));
    }
    
    /**
     * 
     *  This operation is not supported in Scroller.  
     *  A Scroller control has only one child.  Use the <code>viewport</code> property to manipulate 
     *  it.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function setElementIndex(element:IVisualElement, index:int):void
    {
        throw new ArgumentError(resourceManager.getString("components", "operationNotSupported"));
    }
    
    /**
     * 
     *  This operation is not supported in Scroller.  
     *  A Scroller control has only one child.  Use the <code>viewport</code> property to manipulate 
     *  it.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function swapElements(element1:IVisualElement, element2:IVisualElement):void
    {
        throw new ArgumentError(resourceManager.getString("components", "operationNotSupported"));
    }
    
    /**
     * 
     *  This operation is not supported in Scroller.  
     *  A Scroller control has only one child.  Use the <code>viewport</code> property to manipulate 
     *  it.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function swapElementsAt(index1:int, index2:int):void
    {
        throw new ArgumentError(resourceManager.getString("components", "operationNotSupported"));
    }
    
    
    public function previous(event:Event = null):void
    {
        //			this.horizontalScrollPosition -= this.width;
        Tweensy.to(innerGroup, {horizontalScrollPosition:innerGroup.horizontalScrollPosition - width});
    }
    
    public function next(event:Event = null):void
    {
        //            this.horizontalScrollPosition += this.width;
        Tweensy.to(innerGroup, {horizontalScrollPosition:innerGroup.horizontalScrollPosition + width});
    }
    
    //----------------------------------
    // Private Methods
    //----------------------------------
    
    override protected function createChildren():void
    {
        innerGroup.layout = new HorizontalPagesLayout();
        this.addElement(innerGroup);
        innerGroup.clipAndEnableScrolling = true;
        innerGroup.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, viewport_propertyChangeHandler);
        
        installBrowseButtons();
    }
    
    private function installBrowseButtons():void
    {
        var previousButton:Button = new Button();
        previousButton.label = "<<";
        previousButton.width = 40;
        previousButton.height = 50;
        previousButton.left = 5;
        previousButton.verticalCenter = 0;
        previousButton.alpha = 0.5;
        previousButton.addEventListener(MouseEvent.CLICK, previous);
        this.addElement(previousButton);
        
        var nextButton:Button = new Button();
        nextButton.label = ">>";
        nextButton.width = 40;
        nextButton.height = 50;
        nextButton.right = 5;
        nextButton.verticalCenter = 0;
        nextButton.alpha = 0.5;
        nextButton.addEventListener(MouseEvent.CLICK, next);
        this.addElement(nextButton);
    }
    
    //--------------------------------------------------------------------------
    // 
    // Event Handlers
    //
    //--------------------------------------------------------------------------
    
    
    private function viewport_propertyChangeHandler(event:PropertyChangeEvent):void
    {
        switch(event.property) 
        {
            case "contentWidth": 
            case "contentHeight": 
                invalidateSize()
                invalidateDisplayList();
                break;
        }
    }
    
    // To avoid unconditionally linking the RichEditableText class we lazily
    // get a reference if it's been linked already.  See below.
    //private static var textDisplayClassLoaded:Boolean = false;
    //private static var textDisplayClass:Class = null;
    
    private function mouseWheelHandler(event:MouseEvent):void
    {
        var vp:IViewport = innerGroup;
        if (!vp || event.isDefaultPrevented())
            return;
        
        // If a TextField has the focus, then check to see if it's already
        // handling mouse wheel events.  For now, we'll make the same 
        // assumption about RichEditableText.
        
        /*var focusOwner:InteractiveObject = getFocus();
        if ((focusOwner is TextField) && TextField(focusOwner).mouseWheelEnabled)
        return;    
        
        if (!textDisplayClassLoaded)
        {
        textDisplayClassLoaded = true;
        const s:String = "spark.components.RichEditableText";
        if (ApplicationDomain.currentDomain.hasDefinition(s))
        textDisplayClass = Class(ApplicationDomain.currentDomain.getDefinition(s));
        }
        if (textDisplayClass && (focusOwner is textDisplayClass))
        return;*/
        
        var nSteps:uint = Math.abs(event.delta);
        var navigationUnit:uint;
        
        // Scroll event.delta "steps".  If the VSB is up, scroll vertically,
        // if -only- the HSB is up then scroll horizontally.
        
        if (verticalScrollBar && verticalScrollBar.visible)
        {
            navigationUnit = (event.delta < 0) ? NavigationUnit.DOWN : NavigationUnit.UP;
            for(var vStep:int = 0; vStep < nSteps; vStep++)
            {
                var vspDelta:Number = vp.getVerticalScrollPositionDelta(navigationUnit);
                if (!isNaN(vspDelta))
                    vp.verticalScrollPosition += vspDelta;
            }
            event.preventDefault();
        }
        else if (horizontalScrollBar && horizontalScrollBar.visible)
        {
            navigationUnit = (event.delta < 0) ? NavigationUnit.LEFT : NavigationUnit.RIGHT;
            for(var hStep:int = 0; hStep < nSteps; hStep++)
            {
                var hspDelta:Number = vp.getHorizontalScrollPositionDelta(navigationUnit);
                if (!isNaN(hspDelta))
                    vp.horizontalScrollPosition += hspDelta;
            }
            event.preventDefault();
        }            
    }
}
}