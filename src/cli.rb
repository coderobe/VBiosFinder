require "thor"
require "fileutils"
require "logger"
require "colorize"
require "./src/methods"
require "./src/utils"

#Terrapin::CommandLine.logger = Logger.new(STDOUT)

module VBiosFinder
  @@wd
  class CLI < Thor
    desc 'extract <bios update file>'.colorize(:blue), 'attempts to extract an embedded vbios from a bios update'
    def extract file=nil
      wd = "#{Dir.pwd}/tmp-vbiosfinder"
      if file.nil?
        puts "no file specified".colorize(:red)
        return
      end
      if File.directory? wd
        puts "dirty work directory! remove #{wd}".colorize(:red)
        exit 1
      end
      FileUtils.mkdir_p wd
      Kernel.at_exit do
        puts "Cleaning up garbage".colorize(:blue)
        FileUtils.remove_entry_secure wd
      end
      @@wd = wd
      Dir.chdir wd
      puts "output will be stored in '#{wd}'".colorize(":blue")
      Utils::installed?("ruby") # "bugfix"
      Utils::get_new_files # "bugfix" #2
      FileUtils.cp(file, wd)
      puts
      Main::run Utils::get_new_files.first
    end
  end
end
