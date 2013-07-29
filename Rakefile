# encoding: utf-8

require 'bundler'
require 'rake'
require 'rake/testtask'
require 'foodcritic'

Bundler.setup


Rake::TestTask.new do |t|
  t.pattern = '**/**/tests/test_*.rb'
end

FoodCritic::Rake::LintTask.new do |t|
  cookbooks = []
  skip = [ 'bprobe', 'scalarium_nodejs', 'vagrant-test', 'ohai' ]
  Dir.entries('.').select do |entry|
    next unless File.directory?(File.join('.', entry))
    next unless !(entry[0, 1] == '.')
    next if skip.include?(entry)

    cookbooks.push(entry)

  end

  t.files = cookbooks
  t.options = {
    :tags => %w( ~readme ),
    :fail_tags => %w( ~FC002 ~FC003 ~FC004 ~FC005 ~FC013 ~FC014 ~FC015 ~FC016 ~FC017 ~FC023 ~FC024 ~FC033 ~FC045 )
    # ignored: FC19, FC043
  }
end
