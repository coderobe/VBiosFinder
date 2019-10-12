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
        true
      rescue Terrapin::ExitStatusError => e
        false
      end
    end
  end
end