#!/usr/bin/env rake
#encoding: utf-8

require 'bundler'
require 'rake'
require 'rake/testtask'
require 'rspec/core/rake_task'
require 'yaml'

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

  file_list = FileList["#{args.cookbook}/spec/#{args.recipe}_spec.rb"]

  find_all_ignored.each do |ignored|
    file_list = file_list.exclude("#{ignored}/spec/**")
  end

  t.verbose = false
  t.fail_on_error = true
  t.rspec_opts = args.output_file.nil? ? '--format d' : "--format RspecJunitFormatter --out #{args.output_file}"
  t.ruby_opts = '-W0' #it supports ruby options too
  t.pattern = file_list
end

desc "Runs foodcritic linter"
task :foodcritic do
  if Gem::Version.new("1.9.2") <= Gem::Version.new(RUBY_VERSION.dup)
    sandbox = File.join(File.dirname(__FILE__), 'fc_sandbox')

    epic_fail = %w{ }
    ignore_rules = %w{ }

    cookbooks = find_cookbooks('.')

    cookbooks.each do |cb|
      print "."
      prepare_foodcritic_sandbox(sandbox, cb)

      verbose(false)

      fc_command = "bundle exec foodcritic -C --chef-version 11 -f any"
      fc_command << " -f #{epic_fail.join(' -f ')}" if !epic_fail.empty?
      fc_command << " -t ~#{ignore_rules.join(' -t ~')}" unless ignore_rules.empty?
      fc_command << " #{sandbox}"
      sh fc_command do |ok, res|
        if !ok
          puts "Cookbook: #{cb}"
          puts "Command failed: #{fc_command}"
          puts res
          exit 1
        end
      end
    end
    puts "."
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

  skip = find_all_ignored

  Dir.entries(all_your_base).select do |entry|
    next unless File.directory?(File.join(all_your_base, entry))
    next unless !(entry[0, 1] == '.')
    next if skip.include?(entry)

    cookbooks.push(entry)

  end

  return cookbooks
end

private
# ignore the following - mostly third party
def find_all_ignored

  skipped = []

  rubocop = YAML.load_file("./.rubocop.yml")
  rubocop["AllCops"]["Excludes"].each do |ignored|
    skipped << ignored.split("/")[0]
  end

  skipped
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
