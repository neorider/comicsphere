package me.evis.lab.imagestack.supportClasses
{
import flexunit.framework.Assert;

public class ImageBufferTest
{		
    [Before]
    public function setUp():void
    {
    }
    
    [After]
    public function tearDown():void
    {
    }
    
    [BeforeClass]
    public static function setUpBeforeClass():void
    {
    }
    
    [AfterClass]
    public static function tearDownAfterClass():void
    {
    }
    
    [Test]
    public function testLoad():void
    {
        Assert.fail("Test method Not yet implemented");
    }
    
    [Test]
    public function testIsInArchive():void
    {
        var url:String = "file:///E:/temp/MyArchive.zip/folder1/a.jpg";
        var imageBuffer:ImageBuffer = new ImageBuffer(url);
        Assert.assertEquals("zip", imageBuffer.isInArchive());
    }
}
}