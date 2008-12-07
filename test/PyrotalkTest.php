<?php
require_once 'PHPUnit/Framework.php';
require_once 'pyrotalk_lib.php';
 
class PyrotalkTest extends PHPUnit_Framework_TestCase
{
    public function test_pyrotalk()
    {
      $expected = 'Testing <strong>the</strong> pr-ro TRHNTHLHTRR. <em>Thiz thhruld</em> return ok.';
      $text = 'Testing <strong>the</strong> [pyro]pyro TRANSLATOR. <em>This should</em>[/pyro] return ok.';
      $this->assertEquals($expected, pyrotalk($text));
    }

    public function test_pyrotalk_capitalize() {
      $this->assertEquals('I', pyrotalk_capitalize('i', 'i'));
      $this->assertEquals('H', pyrotalk_capitalize('i', 'H'));
      $this->assertEquals('HRRL', pyrotalk_capitalize('HELLO', 'hrrl'));
      $this->assertEquals('Hrrl', pyrotalk_capitalize('Hello', 'hrrl'));
      $this->assertEquals('hrrl', pyrotalk_capitalize('hello', 'hrrl'));
    }

    public function test_pyrotalk_tokenize() {
      $text = 'Testing the PYRO translator. <em>This should</em> return ok.';
      $this->assertEquals(array('','Testing',' ','the', ' ', 'PYRO', ' ', 'translator', '', '. ', '',  '<em>', '', 'This', ' ', 'should', '', '</em>',' ', 'return', ' ', 'ok', '.'), pyrotalk_tokenize($text));
    }
    
    public function test_is_word() {
      $this->assertFalse(pyrotalk_is_word('1'));
      $this->assertFalse(pyrotalk_is_word('!'));
      $this->assertFalse(pyrotalk_is_word('"'));
      $this->assertFalse(pyrotalk_is_word(' '));
      $this->assertFalse(pyrotalk_is_word('. '));
      $this->assertTrue(pyrotalk_is_word('a'));
      $this->assertTrue(pyrotalk_is_word('julian'));
      $this->assertTrue(pyrotalk_is_word('JULIAN'));          
      $this->assertFalse(pyrotalk_is_word('a1'));
      $this->assertFalse(pyrotalk_is_word('<em>'));
      $this->assertFalse(pyrotalk_is_word('</em>'));
    }
    
    public function test_find_pyro_word() {
      // $pyrotalk_rules['shit']         = '!s***!';
      $this->assertEquals('s***', pyrotalk_find_pyro_word('shit'));
      // $pyrotalk_rules['fuck']         = '!f***!';
      $this->assertEquals('f***', pyrotalk_find_pyro_word('fuck'));
      $this->assertEquals('f***ng', pyrotalk_find_pyro_word('fucking'));
      $this->assertEquals('dumbs***', pyrotalk_find_pyro_word('dumbshit'));
      // $pyrotalk_rules['and']          =  '!nn!';
      $this->assertEquals('nn', pyrotalk_find_pyro_word('and'));
      // $pyrotalk_rules['is']           =  '!iz!';
      $this->assertEquals('iz', pyrotalk_find_pyro_word('is'));
      // $pyrotalk_rules['(r|g)+a+h+']   = '!$0!';
      $this->assertEquals('rrraaaahhh', pyrotalk_find_pyro_word('rrraaaahhh'));
      $this->assertEquals('gaaaahhh', pyrotalk_find_pyro_word('gaaaahhh'));
      // $pyrotalk_rules['ing']          = 'ng';
      $this->assertEquals('tryng', pyrotalk_find_pyro_word('trying'));
      // $pyrotalk_rules['pyro']         = '!pr-ro!';
      $this->assertEquals('pr-ro', pyrotalk_find_pyro_word('pyro'));
      // $pyrotalk_rules['rock']         = '!rrkc!';
      $this->assertEquals('rrkc', pyrotalk_find_pyro_word('rock'));
      // $pyrotalk_rules['(a|e)']        = 'h';
      $this->assertEquals('chn', pyrotalk_find_pyro_word('can'));
      $this->assertEquals('chn', pyrotalk_find_pyro_word('cen'));
      // $pyrotalk_rules['o']            = 'r';
      $this->assertEquals('crn', pyrotalk_find_pyro_word('con'));
      // $pyrotalk_rules['s+']           = 'th';
      $this->assertEquals('cthn', pyrotalk_find_pyro_word('csn'));
      // $pyrotalk_rules['k']            = 'g';
      $this->assertEquals('cgn', pyrotalk_find_pyro_word('ckn'));
      // $pyrotalk_rules['^i$']          = '!i!';
      $this->assertEquals('i', pyrotalk_find_pyro_word('i'));
      // $pyrotalk_rules['i']            = 'uh';
      $this->assertEquals('cuhn', pyrotalk_find_pyro_word('cin'));
    }
    
    public function test_protect_regex() {
      $this->assertEquals("/(^|(?!(!.*)))TEST($|(?!(.*!)))/", pyrotalk_protect_regex('TEST'));
    }
    
    public function test_remove_protection() {
      $this->assertEquals("TEST", pyrotalk_remove_protection("!TEST!"));
      $this->assertEquals("TEST", pyrotalk_remove_protection("T!EST!"));
      $this->assertEquals("TEST", pyrotalk_remove_protection("!TE!ST"));
      $this->assertEquals("TEST", pyrotalk_remove_protection("T!E!ST"));
    }

}
?>