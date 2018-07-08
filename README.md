# VBiosFinder (linux)

This tool attempts to extract a VBIOS from a bios update  
Laptops with NVIDIA Optimus graphics often have the dGPU VBIOS integrated in their system BIOS, this makes extracting the VBIOS a complicated process. Provided you have a BIOS Update for your laptop, this tool might be able to automagically extract all available VBIOS from it.

## Dependencies
- Ruby
- bundler **(a ruby gem)**
- [UEFIExtract](https://github.com/LongSoft/UEFITool) **(note: UEFIExtract can be found in the branch `new_engine`)**
- [rom-parser](https://github.com/awilliam/rom-parser)
- p7zip **(optional)**
- [innoextract](https://github.com/dscharrer/innoextract) **(optional)**
- upx **(optional)**

## Note
Some dependencies might not offer a package for your linux distribution **(like UEFIDump and rom-parser)**. The binaries can be placed in `./3rdparty` to avoid having to install them.

## Usage
- Run `bundle install --path=vendor/bundle` to install the required ruby modules **(once)**
- Run `./vbiosfinder extract /path/to/bios_update.exe` to attempt an extraction
- A temporary working dir is created at `./tmp-vbiosfinder` which can be removed inbetween runs
- Extracted VBIOS roms will be placed in `./output`

## Compatibility
- Lenovo y50-70 **(bios update)**
- [Lenovo S5 2nd Gen (20JAA009HH) **(bios update)**](https://github.com/coderobe/VBiosFinder/issues/1)
- **note: if your device isn't listed here, feel free to try this tool and report your results!**

## Troubleshooting
**Q:** There are no files in `./output` after running the tool!  
**A:** It's very possible that VBiosFinder can't extract your type of BIOS update right now. Feel free to open an issue with a link to your bios update and the program output you get!

## TODO
- Add option to extract the bios of the running system **(can we?)**
- ~~Clean up temporary working dir after finishing up~~ done
- Test with more BIOS updates

## Licensing
This project, initially authored by Robin Broda, is licensed under the GNU Affero General Public License v3  
A copy of the license is available in `LICENSE.txt`
