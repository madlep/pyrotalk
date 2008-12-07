<?php

# make any changes to pyrotalk translation rules here. 
# Ideally these should be configurable via the admin screen, but this will do for the moment.
# regex on the left that may match a string. Translate token matched by a rule to the text on the right.
# These will be executed in the order declared here. If a particular piece of a token should NOT be matched
# anymore, then wrap it in !..!. The ! will be removed at the end of translating.
$pyrotalk_rules = array();
$pyrotalk_rules['shit']         = '!s***!';
$pyrotalk_rules['fuck']         = '!f***!';
$pyrotalk_rules['and']          =  '!nn!';
$pyrotalk_rules['is']           =  '!iz!';
#rraaahhh or gggaaahhh etc are preserved unchanged ($0 returns full matched text)
$pyrotalk_rules['(r|g)+a+h+']   = '!$0!';
$pyrotalk_rules['ing']          = 'ng';
$pyrotalk_rules['pyro']         = '!pr-ro!';
$pyrotalk_rules['rock']         = '!rrkc!';
$pyrotalk_rules['(a|e)']        = 'h';
$pyrotalk_rules['o']            = 'r';
$pyrotalk_rules['s+']           = 'th';
$pyrotalk_rules['k']            = 'g';
#preserve 'i' by itself (as in "I rock")
$pyrotalk_rules['^i$']          = '!i!';
$pyrotalk_rules['i']            = 'uh';

# main entry point into plugin. This is mapped to a wordpress callback.
# Just find any [pyro]...[/pyro] marked up sections in the content, and pass each one to pyrotalk_translate()
# $content - blog/comment content passed to the filter by wordpress.
function pyrotalk($content) {
  return preg_replace_callback('/\[pyro\](.*?)\[\/pyro\]/', 'pyrotalk_translate', $content);
}

function pyrotalk_pages($content) {
  return $content. '<li><a href="/">OMG PYRO ROCKS!</a></li>';
}

function pyrotalk_request($request) {
  print_r($request);
  if($request['pagename'] == 'translator/pyro') {
    $request['pagename'] = 'wp-content/plugins/pyrotalk/index.php';
  }
  return $request;
}

# Given a piece of text in english, translate it to pyrotalk
# Split the text into tokens, and apply the rules to each token that is identified as a word by pyrotalk_is_word()
# Handle basic preservation of case.
function pyrotalk_translate($english_text) {
  $pyro_tokens = array();
  foreach(pyrotalk_tokenize($english_text[1]) as $token) {
    if(pyrotalk_is_word($token)) {
      $pyro_word = pyrotalk_find_pyro_word(strtolower($token));
      $pyro_word = pyrotalk_capitalize($token, $pyro_word);
    } else {
      $pyro_word = $token;
    }
    $pyro_tokens[] = $pyro_word;
  } 
  return implode("",$pyro_tokens);
}

# Basic case preservation of translated words taking the case makeup of the original word:
# If the original word was all UPPER, then make translated word UPPER.
# If the original word was Capitalized, then make the translated word Capitalized.
# Otherwise, just leave the translated word alone.
function pyrotalk_capitalize($english_token, $pyro_word) {
  if (strtolower($english_token) == 'i') {
    return strtoupper($pyro_word);
  } else if (preg_match('/^[A-Z]+$/',$english_token) > 0) {
    return strtoupper($pyro_word);
  } else if (preg_match('/[A-Z]/', $english_token[0]) > 0) {
    return ucfirst($pyro_word);
  } else {
    return $pyro_word;
  }
}

# Split the provided english text into token, each of which will be considered for translation.
# Each token is defined as being a word, or a space, or a piece of punctuation, or an HTML tag (not content)
function pyrotalk_tokenize($english_text) {
  return preg_split("/(<.*?>|<\/.*?>|\w+|\W\s)/x", $english_text, -1, PREG_SPLIT_DELIM_CAPTURE);
}

# Tests if a token is a word or not. Words are tokens that contain purely letters only.
function pyrotalk_is_word($token) {
  return (preg_match('/[A-Za-z]+$/', $token) > 0);
}

# Apply rules defined in $pyrotalk_rules to a given english word.
function pyrotalk_find_pyro_word($english_word) {
  global $pyrotalk_rules;
  $pyro_word = $english_word;
  foreach($pyrotalk_rules as $from => $to) {
    #wrap the regex in extra pattern than will stop it from being replaced if anything is wrapped in !..!
    $pyro_word = preg_replace(pyrotalk_protect_regex($from), $to, $pyro_word);
  }
  return pyrotalk_remove_protection($pyro_word);
}

# Wrap pattern round regex that will stop it being replaced if wrapped in !..!
function pyrotalk_protect_regex($reg){
  return "/(^|(?!(!.*)))".$reg."($|(?!(.*!)))/";
}

# Remove protection after rule translation is done.
function pyrotalk_remove_protection($pyro_word){
  return preg_replace('/!/', '', $pyro_word);
}

?>