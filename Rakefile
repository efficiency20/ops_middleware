require "rubygems"
require "bundler"
Bundler.setup

require 'jeweler'

Jeweler::Tasks.new do |gem|
  gem.name = "e20_ops_middleware"
  gem.summary = "Operations support gem for Efficiency 2.0 projects"
  gem.email = "tech@efficiency20.com"
  gem.homepage = "http://github.com/efficiency20/ops_middleware"
  gem.description = "Adds middleware for debugging purposes"
  gem.authors = ["Efficiency 2.0"]
  gem.add_dependency "uuid", "~> 2.1.0"
  gem.add_development_dependency "rspec", "~> 1.3.0"
end

require "spec/rake/spectask"

desc "Run all specs"
Spec::Rake::SpecTask.new("spec") do |t|
  t.spec_files = FileList["spec/**/*_spec.rb"]
end

task :default => :spec
