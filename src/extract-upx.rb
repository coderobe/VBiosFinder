require "cocaine"

module VBiosFinder
  class Extract
    def self.upx file
      begin
        line = Cocaine::CommandLine.new("upx", "-d :file -o :outfile")
        line.run(file: file, outfile: "upx-#{file}")
      rescue Cocaine::ExitStatusError => e
        puts e.message
        return
      end
    end
  end
  class Test
    def self.upx file
      begin
        line = Cocaine::CommandLine.new("upx", "-t :file")
        line.run(file: file)
        true
      rescue Cocaine::ExitStatusError => e
        false
      end
    end
  end
end