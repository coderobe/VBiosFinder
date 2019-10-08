require "terrapin"

module VBiosFinder
  class Extract
    def self.innosetup file
      begin
        line = Terrapin::CommandLine.new("innoextract", ":file")
        puts line.run(file: file)
      rescue Terrapin::ExitStatusError => e
        puts e.message
        return
      end
    end
  end
  class Test
    def self.innosetup file
      begin
        line = Terrapin::CommandLine.new("innoextract", "-t :file")
        line.run(file: file)
        true
      rescue Terrapin::ExitStatusError => e
        false
      end
    end
  end
end