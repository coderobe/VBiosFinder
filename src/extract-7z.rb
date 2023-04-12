require "terrapin"

module VBiosFinder
  class Extract
    def self.p7zip file
      begin
        line = Terrapin::CommandLine.new("7z", "x :file")
        line.run(file: file)
      rescue Terrapin::ExitStatusError => e
        puts e.message
        return
      end
    end
  end
  class Test
    def self.p7zip file
      begin
        line = Terrapin::CommandLine.new("7z", "l :file | grep 'Type = 7z'")
        line.run(file: file)
        result_7Z = true
      rescue Terrapin::ExitStatusError => e
        result_7Z = false
      end
      begin
        line = Terrapin::CommandLine.new("7z", "l :file | grep 'Type = Cab'")
        line.run(file: file)
        result_Cab = true
      rescue Terrapin::ExitStatusError => e
        result_Cab = false
      end
      return result_Cab || result_7Z
    end
  end
end
