require "cocaine"
require "find"
require "colorize"
require "./src/extraction"
require "./src/extract-innosetup"
require "./src/extract-upx"
require "./src/extract-uefi"
require "./src/extract-7z"

module VBiosFinder
  class Main
    def self.run file
      puts "trying to extract #{file}"

      # Attempt all known extraction methods
      extractions = []
      extractions << [:innosetup, "innoextract", "required for Inno Installers", file]
      extractions << [:upx, "upx", "required for UPX executables", file]
      extractions << [:p7zip, "7z", "required for 7z (self-extracting) archives", file]
      extractions.each{|e| Extraction::attempt(*e)}

      # Try to find an UEFI bios image now
      if Utils::installed?("UEFIDump", "required for UEFI images") && Test::uefi(file)
        puts "found UEFI image".colorize(:green)
        outpath = "#{Dir.pwd}/../output"
        FileUtils.mkdir_p outpath
        FileUtils.cp file, "#{outpath}/bios_#{File.basename file}"
        Extract::uefi file
        puts "extracted. filtering modules...".colorize(:blue)
        modules = Find.find("#{file}.dump").reject{|e| File.directory? e}.select{|e| e.end_with? ".bin"}
        puts "got #{modules.length} modules".colorize(:blue)
        puts "finding vbios".colorize(:blue)
        line = Cocaine::CommandLine.new("file", "-b :file")
        modules = modules.select{|e| line.run(file: e).include? "Video"}
        if modules.length > 0
          puts "#{modules.length} possible candidates".colorize(:green)
          if Utils::installed?("rom-parser", "required for proper rom naming & higher accuracy")
            modules.each do |mod|
              rom_parser = Cocaine::CommandLine.new("rom-parser", ":file")
              begin
                romdata = rom_parser.run(file: mod)
                romdata = romdata.split("\n")[1].split(", ").map{|e| e.split(": ")}.to_h rescue nil
                unless romdata.nil? || romdata['vendor'].nil? || romdata['device'].nil?
                  puts "Found VBIOS for device #{romdata['vendor']}:#{romdata['device']}!".colorize(:green)
                  new_filename = "vbios_#{romdata['vendor']}_#{romdata['device']}.rom"
                  FileUtils.cp(mod, "#{outpath}/#{new_filename}")
                end
              rescue Cocaine::ExitStatusError => e
                puts "can't determine vbios type"
              end
            end
          else
            modules.each do |mod|
              FileUtils.cp(mod, outpath)
            end
          end
          puts "Job done. Extracted files can be found in #{outpath}".colorize(:green)
        else
          puts "no candidates found :(".colorize(:red)
        end
        exit 0
      else
        puts "not an uefi image"
      end

      Utils::get_new_files.each do |e|
        puts
        run e
      end
    end
  end
end
