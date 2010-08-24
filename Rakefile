require "rubygems"
require "bundler"
Bundler.setup

begin
  require 'jeweler'
  Jeweler::Tasks.new do |s|
    s.name = "e20_ops_middleware"
    s.summary = "Operations support gem for Efficiency 2.0 projects"
    s.email = "tech@efficiency20.com"
    s.homepage = "http://github.com/efficiency20/ops_middleware"
    s.description = "Operations support gem for Efficiency 2.0 projects"
    s.authors = ["Efficiency 2.0"]
  end
rescue LoadError
  puts "Jeweler, or one of its dependencies, is not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end

require "spec/rake/spectask"

desc "Run all specs"
Spec::Rake::SpecTask.new("spec") do |t|
  t.spec_files = FileList["spec/**/*_spec.rb"]
end

task :default => :spec