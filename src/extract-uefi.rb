require "cocaine"

module VBiosFinder
  class Extract
    def self.uefi file
      begin
        line = Cocaine::CommandLine.new("UEFIExtract", ":file all")
        line.run(file: file)
      rescue Cocaine::ExitStatusError => e
        # TODO: fix Test::uefi before uncommenting this
        puts e.message
        return
      end
    end
  end
  class Test
    def self.uefi file
      begin
        line = Cocaine::CommandLine.new("UEFIExtract", ":file report")
        line.run(file: file)
        true
      rescue Cocaine::ExitStatusError => e
        false
      end
    end
  end
end