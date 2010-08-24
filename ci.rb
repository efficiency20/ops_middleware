#!/usr/bin/env ruby

["bundle install vendor/bundle",
 "rake"
].each do |stage|
  exit 1 unless system(stage)
end