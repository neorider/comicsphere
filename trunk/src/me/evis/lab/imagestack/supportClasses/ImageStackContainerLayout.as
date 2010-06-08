package me.evis.lab.imagestack.supportClasses
{
import spark.components.supportClasses.ScrollerLayout;

public class ImageStackContainerLayout extends ScrollerLayout
{
    public function ImageStackContainerLayout()
    {
        super();
    }
    
    override public function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
    {
        super.updateDisplayList(unscaledWidth, unscaledHeight);
        var layoutTarget:GroupBase = target;
        if (!layoutTarget)
            return;
        
        var count:int = layoutTarget.numElements;
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
}
}