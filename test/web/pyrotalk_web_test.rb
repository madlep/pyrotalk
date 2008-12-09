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

$:.unshift File.join(File.dirname(__FILE__),'..', '..','web')

require 'sinatra'
require 'sinatra/test/unit'
require 'pyrotalk_web'

class PyrotalkWebTest < Test::Unit::TestCase

  def setup
    Sinatra.application.options.views = File.join(File.dirname(__FILE__),'..', '..','web', 'views')
  end

  def test_get
    get_it '/'
  end
  
  def test_post
    post_it '/', :text => 'This is some english text'
    assert_match 'Thiz iz thrmh englizh thxt', @response.body
  end

end