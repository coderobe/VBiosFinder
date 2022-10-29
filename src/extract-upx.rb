require 'terrapin'

module VBiosFinder
  class Extract
    def self.upx(file)
      line = Terrapin::CommandLine.new('upx', '-d :file -o :outfile')
      line.run(file: file, outfile: "upx-#{File.basename(file)}")
    rescue Terrapin::ExitStatusError => e
      puts e.message
      nil
    end
  end

  class Test
    def self.upx(file)
      line = Terrapin::CommandLine.new('upx', '-t :file')
      line.run(file: file)
      true
    rescue Terrapin::ExitStatusError => e
      false
    end
  end
end
