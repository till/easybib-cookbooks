#!/usr/bin/env rake
#encoding: utf-8

require 'bundler'
require 'rake'
require 'rake/testtask'
require 'rspec/core/rake_task'

Bundler.setup

task :default => [
  :test,
  :spec,
  :rubocop,
  :foodcritic
]

desc "Run tests"
Rake::TestTask.new do |t|
  t.pattern = '**/**/tests/test_*.rb'
end

desc 'Runs specs with chefspec.'
RSpec::Core::RakeTask.new :spec, [:cookbook, :recipe, :output_file] do |t, args|
  args.with_defaults( :cookbook => '*', :recipe => '*', :output_file => nil )
  t.verbose = false
  t.fail_on_error = true
  t.rspec_opts = args.output_file.nil? ? '--format d' : "--format RspecJunitFormatter --out #{args.output_file}"
  t.ruby_opts = '-W0' #it supports ruby options too
  t.pattern = "#{args.cookbook}/spec/#{args.recipe}_spec.rb"
end

desc "Runs foodcritic linter"
task :foodcritic do
  if Gem::Version.new("1.9.2") <= Gem::Version.new(RUBY_VERSION.dup)
    sandbox = File.join(File.dirname(__FILE__), 'fc_sandbox')

#    epic_fail = %w{ }

    cookbooks = find_cookbooks('.')

    cookbooks.each do |cb|

      prepare_foodcritic_sandbox(sandbox, cb)

      verbose(false)
#      fc_command = "bundle exec foodcritic -C --chef-version 11 -f any -f #{epic_fail.join(' -f ')} #{sandbox}"
      fc_command = "bundle exec foodcritic -C --chef-version 11 -f any #{sandbox}"
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
  skip = [ 'bprobe', 'git', 'opsworks_nodejs', 'vagrant-test', 'ohai', 'test' ]
  Dir.entries(all_your_base).select do |entry|
    next unless File.directory?(File.join(all_your_base, entry))
    next unless !(entry[0, 1] == '.')
    next if skip.include?(entry)

    cookbooks.push(entry)

  end

  return cookbooks
end

current_dir = File.expand_path(File.dirname(__FILE__))

if !ENV['TRAVIS'] && File.exists?(current_dir + '/.kitchen.yml')
  begin
    require 'kitchen/rake_tasks'
    Kitchen::RakeTasks.new
  rescue LoadError
    puts ">>>>> Kitchen gem not loaded, omitting tasks" unless ENV['CI']
  end
end

require 'rubocop/rake_task'
Rubocop::RakeTask.new
