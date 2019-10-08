require "terrapin"

module VBiosFinder
  class Extract
    def self.upx file
      begin
        line = Terrapin::CommandLine.new("upx", "-d :file -o :outfile")
        line.run(file: file, outfile: "upx-#{file}")
      rescue Terrapin::ExitStatusError => e
        puts e.message
        return
      end
    end
  end
  class Test
    def self.upx file
      begin
        line = Terrapin::CommandLine.new("upx", "-t :file")
        line.run(file: file)
        true
      rescue Terrapin::ExitStatusError => e
        false
      end
    end
  end
end