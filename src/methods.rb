require "terrapin"
require "find"
require "colorize"
require "./src/extraction"
require "./src/extract-innosetup"
require "./src/extract-upx"
require "./src/extract-uefi"
require "./src/extract-7z"
require "./src/extract-polyglot"
require "./src/extract-zlib"
require 'digest/md5'
hash = {}
module VBiosFinder
  class Main
    @extractions = []
    @extractions << [:polyglot, "polyglot", "builtin module for polyglot files"]
    @extractions << [:zlib, "zlib", "builtin module for zlib data"]
    @extractions << [:innosetup, "innoextract", "required for Inno Installers"]
    @extractions << [:upx, "upx", "required for UPX executables"]
    @extractions << [:p7zip, "7z", "required for 7z (self-extracting) archives"]

    def self.extract file
      puts "trying to extract #{file}"
      # Attempt all known extraction methods
      @extractions.each{|e| Extraction::attempt(*e, file)}
    end

    def self.run file
      @extractions.select! do |sym, requires, reason, arg|
        reason.start_with?("builtin") || Utils::installed?(requires, reason)
      end

      files = Utils::get_new_files
      files << file

      while files.size > 0
        files.each do |e|
          extract e
        end
        files = Utils::get_new_files
      end

      puts "extracting uefi data".colorize(:blue)
      Find.find(".").reject{|e| File.directory? e}.each do |e|
        puts "trying to extract #{e}"
        Extraction::attempt(:uefi, "UEFIExtract", "required for UEFI images", e)
      end

      outpath = "#{Dir.pwd}/../output"
      FileUtils.mkdir_p outpath
      FileUtils.cp file, "#{outpath}/bios_#{File.basename file}"
      puts "filtering for modules...".colorize(:blue)
      uefibins = Find.find(".").reject{|e| File.directory? e}.select{|e| e.end_with? ".bin"}
      puts "got #{uefibins.length} modules".colorize(:blue)
      puts "finding vbios".colorize(:blue)
      line = Terrapin::CommandLine.new("file", "-b :file")
      modules = uefibins.select{|e| line.run(file: e).include? "Video"}
      if modules.length > 0
        puts "#{modules.length} possible candidates".colorize(:green)
        if Utils::installed?("rom-parser", "required for proper rom naming & higher accuracy")
          modules.each do |mod|
            rom_parser = Terrapin::CommandLine.new("rom-parser", ":file")
            begin
              romdata = rom_parser.run(file: mod)
              romdata = romdata.split("\n")[1].split(", ").map{|e| e.split(": ")}.to_h rescue nil
              unless romdata.nil? || romdata['vendor'].nil? || romdata['device'].nil?
                puts "Found VBIOS for device #{romdata['vendor']}:#{romdata['device']}!".colorize(:green)
                new_filename = "vbios_#{romdata['vendor']}_#{romdata['device']}.rom"
                new_filename =check_cpy(new_filename,romdata)                
                FileUtils.cp(mod, "#{outpath}/#{new_filename}")
              end
            rescue Terrapin::ExitStatusError => e
              puts "can't determine vbios type of #{File.basename(mod)}, saving as 'vbios_unknown_#{File.basename(mod)}'"
              FileUtils.cp(mod, "#{outpath}/vbios_unknown_#{File.basename(mod)}")
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
        if uefibins.length > 0
          puts "input contains uefi data but no vbios could be found".colorize(:yellow)
          puts "the vbios might not be baked into the input!".colorize(:yellow)
        end
      end
    end
  end
end



def check_cpy(new_filename,romdata)
  count = 0
  Dir.glob('**/*',File::FNM_DOTMATCH).each do |f|
    key = Digest::MD5.hexdigest(IO.read(f)).to_sym
    if hash.has_key?(key) then hash[key].push(f) else hash[key] = [f] end
  end

  hash.each_value do |a|
    next if a.length == 1
    count+= 1
    new_filename = "vbios_#{romdata['vendor']}_#{romdata['device']}_#{count}.rom"

    return new_filename
  end
end
