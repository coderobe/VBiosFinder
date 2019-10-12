require "terrapin"

module VBiosFinder
  class Extract
    def self.uefi file
      begin
        line = Terrapin::CommandLine.new("UEFIExtract", ":file all")
        line.run(file: file)
      rescue Terrapin::ExitStatusError => e
        # TODO: fix Test::uefi before uncommenting this
        puts e.message
        return
      end
    end
  end
  class Test
    def self.uefi file
      begin
        line = Terrapin::CommandLine.new("UEFIExtract", ":file report")
        line.run(file: file)
        true
      rescue Terrapin::ExitStatusError => e
        false
      end
    end
  end
end