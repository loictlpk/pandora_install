#!/bin/bash

# VALKEY INSTALL
sudo apt-get update
sudo apt install build-essential tcl

git clone https://github.com/valkey-io/valkey.git
cd valkey
git checkout 8.0
make
# Optionally, you can run the tests:
make test
cd ..


# KVROCKS INSTALL
sudo apt-get update
sudo apt install git gcc g++ make cmake autoconf automake libtool python3 libssl-dev
git clone --recursive  https://github.com/apache/kvrocks.git kvrocks
cd kvrocks
git checkout 2.10
./x.py build
cd ..


# OTHERS DEPS
sudo apt install python3-dev  # for compiling things
sudo apt install libpango-1.0-0 libharfbuzz0b libpangoft2-1.0-0  # For HTML -> PDF
sudo apt install libreoffice-nogui # For Office -> PDF
sudo apt install exiftool  # for extracting exif information
sudo apt install unrar  # for extracting rar files
sudo apt install libxml2-dev libxslt1-dev antiword unrtf poppler-utils tesseract-ocr flac ffmpeg lame libmad0 libsox-fmt-mp3 sox libjpeg-dev swig  # for textract
sudo apt install libssl-dev  # seems required for yara-python
sudo apt install libcairo2-dev  # Required by reportlab
# sudo add-apt-repository ppa:libreoffice/ppa
# sudo apt-get update
# sudo apt-get install libreoffice

#PANDORA INSTALL 
git clone https://github.com/pandora-analysis/pandora.git
cd pandora  # if you're not already in the directory
poetry install
echo PANDORA_HOME="`pwd`" >> .env
poetry run python tools/3rdparty.py
cp config/generic.json.sample config/generic.json


#ANTIVIRUS INSTALL
sudo apt-get install clamav-daemon
# In order for the module to work, you need the signatures.
# Running the command "freshclam" will do it but if the script is already running
# (it is started by the systemd service clamav-freshclam)
# You might want to run the commands below:
sudo systemctl stop clamav-freshclam.service  # Stop the service
sudo freshclam  # Run the signatures update
sudo systemctl start clamav-freshclam.service # Start the service so we keep getting the updates

sudo service clamav-daemon start


#WORKERS CONF
for file in pandora/workers/*.sample; do cp -i ${file} ${file%%.sample}; done

# Update and launch
poetry run update --yes

# START PANDORA
poetry run start