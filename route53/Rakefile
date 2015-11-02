#!/usr/bin/env rake
require 'rake'
require 'rspec/core/rake_task'

begin
  require 'emeril/rake'
rescue LoadError
  puts ">>>>> Emeril gem not loaded, omitting tasks" unless ENV['CI']
end

task :spec    => 'spec:all'
task :default => :spec

namespace :spec do
  targets = []
  Dir.glob('./test/integration/default/*').each do |dir|
    next unless File.directory?(dir)
    targets << File.basename(dir)
  end

  task :all     => targets
  task :default => :all

  targets.each do |target|
    desc "Run serverspec tests to #{target}"
    RSpec::Core::RakeTask.new(target.to_sym) do |t|
      ENV['TARGET_HOST'] = target
      t.pattern = "test/integration/default/#{target}/*_spec.rb"
    end
  end
end
