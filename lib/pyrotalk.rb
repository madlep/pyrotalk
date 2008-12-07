class PyroTalk
  
  Rule = Struct.new(:match, :result)
  # Regex on the left that may match a string. Translate token matched by a rule to the text on the right.
  # These will be executed in the order declared here. If a particular piece of a token should NOT be matched
  # to any further rules, then escape it inside !..!. 
  # This will then be ignored for further processing. 
  # The ! will be removed at the end of translating.
  
  RULES = [
    # sorry if these offend you, no one said the pyro was child friendly
    Rule.new(/shit/,        '!s***!'), 
    Rule.new(/fuck/,        '!f***!'),
    Rule.new(/and/,         '!nn!'),
    Rule.new(/is/,          '!iz!'),
    Rule.new(/(r|g)+a+h+/,  '!\0!'), #rraaahhh or gggaaahhh etc are preserved unchanged (\0 returns full matched text)
    Rule.new(/ing/,         'ng'),
    Rule.new(/pyro/,        '!pr-ro!'),
    Rule.new(/rock/,        '!rrkc!'),
    Rule.new(/(a|e)/,       'h'),
    Rule.new(/o/,           'r'),
    Rule.new(/s+/,          'th'),
    Rule.new(/k/,           'g'),
    Rule.new(/^i$/,         '!i!'), #preserve 'i' by itself (as in "I rock")
    Rule.new(/i/,           'uh')
  ]
  
  def initialize()
    
  end

  # Given a piece of text in english, translate it to pyrotalk
  # Split the text into tokens, and apply the rules to each token that is identified as a word by pyrotalk_is_word()
  # Handle basic preservation of case.
  def translate(english_text)
    tokenize(english_text).map{|token|
      if word?(token)
        capitalize(token, find_pyro_word(token.downcase))
      else
        token
      end
    }.join('')
  end


  # Basic case preservation of translated words taking the case makeup of the original word:
  # If the original word was all UPPER, then make translated word UPPER.
  # If the original word was Capitalized, then make the translated word Capitalized.
  # Otherwise, just leave the translated word alone.
  def capitalize(english_token, pyro_word)
    return pyro_word.upcase     if english_token.downcase == 'i'
    return pyro_word.upcase     if english_token.upcase == english_token
    return pyro_word.capitalize if english_token.capitalize == english_token
    return pyro_word
  end

  # Split the provided english text into token, each of which will be considered for translation.
  # Each token is defined as being a word, or a space, or a piece of punctuation, or an HTML tag (not content)
  def tokenize(english_text)
    english_text.split(/(<.*?>|<\/.*?>|\w+|\W\s)/x)
  end

  # Tests if a token is a word or not. Words are tokens that contain purely letters only.
  def word?(token)
    token =~ /^[A-Za-z]+$/
  end

  # Apply rules defined in $pyrotalk_rules to a given english word.
  def find_pyro_word(english_word)
    translated = RULES.inject(english_word) { |word, rule|
      # wrap the regex in extra pattern than will stop it from being replaced if anything is wrapped in !..!
      word.gsub(protect_regex(rule.match), rule.result)
    }
    remove_protection(translated)
  end
  
  # Wrap pattern round regex that will stop it being replaced if wrapped in !..!
  def protect_regex(reg)
    Regexp.new('(^|(?!(!.*)))' + reg.source + '($|(?!(.*!)))')
  end
  
  # Remove protection after rule translation is done.
  def remove_protection(pyro_word)
    pyro_word.gsub(/!/,'')
  end

end