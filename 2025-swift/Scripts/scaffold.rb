#!/usr/bin/env ruby

require "fileutils"

day = ARGV[0]

puts "Preparing Day #{day}"
folder = "Day#{format("%02d", day)}"
puts folder

FileUtils.mkdir_p "Sources/#{folder}"
FileUtils.mkdir_p "Tests/#{folder}"

def write_file_safe(file_name, contents)
  return if File.exist?(file_name) and puts "File #{file_name} already exists, skipping."

  File.write(file_name, contents)
end

write_file_safe("Sources/#{folder}/input.txt", "")

write_file_safe("Sources/#{folder}/main.swift", <<-EOS
import AOCHelper
import Foundation
import Parsing
EOS
                )

write_file_safe("Tests/#{folder}/#{folder}Tests.swift", <<-EOS
import Testing
@testable import #{folder}
EOS
                )
