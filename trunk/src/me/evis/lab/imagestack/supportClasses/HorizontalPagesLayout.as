package me.evis.lab.imagestack.supportClasses
{
import com.flashdynamix.motion.Tweensy;

import mx.core.ILayoutElement;

import spark.components.Button;
import spark.components.supportClasses.GroupBase;
import spark.layouts.supportClasses.LayoutBase;

public class HorizontalPagesLayout extends LayoutBase
{
    public function HorizontalPagesLayout()
    {
        super();
        this.clipAndEnableScrolling = true;
    }
    
//    override public function measure():void
//    {
//        super.measure();
//        var layoutTarget:GroupBase = target;
//        if (!layoutTarget)
//            return;
//        
//        var width:Number = 0;
//        var height:Number = 0;
//        var minWidth:Number = 0;
//        var minHeight:Number = 0;
//        
//        var count:int = layoutTarget.numElements;
//        for (var i:int = 0; i < count; i++)
//        {
//            var layoutElement:ILayoutElement = layoutTarget.getElementAt(i);
//            if (!layoutElement || !layoutElement.includeInLayout)
//                continue;
//            
//            var hCenter:Number   = parseValue(layoutElement.horizontalCenter);
//            var vCenter:Number   = parseValue(layoutElement.verticalCenter);
//            var baseline:Number  = parseValue(layoutElement.baseline);
//            var left:Number      = parseValue(layoutElement.left);
//            var right:Number     = parseValue(layoutElement.right);
//            var top:Number       = parseValue(layoutElement.top);
//            var bottom:Number    = parseValue(layoutElement.bottom);
//            
//            // Extents of the element - how much additional space (besides its own width/height)
//            // the element needs based on its constraints.
//            var extX:Number;
//            var extY:Number;
//            
//            if (!isNaN(left) && !isNaN(right))
//            {
//                // If both left & right are set, then the extents is always
//                // left + right so that the element is resized to its preferred
//                // size (if it's the one that pushes out the default size of the container).
//                extX = left + right;                
//            }
//            else if (!isNaN(hCenter))
//            {
//                // If we have horizontalCenter, then we want to have at least enough space
//                // so that the element is within the parent container.
//                // If the element is aligned to the left/right edge of the container and the
//                // distance between the centers is hCenter, then the container width will be
//                // parentWidth = 2 * (abs(hCenter) + elementWidth / 2)
//                // <=> parentWidth = 2 * abs(hCenter) + elementWidth
//                // Since the extents is the additional space that the element needs
//                // extX = parentWidth - elementWidth = 2 * abs(hCenter)
//                extX = Math.abs(hCenter) * 2;
//            }
//            else if (!isNaN(left) || !isNaN(right))
//            {
//                extX = isNaN(left) ? 0 : left;
//                extX += isNaN(right) ? 0 : right;
//            }
//            else
//            {
//                extX = layoutElement.getBoundsXAtSize(NaN, NaN);
//            }
//            
//            if (!isNaN(top) && !isNaN(bottom))
//            {
//                // If both top & bottom are set, then the extents is always
//                // top + bottom so that the element is resized to its preferred
//                // size (if it's the one that pushes out the default size of the container).
//                extY = top + bottom;                
//            }
//            else if (!isNaN(vCenter))
//            {
//                // If we have verticalCenter, then we want to have at least enough space
//                // so that the element is within the parent container.
//                // If the element is aligned to the top/bottom edge of the container and the
//                // distance between the centers is vCenter, then the container height will be
//                // parentHeight = 2 * (abs(vCenter) + elementHeight / 2)
//                // <=> parentHeight = 2 * abs(vCenter) + elementHeight
//                // Since the extents is the additional space that the element needs
//                // extY = parentHeight - elementHeight = 2 * abs(vCenter)
//                extY = Math.abs(vCenter) * 2;
//            }
//            else if (!isNaN(baseline))
//            {
//                extY = Math.round(baseline - layoutElement.baselinePosition);
//            }
//            else if (!isNaN(top) || !isNaN(bottom))
//            {
//                extY = isNaN(top) ? 0 : top;
//                extY += isNaN(bottom) ? 0 : bottom;
//            }
//            else
//            {
//                extY = layoutElement.getBoundsYAtSize(NaN, NaN);
//            }
//            
//            var preferredWidth:Number = layoutElement.getPreferredBoundsWidth();
//            var preferredHeight:Number = layoutElement.getPreferredBoundsHeight();
//            
//            width = Math.max(width, extX + preferredWidth);
//            height = Math.max(height, extY + preferredHeight);
//            
//            // Find the minimum default extents, we take the minimum width/height only
//            // when the element size is determined by the parent size
//            var elementMinWidth:Number = layoutElement.getMinBoundsWidth();
//            var elementMinHeight:Number = layoutElement.getMinBoundsHeight();
//            
//            minWidth = Math.max(minWidth, extX + elementMinWidth);
//            minHeight = Math.max(minHeight, extY + elementMinHeight);
//        }
//        
//        // Use Math.ceil() to make sure that if the content partially occupies
//        // the last pixel, we'll count it as if the whole pixel is occupied.
//        layoutTarget.measuredWidth = Math.ceil(Math.max(width, minWidth));
//        layoutTarget.measuredHeight = Math.ceil(Math.max(height, minHeight));
//        layoutTarget.measuredMinWidth = Math.ceil(minWidth);
//        layoutTarget.measuredMinHeight = Math.ceil(minHeight);
//    }
    
    override public function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
    {
        super.updateDisplayList(unscaledWidth, unscaledHeight);
        var layoutTarget:GroupBase = target;
        if (!layoutTarget)
            return;
        
        var count:int = layoutTarget.numElements;
        var maxX:Number = 0;
        var maxY:Number = 0;
        for (var i:int = 0; i < count; i++)
        {
            var layoutElement:ILayoutElement = layoutTarget.getElementAt(i);
            if (!layoutElement || !layoutElement.includeInLayout)
                continue;
            
            if (layoutElement is Button)
            {
                var left:Number = parseValue(layoutElement.left);
                var right:Number = parseValue(layoutElement.right);
                var vCenter:Number = parseValue(layoutElement.verticalCenter);
                var elementWidth:Number = layoutElement.getPreferredBoundsWidth();
                var elementHeight:Number = layoutElement.getPreferredBoundsHeight();
                
                layoutElement.setLayoutBoundsSize(elementWidth, elementHeight);
                
                var childX:Number = NaN;
                var childY:Number = NaN;
                if (!isNaN(left))
                    childX = left;
                else if (!isNaN(right))
                    childX = unscaledWidth - elementWidth - right;
                if (!isNaN(vCenter))
                    childY = Math.round((unscaledHeight - elementHeight) / 2 + vCenter);
                // Set position
                layoutElement.setLayoutBoundsPosition(childX, childY);
            }
            else
            {
                var left:Number = parseValue(layoutElement.left);
                var right:Number = parseValue(layoutElement.right);
                var vCenter:Number = parseValue(layoutElement.verticalCenter);
                var elementWidth:Number = layoutElement.getPreferredBoundsWidth();
                var elementHeight:Number = layoutElement.getPreferredBoundsHeight();
                
                layoutElement.setLayoutBoundsSize(elementWidth, elementHeight);
                
                layoutElement.setLayoutBoundsPosition(elementWidth * i, 
                                                      Math.round((unscaledHeight - elementHeight) / 2));
                
                
                // update content limits
                maxX = Math.max(maxX, elementWidth * (i + 1));
                maxY = Math.max(maxY, elementHeight);
            }
            
            continue;
            
            var hCenter:Number = parseValue(layoutElement.horizontalCenter);
            var vCenter:Number = parseValue(layoutElement.verticalCenter);
            var baseline:Number      = parseValue(layoutElement.baseline);
            var left:Number    = parseValue(layoutElement.left);
            var right:Number   = parseValue(layoutElement.right);
            var top:Number     = parseValue(layoutElement.top);
            var bottom:Number  = parseValue(layoutElement.bottom);
            var percentWidth:Number  = layoutElement.percentWidth;
            var percentHeight:Number = layoutElement.percentHeight;
            
            var elementMaxWidth:Number = layoutElement.getMaxBoundsWidth();
            var elementMaxHeight:Number = layoutElement.getMaxBoundsHeight();
            
            // Calculate size
            var childWidth:Number = NaN;
            var childHeight:Number = NaN;
            
            if (!isNaN(percentWidth))
            {
                var availableWidth:Number = unscaledWidth;
                if (!isNaN(left))
                    availableWidth -= left;
                if (!isNaN(right))
                    availableWidth -= right;
                
                childWidth = Math.round(availableWidth * Math.min(percentWidth * 0.01, 1));
                elementMaxWidth = Math.min(elementMaxWidth,
                    maxSizeToFitIn(unscaledWidth, hCenter, left, right, layoutElement.getLayoutBoundsX()));
            }
            else if (!isNaN(left) && !isNaN(right))
            {
                childWidth = unscaledWidth - right - left;
            }
            
            if (!isNaN(percentHeight))
            {
                var availableHeight:Number = unscaledHeight;
                if (!isNaN(top))
                    availableHeight -= top;
                if (!isNaN(bottom))
                    availableHeight -= bottom;    
                
                childHeight = Math.round(availableHeight * Math.min(percentHeight * 0.01, 1));
                elementMaxHeight = Math.min(elementMaxHeight,
                    maxSizeToFitIn(unscaledHeight, vCenter, top, bottom, layoutElement.getLayoutBoundsY()));
            }
            else if (!isNaN(top) && !isNaN(bottom))
            {
                childHeight = unscaledHeight - bottom - top;
            }
            
            // Apply min and max constraints, make sure min is applied last. In the cases
            // where childWidth and childHeight are NaN, setLayoutBoundsSize will use preferredSize
            // which is already constrained between min and max.
            if (!isNaN(childWidth))
                childWidth = Math.max(layoutElement.getMinBoundsWidth(), Math.min(elementMaxWidth, childWidth));
            if (!isNaN(childHeight))
                childHeight = Math.max(layoutElement.getMinBoundsHeight(), Math.min(elementMaxHeight, childHeight));
            
            // Set the size.
            layoutElement.setLayoutBoundsSize(childWidth, childHeight);
            var elementWidth:Number = layoutElement.getLayoutBoundsWidth();
            var elementHeight:Number = layoutElement.getLayoutBoundsHeight();
            
            var childX:Number = NaN;
            var childY:Number = NaN;
            
            // Horizontal position
            if (!isNaN(hCenter))
                childX = Math.round((unscaledWidth - elementWidth) / 2 + hCenter);
            else if (!isNaN(left))
                childX = left;
            else if (!isNaN(right))
                childX = unscaledWidth - elementWidth - right;
            else
                childX = layoutElement.getLayoutBoundsX();
            
            // Vertical position
            if (!isNaN(vCenter))
                childY = Math.round((unscaledHeight - elementHeight) / 2 + vCenter);
            else if (!isNaN(baseline))
                childY = Math.round(baseline - layoutElement.baselinePosition);
            else if (!isNaN(top))
                childY = top;
            else if (!isNaN(bottom))
                childY = unscaledHeight - elementHeight - bottom;
            else
                childY = layoutElement.getLayoutBoundsY();
            
            // Set position
            layoutElement.setLayoutBoundsPosition(childX, childY);

        }
        
        // Make sure that if the content spans partially over a pixel to the right/bottom,
        // the content size includes the whole pixel.
        layoutTarget.setContentSize(Math.ceil(maxX), Math.ceil(maxY));
    }
    
    override protected function scrollPositionChanged():void
    {
        var layoutTarget:GroupBase = target;
        var count:int = layoutTarget.numElements;
        for (var i:int = 0; i < count; i++)
        {
            var layoutElement:ILayoutElement = layoutTarget.getElementAt(i);
            if (layoutElement is Button)
            {
                var left:Number = parseValue(layoutElement.left);
                var right:Number = parseValue(layoutElement.right);
                var vCenter:Number = parseValue(layoutElement.verticalCenter);
                var elementWidth:Number = layoutElement.getPreferredBoundsWidth();
                var elementHeight:Number = layoutElement.getPreferredBoundsHeight();
                
                layoutElement.setLayoutBoundsSize(elementWidth, elementHeight);
                
                var childX:Number = NaN;
                var childY:Number = NaN;
                if (!isNaN(left))
                    childX = left + horizontalScrollPosition;
                else if (!isNaN(right))
                    childX = layoutTarget.width - elementWidth - right + horizontalScrollPosition;
                if (!isNaN(vCenter))
                    childY = layoutElement.getLayoutBoundsY();
                // Set position
                layoutElement.setLayoutBoundsPosition(childX, childY);
            }
        }
        
        super.scrollPositionChanged();
    }
    
    /**
     *  @return Returns the maximum value for an element's dimension so that the component doesn't
     *  spill out of the container size. Calculations are based on the layout rules.
     *  Pass in unscaledWidth, hCenter, left, right, childX to get a maxWidth value.
     *  Pass in unscaledHeight, vCenter, top, bottom, childY to get a maxHeight value.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    static private function maxSizeToFitIn(totalSize:Number,
                                           center:Number,
                                           lowConstraint:Number,
                                           highConstraint:Number,
                                           position:Number):Number
    {
        if (!isNaN(center))
        {
            // (1) x == (totalSize - childWidth) / 2 + hCenter
            // (2) x + childWidth <= totalSize
            // (3) x >= 0
            //
            // Substitue x in (2):
            // (totalSize - childWidth) / 2 + hCenter + childWidth <= totalSize
            // totalSize - childWidth + 2 * hCenter + 2 * childWidth <= 2 * totalSize
            // 2 * hCenter + childWidth <= totalSize se we get:
            // (3) childWidth <= totalSize - 2 * hCenter
            //
            // Substitute x in (3):
            // (4) childWidth <= totalSize + 2 * hCenter
            //
            // From (3) & (4) above we get:
            // childWidth <= totalSize - 2 * abs(hCenter)
            
            return totalSize - 2 * Math.abs(center);
        }
        else if(!isNaN(lowConstraint))
        {
            // childWidth + left <= totalSize
            return totalSize - lowConstraint;
        }
        else if(!isNaN(highConstraint))
        {
            // childWidth + right <= totalSize
            return totalSize - highConstraint;
        }
        else
        {
            // childWidth + childX <= totalSize
            return totalSize - position;
        }
    }
    
    private function parseValue(value:Object):Number
    {
        if (value is Number)
        {
            return Number(value);
        }
        else
        {
            return NaN;
        }
    }
}
}