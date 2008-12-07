$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'test/unit'
require 'pyrotalk'

class PyrotalkTest < Test::Unit::TestCase

  def setup
    @pyro_talk = PyroTalk.new
  end
  
  def teardown
  end
  
  def test_translate
    original_text        = 'Testing <strong>the</strong> pyro TRANSLATOR. <em>This should</em> return ok.'
    expected_translation = 'Ththtng <strong>thh</strong> pr-ro TRHNTHLHTRR. <em>Thiz thhruld</em> rhturn rg.'
    assert_equal expected_translation, @pyro_talk.translate(original_text), 'Testing <strong>the</strong> pyro TRANSLATOR. <em>This should</em> return ok.'
  end
  
  def test_capitalize
    assert_equal 'I',     @pyro_talk.capitalize('i', 'i')
    assert_equal 'H',     @pyro_talk.capitalize('i', 'H')
    assert_equal 'HRRL',  @pyro_talk.capitalize('HELLO', 'hrrl')
    assert_equal 'Hrrl',  @pyro_talk.capitalize('Hello', 'hrrl')
    assert_equal 'hrrl',  @pyro_talk.capitalize('hello', 'hrrl')
  end
  

  def test_tokenize
    text = 'Testing the PYRO translator. <em>This should</em> return ok.'
    expected = ['','Testing',' ','the', ' ', 'PYRO', ' ', 'translator', '', '. ', '',  '<em>', '', 'This', ' ', 'should', '', '</em>',' ', 'return', ' ', 'ok', '.']
    assert_equal(expected, @pyro_talk.tokenize(text))
  end
  
  def test_word?
    ['1', '!', '"', ' ', '. ', 'a1', '<em>', '</em>'].each do |word|
      assert !@pyro_talk.word?(word)
    end
    
    ['a','madlep','madlep'].each do |word|
      assert @pyro_talk.word?(word)
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
    assert_equal /(^|(?!(!.*)))TEST($|(?!(.*!)))/, @pyro_talk.protect_regex(/TEST/)
  end

  def test_remove_protection
    %w{!TEST! T!EST! !TE!ST T!E!ST}.each do |word|
      assert_equal 'TEST', @pyro_talk.remove_protection(word)
    end
  end
  
  private
  def assert_find_pyro_word(expected, word_to_translate)
    assert_equal expected, @pyro_talk.find_pyro_word(word_to_translate)
  end
  
end