# Copyright (c) 2008 Julian Doherty
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.



$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'test/unit'
require 'pyrotalk'

class PyrotalkTest < Test::Unit::TestCase

  def setup
  end
  
  def teardown
  end
  
  def test_translate
    original_text        = 'Testing <strong>the</strong> pyro TRANSLATOR. <em>This should</em> return ok.'
    expected_translation = 'Ththtng <strong>thh</strong> pr-ro TRHNTHLHTRR. <em>Thiz thhruld</em> rhturn rg.'
    assert_equal expected_translation, Pyrotalk.translate(original_text), 'Testing <strong>the</strong> pyro TRANSLATOR. <em>This should</em> return ok.'
  end
  
  def test_capitalize
    assert_equal 'I',     Pyrotalk.capitalize('i', 'i')
    assert_equal 'H',     Pyrotalk.capitalize('i', 'H')
    assert_equal 'HRRL',  Pyrotalk.capitalize('HELLO', 'hrrl')
    assert_equal 'Hrrl',  Pyrotalk.capitalize('Hello', 'hrrl')
    assert_equal 'hrrl',  Pyrotalk.capitalize('hello', 'hrrl')
  end
  

  def test_tokenize
    text = 'Testing the PYRO translator. <em>This should</em> return ok.'
    expected = ['','Testing',' ','the', ' ', 'PYRO', ' ', 'translator', '', '. ', '',  '<em>', '', 'This', ' ', 'should', '', '</em>',' ', 'return', ' ', 'ok', '.']
    assert_equal(expected, Pyrotalk.tokenize(text))
  end
  
  def test_word?
    ['1', '!', '"', ' ', '. ', 'a1', '<em>', '</em>'].each do |word|
      assert !Pyrotalk.word?(word)
    end
    
    ['a','madlep','madlep'].each do |word|
      assert Pyrotalk.word?(word)
    end
  end
  
  
  def test_find_pyro_word
    # sorry if you don't like the language here, but the rules all need to be tested
    
    #['shit']         = '!s***!'
    assert_find_pyro_word 's***', 'shit'
    assert_find_pyro_word 'dumbs***', 'dumbshit'

    #['fuck']         = '!f***!'
    assert_find_pyro_word 'f***','fuck'
    assert_find_pyro_word 'f***ng', 'fucking'

    #['and']          =  '!nn!'
    assert_find_pyro_word 'nn', 'and'

    #['is']           =  '!iz!'
    assert_find_pyro_word 'iz', 'is'
    
    #['(r|g)+a+h+']   = '!$0!'
    assert_find_pyro_word 'rrraaaahhh', 'rrraaaahhh'
    assert_find_pyro_word 'gaaaahhh', 'gaaaahhh'

    #['ing']          = 'ng'
    assert_find_pyro_word 'tryng', 'trying'

    #['pyro']         = '!pr-ro!'
    assert_find_pyro_word 'pr-ro', 'pyro'
    
    #['rock']         = '!rrkc!'
    assert_find_pyro_word 'rrkc', 'rock'

    #['(a|e)']        = 'h'
    assert_find_pyro_word 'chn', 'can'
    assert_find_pyro_word 'chn', 'cen'

    #['o']            = 'r'
    assert_find_pyro_word 'crn', 'con'

    #['s+']           = 'th'
    assert_find_pyro_word 'cthn', 'csn'
    assert_find_pyro_word 'cthn', 'csssn'

    #['k']            = 'g'
    assert_find_pyro_word 'cgn', 'ckn'

    #['^i$']          = '!i!'
    assert_find_pyro_word 'i', 'i'

    #['i']            = 'uh'
    assert_find_pyro_word 'cuhn', 'cin'
  end

  def test_protect_regex
    assert_equal /(^|(?!(!.*)))TEST($|(?!(.*!)))/, Pyrotalk.protect_regex(/TEST/)
  end

  def test_remove_protection
    %w{!TEST! T!EST! !TE!ST T!E!ST}.each do |word|
      assert_equal 'TEST', Pyrotalk.remove_protection(word)
    end
  end
  
  private
  def assert_find_pyro_word(expected, word_to_translate)
    assert_equal expected, Pyrotalk.find_pyro_word(word_to_translate)
  end
  
end