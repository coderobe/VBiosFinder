require "cocaine"

module VBiosFinder
  class Extract
    def self.innosetup file
      begin
        line = Cocaine::CommandLine.new("innoextract", ":file")
        puts line.run(file: file)
      rescue Cocaine::ExitStatusError => e
        puts e.message
        return
      end
    end
  end
  class Test
    def self.innosetup file
      begin
        line = Cocaine::CommandLine.new("innoextract", "-t :file")
        line.run(file: file)
        true
      rescue Cocaine::ExitStatusError => e
        false
      end
    end
  end
end