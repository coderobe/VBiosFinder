require "cocaine"
require "mkmf"
require "find"

module VBiosFinder
  class Utils
    @@current_files = []
    def self.get_new_files
      current_files = Find.find(".").reject{|e| File.directory? e}
      result = current_files - @@current_files
      @@current_files = current_files
      return result
    end
    def self.installed? program, reason="optional"
      if find_executable(program).nil?
        puts "Install '#{program}' on your system (#{reason})".colorize(:red)
        false
      else
        true
      end
    end
  end
end