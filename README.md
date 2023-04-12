# VBiosFinder (linux)

This tool attempts to extract a VBIOS from a bios update  
Laptops with NVIDIA Optimus graphics often have the dGPU VBIOS integrated in their system BIOS, this makes extracting the VBIOS a complicated process. Provided you have a BIOS Update for your laptop, this tool might be able to automagically extract all available VBIOS from it.

This version adds the ability to extract from HP Service Pack executable files. HP Service Packs contain embedded BIOS and VBIOS for HP laptops. Replacement graphics cards for HP laptops are usually shipped "bare" without any VBIOS installed.

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
    - NOTE: /path/to/bios_update.exe **MUST** be a fully qualified path. Do **not** use relative path names
- A temporary working dir is created at `./tmp-vbiosfinder` which can be removed inbetween runs
- Extracted VBIOS roms will be placed in `./output`

## Compatibility (non-exhaustive)
- [ASUS N580GD](https://github.com/coderobe/VBiosFinder/issues/15)
- Lenovo y50-70
- [Lenovo S5 2nd Gen (20JAA009HH)](https://github.com/coderobe/VBiosFinder/issues/1)
- [ThinkPad P52](https://github.com/coderobe/VBiosFinder/issues/24)
- [ThinkPad P72](https://github.com/coderobe/VBiosFinder/issues/13)
- [ThinkPad T430](https://github.com/coderobe/VBiosFinder/issues/18)
- [ThinkPad T440p](https://github.com/coderobe/VBiosFinder/issues/21)
- [ThinkPad T530](https://github.com/coderobe/VBiosFinder/issues/34)
- [TravelMate P645-SG](https://github.com/coderobe/VBiosFinder/issues/9)
- HP Service Packs

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
