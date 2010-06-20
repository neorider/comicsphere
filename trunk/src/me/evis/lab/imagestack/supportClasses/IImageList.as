package me.evis.lab.imagestack.supportClasses
{
import flash.display.DisplayObject;

import mx.core.ISelectableList;

import org.osmf.image.ImageElement;

public interface IImageList
{
    public function get first():DisplayObject;
    public function get previous():DisplayObject;
    public function get current():DisplayObject;
    public function get next():DisplayObject;
    public function get last():DisplayObject;
}
}