package me.evis.lab.imagestack.supportClasses
{
import mx.core.ISelectableList;

public interface IImageList extends ISelectableList
{
    function get first():ImageBuffer;
    function get previous():ImageBuffer;
    function get current():ImageBuffer;
    function get next():ImageBuffer;
    function get last():ImageBuffer;
}
}