#!/usr/bin/env rake
# encoding: utf-8

# to run all testsuites for a single cookbook: rake test[cookbook] - eg rake test[easybib]
# to run all specs for a cookbook: rake spec[cookbook] - eg rake spec[easybib]
# to run all specs for a single cb spec: rake[cookbook,spec] - eg rake spec[easybib,easybib_deploy]

require 'bundler'
require 'rake'
require 'rake/testtask'
require 'rspec/core/rake_task'
require 'yaml'
require 'parallel_tests'
require 'parallel_tests/cli'

Bundler.setup

task :default => [
  :test
]

task :test, :cookbook do |t, args|
  task(:unittest).invoke(args.cookbook)
  task(:spec).invoke(args.cookbook)
  task(:rubocop).invoke(args.cookbook)
  task(:foodcritic).invoke(args.cookbook)
end
desc 'Run tests'

task :unittest, :cookbook do |t, args|
  Rake::TestTask.new('testtask') do |raketask|
    raketask.pattern = if args.cookbook.nil?
                         '**/**/tests/test_*.rb'
                       else
                         "#{args.cookbook}/**/tests/test_*.rb"
                       end
    raketask.verbose = false
    raketask.warning = false
  end
  task('testtask').execute
end

desc 'Runs specs with chefspec.'
RSpec::Core::RakeTask.new :spec, [:cookbook, :recipe, :output_file] do |t, args|

  args.with_defaults(:cookbook => '*', :recipe => '*', :output_file => nil)

  file_list = FileList["#{args.cookbook}/spec/#{args.recipe}_spec.rb"]

  find_all_ignored.each do |ignored|
    file_list = file_list.exclude("#{ignored}/spec/**")
  end

  t.verbose = false
  t.fail_on_error = true
  t.rspec_opts = '--format d --require ./global_spec_helper.rb'
  t.ruby_opts = '-W0' # it supports ruby options too
  t.pattern = file_list
end

task :parallel_spec do
  file_list = FileList['*/spec/*_spec.rb']

  find_all_ignored.each do |ignored|
    file_list = file_list.exclude("#{ignored}/spec/**")
  end

  cli_args = ['-o "--require ./global_spec_helper.rb"', '-o "-fd"', '-t', 'rspec']
  cli_args.concat(file_list)

  ParallelTests::CLI.new.run(cli_args)
end

desc 'Runs foodcritic linter'
task :foodcritic, [:cookbook] do |t, args|
  args.with_defaults(:cookbook => nil)

  if Gem::Version.new('1.9.2') <= Gem::Version.new(RUBY_VERSION.dup)
    epic_fail = %w()
    ignore_rules = %w(FC059)

    cb = if args.cookbook.nil?
           find_cookbooks('.').join(' ')
         else
           args.cookbook
         end

    fc_command = 'bundle exec foodcritic -C --chef-version 12 -f any -P '
    fc_command << " -f #{epic_fail.join(' -f ')}" unless epic_fail.empty?
    fc_command << " -t ~#{ignore_rules.join(' -t ~')}" unless ignore_rules.empty?
    fc_command << " #{cb}"
    verbose(false)
    sh fc_command do |ok, res|
      unless ok
        puts "Cookbook: #{cb}"
        puts "Command failed: #{fc_command}"
        puts res
        exit 1
      end
    end
  else
    puts "WARN: foodcritic run is skipped as Ruby #{RUBY_VERSION} is < 1.9.2."
  end
end

private

def find_cookbooks(all_your_base)
  cookbooks = []

  skip = find_all_ignored

  Dir.entries(all_your_base).select do |entry|
    next unless File.directory?(File.join(all_your_base, entry))
    next if entry[0, 1] == '.'
    next if skip.include?(entry)

    cookbooks.push(entry)

  end

  cookbooks
end

private

# ignore the following - mostly third party
def find_all_ignored
  skipped = []

  rubocop = YAML.load_file('./.rubocop.yml')
  rubocop['AllCops']['Exclude'].each do |ignored|
    skipped << ignored.split('/')[0]
  end

  skipped
end

current_dir = File.expand_path(File.dirname(__FILE__))

if !ENV['TRAVIS'] && File.exist?(current_dir + '/.kitchen.yml')
  begin
    require 'kitchen/rake_tasks'
    Kitchen::RakeTasks.new
  rescue LoadError
    puts '>>>>> Kitchen gem not loaded, omitting tasks' unless ENV['CI']
  end
end

require 'rubocop/rake_task'
RuboCop::RakeTask.new(:rubocop, :cookbook)  do |task, args|
  unless ENV['TRAVIS']
    # no autocorrect in travis
    task.options = ['--auto-correct']
  end
  if args.cookbook.nil?
    cookbooks = find_cookbooks('.').map! { |cb| "#{cb}/**/*.rb" }
    pattern = %w(Rakefile Gemfile) + cookbooks
  else
    pattern = ["#{args.cookbook}/**/*.rb"]
  end
  task.patterns = pattern
end
