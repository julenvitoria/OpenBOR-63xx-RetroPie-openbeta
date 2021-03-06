#!/bin/bash
readonly VERSION="$1"
readonly INST_DIR="$HOME"
readonly PAK_DIR="$HOME/RetroPie/roms/ports/openbor"
readonly PORTS_DIR="$HOME/RetroPie/roms/ports"

function drawline() {
echo "-------------------------------------------------------------------------"
}

# Called with argument?
[[ -z $VERSION ]] && echo "Not called with argument!" && exit

# Install dependencies
echo; echo -e "\t\tGetting dependecies";drawline
sudo apt install libsdl2-gfx-dev libvorbisidec-dev libvpx-dev libogg-dev libsdl2-gfx-1.0-0 libvorbisidec1
drawline; sleep 5

# Get Beta-files
echo; echo -e "\t\tGet GITHUB zip file"; drawline
cd "$INST_DIR"
wget -N -q --show-progress "http://raw.githubusercontent.com/crcerror/OpenBOR-63xx-RetroPie-openbeta/master/openbor_${VERSION}.zip"
sleep 1
# Install
echo; echo -e "\t\tUnzipping file with overwrite option"; drawline
unzip -o "openbor_${VERSION}.zip"
drawline; sleep 2

# Try to make binary file executable
echo; echo -e "\t\tCheck file existance and file state of OpenBOR binary"; drawline
if [[ -e ./openbor_openbeta/OpenBOR ]]; then
   echo "Found correct binary in archive"
   echo "Proceed with install"

    if [[ -x ./openbor_openbeta/OpenBOR ]]; then
       echo "Attribute is setted to executable"
       echo "Everything is all right"
   else
       echo "Attribute is setted to wrong"
       echo "I change attribute to executable now!"
       chmod +x ./openbor_openbeta/OpenBOR
   fi

else
    echo "Can't find file OpenBOR"
    echo "This is nasty -- Aborting now!"
    drawline; sleep 2
    exit
fi
drawline; sleep 2

# Try to link to PAK-files
echo; echo -e "\t\tLink to PAK files"; drawline
if [[ -d ./openbor_openbeta/Paks ]]; then
    echo "PAK folder is already present!"
    echo "$VERSION takes no action now!"
elif [[ -d $PAK_DIR ]]; then
    ln -s "${PAK_DIR}" ./openbor_openbeta/Paks
    echo "Successfully linked Pak dir"
    echo "$VERSION is making you happy"
else
    echo "Failed to link to Pak dir"
    echo "$VERSION must be feed with PAKs"
fi
drawline; sleep 5

# Try to install sh file into ports section
echo; echo -e "\t\tCreating script in ports section"; drawline
if [[ -d $PORTS_DIR ]]; then
    echo "cd ${INST_DIR}/openbor_openbeta; ./OpenBOR" > "${PORTS_DIR}/OpenBOR OPENBETA.sh"
    echo "Successfully installed script file to ports dir"
    echo "Please restart ES to make it visible"
    echo "Have much fun with: OpenBOR BETA $VERSION"
else
    echo; echo "Failed to create bash script to $PORTS_DIR"
fi
drawline; sleep 3
