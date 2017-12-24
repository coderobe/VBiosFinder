# VBiosFinder (linux)

This tool attempts to extract a VBIOS from a bios update  
Laptops with NVIDIA Optimus graphics often have the dGPU VBIOS integrated in their system BIOS, this makes extracting the VBIOS a complicated process. Provided you have a BIOS Update for your laptop, this tool might be able to automagically extract all available VBIOS from it.

## Dependencies
- Ruby
- bundler ^(a ruby gem)
⁻ p7zip ^(optional)
- [innoextract](https://github.com/dscharrer/innoextract) ^(optional)
- upx ^(optional)
- [UEFIDump](https://github.com/LongSoft/UEFITool) ^(note: UEFIDump can be found in the branch `new_engine`)
- [rom-parser](https://github.com/awilliam/rom-parser)

## Note
Some dependencies might not offer a package for your linux distribution ^(like UEFIDump and rom-parser). The binaries can be placed in `./3rdparty` to avoid having to install them.

## Usage
- Run `bundle install --path=vendor/bundle` to install the required ruby modules ^(once)
- Run `./vbiosfinder extract /path/to/bios_update.exe` to attempt an extraction
- A temporary working dir is created at `./tmp-vbiosfinder` which can be removed inbetween runs
- Extracted VBIOS roms will be placed in `./output`

## Licensing
This project, initially authored by Robin Broda, is licensed under the GNU Affero General Public License v3  
A copy of the license is available in `LICENSE.txt`
