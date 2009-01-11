package wrapperSuite.tests
{
  import luaAlchemy.LuaAlchemy;

  import mx.containers.Canvas;

  import net.digitalprimates.fluint.tests.TestCase;

  public class TestSugar extends TestCase
  {
      protected var myLuaAlchemy:LuaAlchemy;
      protected static var v:TestWrapperHelper; // Make sure the TestWrapperHelper is included so sugar can make it even when the other tests are compiled out

      override protected function setUp():void
      {
        myLuaAlchemy = new LuaAlchemy();
      }

      override protected function tearDown():void
      {
        trace("TestSugar::tearDown(): begin");
        try
        {
          myLuaAlchemy.close();
          myLuaAlchemy = null;
        }
        catch (errObject:Error)
        {
          trace("TestSugar::tearDown(): error " + errObject.message);
          throw errObject;
        }
        trace("TestSugar::tearDown(): end");
      }

      public function testNewInstance():void
      {
        var script:String = ( <![CDATA[
          local v = as3.package.wrapperSuite.tests.TestWrapperHelper.new()
          return as3.type(v)
        ]]> ).toString();
        var stack:Array = myLuaAlchemy.doString(script);
        assertTrue(stack[0]);
        assertEquals("wrapperSuite.tests::TestWrapperHelper", stack[1]);
      }

      public function testSetGetInstance():void
      {
        var script:String = ( <![CDATA[
          local v = as3.package.wrapperSuite.tests.TestWrapperHelper.new()
          v.string2 = "hello"
          return as3.tolua(v.string2)
        ]]> ).toString();
        var stack:Array = myLuaAlchemy.doString(script);
        assertTrue(stack[0]);
        assertEquals("hello", stack[1]);
      }

      public function testCallInstanceNoReturn():void
      {
        var script:String = ( <![CDATA[
          local v = as3.package.wrapperSuite.tests.TestWrapperHelper.new()
          v.setNameAge("OldDude", 999)
          return as3.tolua(v.nameAge)
        ]]> ).toString();
        var stack:Array = myLuaAlchemy.doString(script);
        assertTrue(stack[0]);
        assertEquals("Name: OldDude age: 999", stack[1]);
      }

      public function testCallInstanceReturnNumber():void
      {
        var script:String = ( <![CDATA[
          local v = as3.package.wrapperSuite.tests.TestWrapperHelper.new()
          return v.addTwoNumbers(13, 5)
        ]]> ).toString();
        var stack:Array = myLuaAlchemy.doString(script);
        assertTrue(stack[0]);
        assertEquals(18, stack[1]);
      }

      public function testClassStatic():void
      {
        var script:String = ( <![CDATA[
          -- TODO anyway we can drop need for .class() below?
          return as3.tolua(as3.package.wrapperSuite.tests.TestWrapperHelper.class().TEST_WRAPPER_HELPER_EVENT)
        ]]> ).toString();
        var stack:Array = myLuaAlchemy.doString(script);
        assertTrue(stack[0]);
        assertEquals("TestWrapperHelperEvent", stack[1]);
      }

      public function testClassVar():void
      {
        var script:String = ( <![CDATA[
          local v = as3.package.String.class()
          return as3.type(v)
        ]]> ).toString();
        var stack:Array = myLuaAlchemy.doString(script);
        assertTrue(stack[0]);
        assertEquals("String", stack[1]);
      }
  }
}