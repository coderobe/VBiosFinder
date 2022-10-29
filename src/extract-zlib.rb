require 'zlib'

module VBiosFinder
  class Extract
    def self.zlib(file)
      target = "#{file}-zlib"
      begin
        File.open file, 'r:ASCII-8BIT' do |data|
          File.open target, 'w:ASCII-8BIT' do |outdata|
            outdata.write Zlib::Inflate.inflate(data.read)
          end
        end
      rescue Zlib::DataError
        puts 'wrong guess :('.colorize(:red)
        FileUtils.rm target
      end
    end
  end

  class Test
    def self.zlib(file)
      File.open file, 'r:ASCII-8BIT' do |data|
        regex = /^\x78\x9C/n
        return !regex.match(data.read).nil?
      end
    end
  end
end
