require 'test/unit'
require File.join(File.dirname(__FILE__), '../libraries', 'configfile.rb')

class TestEasyBibConfigFile < Test::Unit::TestCase
  def default_data
    { 'strings' => { 'blastring' => 'bla', 'foostring' => 'foo' },
      'underscore' => { 'BLA_SOMEKEY' => 'somevalue' },
      'array' => {  'BLA_SOMEARRAY' => %w(server1 server2) } }
  end

  def test_hash_to_ini
    output = ::EasyBib::ConfigFile.new.to_configformat('ini', default_data)
    assert_equal(
      "[strings]\nblastring = \"bla\"\nfoostring = \"foo\"\n[underscore]\nBLA_SOMEKEY = \"somevalue\"\n" \
      "[array]\nBLA_SOMEARRAY[0] = \"server1\"\nBLA_SOMEARRAY[1] = \"server2\"\n",
      output
    )
  end

  def test_hash_to_php
    output = ::EasyBib::ConfigFile.new.to_configformat('php', default_data)
    assert_equal(
      "<?php\nreturn [\n  'strings' => [\n    'blastring'=>'bla',\n    'foostring'=>'foo',\n  ],\n  "\
      "'underscore' => [\n    'BLA_SOMEKEY'=>'somevalue',\n  ],\n  'array' => [\n    'BLA_SOMEARRAY'=> ['server1', 'server2'],\n  ],\n];",
      output
    )
  end

  def test_hash_to_nginx
    output = ::EasyBib::ConfigFile.new.to_configformat('nginx', default_data)
    assert_equal(
      "fastcgi_param blastring \"bla\";\nfastcgi_param foostring \"foo\";\nfastcgi_param BLA_SOMEKEY "\
      "\"somevalue\";\nfastcgi_param BLA_SOMEARRAY[0] \"server1\";\nfastcgi_param BLA_SOMEARRAY[1] \"server2\";\n",
      output
    )
  end

  def test_hash_to_shell
    output = ::EasyBib::ConfigFile.new.to_configformat('sh', default_data)
    assert_equal(
      "export blastring=\"bla\"\nexport foostring=\"foo\"\nexport BLA_SOMEKEY=\"somevalue\"\nexport "\
      "BLA_SOMEARRAY[0]=\"server1\"\nexport BLA_SOMEARRAY[1]=\"server2\"\n",
      output
    )
  end
end
