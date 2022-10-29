require 'colorize'
require './src/utils'
require './src/methods'

module VBiosFinder
  class Extraction
    def self.attempt(method_s, requires, reason, file)
      if Test.method(method_s).call(file)
        puts "found #{requires} archive".colorize(:green)
        Extract.method(method_s).call(file)
      else
        #puts "not extractable with #{requires}".colorize(:red)
      end
    end
  end
end
