require "cocaine"

module VBiosFinder
  class Extract
    def self.p7zip file
      begin
        line = Cocaine::CommandLine.new("7z", "x :file")
        line.run(file: file)
      rescue Cocaine::ExitStatusError => e
        puts e.message
        return
      end
    end
  end
  class Test
    def self.p7zip file
      begin
        line = Cocaine::CommandLine.new("7z", "l :file | grep 'Type = 7z'")
        line.run(file: file)
        true
      rescue Cocaine::ExitStatusError => e
        false
      end
    end
  end
end