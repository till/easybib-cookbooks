#!/usr/bin/env rake
#encoding: utf-8

require 'bundler'
require 'rake'
require 'rake/testtask'

Bundler.setup

task :default => [
  :lint,
  :test,
  :chefspec,
  :foodcritic
]

desc "Run tests"
Rake::TestTask.new do |t|
  t.pattern = '**/**/tests/test_*.rb'
end

desc "WIP: Ruby lint (too slow)"
task :lint do
  system 'find . -type f -name "*.rb" -exec ruby -c {} > /dev/null \;'
end

desc "ChefSpec"
task :chefspec do
  sh 'find . -maxdepth 2 -type d -name "spec" -exec bundle exec rspec {} \;'
end

desc "Runs foodcritic linter"
task :foodcritic do
  if Gem::Version.new("1.9.2") <= Gem::Version.new(RUBY_VERSION.dup)
    sandbox = File.join(File.dirname(__FILE__), 'fc_sandbox')

    epic_fail = %w{ ~FC019 ~FC023 ~FC024 ~FC034 ~FC045 }

    cookbooks = find_cookbooks('.')

    cookbooks.each do |cb|

      prepare_foodcritic_sandbox(sandbox, cb)

      verbose(false)
      fc_command = "bundle exec foodcritic -C --chef-version 11 -f any -f #{epic_fail.join(' -f ')} #{sandbox}"

      sh fc_command do |ok, res|
        if !ok
          puts "Cookbook: #{cb}"
          puts "Command failed: #{fc_command}"
          puts res
          exit 1
        end
      end
    end

  else
    puts "WARN: foodcritic run is skipped as Ruby #{RUBY_VERSION} is < 1.9.2."
  end
end

private
def prepare_foodcritic_sandbox(sandbox, cookbook)

  files = %w{*.md *.rb attributes definitions files libraries providers recipes resources templates}

  opts = {:verbose => false}

  rm_rf sandbox, opts
  mkdir_p sandbox, opts
  cp_r Dir.glob("#{cookbook}/{#{files.join(',')}}"), sandbox, opts
end

private
def find_cookbooks(all_your_base)
  cookbooks = []

  # ignore the following - mostly third party
  skip = [ 'bprobe', 'git', 'scalarium_nodejs', 'vagrant-test', 'ohai' ]
  Dir.entries(all_your_base).select do |entry|
    next unless File.directory?(File.join(all_your_base, entry))
    next unless !(entry[0, 1] == '.')
    next if skip.include?(entry)

    cookbooks.push(entry)

  end

  return cookbooks
end
