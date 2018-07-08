module VBiosFinder
  class Extract
    def self.polyglot file
      File.open file, "r:ASCII-8BIT" do |data|
        regex = /(.{4})\xAA\xEE\xAA\x76\x1B\xEC\xBB\x20\xF1\xE6\x51(.{1})/n
        input = data.read
        matches = regex.match input
        payload_size = matches.captures.first.unpack('V').first
        payload_offset = matches.offset(2).last
        data.seek payload_offset
        File.open "#{file}-polyglot", "w:ASCII-8BIT" do |outdata|
          outdata.write data.read
        end
      end
    end
  end
  class Test
    def self.polyglot file
      File.open file, "r:ASCII-8BIT" do |data|
        regex = /(.{4})\xAA\xEE\xAA\x76\x1B\xEC\xBB\x20\xF1\xE6\x51.{1}/n
        return !(regex.match(data.read).nil?)
      end
    end
  end
end