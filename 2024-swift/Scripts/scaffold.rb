#!/usr/bin/env ruby

require "fileutils"

day = ARGV[0]

puts "Preparing Day #{day}"
folder = "Day#{format("%02d", day)}"
puts folder

FileUtils.mkdir_p "Sources/#{folder}"
FileUtils.mkdir_p "Tests/#{folder}"

File.write("Sources/#{folder}/input.txt", "")

File.open("Sources/#{folder}/main.swift", "w") do |f|
  f.puts <<-EOS
import AOCHelper
import Foundation
import Parsing
  EOS
end

File.open("Tests/#{folder}/#{folder}Tests.swift", "w") do |f|
  f.puts <<-EOS
import Testing
@testable import #{folder}
  EOS
end
