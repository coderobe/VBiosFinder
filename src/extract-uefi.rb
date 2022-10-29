require 'terrapin'

module VBiosFinder
  class Extract
    def self.uefi(file)
      line = Terrapin::CommandLine.new('uefiextract', ':file all')
      line.run(file: file)
    rescue Terrapin::ExitStatusError => e
      # TODO: fix Test::uefi before uncommenting this
      puts e.message
      nil
    end
  end

  class Test
    def self.uefi(file)
      line = Terrapin::CommandLine.new('uefiextract', ':file report')
      line.run(file: file)
      true
    rescue Terrapin::ExitStatusError => e
      false
    end
  end
end
